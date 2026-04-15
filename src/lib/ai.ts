// Define the shape of the AI response we expect
interface AIProtocolResponse {
    dosage: string;
    frequency: string;
    duration: string;
    notes: string[];
    storage: string;
}

export const generateProtocolWithAI = async (
    productName: string,
    description: string
): Promise<AIProtocolResponse> => {
    const response = await fetch('/api/generate-protocol', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ productName, description }),
    });

    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || 'Failed to generate protocol');
    }

    return response.json();
};
