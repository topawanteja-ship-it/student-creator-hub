<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("sch3.jsp");
        return;
    }

    boolean loginFailed = false;
    if ("POST".equalsIgnoreCase(request.getMethod()) && "login".equals(request.getParameter("action"))) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if ("parthip".equals(username) && "1234".equals(password)) {
            session.setAttribute("currentUser", username);
            response.sendRedirect("sch3.jsp");
            return;
        }
        loginFailed = true;
    }

    String currentUser = (String) session.getAttribute("currentUser");
    boolean loggedIn = currentUser != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STUDENT CREATOR COLLABORATION HUB</title>
    
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Lucide Icons CDN -->
    <script src="https://unpkg.com/lucide@latest"></script>
    <!-- Three.js CDN for Deep 3D Dark Engine -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>

    <style>
        :root {
            --bg-primary: #02040a;
            --glass-bg: rgba(8, 12, 28, 0.75);
            --glass-border: rgba(99, 102, 241, 0.3);
            --accent-glow: #6366f1;
            --text-main: #f8fafc;
        }

        body {
            background-color: var(--bg-primary);
            color: var(--text-main);
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        /* Fullscreen WebGL Canvas Layer */
        #canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 0;
            pointer-events: none;
        }

        /* High-End Glassmorphism */
        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--glass-border);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.7);
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .glass-card:hover {
            transform: translateY(-8px) scale(1.02);
            border-color: var(--accent-glow);
            box-shadow: 0 12px 40px -10px rgba(99, 102, 241, 0.5);
        }

        /* Custom Floating AI Chat Window */
        .chat-drawer {
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Scrollbar Styling */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: rgba(0,0,0,0.5); }
        ::-webkit-scrollbar-thumb { background: rgba(99, 102, 241, 0.4); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #6366f1; }

        /* Login Shake Animation on Error */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-10px); }
            40%, 80% { transform: translateX(10px); }
        }
        .shake-error { animation: shake 0.4s ease-in-out; }

        .voice-listening { animation: voice-pulse 1.2s ease-in-out infinite; }
        @keyframes voice-pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(52, 211, 153, 0.2); }
            50% { box-shadow: 0 0 0 8px rgba(52, 211, 153, 0.08); }
        }
    </style>
