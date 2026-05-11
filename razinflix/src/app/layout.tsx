import type { Metadata, Viewport } from 'next';
import './globals.css';
import { UIProvider } from '@/components/providers/UIProvider';

export const metadata: Metadata = {
  title: 'RazinFlix — Personal Streaming Library',
  description:
    'A self-maintaining, AI-enriched personal film catalogue. Powered by Gemini 2.5 Flash, Google Vision, YouTube API, and TMDB.',
  keywords: ['film', 'movies', 'streaming', 'personal library', 'AI', 'Netflix clone'],
  authors: [{ name: 'Ramin Hoodeh' }],
  openGraph: {
    title: 'RazinFlix',
    description: 'AI-enriched personal streaming library.',
    type: 'website',
    url: 'https://nsso.me/film/razinflix',
  },
};

export const viewport: Viewport = {
  themeColor: '#000000',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="antialiased min-h-screen bg-black text-white" suppressHydrationWarning>
        <UIProvider>{children}</UIProvider>
      </body>
    </html>
  );
}
