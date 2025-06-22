import React, { useState, useEffect } from 'react';

// Global variables from the environment for Firebase and App ID
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : null;
const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';

function App() {
    const [mainPrompt, setMainPrompt] = useState('');
    const [faceShape, setFaceShape] = useState('');
    const [eyeType, setEyeType] = useState('');
    const [eyeColor, setEyeColor] = useState('');
    const [noseShape, setNoseShape] = useState('');
    const [lipShape, setLipShape] = useState('');
    const [hairStyle, setHairStyle] = useState('');
    const [hairColor, setHairColor] = useState('');
    const [expression, setExpression] = useState('');
    const [age, setAge] = useState('');
    const [genderPresentation, setGenderPresentation] = useState('');
    const [generatedPrompt, setGeneratedPrompt] = useState('');
    const [enhancedPrompt, setEnhancedPrompt] = useState(''); // New state for enhanced prompt
    const [imageLoading, setImageLoading] = useState(false);
    const [promptEnhancementLoading, setPromptEnhancementLoading] = useState(false); // New state for enhancement loading
    const [imageUrl, setImageUrl] = useState('');
    const [errorMessage, setErrorMessage] = useState('');

    // Define options for facial features
    const faceShapeOptions = [
        { label: 'Pilih Bentuk Wajah', value: '' },
        { label: 'Oval', value: 'oval face' },
        { label: 'Bulat', value: 'round face' },
        { label: 'Kotak', value: 'square face' },
        { label: 'Hati', value: 'heart-shaped face' },
        { label: 'Panjang', value: 'long face' },
    ];

    const eyeTypeOptions = [
        { label: 'Pilih Bentuk Mata', value: '' },
        { label: 'Almond', value: 'almond-shaped eyes' },
        { label: 'Bulat', value: 'round eyes' },
        { label: 'Sipit', value: 'slanted eyes' },
        { label: 'Monolid', value: 'monolid eyes' },
        { label: 'Hooded', value: 'hooded eyes' },
    ];

    const eyeColorOptions = [
        { label: 'Pilih Warna Mata', value: '' },
        { label: 'Biru', value: 'blue eyes' },
        { label: 'Coklat', value: 'brown eyes' },
        { label: 'Hijau', value: 'green eyes' },
        { label: 'Abu-abu', value: 'gray eyes' },
        { label: 'Hazel', value: 'hazel eyes' },
    ];

    const noseShapeOptions = [
        { label: 'Pilih Bentuk Hidung', value: '' },
        { label: 'Kecil', value: 'small nose' },
        { label: 'Mancung', value: 'pointed nose' },
        { label: 'Lebar', value: 'wide nose' },
        { label: 'Datar', value: 'flat nose' },
        { label: 'Roman', value: 'roman nose' },
        { label: 'Nubian', value: 'nubian nose' },
    ];

    const lipShapeOptions = [
        { label: 'Pilih Bentuk Bibir', value: '' },
        { label: 'Tipis', value: 'thin lips' },
        { label: 'Penuh', value: 'full lips' },
        { label: 'Bentuk Hati', value: 'heart-shaped lips' },
        { label: 'Cupid Bow', value: 'cupid\'s bow lips' },
    ];

    const hairStyleOptions = [
        { label: 'Pilih Gaya Rambut', value: '' },
        { label: 'Lurus', value: 'straight hair' },
        { label: 'Keriting', value: 'curly hair' },
        { label: 'Bergelombang', value: 'wavy hair' },
        { label: 'Pendek', value: 'short hair' },
        { label: 'Panjang', value: 'long hair' },
        { label: 'Kepang', value: 'braided hair' },
        { label: 'Kuncir Kuda', value: 'ponytail' },
    ];

    const hairColorOptions = [
        { label: 'Pilih Warna Rambut', value: '' },
        { label: 'Hitam', value: 'black hair' },
        { label: 'Coklat', value: 'brown hair' },
        { label: 'Pirang', value: 'blonde hair' },
        { label: 'Merah', value: 'red hair' },
        { label: 'Abu-abu', value: 'gray hair' },
        { label: 'Putih', value: 'white hair' },
    ];

    const expressionOptions = [
        { label: 'Pilih Ekspresi', value: '' },
        { label: 'Senyum', value: 'smiling' },
        { label: 'Serius', value: 'serious expression' },
        { label: 'Sedih', value: 'sad expression' },
        { label: 'Terkejut', value: 'surprised expression' },
        { label: 'Marah', value: 'angry expression' },
        { label: 'Netral', value: 'neutral expression' },
    ];

    const ageOptions = [
        { label: 'Pilih Usia', value: '' },
        { label: 'Anak-anak', value: 'child' },
        { label: 'Remaja', value: 'teenager' },
        { label: 'Dewasa Muda', value: 'young adult' },
        { label: 'Paruh Baya', value: 'middle-aged' },
        { label: 'Tua', value: 'elderly' },
    ];

    const genderPresentationOptions = [
        { label: 'Pilih Fitur Wajah', value: '' },
        { label: 'Feminin', value: 'feminine features' },
        { label: 'Maskulin', value: 'masculine features' },
        { label: 'Netral Gender', value: 'gender-neutral features' },
    ];

    const generatePrompt = () => {
        let parts = [];
        if (mainPrompt) {
            parts.push(mainPrompt);
        }

        const faceDetails = [
            faceShape,
            age,
            genderPresentation,
            eyeType,
            eyeColor,
            noseShape,
            lipShape,
            hairStyle,
            hairColor,
            expression,
        ].filter(Boolean).join(', ');

        if (faceDetails) {
            parts.push(faceDetails.charAt(0).toUpperCase() + faceDetails.slice(1));
        }

        const finalPrompt = parts.join(', ') + '.';
        setGeneratedPrompt(finalPrompt);
        setImageUrl(''); // Clear previous image when prompt is regenerated
        setErrorMessage('');
        setEnhancedPrompt(''); // Clear enhanced prompt
    };

    const copyToClipboard = (textToCopy) => {
        if (textToCopy) {
            document.execCommand('copy', false, textToCopy);
            alert('Prompt berhasil disalin!');
        }
    };

    const generateImage = async (promptToUse) => {
        if (!promptToUse) {
            setErrorMessage('Silakan hasilkan prompt terlebih dahulu.');
            return;
        }

        setImageLoading(true);
        setErrorMessage('');
        setImageUrl('');

        try {
            const payload = { instances: { prompt: promptToUse }, parameters: { "sampleCount": 1 } };
            const apiKey = ""; // Canvas will automatically provide this
            const apiUrl = `https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-002:predict?key=${apiKey}`;

            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            const result = await response.json();

            if (result.predictions && result.predictions.length > 0 && result.predictions[0].bytesBase64Encoded) {
                const url = `data:image/png;base64,${result.predictions[0].bytesBase64Encoded}`;
                setImageUrl(url);
            } else {
                setErrorMessage('Gagal menghasilkan gambar. Respon tidak valid.');
                console.error('Invalid image generation response:', result);
            }
        } catch (error) {
            setErrorMessage('Terjadi kesalahan saat menghasilkan gambar: ' + error.message);
            console.error('Error generating image:', error);
        } finally {
            setImageLoading(false);
        }
    };

    const enhancePrompt = async () => {
        if (!generatedPrompt) {
            setErrorMessage('Tidak ada prompt untuk ditingkatkan. Silakan buat prompt terlebih dahulu.');
            return;
        }

        setPromptEnhancementLoading(true);
        setErrorMessage('');
        setEnhancedPrompt('');

        try {
            const chatHistory = [];
            const promptForLLM = `Improve the following image and video generation prompt by adding more details, descriptive adjectives, and artistic elements to make it richer and more effective for generating high-quality visuals. Focus on lighting, mood, style, composition, and for video, consider motion, camera angles, and scene transitions. The original prompt is: "${generatedPrompt}"`;

            chatHistory.push({ role: "user", parts: [{ text: promptForLLM }] });

            const payload = { contents: chatHistory };
            const apiKey = ""; // Canvas will automatically provide this
            const apiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${apiKey}`;

            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            const result = await response.json();

            if (result.candidates && result.candidates.length > 0 &&
                result.candidates[0].content && result.candidates[0].content.parts &&
                result.candidates[0].content.parts.length > 0) {
                const text = result.candidates[0].content.parts[0].text;
                setEnhancedPrompt(text);
            } else {
                setErrorMessage('Gagal meningkatkan prompt. Respon LLM tidak valid.');
                console.error('Invalid LLM response:', result);
            }
        } catch (error) {
            setErrorMessage('Terjadi kesalahan saat meningkatkan prompt: ' + error.message);
            console.error('Error enhancing prompt:', error);
        } finally {
            setPromptEnhancementLoading(false);
        }
    };

    useEffect(() => {
        // Automatically generate prompt when any input changes
        generatePrompt();
    }, [mainPrompt, faceShape, eyeType, eyeColor, noseShape, lipShape, hairStyle, hairColor, expression, age, genderPresentation]);


    return (
        <div className="min-h-screen bg-gray-100 p-4 font-inter">
            <script src="https://cdn.tailwindcss.com"></script>
            <style>
                {`
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
                body {
                    font-family: 'Inter', sans-serif;
                }
                .scrollable-content {
                    max-height: 400px; /* Adjust as needed */
                    overflow-y: auto;
                    -webkit-overflow-scrolling: touch;
                }
                `}
            </style>
            <div className="max-w-4xl mx-auto bg-white p-8 rounded-lg shadow-xl border border-gray-200">
                <h1 className="text-4xl font-extrabold text-center text-gray-900 mb-8 tracking-tight">
                    Generator Prompt Gambar dan Video Gemini Pro
                </h1>

                {/* Main Prompt Input */}
                <div className="mb-6">
                    <label htmlFor="mainPrompt" className="block text-gray-700 text-lg font-semibold mb-2">
                        Deskripsi Utama Gambar atau Video (Apa yang ingin Anda hasilkan?):
                    </label>
                    <textarea
                        id="mainPrompt"
                        className="w-full p-4 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 text-gray-800 text-base shadow-sm resize-y"
                        rows="5"
                        placeholder="Contoh: Seorang wanita muda berjalan di taman yang diterangi sinar matahari, Seorang ksatria berdiri di puncak gunung bersalju..."
                        value={mainPrompt}
                        onChange={(e) => setMainPrompt(e.target.value)}
                    ></textarea>
                </div>

                {/* Facial Character Customization */}
                <div className="mb-8 p-6 bg-blue-50 rounded-lg border border-blue-200 shadow-md">
                    <h2 className="text-2xl font-bold text-blue-800 mb-4 flex items-center">
                        <svg className="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        Fitur Karakter Wajah (Opsional)
                    </h2>
                    <p className="text-gray-600 mb-4 text-sm">
                        Gunakan opsi di bawah untuk menyesuaikan fitur wajah karakter dalam prompt Anda untuk gambar atau video.
                    </p>

                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        <div className="flex flex-col">
                            <label htmlFor="age" className="text-gray-700 font-medium mb-1">Usia:</label>
                            <select id="age" value={age} onChange={(e) => setAge(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {ageOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="genderPresentation" className="text-gray-700 font-medium mb-1">Fitur Wajah:</label>
                            <select id="genderPresentation" value={genderPresentation} onChange={(e) => setGenderPresentation(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {genderPresentationOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="faceShape" className="text-gray-700 font-medium mb-1">Bentuk Wajah:</label>
                            <select id="faceShape" value={faceShape} onChange={(e) => setFaceShape(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {faceShapeOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="eyeType" className="text-gray-700 font-medium mb-1">Bentuk Mata:</label>
                            <select id="eyeType" value={eyeType} onChange={(e) => setEyeType(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {eyeTypeOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="eyeColor" className="text-gray-700 font-medium mb-1">Warna Mata:</label>
                            <select id="eyeColor" value={eyeColor} onChange={(e) => setEyeColor(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {eyeColorOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="noseShape" className="text-gray-700 font-medium mb-1">Bentuk Hidung:</label>
                            <select id="noseShape" value={noseShape} onChange={(e) => setNoseShape(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {noseShapeOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="lipShape" className="text-gray-700 font-medium mb-1">Bentuk Bibir:</label>
                            <select id="lipShape" value={lipShape} onChange={(e) => setLipShape(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {lipShapeOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="hairStyle" className="text-gray-700 font-medium mb-1">Gaya Rambut:</label>
                            <select id="hairStyle" value={hairStyle} onChange={(e) => setHairStyle(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {hairStyleOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="hairColor" className="text-gray-700 font-medium mb-1">Warna Rambut:</label>
                            <select id="hairColor" value={hairColor} onChange={(e) => setHairColor(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {hairColorOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex flex-col">
                            <label htmlFor="expression" className="text-gray-700 font-medium mb-1">Ekspresi:</label>
                            <select id="expression" value={expression} onChange={(e) => setExpression(e.target.value)}
                                className="p-3 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500 text-gray-800">
                                {expressionOptions.map(option => (
                                    <option key={option.value} value={option.value}>{option.label}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                </div>

                {/* Generated Prompt Output */}
                <div className="mb-6">
                    <h2 className="text-2xl font-bold text-gray-900 mb-4">Prompt yang Dihasilkan:</h2>
                    <textarea
                        readOnly
                        className="w-full p-4 border border-gray-300 rounded-lg bg-gray-50 text-gray-800 text-base font-mono shadow-sm resize-y"
                        rows="6"
                        value={generatedPrompt}
                        placeholder="Prompt Anda akan muncul di sini..."
                    ></textarea>
                    <button
                        onClick={() => copyToClipboard(generatedPrompt)}
                        className="mt-4 px-6 py-3 bg-green-600 text-white font-bold rounded-lg shadow-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition duration-200 ease-in-out transform hover:scale-105"
                    >
                        Salin Prompt
                    </button>
                    <button
                        onClick={enhancePrompt}
                        className="mt-4 ml-4 px-6 py-3 bg-teal-600 text-white font-bold rounded-lg shadow-md hover:bg-teal-700 focus:outline-none focus:ring-2 focus:ring-teal-500 focus:ring-offset-2 transition duration-200 ease-in-out transform hover:scale-105"
                        disabled={promptEnhancementLoading}
                    >
                        {promptEnhancementLoading ? (
                            <div className="flex items-center justify-center">
                                <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Meningkatkan...
                            </div>
                        ) : '✨ Tingkatkan Prompt ✨'}
                    </button>
                    <button
                        onClick={() => generateImage(generatedPrompt)}
                        className="mt-4 ml-4 px-6 py-3 bg-purple-600 text-white font-bold rounded-lg shadow-md hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 transition duration-200 ease-in-out transform hover:scale-105"
                        disabled={imageLoading}
                    >
                        {imageLoading ? (
                            <div className="flex items-center justify-center">
                                <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                </svg>
                                Menghasilkan...
                            </div>
                        ) : 'Hasilkan Contoh Gambar'}
                    </button>
                </div>

                {enhancedPrompt && (
                    <div className="mb-6 p-6 bg-indigo-50 rounded-lg border border-indigo-200 shadow-md">
                        <h2 className="text-2xl font-bold text-indigo-800 mb-4 flex items-center">
                            <svg className="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9.663 17h4.673M12 17v5m6.447-15.004L12 9.295l-6.447-3.249L12 2.5l6.447 3.249zM12 14.5l-6.447 3.249L12 21.5l6.447-3.249L12 14.5z"></path></svg>
                            Prompt yang Ditingkatkan (oleh Gemini Flash)
                        </h2>
                        <textarea
                            readOnly
                            className="w-full p-4 border border-gray-300 rounded-lg bg-gray-50 text-gray-800 text-base font-mono shadow-sm resize-y"
                            rows="6"
                            value={enhancedPrompt}
                            placeholder="Prompt yang ditingkatkan akan muncul di sini..."
                        ></textarea>
                        <button
                            onClick={() => copyToClipboard(enhancedPrompt)}
                            className="mt-4 px-6 py-3 bg-blue-600 text-white font-bold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition duration-200 ease-in-out transform hover:scale-105"
                        >
                            Salin Prompt yang Ditingkatkan
                        </button>
                        <button
                            onClick={() => generateImage(enhancedPrompt)}
                            className="mt-4 ml-4 px-6 py-3 bg-purple-600 text-white font-bold rounded-lg shadow-md hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-offset-2 transition duration-200 ease-in-out transform hover:scale-105"
                            disabled={imageLoading}
                        >
                            {imageLoading ? (
                                <div className="flex items-center justify-center">
                                    <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    Menghasilkan...
                                </div>
                            ) : 'Hasilkan Gambar dari Prompt Ditingkatkan'}
                        </button>
                    </div>
                )}

                {errorMessage && (
                    <div className="p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg mb-6" role="alert">
                        <p className="font-bold">Error:</p>
                        <p>{errorMessage}</p>
                    </div>
                )}

                {imageUrl && (
                    <div className="mb-6 text-center">
                        <h2 className="text-2xl font-bold text-gray-900 mb-4">Gambar yang Dihasilkan:</h2>
                        <img src={imageUrl} alt="Generated from prompt" className="max-w-full h-auto mx-auto rounded-lg shadow-lg border border-gray-300" />
                    </div>
                )}

                {/* Gemini Pro Guidelines */}
                <div className="mt-8 p-6 bg-yellow-50 rounded-lg border border-yellow-200 shadow-md">
                    <h2 className="text-2xl font-bold text-yellow-800 mb-4 flex items-center">
                        <svg className="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13c1.168-.777 2.754-1.253 4.5-1.253s3.332.476 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5s3.332.477 4.5 1.253v13c-1.168-.777-2.754-1.253-4.5-1.253s-3.332.476-4.5 1.253"></path></svg>
                        Tips untuk Prompt Gambar dan Video Gemini Pro
                    </h2>
                    <ul className="list-disc list-inside text-gray-700 text-base space-y-2">
                        <li><strong className="text-yellow-900">Spesifik dan Detail:</strong> Semakin detail prompt Anda, semakin baik hasilnya. Jelaskan subjek, latar belakang, pencahayaan, gaya, dan suasana hati.</li>
                        <li><strong className="text-yellow-900">Gaya Seni:</strong> Tentukan gaya yang Anda inginkan (misalnya, "gaya fotografi," "cat minyak," "gambar sketsa," "seni digital," "anime," "realistis").</li>
                        <li><strong className="text-yellow-900">Pencahayaan dan Suasana:</strong> Sertakan detail pencahayaan (misalnya, "cahaya keemasan senja," "pencahayaan dramatis," "neon terang") dan suasana hati (misalnya, "menenangkan," "misterius," "cerah").</li>
                        <li><strong className="text-yellow-900">Komposisi dan Sudut Pandang:</strong> Jelaskan bagaimana subjek diposisikan atau dari sudut mana gambar diambil (misalnya, "potret jarak dekat," "pandangan luas," "sudut rendah").</li>
                        <li><strong className="text-yellow-900">Untuk Video: Gerakan dan Transisi:</strong> Deskripsikan gerakan karakter atau objek, arah kamera (pan, tilt, zoom), dan transisi antar adegan (misalnya, "pergerakan kamera lambat," "transisi cepat," "fade out"). Tentukan durasi yang diinginkan jika memungkinkan (misalnya, "video berdurasi 10 detik").</li>
                        <li><strong className="text-yellow-900">Hindari Ambigu:</strong> Pastikan prompt Anda jelas dan tidak ada interpretasi ganda.</li>
                        <li><strong className="text-yellow-900">Gunakan Kata Kunci yang Kuat:</strong> Pilih kata-kata yang menggambarkan visual secara efektif.</li>
                        <li><strong className="text-yellow-900">Ulangi dan Perbaiki:</strong> Jika hasil pertama tidak sesuai, modifikasi prompt Anda dengan lebih banyak detail atau penyesuaian.</li>
                        <li><strong className="text-yellow-900">Hindari Konten Terlarang:</strong> Pastikan prompt Anda tidak melanggar pedoman keamanan atau etika.</li>
                    </ul>
                    <p className="text-sm text-gray-500 mt-4">
                        *Catatan: Fitur "Hasilkan Contoh Gambar" saat ini menggunakan model Imagen yang utamanya menghasilkan gambar diam. Kemampuan untuk menghasilkan video secara langsung melalui API ini mungkin memerlukan model atau konfigurasi yang berbeda.
                    </p>
                </div>
            </div>
        </div>
    );
}

export default App;