</head>
<body class="antialiased">

    <!-- 3D Canvas Background Engine (Visible Everywhere) -->
    <div id="canvas-container"></div>

    <!-- LOGIN OVERLAY -->
    <div id="loginScreen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xl <%= loggedIn ? "hidden" : "" %>">
        <div id="loginBox" class="glass-panel w-full max-w-md p-8 rounded-3xl border border-indigo-500/40 shadow-2xl space-y-6 relative overflow-hidden">
            <!-- Glow Accent -->
            <div class="absolute -top-10 -right-10 w-32 h-32 bg-indigo-600/30 rounded-full blur-2xl"></div>
            <div class="absolute -bottom-10 -left-10 w-32 h-32 bg-pink-600/30 rounded-full blur-2xl"></div>

            <div class="text-center space-y-2 relative z-10">
                <div class="inline-flex p-3 rounded-2xl bg-gradient-to-tr from-indigo-600 via-purple-600 to-pink-500 text-white shadow-lg shadow-indigo-500/40 mb-2">
                    <i data-lucide="lock" class="w-8 h-8"></i>
                </div>
                <h2 class="text-2xl font-black tracking-wider text-white">STUDENT CREATOR</h2>
                <p class="text-[10px] font-semibold tracking-widest text-pink-300 uppercase">STUDENT CREATOR COLLABORATION HUB</p>
                <p data-i18n="loginSubtitle" class="text-xs text-slate-400">Enter your credentials to unlock the ecosystem</p>
                <select id="languageSelectLogin" onchange="changeLanguage(this.value)" aria-label="Choose language" class="px-3 py-2 rounded-xl bg-slate-900/80 border border-indigo-500/30 text-slate-200 text-xs focus:outline-none focus:border-indigo-400">
                    <option value="en">English</option><option value="as">অসমীয়া</option><option value="bn">বাংলা</option><option value="gu">ગુજરાતી</option><option value="hi">हिन्दी</option><option value="kn">ಕನ್ನಡ</option><option value="ml">മലയാളം</option><option value="mr">मराठी</option><option value="or">ଓଡ଼ିଆ</option><option value="pa">ਪੰਜਾਬੀ</option><option value="ta">தமிழ்</option><option value="te">తెలుగు</option><option value="ur">اردو</option>
                </select>
            </div>

            <form method="post" action="sch3.jsp" class="space-y-4 relative z-10">
                <input type="hidden" name="action" value="login">
                <div>
                    <label data-i18n="username" class="block text-xs font-semibold text-slate-300 mb-1.5">Username</label>
                    <div class="relative">
                        <i data-lucide="user" class="absolute left-3.5 top-3 w-4 h-4 text-slate-400"></i>
                        <input type="text" id="loginUsername" name="username" required placeholder="parthip" 
                               class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white/5 border border-white/10 text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 transition text-sm">
                    </div>
                </div>

                <div>
                    <label data-i18n="password" class="block text-xs font-semibold text-slate-300 mb-1.5">Password</label>
                    <div class="relative">
                        <i data-lucide="key" class="absolute left-3.5 top-3 w-4 h-4 text-slate-400"></i>
                        <input type="password" id="loginPassword" name="password" required placeholder="••••" 
                               class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white/5 border border-white/10 text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 transition text-sm">
                    </div>
                </div>

                <div id="loginError" class="<%= loginFailed ? "" : "hidden" %> text-xs text-rose-400 text-center font-medium bg-rose-500/10 border border-rose-500/20 py-2 rounded-xl">
                    Invalid username or password!
                </div>

                <button type="submit" class="w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500 via-purple-600 to-pink-500 hover:opacity-90 text-white font-bold text-sm shadow-lg shadow-indigo-500/30 transition active:scale-95 flex items-center justify-center space-x-2">
                    <span data-i18n="unlockDashboard">Unlock Dashboard</span>
                    <i data-lucide="arrow-right" class="w-4 h-4"></i>
                </button>
            </form>
        </div>
    </div>

    <!-- MAIN DASHBOARD CONTENT (Hidden until authenticated) -->
    <div id="mainDashboard" class="<%= loggedIn ? "" : "hidden" %> relative z-10">
        <!-- Navigation Header -->
        <nav class="sticky top-0 z-40 glass-panel border-b border-indigo-500/20 px-6 py-4 mb-8">
            <div class="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-4">
                <div class="flex items-center space-x-3">
                    <div class="p-2.5 rounded-xl bg-gradient-to-tr from-indigo-600 via-purple-600 to-pink-500 text-white shadow-lg shadow-indigo-500/40">
                        <i data-lucide="box" class="w-6 h-6 animate-spin" style="animation-duration: 12s;"></i>
                    </div>
                    <div>
                        <span class="text-2xl font-black tracking-wider bg-clip-text text-transparent bg-gradient-to-r from-white via-slate-200 to-indigo-400">
                            STUDENT CREATOR
                        </span>
                        <span class="block text-[10px] font-mono tracking-widest text-indigo-400 uppercase">COLLABORATION HUB</span>
                    </div>
                </div>

                <!-- Global Search -->
                <div class="relative flex-1 max-w-md mx-4">
                    <i data-lucide="search" class="absolute left-3.5 top-3 w-4 h-4 text-slate-400"></i>
                    <input type="text" id="globalSearch" onkeyup="handleGlobalSearch()" 
                           placeholder="Search roles, creators, skills, algorithms..." 
                           class="w-full pl-10 pr-4 py-2 rounded-xl bg-white/5 border border-white/10 text-slate-200 placeholder-slate-400 focus:outline-none focus:border-indigo-500 transition text-sm">
                </div>

                <div class="flex items-center space-x-3">
                    <select id="languageSelect" onchange="changeLanguage(this.value)" aria-label="Choose language" class="px-3 py-2 rounded-xl bg-slate-900/80 border border-indigo-500/30 text-slate-200 text-xs focus:outline-none focus:border-indigo-400">
                        <option value="en">English</option>
                        <option value="as">অসমীয়া</option>
                        <option value="bn">বাংলা</option>
                        <option value="gu">ગુજરાતી</option>
                        <option value="hi">हिन्दी</option>
                        <option value="kn">ಕನ್ನಡ</option>
                        <option value="ml">മലയാളം</option>
                        <option value="mr">मराठी</option>
                        <option value="or">ଓଡ଼ିଆ</option>
                        <option value="pa">ਪੰਜਾਬੀ</option>
                        <option value="ta">தமிழ்</option>
                        <option value="te">తెలుగు</option>
                        <option value="ur">اردو</option>
                    </select>
                    <button onclick="openApplicationsModal()" class="flex items-center gap-2 px-3 py-2 rounded-xl bg-pink-500/10 border border-pink-500/20 text-pink-200 text-xs font-semibold hover:bg-pink-500/20 transition">
                        <i data-lucide="clipboard-list" class="w-4 h-4"></i>
                        <span>Applications</span>
                        <span id="navApplicationCount" class="min-w-6 px-1.5 py-0.5 rounded-full bg-pink-500 text-white text-[10px] text-center">5,120</span>
                    </button>
                    <button onclick="openMessagingModal()" class="flex items-center gap-2 px-3 py-2 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-cyan-200 text-xs font-semibold hover:bg-cyan-500/20 transition">
                        <i data-lucide="message-circle" class="w-4 h-4"></i><span>Messaging</span>
                    </button>
                    <button onclick="toggleModal('postModal', true)" class="flex items-center space-x-2 px-4 py-2 rounded-xl bg-gradient-to-r from-indigo-500 via-purple-600 to-pink-500 hover:opacity-90 text-white font-medium text-sm shadow-lg shadow-indigo-500/30 transition active:scale-95">
                        <i data-lucide="plus-circle" class="w-4 h-4"></i>
                        <span>Create Post</span>
                    </button>

                    <!-- User Profile & Logout -->
                    <div class="flex items-center space-x-2 pl-2 border-l border-white/10">
                        <div class="px-3 py-1.5 rounded-xl bg-indigo-500/20 border border-indigo-500/30 text-xs font-semibold text-indigo-300 flex items-center space-x-1.5">
                            <i data-lucide="user-check" class="w-3.5 h-3.5 text-emerald-400"></i>
                            <span id="displayUsername"><%= loggedIn ? currentUser : "parthip" %></span>
                        </div>
                        <button onclick="handleLogout()" title="Logout" class="p-2 rounded-xl bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border border-rose-500/20 transition">
                            <i data-lucide="log-out" class="w-4 h-4"></i>
                        </button>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content Layout -->
        <main class="max-w-7xl mx-auto px-6 pb-24 space-y-10">

            <!-- Stat Cards -->
            <section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="glass-panel p-6 rounded-2xl relative overflow-hidden group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p data-i18n="activeNodes" class="text-xs font-semibold uppercase tracking-wider text-slate-400">Active Nodes</p>
                            <h3 class="text-3xl font-extrabold mt-2 text-white">412</h3>
                        </div>
                        <div class="p-3 bg-indigo-500/10 rounded-xl text-indigo-400 border border-indigo-500/20">
                            <i data-lucide="network" class="w-6 h-6"></i>
                        </div>
                    </div>
                </div>

                <div class="glass-panel p-6 rounded-2xl relative overflow-hidden group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p data-i18n="totalApplications" class="text-xs font-semibold uppercase tracking-wider text-slate-400">Total Applications</p>
                            <h3 id="statApps" class="text-3xl font-extrabold mt-2 text-white">5,120</h3>
                        </div>
                        <div class="p-3 bg-pink-500/10 rounded-xl text-pink-400 border border-pink-500/20">
                            <i data-lucide="file-text" class="w-6 h-6"></i>
                        </div>
                    </div>
                </div>

                <div class="glass-panel p-6 rounded-2xl relative overflow-hidden group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p data-i18n="aiAccuracy" class="text-xs font-semibold uppercase tracking-wider text-slate-400">AI Accuracy</p>
                            <h3 class="text-3xl font-extrabold mt-2 text-emerald-400">99.1%</h3>
                        </div>
                        <div class="p-3 bg-emerald-500/10 rounded-xl text-emerald-400 border border-emerald-500/20">
                            <i data-lucide="brain-circuit" class="w-6 h-6"></i>
                        </div>
                    </div>
                </div>

                <div class="glass-panel p-6 rounded-2xl relative overflow-hidden group">
                    <div class="flex items-center justify-between">
                        <div>
                            <p data-i18n="upvotes" class="text-xs font-semibold uppercase tracking-wider text-slate-400">Ecosystem Upvotes</p>
                            <h3 id="statVotes" class="text-3xl font-extrabold mt-2 text-amber-400">18,940</h3>
                        </div>
                        <div class="p-3 bg-amber-500/10 rounded-xl text-amber-400 border border-amber-500/20">
                            <i data-lucide="zap" class="w-6 h-6"></i>
                        </div>
                    </div>
                </div>
            </section>

            <!-- CREATOR ANALYTICS DASHBOARD -->
            <section class="grid grid-cols-1 lg:grid-cols-5 gap-6">
                <div class="lg:col-span-3 glass-panel p-6 rounded-2xl">
                    <div class="flex items-center justify-between mb-5">
                        <div>
                            <p class="text-xs font-semibold uppercase tracking-wider text-indigo-300">Creator analytics</p>
                            <h2 class="text-xl font-bold text-white mt-1">Collaboration activity</h2>
                        </div>
                        <span class="text-[10px] text-emerald-300 px-2 py-1 rounded-lg bg-emerald-500/10 border border-emerald-500/20">+24% this week</span>
                    </div>
                    <div class="h-40 flex items-end gap-3 border-b border-white/10 px-2">
                        <div class="flex-1 h-[38%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Mon: 38 interactions"></div>
                        <div class="flex-1 h-[54%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Tue: 54 interactions"></div>
                        <div class="flex-1 h-[46%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Wed: 46 interactions"></div>
                        <div class="flex-1 h-[72%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Thu: 72 interactions"></div>
                        <div class="flex-1 h-[64%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Fri: 64 interactions"></div>
                        <div class="flex-1 h-[88%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Sat: 88 interactions"></div>
                        <div class="flex-1 h-[76%] rounded-t-lg bg-gradient-to-t from-indigo-600 to-cyan-300" title="Sun: 76 interactions"></div>
                    </div>
                    <div class="flex justify-between px-2 pt-2 text-[10px] text-slate-500"><span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span></div>
                </div>
                <div class="lg:col-span-2 glass-panel p-6 rounded-2xl">
                    <p class="text-xs font-semibold uppercase tracking-wider text-pink-300">Role demand</p>
                    <h2 class="text-xl font-bold text-white mt-1 mb-5">Most requested skills</h2>
                    <div class="space-y-4 text-xs">
                        <div><div class="flex justify-between mb-1 text-slate-300"><span>Video editing</span><span>82%</span></div><div class="h-2 rounded-full bg-white/10"><div class="h-2 w-[82%] rounded-full bg-pink-400"></div></div></div>
                        <div><div class="flex justify-between mb-1 text-slate-300"><span>3D design</span><span>68%</span></div><div class="h-2 rounded-full bg-white/10"><div class="h-2 w-[68%] rounded-full bg-indigo-400"></div></div></div>
                        <div><div class="flex justify-between mb-1 text-slate-300"><span>AI production</span><span>61%</span></div><div class="h-2 rounded-full bg-white/10"><div class="h-2 w-[61%] rounded-full bg-cyan-400"></div></div></div>
                        <div><div class="flex justify-between mb-1 text-slate-300"><span>Audio & podcast</span><span>47%</span></div><div class="h-2 rounded-full bg-white/10"><div class="h-2 w-[47%] rounded-full bg-amber-400"></div></div></div>
                    </div>
                </div>
            </section>

            <!-- Dynamic Opportunities Section -->
            <section class="space-y-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <h2 data-i18n="trending" class="text-2xl font-bold text-white tracking-tight">Trending Collaborations & Opportunities</h2>
                        <p data-i18n="trendingDesc" class="text-sm text-slate-400">AI-matched creator roles with live 3D environment support.</p>
                    </div>
                </div>

                <!-- Categories -->
                <div class="flex items-center space-x-2 overflow-x-auto pb-2">
                    <button onclick="filterCategory('All')" class="filter-btn active-tab px-4 py-2 rounded-xl text-xs font-semibold glass-panel bg-indigo-600/30 border-indigo-500 text-indigo-300">All</button>
                    <button onclick="filterCategory('YouTube')" class="filter-btn px-4 py-2 rounded-xl text-xs font-semibold glass-panel text-slate-400 hover:text-white">YouTube</button>
                    <button onclick="filterCategory('Podcast')" class="filter-btn px-4 py-2 rounded-xl text-xs font-semibold glass-panel text-slate-400 hover:text-white">Podcast</button>
                    <button onclick="filterCategory('Design')" class="filter-btn px-4 py-2 rounded-xl text-xs font-semibold glass-panel text-slate-400 hover:text-white">Design & 3D</button>
                    <button onclick="filterCategory('AI Tech')" class="filter-btn px-4 py-2 rounded-xl text-xs font-semibold glass-panel text-slate-400 hover:text-white">AI Tech</button>
                </div>

                <!-- Grid -->
                <div id="postsGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"></div>
            </section>
        </main>

        <!-- ADVANCED AI ASSISTANT WIDGET -->
        <div id="chatWidget" class="fixed bottom-6 right-6 z-50">
            <!-- Chat Trigger Floating Icon -->
            <button onclick="toggleChat()" class="p-4 rounded-full bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 text-white shadow-2xl hover:scale-110 transition duration-300 flex items-center justify-center relative">
                <i data-lucide="bot" class="w-7 h-7"></i>
                <span class="absolute -top-1 -right-1 flex h-3 w-3">
                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                    <span class="relative inline-flex rounded-full h-3 w-3 bg-emerald-500"></span>
                </span>
            </button>

            <!-- Chat Window Drawer -->
            <div id="chatWindow" class="hidden absolute bottom-16 right-0 w-80 md:w-96 glass-panel rounded-2xl border border-indigo-500/40 shadow-2xl flex flex-col h-[520px] overflow-hidden chat-drawer">
                <!-- Header -->
                <div class="p-4 bg-indigo-950/60 border-b border-white/10 flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                        <div class="p-2 rounded-lg bg-indigo-600/30 text-indigo-400 border border-indigo-500/30">
                            <i data-lucide="sparkles" class="w-5 h-5"></i>
                        </div>
                        <div>
                            <span class="font-bold text-sm text-white block">Student Hub AI Assistant</span>
                            <span id="voiceStatus" class="text-[10px] text-emerald-400 font-mono flex items-center gap-1">
                                <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span> Online & Listening
                            </span>
                        </div>
                    </div>
                    <button onclick="toggleChat()" class="text-slate-400 hover:text-white transition"><i data-lucide="x" class="w-5 h-5"></i></button>
                </div>

                <!-- Messages Stream -->
                <div id="chatMessages" class="flex-1 p-4 overflow-y-auto space-y-3 text-xs">
                    <div class="bg-indigo-950/40 text-slate-200 p-3 rounded-xl max-w-[88%] border border-indigo-500/20">
                        <p class="font-semibold text-indigo-300 mb-1">Welcome back, Parthip! 🤖</p>
                        I am your Student Hub AI assistant. Here is what I can do:
                        <ul class="list-disc list-inside mt-1 space-y-1 text-slate-300">
                            <li>Match you with active 3D & AI roles</li>
                            <li>Review your project metrics</li>
                            <li>Help you submit applications</li>
                        </ul>
                    </div>
                </div>

                <!-- Quick Action Chips -->
                <div class="px-3 py-2 bg-black/40 border-t border-white/5 flex gap-1.5 overflow-x-auto text-[11px]">
                    <button onclick="sendQuickPrompt('Find high matching roles')" class="px-2.5 py-1 rounded-lg bg-indigo-600/20 hover:bg-indigo-600/40 text-indigo-300 border border-indigo-500/30 whitespace-nowrap">🎯 Match Roles</button>
                    <button onclick="sendQuickPrompt('Analyze my portfolio')" class="px-2.5 py-1 rounded-lg bg-purple-600/20 hover:bg-purple-600/40 text-purple-300 border border-purple-500/30 whitespace-nowrap">📈 Portfolio Review</button>
                </div>

                <!-- Input Bar -->
                <form onsubmit="sendChatMessage(event)" class="p-3 border-t border-white/10 flex items-center space-x-2 bg-black/60">
                    <input type="text" id="chatInput" placeholder="Ask AI assistant..." class="flex-1 px-3 py-2.5 rounded-xl bg-white/5 border border-white/10 text-white text-xs focus:outline-none focus:border-indigo-500">
                    <button type="button" id="voiceInputButton" onclick="toggleVoiceInput()" title="Speak to Student Hub AI" class="p-2.5 rounded-xl bg-emerald-500/10 text-emerald-300 border border-emerald-500/20 hover:bg-emerald-500/20 transition"><i data-lucide="mic" class="w-4 h-4"></i></button>
                    <button type="button" id="voiceOutputButton" onclick="toggleVoiceOutput()" title="Toggle spoken replies" class="p-2.5 rounded-xl bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 hover:bg-indigo-500/30 transition"><i data-lucide="volume-2" class="w-4 h-4"></i></button>
                    <button type="submit" class="p-2.5 rounded-xl bg-indigo-600 text-white hover:bg-indigo-500 transition shadow-lg shadow-indigo-600/30"><i data-lucide="send" class="w-4 h-4"></i></button>
                </form>
            </div>
        </div>

        <!-- APPLY MODAL -->
        <div id="applyModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md hidden">
            <div class="glass-panel w-full max-w-lg p-6 rounded-2xl border border-white/20 shadow-2xl space-y-4">
                <div class="flex justify-between items-center border-b border-white/10 pb-3">
                    <h3 class="text-lg font-bold text-white">Apply for Role</h3>
                    <button onclick="toggleModal('applyModal', false)" class="text-slate-400 hover:text-white"><i data-lucide="x" class="w-5 h-5"></i></button>
                </div>
                <form id="applyForm" onsubmit="submitApplication(event)" class="space-y-4">
                    <input type="hidden" id="applyRoleTitle">
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Full Name</label>
                        <input type="text" id="appFullName" required value="parthip" class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Email Address</label>
                        <input type="email" id="appEmail" required placeholder="student@creatorhub.com" class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Portfolio / Work URL</label>
                        <input type="url" id="appPortfolio" required placeholder="https://github.com/parthip" class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs">
                    </div>
                    <div id="profileInterviewContainer" class="hidden mt-3 p-3 rounded-xl bg-indigo-500/10 border border-indigo-500/20">
                        <div class="flex items-center justify-between mb-2">
                            <p class="text-xs font-semibold text-indigo-200">Profile experience interview</p>
                            <span id="profileInterviewBadge" class="px-2 py-1 rounded-full bg-indigo-500/20 text-[10px] text-indigo-200 border border-indigo-500/30">LinkedIn / GitHub</span>
                        </div>
                        <div id="profileInterviewQuestions" class="space-y-3"></div>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Work report or cover note</label>
                        <textarea id="applicationReport" rows="3" placeholder="Describe your skills, tools, experience, availability, and contribution..." class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 text-xs"></textarea>
                        <button type="button" onclick="analyzeApplicationReport()" class="mt-2 px-3 py-2 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-300 hover:bg-emerald-500/20 text-xs font-semibold">Analyze with AI</button>
                        <div id="applicationAnalysis" class="hidden mt-3 p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/20"></div>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Attach work samples</label>
                        <input type="file" id="applicationMedia" accept="image/*,video/*" multiple onchange="previewApplicationMedia(event)" class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-slate-300 text-xs">
                        <div id="applicationMediaPreview" class="grid grid-cols-4 gap-2 mt-2"></div>
                        <p class="text-[10px] text-slate-500 mt-1">Share images, demo reels, or short videos with your application.</p>
                    </div>
                    <div class="flex justify-end space-x-3 pt-2">
                        <button type="button" onclick="toggleModal('applyModal', false)" class="px-4 py-2 rounded-xl text-xs font-medium text-slate-400 hover:text-white">Cancel</button>
                        <button type="submit" class="px-4 py-2 rounded-xl text-xs font-semibold bg-indigo-600 hover:bg-indigo-500 text-white shadow-lg">Submit Application</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- APPLICATIONS OVERVIEW MODAL -->
        <div id="applicationsModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md hidden p-4">
            <div class="glass-panel w-full max-w-4xl max-h-[85vh] overflow-y-auto p-6 rounded-2xl border border-pink-500/30 shadow-2xl space-y-4">
                <div class="flex justify-between items-center border-b border-white/10 pb-3">
                    <div><h3 class="text-lg font-bold text-white">Registered Applications</h3><p class="text-xs text-slate-400">Review applicants, reports, links, AI signals, and submitted work.</p></div>
                    <button onclick="toggleModal('applicationsModal', false)" class="text-slate-400 hover:text-white"><i data-lucide="x" class="w-5 h-5"></i></button>
                </div>
                <div id="applicationsList" class="space-y-3"></div>
            </div>
        </div>

        <!-- MESSAGING MODAL -->
        <div id="messagingModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md hidden p-4">
            <div class="glass-panel w-full max-w-lg max-h-[85vh] p-6 rounded-2xl border border-cyan-500/30 shadow-2xl flex flex-col">
                <div class="flex justify-between items-center border-b border-white/10 pb-3">
                    <div><h3 class="text-lg font-bold text-white">Creator Messaging</h3><p id="messageRecipient" class="text-xs text-cyan-300 mt-1">Select an applicant to start a conversation.</p></div>
                    <button onclick="toggleModal('messagingModal', false)" class="text-slate-400 hover:text-white"><i data-lucide="x" class="w-5 h-5"></i></button>
                </div>
                <div id="conversationList" class="flex-1 min-h-48 max-h-80 overflow-y-auto py-4 space-y-2"></div>
                <form onsubmit="sendCreatorMessage(event)" class="border-t border-white/10 pt-3 flex gap-2">
                    <input id="messageInput" required placeholder="Write a message to the creator..." class="flex-1 px-3 py-2.5 rounded-xl bg-white/5 border border-white/10 text-white placeholder-slate-500 text-xs focus:outline-none focus:border-cyan-400">
                    <button type="submit" class="px-3 py-2 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold"><i data-lucide="send" class="w-4 h-4"></i></button>
                </form>
            </div>
        </div>

        <!-- POST MODAL -->
        <div id="postModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-md hidden">
            <div class="glass-panel w-full max-w-lg p-6 rounded-2xl border border-white/20 shadow-2xl space-y-4">
                <div class="flex justify-between items-center border-b border-white/10 pb-3">
                    <h3 class="text-lg font-bold text-white">Publish Opportunity</h3>
                    <button onclick="toggleModal('postModal', false)" class="text-slate-400 hover:text-white"><i data-lucide="x" class="w-5 h-5"></i></button>
                </div>
                <form id="postForm" onsubmit="createNewPost(event)" class="space-y-4">
                    <div class="grid grid-cols-2 gap-2">
                        <button type="button" id="postTypeOpportunity" onclick="setPostType('Opportunity')" class="post-type-btn px-3 py-2 rounded-xl text-xs font-semibold bg-indigo-600/30 border border-indigo-500 text-indigo-200">Opportunity</button>
                        <button type="button" id="postTypeRequirement" onclick="setPostType('Requirement')" class="post-type-btn px-3 py-2 rounded-xl text-xs font-semibold bg-white/5 border border-white/10 text-slate-400">Requirement</button>
                    </div>
                    <input type="hidden" id="postType" value="Opportunity">
                    <div class="p-3 rounded-xl bg-indigo-500/10 border border-indigo-500/20 space-y-2">
                        <div class="flex items-center gap-2"><i data-lucide="sparkles" class="w-4 h-4 text-indigo-300"></i><span class="text-xs font-semibold text-indigo-200">AI post generator</span></div>
                        <div class="flex gap-2">
                            <input type="text" id="aiPostPrompt" placeholder="e.g. Need a 3D artist for a sci-fi trailer" class="flex-1 px-3 py-2 rounded-lg bg-black/20 border border-white/10 text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 text-xs">
                            <button type="button" onclick="generateAIPost()" class="px-3 py-2 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold">Generate</button>
                        </div>
                        <div class="flex flex-wrap gap-1.5">
                            <button type="button" onclick="useAIPreset('video editor')" class="px-2 py-1 rounded-lg bg-white/5 border border-white/10 text-[10px] text-slate-300 hover:text-white">Video editor</button>
                            <button type="button" onclick="useAIPreset('podcast producer')" class="px-2 py-1 rounded-lg bg-white/5 border border-white/10 text-[10px] text-slate-300 hover:text-white">Podcast producer</button>
                            <button type="button" onclick="useAIPreset('3D designer')" class="px-2 py-1 rounded-lg bg-white/5 border border-white/10 text-[10px] text-slate-300 hover:text-white">3D designer</button>
                            <button type="button" onclick="generateOpportunityOptions()" class="px-2 py-1 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-[10px] text-emerald-300 hover:bg-emerald-500/20">Generate 3 options</button>
                        </div>
                        <div id="aiOpportunityOptions" class="hidden space-y-2"></div>
                        <p id="aiPostStatus" class="hidden text-[10px] text-emerald-300"></p>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Title</label>
                        <input type="text" id="postTitle" required class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Category</label>
                        <select id="postCategory" class="w-full px-3 py-2 rounded-xl bg-slate-900 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs">
                            <option value="YouTube">YouTube</option>
                            <option value="Podcast">Podcast</option>
                            <option value="Design">Design & 3D</option>
                            <option value="AI Tech">AI Tech</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Description</label>
                        <textarea id="postDesc" rows="3" required class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-indigo-500 text-xs"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-300 mb-1">Images or videos</label>
                        <input type="file" id="postMedia" accept="image/*,video/*" multiple onchange="previewPostMedia(event)" class="w-full px-3 py-2 rounded-xl bg-white/5 border border-white/10 text-slate-300 text-xs">
                        <div id="postMediaPreview" class="grid grid-cols-3 gap-2 mt-2"></div>
                    </div>
                    <div class="flex justify-end space-x-3 pt-2">
                        <button type="button" onclick="toggleModal('postModal', false)" class="px-4 py-2 rounded-xl text-xs font-medium text-slate-400 hover:text-white">Cancel</button>
                        <button type="submit" class="px-4 py-2 rounded-xl text-xs font-semibold bg-gradient-to-r from-indigo-500 to-purple-600 text-white shadow-lg">Publish Now</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- TOAST MESSAGES -->
        <div id="toastContainer" class="fixed bottom-6 left-6 z-50 space-y-3 pointer-events-none"></div>
    </div>

    <script>
        // --- 1. AUTHENTICATION ENGINE ---
        function handleLogin(e) {
            e.preventDefault();
            const user = document.getElementById('loginUsername').value.trim();
            const pass = document.getElementById('loginPassword').value.trim();
            const errorBox = document.getElementById('loginError');
            const loginBox = document.getElementById('loginBox');

            if (user === 'parthip' && pass === '1234') {
                errorBox.classList.add('hidden');
                document.getElementById('loginScreen').classList.add('hidden');
                document.getElementById('mainDashboard').classList.remove('hidden');
                showToast("Welcome back, parthip!");
            } else {
                errorBox.classList.remove('hidden');
                loginBox.classList.add('shake-error');
                setTimeout(() => loginBox.classList.remove('shake-error'), 400);
            }
        }

        function handleLogout() {
            window.location.href = 'sch3.jsp?action=logout';
        }

        // --- 2. DATA STATE ---
        let posts = [
            { id: 1, title: "Generative AI Video Editor", category: "YouTube", votes: 532, bg: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80", desc: "Craft stunning video experiences utilizing Runway Gen-2 and After Effects." },
            { id: 2, title: "Unreal Engine 5 Dark 3D Artist", category: "Design", votes: 810, bg: "https://images.unsplash.com/photo-1634017839464-5c339ebe3cb4?w=600&auto=format&fit=crop&q=80", desc: "Build futuristic dark grid environments and virtual production sets." },
            { id: 3, title: "Spatial AI Audio Master", category: "Podcast", votes: 340, bg: "https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=600&auto=format&fit=crop&q=80", desc: "Refine audio clarity and master spatial acoustics using neural networks." },
            { id: 4, title: "Short-Form Content Strategist", category: "YouTube", votes: 276, bg: "https://images.unsplash.com/photo-1536240478700-b869070f9279?w=600&auto=format&fit=crop&q=80", desc: "Plan a creator-first content calendar for Reels, Shorts, and TikTok launches." },
            { id: 5, title: "Brand Identity Illustrator", category: "Design", votes: 418, bg: "https://images.unsplash.com/photo-1561214115-f2f134cc4912?w=600&auto=format&fit=crop&q=80", desc: "Create a distinctive visual identity, social kit, and launch artwork for student creators." },
            { id: 6, title: "AI Research & Prompt Designer", category: "AI Tech", votes: 625, bg: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=600&auto=format&fit=crop&q=80", desc: "Design reliable prompts and creative workflows for an AI-assisted production team." },
            { id: 7, title: "Community Growth Coordinator", category: "AI Tech", votes: 189, bg: "https://images.unsplash.com/photo-1556761175-b413da4baf72?w=600&auto=format&fit=crop&q=80", desc: "Build events, feedback loops, and welcoming spaces for student creator collaborations." }
        ];

        let activeCategory = 'All';
        let selectedPostType = 'Opportunity';
        let selectedPostMedia = [];
        let voiceOutputEnabled = false;
        let voiceRecognition = null;
        let selectedApplicationMedia = [];
        let applications = [];
        let latestApplicationScore = null;
        let activeConversation = null;
        let messages = {};

        const translations = {
            en: { loginSubtitle: 'Enter your credentials to unlock the ecosystem', username: 'Username', password: 'Password', unlockDashboard: 'Unlock Dashboard', activeNodes: 'Active Nodes', totalApplications: 'Total Applications', aiAccuracy: 'AI Accuracy', upvotes: 'Ecosystem Upvotes', trending: 'Trending Collaborations & Opportunities', trendingDesc: 'AI-matched creator roles with live 3D environment support.' },
            as: { loginSubtitle: 'ইক' + 'োচিষ্টেম খুলিবলৈ আপোনাৰ তথ্য দিয়ক', username: 'ব্যৱহাৰকাৰীৰ নাম', password: 'পাছৱৰ্ড', unlockDashboard: 'ডেশ্বব' + 'ৰ্ড খোলক', activeNodes: 'সক্ৰিয় ন' + 'ড', totalApplications: 'মুঠ আবেদন', aiAccuracy: 'AI সঠিকতা', upvotes: 'আপভোট', trending: 'জনপ্ৰিয় সহযোগিতা আৰু সুযোগ', trendingDesc: 'AI-ভিত্তিক সৃষ্টিশীল ভূমিকাসমূহ।' },
            bn: { loginSubtitle: 'ইকোসিস্টেম খুলতে আপনার তথ্য দিন', username: 'ব্যবহারকারীর নাম', password: 'পাসওয়ার্ড', unlockDashboard: 'ড্যাশবোর্ড খুলুন', activeNodes: 'সক্রিয় নোড', totalApplications: 'মোট আবেদন', aiAccuracy: 'AI নির্ভুলতা', upvotes: 'আপভোট', trending: 'জনপ্রিয় সহযোগিতা ও সুযোগ', trendingDesc: 'AI-মিলিত স্রষ্টার ভূমিকা।' },
            gu: { loginSubtitle: 'ઇકોસિસ્ટમ ખોલવા માટે તમારી વિગતો દાખલ કરો', username: 'વપરાશકર્તા નામ', password: 'પાસવર્ડ', unlockDashboard: 'ડેશબોર્ડ ખોલો', activeNodes: 'સક્રિય નોડ્સ', totalApplications: 'કુલ અરજીઓ', aiAccuracy: 'AI ચોકસાઈ', upvotes: 'અપવોટ્સ', trending: 'ટ્રેન્ડિંગ સહયોગ અને તકો', trendingDesc: 'AI સાથે મેળ ખાતી સર્જક ભૂમિકાઓ.' },
            hi: { loginSubtitle: 'इकोसिस्टम खोलने के लिए अपनी जानकारी दर्ज करें', username: 'उपयोगकर्ता नाम', password: 'पासवर्ड', unlockDashboard: 'डैशबोर्ड खोलें', activeNodes: 'सक्रिय नोड', totalApplications: 'कुल आवेदन', aiAccuracy: 'AI सटीकता', upvotes: 'अपवोट', trending: 'लोकप्रिय सहयोग और अवसर', trendingDesc: 'AI से मिलान की गई क्रिएटर भूमिकाएँ।' },
            kn: { loginSubtitle: 'ಇಕೋಸಿಸ್ಟಮ್ ತೆರೆಯಲು ನಿಮ್ಮ ವಿವರಗಳನ್ನು ನಮೂದಿಸಿ', username: 'ಬಳಕೆದಾರ ಹೆಸರು', password: 'ಪಾಸ್‌ವರ್ಡ್', unlockDashboard: 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್ ತೆರೆಯಿರಿ', activeNodes: 'ಸಕ್ರಿಯ ನೋಡ್‌ಗಳು', totalApplications: 'ಒಟ್ಟು ಅರ್ಜಿಗಳು', aiAccuracy: 'AI ನಿಖರತೆ', upvotes: 'ಅಪ್‌ವೋಟ್‌ಗಳು', trending: 'ಜನಪ್ರಿಯ ಸಹಯೋಗಗಳು ಮತ್ತು ಅವಕಾಶಗಳು', trendingDesc: 'AI ಹೊಂದಾಣಿಕೆಯ ಸೃಜನಶೀಲ ಪಾತ್ರಗಳು.' },
            ml: { loginSubtitle: 'ഇക്കോസിസ്റ്റം തുറക്കാൻ നിങ്ങളുടെ വിവരങ്ങൾ നൽകുക', username: 'ഉപയോക്തൃനാമം', password: 'പാസ്‌വേഡ്', unlockDashboard: 'ഡാഷ്‌ബോർഡ് തുറക്കുക', activeNodes: 'സജീവ നോഡുകൾ', totalApplications: 'ആകെ അപേക്ഷകൾ', aiAccuracy: 'AI കൃത്യത', upvotes: 'അപ്‌വോട്ടുകൾ', trending: 'ജനപ്രിയ സഹകരണങ്ങളും അവസരങ്ങളും', trendingDesc: 'AI പൊരുത്തപ്പെടുത്തിയ ക്രിയേറ്റർ റോളുകൾ.' },
            mr: { loginSubtitle: 'इकोसिस्टम उघडण्यासाठी तुमची माहिती द्या', username: 'वापरकर्तानाव', password: 'पासवर्ड', unlockDashboard: 'डॅशबोर्ड उघडा', activeNodes: 'सक्रिय नोड्स', totalApplications: 'एकूण अर्ज', aiAccuracy: 'AI अचूकता', upvotes: 'अपव्होट्स', trending: 'ट्रेंडिंग सहयोग आणि संधी', trendingDesc: 'AI जुळवलेल्या क्रिएटर भूमिका.' },
            or: { loginSubtitle: 'ଇକୋସିଷ୍ଟମ ଖୋଲିବା ପାଇଁ ଆପଣଙ୍କ ତଥ୍ୟ ଦିଅନ୍ତୁ', username: 'ବ୍ୟବହାରକାରୀ ନାମ', password: 'ପାସୱାର୍ଡ', unlockDashboard: 'ଡ୍ୟାସବୋର୍ଡ ଖୋଲନ୍ତୁ', activeNodes: 'ସକ୍ରିୟ ନୋଡ', totalApplications: 'ମୋଟ ଆବେଦନ', aiAccuracy: 'AI ସଠିକତା', upvotes: 'ଅପଭୋଟ', trending: 'ଲୋକପ୍ରିୟ ସହଯୋଗ ଏବଂ ସୁଯୋଗ', trendingDesc: 'AI ମେଳ ହୋଇଥିବା ସୃଜନଶୀଳ ଭୂମିକା।' },
            pa: { loginSubtitle: 'ਈਕੋਸਿਸਟਮ ਖੋਲ੍ਹਣ ਲਈ ਆਪਣੀ ਜਾਣਕਾਰੀ ਦਿਓ', username: 'ਵਰਤੋਂਕਾਰ ਨਾਮ', password: 'ਪਾਸਵਰਡ', unlockDashboard: 'ਡੈਸ਼ਬੋਰਡ ਖੋਲ੍ਹੋ', activeNodes: 'ਸਰਗਰਮ ਨੋਡ', totalApplications: 'ਕੁੱਲ ਅਰਜ਼ੀਆਂ', aiAccuracy: 'AI ਸ਼ੁੱਧਤਾ', upvotes: 'ਅਪਵੋਟ', trending: 'ਪ੍ਰਸਿੱਧ ਸਹਿਯੋਗ ਅਤੇ ਮੌਕੇ', trendingDesc: 'AI ਨਾਲ ਮਿਲਦੀਆਂ ਰਚਨਾਕਾਰ ਭੂਮਿਕਾਵਾਂ।' },
            ta: { loginSubtitle: 'சுற்றுச்சூழலைத் திறக்க உங்கள் விவரங்களை உள்ளிடவும்', username: 'பயனர் பெயர்', password: 'கடவுச்சொல்', unlockDashboard: 'டாஷ்போர்டைத் திறக்கவும்', activeNodes: 'செயலில் உள்ள முனைகள்', totalApplications: 'மொத்த விண்ணப்பங்கள்', aiAccuracy: 'AI துல்லியம்', upvotes: 'அப்வோட்கள்', trending: 'பிரபலமான ஒத்துழைப்புகள் மற்றும் வாய்ப்புகள்', trendingDesc: 'AI பொருத்திய படைப்பாளர் பணிகள்.' },
            te: { loginSubtitle: 'ఎకోసిస్టమ్‌ను తెరవడానికి మీ వివరాలను నమోదు చేయండి', username: 'వినియోగదారు పేరు', password: 'పాస్‌వర్డ్', unlockDashboard: 'డ్యాష్‌బోర్డ్ తెరవండి', activeNodes: 'క్రియాశీల నోడ్‌లు', totalApplications: 'మొత్తం దరఖాస్తులు', aiAccuracy: 'AI ఖచ్చితత్వం', upvotes: 'అప్‌వోట్‌లు', trending: 'ట్రెండింగ్ సహకారాలు మరియు అవకాశాలు', trendingDesc: 'AI సరిపోల్చిన క్రియేటర్ పాత్రలు.' },
            ur: { loginSubtitle: 'ایکو سسٹم کھولنے کے لیے اپنی معلومات درج کریں', username: 'صارف نام', password: 'پاس ورڈ', unlockDashboard: 'ڈیش بورڈ کھولیں', activeNodes: 'فعال نوڈز', totalApplications: 'کل درخواستیں', aiAccuracy: 'AI درستگی', upvotes: 'اپ ووٹس', trending: 'مقبول تعاون اور مواقع', trendingDesc: 'AI سے مماثل تخلیق کار کردار۔' }
        };

        function changeLanguage(language) {
            const selected = translations[language] || translations.en;
            document.querySelectorAll('[data-i18n]').forEach(element => {
                if (selected[element.dataset.i18n]) element.textContent = selected[element.dataset.i18n];
            });
            document.getElementById('languageSelect').value = language;
            document.getElementById('languageSelectLogin').value = language;
            document.documentElement.lang = language;
            showToast(`Language changed to ${document.querySelector(`#languageSelectLogin option[value="${language}"]`).textContent}`);
        }

        // --- 3. RENDER LOGIC ---
        function renderPosts() {
            const grid = document.getElementById('postsGrid');
            grid.innerHTML = '';
            const query = document.getElementById('globalSearch').value.toLowerCase();
            const filtered = posts.filter(p => {
                const catMatch = activeCategory === 'All' || p.category === activeCategory;
                const searchMatch = p.title.toLowerCase().includes(query) || p.desc.toLowerCase().includes(query);
                return catMatch && searchMatch;
            });

            filtered.forEach(p => {
                grid.innerHTML += `
                    <div class="glass-card rounded-2xl overflow-hidden flex flex-col justify-between p-5 space-y-4 relative group">
                        <div class="h-36 rounded-xl bg-cover bg-center relative overflow-hidden" style="background-image: url('${p.bg}')">
                            <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent"></div>
                            <span class="absolute top-3 left-3 px-3 py-1 rounded-full text-[10px] font-bold glass-panel text-indigo-300 border border-indigo-500/30">${p.category}</span>
                        </div>
                        <div class="space-y-2">
                            <h3 class="text-lg font-bold text-white group-hover:text-indigo-400 transition">${p.title}</h3>
                            <p class="text-xs text-slate-300 line-clamp-2">${p.desc}</p>
                        </div>
                        <div class="flex items-center justify-between pt-3 border-t border-white/10">
                            <button onclick="upvotePost(${p.id})" class="flex items-center space-x-1.5 text-xs text-amber-400 font-semibold px-3 py-1.5 rounded-lg bg-amber-500/10 border border-amber-500/20 hover:bg-amber-500/20 transition">
                                <i data-lucide="zap" class="w-3.5 h-3.5"></i>
                                <span>${p.votes}</span>
                            </button>
                            <button onclick="openApplyModal('${p.title}')" class="px-4 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold shadow-md transition">
                                Apply Role
                            </button>
                        </div>
                    </div>
                `;
            });
            lucide.createIcons();
        }

        // --- 4. ADVANCED AI CHATBOT ENGINE ---
        function toggleChat() {
            document.getElementById('chatWindow').classList.toggle('hidden');
        }

        function sendQuickPrompt(prompt) {
            document.getElementById('chatInput').value = prompt;
            sendChatMessage(new Event('submit'));
        }

        function toggleVoiceOutput() {
            voiceOutputEnabled = !voiceOutputEnabled;
            const button = document.getElementById('voiceOutputButton');
            button.classList.toggle('bg-emerald-500/20', voiceOutputEnabled);
            button.classList.toggle('text-emerald-300', voiceOutputEnabled);
            showToast(voiceOutputEnabled ? 'Voice replies enabled' : 'Voice replies muted');
        }

        function toggleVoiceInput() {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            if (!SpeechRecognition) {
                showToast('Voice input is not supported in this browser.');
                return;
            }
            if (voiceRecognition) {
                voiceRecognition.stop();
                return;
            }
            voiceRecognition = new SpeechRecognition();
            voiceRecognition.lang = 'en-US';
            voiceRecognition.interimResults = false;
            voiceRecognition.maxAlternatives = 1;
            const button = document.getElementById('voiceInputButton');
            const status = document.getElementById('voiceStatus');
            voiceRecognition.onstart = () => {
                button.classList.add('voice-listening', 'bg-emerald-500/30');
                status.innerHTML = '<span class="w-1.5 h-1.5 rounded-full bg-amber-300 animate-pulse"></span> Listening for your request';
            };
            voiceRecognition.onresult = event => {
                document.getElementById('chatInput').value = event.results[0][0].transcript;
                sendChatMessage(new Event('submit'));
            };
            voiceRecognition.onerror = () => showToast('I could not hear that. Please try again.');
            voiceRecognition.onend = () => {
                voiceRecognition = null;
                button.classList.remove('voice-listening', 'bg-emerald-500/30');
                status.innerHTML = '<span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"></span> Online & Listening';
            };
            voiceRecognition.start();
        }

        function speakAIReply(reply) {
            if (!voiceOutputEnabled || !('speechSynthesis' in window)) return;
            window.speechSynthesis.cancel();
            const speech = new SpeechSynthesisUtterance(reply.replace(/[*🎯📈]/g, ''));
            speech.rate = 1;
            speech.pitch = 1.05;
            window.speechSynthesis.speak(speech);
        }

        function sendChatMessage(e) {
            e.preventDefault();
            const input = document.getElementById('chatInput');
            const userMsg = input.value.trim();
            if(!userMsg) return;

            const container = document.getElementById('chatMessages');
            
            // User Message
            container.innerHTML += `
                <div class="bg-indigo-600 text-white p-3 rounded-xl max-w-[85%] ml-auto shadow-md">
                    ${userMsg}
                </div>
            `;
            input.value = '';
            container.scrollTop = container.scrollHeight;

            // Smart AI Responses
            setTimeout(() => {
            let aiReply = "I have analyzed your request within the Student Creator Collaboration Hub. How else can I guide your workflow?";
                const lower = userMsg.toLowerCase();

                if (lower.includes("match") || lower.includes("role")) {
                    aiReply = "🎯 Parthip, you currently have a **99% match score** for 'Unreal Engine 5 Dark 3D Artist'!";
                } else if (lower.includes("portfolio") || lower.includes("review") || lower.includes("analyze")) {
                    aiReply = "📈 Your 3D graphics portfolio looks excellent! You are ready to apply for lead creator roles.";
                } else if (lower.includes("hello") || lower.includes("hi")) {
                    aiReply = "Hello Parthip! How can I assist your creator project today?";
                }

                container.innerHTML += `
                    <div class="bg-indigo-950/40 text-slate-200 p-3 rounded-xl max-w-[88%] border border-indigo-500/20 shadow-md">
                        <p class="font-semibold text-indigo-400 mb-1">Student Hub AI Assistant</p>
                        ${aiReply}
                    </div>
                `;
                speakAIReply(aiReply);
                container.scrollTop = container.scrollHeight;
            }, 600);
        }

        // --- 5. ACTION HANDLERS ---
        function upvotePost(id) {
            const p = posts.find(item => item.id === id);
            if(p) { p.votes++; renderPosts(); showToast("Upvote recorded!"); }
        }

        function filterCategory(cat) {
            activeCategory = cat;
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.classList.remove('bg-indigo-600/30', 'border-indigo-500', 'text-indigo-300');
                btn.classList.add('text-slate-400');
            });
            event.target.classList.add('bg-indigo-600/30', 'border-indigo-500', 'text-indigo-300');
            renderPosts();
        }

        function handleGlobalSearch() { renderPosts(); }

        function setPostType(type) {
            selectedPostType = type;
            document.getElementById('postType').value = type;
            document.querySelectorAll('.post-type-btn').forEach(btn => btn.classList.remove('bg-indigo-600/30', 'border-indigo-500', 'text-indigo-200'));
            document.getElementById(type === 'Requirement' ? 'postTypeRequirement' : 'postTypeOpportunity').classList.add('bg-indigo-600/30', 'border-indigo-500', 'text-indigo-200');
        }

        function previewPostMedia(e) {
            selectedPostMedia = Array.from(e.target.files || []);
            document.getElementById('postMediaPreview').innerHTML = selectedPostMedia.map(file => {
                const url = URL.createObjectURL(file);
                return file.type.startsWith('video/')
                    ? `<video src="${url}" controls class="w-full h-20 object-cover rounded-lg border border-white/10"></video>`
                    : `<img src="${url}" alt="${file.name}" class="w-full h-20 object-cover rounded-lg border border-white/10">`;
            }).join('');
        }

        function generateAIPost() {
            const prompt = document.getElementById('aiPostPrompt').value.trim();
            if (!prompt) { showToast('Describe the post you want AI to create.'); return; }
            const title = prompt.length > 56 ? prompt.slice(0, 53) + '...' : prompt;
            document.getElementById('postTitle').value = selectedPostType === 'Requirement' ? `Need: ${title}` : title;
            document.getElementById('postDesc').value = selectedPostType === 'Requirement'
                ? `Looking for a creator to help with ${prompt}. Share your relevant work, availability, and estimated timeline.`
                : `Seeking collaborators for ${prompt}. Include your relevant experience, creative approach, availability, and preferred tools.`;
            const lower = prompt.toLowerCase();
            document.getElementById('postCategory').value = lower.includes('podcast') ? 'Podcast' : lower.includes('design') || lower.includes('3d') ? 'Design' : lower.includes('ai') ? 'AI Tech' : 'YouTube';
            const status = document.getElementById('aiPostStatus');
            status.textContent = 'Draft generated. Review it and add media before publishing.';
            status.classList.remove('hidden');
        }

        function useAIPreset(role) {
            document.getElementById('aiPostPrompt').value = `Looking for a ${role} for a creator collaboration`;
            generateAIPost();
        }

        function generateOpportunityOptions() {
            const options = [
                { title: 'Short-form video editor needed', category: 'YouTube', desc: 'Looking for an editor to turn raw footage into energetic short-form videos. Experience with captions, pacing, and social formats is a plus.' },
                { title: 'Podcast production collaborator', category: 'Podcast', desc: 'Seeking a podcast producer to help with recording workflow, cleanup, episode editing, and publishing. Share examples of your audio work.' },
                { title: '3D artist for a concept environment', category: 'Design', desc: 'Collaborate on a polished 3D environment for a creative showcase. Experience with Blender, Unreal Engine, or similar tools is welcome.' }
            ];
            const container = document.getElementById('aiOpportunityOptions');
            container.innerHTML = options.map((option, index) => `
                <button type="button" onclick="applyAIOpportunity(${index})" class="w-full text-left p-2 rounded-lg bg-black/20 border border-white/10 hover:border-indigo-400 transition">
                    <span class="block text-xs font-semibold text-white">${option.title}</span>
                    <span class="block text-[10px] text-slate-400 mt-1">${option.category} · ${option.desc}</span>
                </button>
            `).join('');
            window.aiOpportunityOptions = options;
            container.classList.remove('hidden');
        }

        function applyAIOpportunity(index) {
            const option = window.aiOpportunityOptions[index];
            if (!option) return;
            setPostType('Opportunity');
            document.getElementById('postTitle').value = option.title;
            document.getElementById('postCategory').value = option.category;
            document.getElementById('postDesc').value = option.desc;
            document.getElementById('aiPostStatus').textContent = 'AI opportunity selected. Review it and publish when ready.';
            document.getElementById('aiPostStatus').classList.remove('hidden');
        }

        function openApplyModal(title) {
            document.getElementById('applyRoleTitle').value = title;
            selectedApplicationMedia = [];
            document.getElementById('applicationMediaPreview').innerHTML = '';
            const portfolioValue = document.getElementById('appPortfolio').value.trim();
            renderProfileInterview(portfolioValue);
            toggleModal('applyModal', true);
        }

        function previewApplicationMedia(e) {
            selectedApplicationMedia = Array.from(e.target.files || []);
            document.getElementById('applicationMediaPreview').innerHTML = selectedApplicationMedia.map(file => {
                const url = URL.createObjectURL(file);
                return file.type.startsWith('video/')
                    ? `<video src="${url}" controls class="w-full h-16 object-cover rounded-lg border border-white/10"></video>`
                    : `<img src="${url}" alt="${file.name}" class="w-full h-16 object-cover rounded-lg border border-white/10">`;
            }).join('');
        }

        function getProfileInterviewQuestions() {
            return [
                {
                    question: 'Which practice best demonstrates strong professional growth on a GitHub or LinkedIn profile?',
                    choices: [
                        'Only showing a single project with no documentation',
                        'A consistent history of projects, clear responsibilities, and measurable outcomes',
                        'Keeping all work private and not sharing repositories',
                        'Listing tools without evidence of implementation'
                    ],
                    answer: 1
                },
                {
                    question: 'What is the strongest signal of technical credibility in a developer profile?',
                    choices: [
                        'A large number of followers with no project evidence',
                        'A portfolio of real implementations, code reviews, and problem-solving examples',
                        'Only using flashy UI screenshots',
                        'Avoiding public commits or discussions'
                    ],
                    answer: 1
                },
                {
                    question: 'Why is a well-documented project more valuable than a visually impressive one?',
                    choices: [
                        'It proves thought process, architecture, and practical impact',
                        'It guarantees more social media likes',
                        'It removes the need for teamwork',
                        'It shortens the hiring process automatically'
                    ],
                    answer: 0
                },
                {
                    question: 'When reviewing a candidate profile, which detail is most useful for evaluating experience?',
                    choices: [
                        'The number of profile pictures',
                        'Scope, complexity, and results of previous work',
                        'The latest profile banner color',
                        'How often the profile is updated per week'
                    ],
                    answer: 1
                },
                {
                    question: 'Which action best supports long-term professional credibility?',
                    choices: [
                        'Sharing unfinished experiments without context',
                        'Documenting challenges, decisions, and results in public work',
                        'Removing all older projects from the profile',
                        'Only applying to jobs without networking'
                    ],
                    answer: 1
                }
            ];
        }

        function renderProfileInterview(url) {
            const container = document.getElementById('profileInterviewContainer');
            const questionsContainer = document.getElementById('profileInterviewQuestions');
            if (!url || (!url.includes('linkedin.com') && !url.includes('github.com'))) {
                container.classList.add('hidden');
                questionsContainer.innerHTML = '';
                return;
            }

            document.getElementById('profileInterviewBadge').textContent = url.includes('linkedin.com') ? 'LinkedIn profile' : 'GitHub profile';
            const questions = getProfileInterviewQuestions();

            questionsContainer.innerHTML = questions.map((item, index) => {
                const choicesHtml = item.choices.map((choice, choiceIndex) => `
                    <label class="flex items-start gap-2 px-2 py-1.5 rounded-lg bg-black/10 border border-white/10 text-[11px] text-slate-200">
                        <input type="radio" name="profileQuestion${index}" value="${choiceIndex}" class="mt-0.5 accent-indigo-500">
                        <span>${choice}</span>
                    </label>
                `).join('');

                return `
                    <div class="p-2 rounded-lg bg-black/10 border border-white/10">
                        <p class="text-[11px] font-semibold text-white mb-2">Q${index + 1}. ${item.question}</p>
                        <div class="space-y-2">${choicesHtml}</div>
                        <p class="mt-2 text-[10px] text-emerald-300">Correct answer: ${item.choices[item.answer]}</p>
                    </div>
                `;
            }).join('');

            container.classList.remove('hidden');
        }

        function analyzeApplicationReport() {
            const report = document.getElementById('applicationReport').value.trim();
            const result = document.getElementById('applicationAnalysis');
            if (!report) {
                showToast('Add a work report or cover note first.');
                return;
            }
            const lower = report.toLowerCase();
            const signals = {
                skills: ['skill', 'experience', 'worked', 'built', 'created', 'designed', 'edited'].some(word => lower.includes(word)),
                tools: ['blender', 'unreal', 'premiere', 'after effects', 'figma', 'python', 'ai', 'camera'].some(word => lower.includes(word)),
                availability: ['available', 'availability', 'week', 'month', 'hours', 'deadline'].some(word => lower.includes(word)),
                contribution: ['contribute', 'collaborate', 'team', 'help', 'deliver', 'responsible'].some(word => lower.includes(word))
            };
            const completed = Object.values(signals).filter(Boolean).length;
            const score = Math.min(96, Math.max(35, 42 + completed * 12 + (report.length > 220 ? 6 : 0) + (selectedApplicationMedia.length ? 5 : 0)));
            const strengths = Object.entries(signals).filter(([, present]) => present).map(([key]) => ({ skills: 'relevant experience', tools: 'tools and technical skills', availability: 'availability details', contribution: 'collaboration approach' }[key]));
            const missing = Object.entries(signals).filter(([, present]) => !present).map(([key]) => ({ skills: 'specific skills or past work', tools: 'tools or technologies used', availability: 'availability or timeline', contribution: 'how you will contribute' }[key]));
            const label = score >= 78 ? 'Strong fit signal' : score >= 60 ? 'Promising fit signal' : 'Needs more evidence';
            latestApplicationScore = score;
            result.innerHTML = `<div class="flex items-center justify-between gap-3"><div><p class="text-xs font-bold text-emerald-200">${label}</p><p class="text-[10px] text-slate-300 mt-1">AI fit signal based on the submitted information</p></div><strong class="text-2xl text-emerald-300">${score}%</strong></div><p class="text-[10px] text-slate-300 mt-2"><b>Detected:</b> ${strengths.length ? strengths.join(', ') : 'add more project detail'}</p>${missing.length ? `<p class="text-[10px] text-amber-200 mt-1"><b>Consider adding:</b> ${missing.join(', ')}</p>` : ''}<p class="text-[10px] text-slate-500 mt-2">Use this as decision support only. Review the work samples and speak with the applicant before hiring.</p>`;
            result.classList.remove('hidden');
        }

        function openApplicationsModal() {
            const list = document.getElementById('applicationsList');
            list.innerHTML = applications.length ? applications.map((application, index) => `
                <article class="p-4 rounded-xl bg-white/5 border border-white/10">
                    <div class="flex flex-wrap items-start justify-between gap-3">
                        <div><p class="text-sm font-bold text-white">${application.name}</p><p class="text-xs text-indigo-300 mt-1">${application.role}</p></div>
                        <span class="px-2 py-1 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-300 text-xs font-bold">${application.score ? `${application.score}% fit signal` : 'Not analyzed'}</span>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-2 mt-3 text-xs text-slate-300">
                        <p><span class="text-slate-500">Email:</span> ${application.email}</p>
                        <p><span class="text-slate-500">Work samples:</span> ${application.mediaCount} image/video file${application.mediaCount === 1 ? '' : 's'}</p>
                        <p class="truncate"><span class="text-slate-500">Portfolio:</span> <a href="${application.portfolio}" target="_blank" rel="noopener" class="text-cyan-300 hover:text-cyan-200">${application.portfolio}</a></p>
                        <p><span class="text-slate-500">Submitted:</span> ${application.submittedAt}</p>
                    </div>
                    <p class="mt-3 p-3 rounded-lg bg-black/20 text-xs leading-5 text-slate-300">${application.report || 'No report or cover note provided.'}</p>
                    <button onclick="openMessagingModal(${index})" class="mt-3 px-3 py-2 rounded-lg bg-cyan-500/10 border border-cyan-500/20 text-cyan-200 text-xs font-semibold hover:bg-cyan-500/20">Message creator</button>
                </article>
            `).join('') : '<div class="p-8 text-center text-sm text-slate-400 border border-dashed border-white/10 rounded-xl">No applications submitted yet. Applications will appear here after someone applies for a role.</div>';
            toggleModal('applicationsModal', true);
            lucide.createIcons();
        }

        function openMessagingModal(applicationIndex = null) {
            if (applicationIndex !== null && applications[applicationIndex]) {
                activeConversation = applications[applicationIndex];
                const key = activeConversation.email;
                if (!messages[key]) messages[key] = [{ from: 'hub', text: `Hello ${activeConversation.name}, thanks for applying for ${activeConversation.role}.` }];
            }
            const recipient = document.getElementById('messageRecipient');
            const list = document.getElementById('conversationList');
            recipient.textContent = activeConversation ? `Conversation with ${activeConversation.name} · ${activeConversation.role}` : 'Select an applicant from Applications to start a conversation.';
            const thread = activeConversation ? messages[activeConversation.email] || [] : [];
            list.innerHTML = thread.length ? thread.map(message => `<div class="max-w-[84%] ${message.from === 'hub' ? '' : 'ml-auto'} p-3 rounded-xl ${message.from === 'hub' ? 'bg-cyan-500/10 border border-cyan-500/20 text-cyan-100' : 'bg-indigo-600 text-white'} text-xs">${message.text}</div>`).join('') : '<p class="text-center text-xs text-slate-500 py-12">Open an application and choose “Message creator”.</p>';
            toggleModal('messagingModal', true);
            list.scrollTop = list.scrollHeight;
            lucide.createIcons();
        }

        function sendCreatorMessage(e) {
            e.preventDefault();
            if (!activeConversation) {
                showToast('Select an applicant before sending a message.');
                return;
            }
            const input = document.getElementById('messageInput');
            const text = input.value.trim();
            if (!text) return;
            messages[activeConversation.email].push({ from: 'hub', text });
            input.value = '';
            openMessagingModal();
            showToast(`Message sent to ${activeConversation.name}`);
        }

        function submitApplication(e) {
            e.preventDefault();
            const mediaCount = selectedApplicationMedia.length;
            applications.unshift({
                name: document.getElementById('appFullName').value,
                email: document.getElementById('appEmail').value,
                portfolio: document.getElementById('appPortfolio').value,
                role: document.getElementById('applyRoleTitle').value,
                report: document.getElementById('applicationReport').value.trim(),
                score: latestApplicationScore,
                mediaCount,
                submittedAt: new Date().toLocaleString()
            });
            const applicationCount = document.getElementById('navApplicationCount');
            const applicationsStat = document.getElementById('statApps');
            const currentCount = Number(applicationCount.textContent.replace(/,/g, '')) + 1;
            applicationCount.textContent = currentCount.toLocaleString();
            applicationsStat.textContent = currentCount.toLocaleString();
            toggleModal('applyModal', false);
            document.getElementById('applyForm').reset();
            selectedApplicationMedia = [];
            document.getElementById('applicationMediaPreview').innerHTML = '';
            document.getElementById('applicationAnalysis').innerHTML = '';
            document.getElementById('applicationAnalysis').classList.add('hidden');
            latestApplicationScore = null;
            showToast(mediaCount ? `Application submitted with ${mediaCount} work sample${mediaCount === 1 ? '' : 's'}!` : "Application submitted successfully!");
        }

        function createNewPost(e) {
            e.preventDefault();
            posts.unshift({
                id: Date.now(),
                title: document.getElementById('postTitle').value,
                category: document.getElementById('postCategory').value,
                type: selectedPostType,
                votes: 1,
                bg: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=600&auto=format&fit=crop&q=80",
                desc: document.getElementById('postDesc').value,
                media: selectedPostMedia.map(file => ({ name: file.name, type: file.type, url: URL.createObjectURL(file) }))
            });
            renderPosts();
            toggleModal('postModal', false);
            document.getElementById('postForm').reset();
            selectedPostMedia = [];
            document.getElementById('postMediaPreview').innerHTML = '';
            document.getElementById('aiPostStatus').classList.add('hidden');
            setPostType('Opportunity');
            showToast("Opportunity published!");
        }

        function toggleModal(id, show) {
            const m = document.getElementById(id);
            if(show) m.classList.remove('hidden'); else m.classList.add('hidden');
        }

        function showToast(msg) {
            const container = document.getElementById('toastContainer');
            const toast = document.createElement('div');
            toast.className = 'glass-panel px-4 py-3 rounded-xl text-xs font-semibold text-white shadow-xl flex items-center space-x-2 border border-indigo-500/40';
            toast.innerHTML = `<i data-lucide="check-circle" class="w-4 h-4 text-emerald-400"></i><span>${msg}</span>`;
            container.appendChild(toast);
            lucide.createIcons();
            setTimeout(() => toast.remove(), 3000);
        }

        // --- 6. ENHANCED THREE.JS DARK 3D ENGINE ---
        let scene, camera, renderer, cyberLattice, glowParticles;

        function init3D() {
            const container = document.getElementById('canvas-container');
            scene = new THREE.Scene();

            camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 1000);
            camera.position.set(0, 40, 200);

            renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
            container.appendChild(renderer.domElement);

            // Dark Geometric Mesh Grid
            const geometry = new THREE.PlaneGeometry(800, 800, 40, 40);
            const material = new THREE.MeshBasicMaterial({
                color: 0x4f46e5,
                wireframe: true,
                transparent: true,
                opacity: 0.18
            });
            cyberLattice = new THREE.Mesh(geometry, material);
            cyberLattice.rotation.x = -Math.PI / 2.2;
            cyberLattice.position.y = -100;
            scene.add(cyberLattice);

            // Floating Particles
            const pCount = 1500;
            const pGeo = new THREE.BufferGeometry();
            const pPos = new Float32Array(pCount * 3);

            for (let i = 0; i < pCount * 3; i += 3) {
                pPos[i] = (Math.random() - 0.5) * 1000;
                pPos[i + 1] = (Math.random() - 0.5) * 1000;
                pPos[i + 2] = (Math.random() - 0.5) * 1000;
            }

            pGeo.setAttribute('position', new THREE.BufferAttribute(pPos, 3));
            const pMat = new THREE.PointsMaterial({
                color: 0x818cf8,
                size: 2,
                transparent: true,
                opacity: 0.7
            });
            glowParticles = new THREE.Points(pGeo, pMat);
            scene.add(glowParticles);

            // Parallax Interaction
            document.addEventListener('mousemove', (e) => {
                const moveX = (e.clientX - window.innerWidth / 2) * 0.0003;
                const moveY = (e.clientY - window.innerHeight / 2) * 0.0003;
                camera.rotation.y = -moveX;
                camera.rotation.x = -moveY;
            });

            animate3D();
        }

        function animate3D() {
            requestAnimationFrame(animate3D);
            if(cyberLattice) cyberLattice.rotation.z += 0.0006;
            if(glowParticles) glowParticles.rotation.y += 0.0004;
            renderer.render(scene, camera);
        }

        window.addEventListener('resize', () => {
            if(camera && renderer) {
                camera.aspect = window.innerWidth / window.innerHeight;
                camera.updateProjectionMatrix();
                renderer.setSize(window.innerWidth, window.innerHeight);
            }
        });

        // Initialize App
        document.getElementById('appPortfolio').addEventListener('input', function() {
            renderProfileInterview(this.value.trim());
        });

        window.onload = () => {
            init3D();
            renderPosts();
            lucide.createIcons();
        };
    </script>
</body>
</html>