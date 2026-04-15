import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
});

export default async function handler(req: any, res: any) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    const { productName, description } = req.body;

    if (!productName || !description) {
        return res.status(400).json({ error: 'productName and description are required' });
    }

    if (!process.env.ANTHROPIC_API_KEY) {
        return res.status(500).json({ error: 'ANTHROPIC_API_KEY is not configured' });
    }

    const systemPrompt = `You are a medical assistant specializing in peptide protocols for research purposes.

You have access to an advisor tool backed by a stronger reviewer model. It takes NO parameters — when you call advisor(), your entire conversation history is automatically forwarded.

Call advisor BEFORE generating the protocol — before writing, before committing to an interpretation. Generate the protocol AFTER receiving advisor guidance.

Give the advice serious weight. Adapt only if you have primary-source evidence that contradicts a specific claim.`;

    try {
        const response = await (client.beta.messages as any).create({
            model: 'claude-sonnet-4-6',
            max_tokens: 2048,
            betas: ['advisor-tool-2026-03-01'],
            system: systemPrompt,
            tools: [
                {
                    type: 'advisor_20260301',
                    name: 'advisor',
                    model: 'claude-opus-4-6',
                    max_uses: 5,
                },
            ],
            messages: [
                {
                    role: 'user',
                    content: `Generate a research peptide usage protocol for: "${productName}".
Description: "${description}"

Return ONLY a JSON object with these fields:
- dosage: (string) Recommended dosage (e.g., "500mcg daily")
- frequency: (string) How often to use (e.g., "Once daily before breakfast")
- duration: (string) Detailed cycle length (e.g., "8-12 weeks")
- notes: (array of strings) 3-5 important safety or usage notes
- storage: (string) Storage instructions (e.g., "Refrigerate after reconstitution")

Ensure professional tone. Return only the JSON, no markdown or extra text.`,
                },
            ],
        });

        // Extract the final text content from the response
        const textBlocks = response.content.filter((block: any) => block.type === 'text');
        const content = textBlocks.map((block: any) => block.text).join('');

        if (!content) {
            return res.status(500).json({ error: 'No content received from AI' });
        }

        // Strip any markdown code fences if present
        const cleaned = content.replace(/```json\n?/g, '').replace(/```\n?/g, '').trim();

        let parsed: any;
        try {
            parsed = JSON.parse(cleaned);
        } catch {
            return res.status(500).json({ error: 'Invalid response format from AI', raw: content });
        }

        return res.status(200).json({
            dosage: parsed.dosage || 'Consult physician',
            frequency: parsed.frequency || 'Consult physician',
            duration: parsed.duration || 'Consult physician',
            notes: Array.isArray(parsed.notes) ? parsed.notes : ['Consult physician'],
            storage: parsed.storage || 'Store in cool, dry place',
        });

    } catch (error: any) {
        console.error('Advisor API error:', error);
        return res.status(500).json({ error: error.message || 'Failed to generate protocol' });
    }
}
