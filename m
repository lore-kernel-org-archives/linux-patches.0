Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064790;
	b=EGi3x90HdbE5hq4ts1O4k/nR8vLv7kqXzdm8pG7SXm2lAvsNKc5CeWsRPjjBoQeH6qmb
	 EarjEdmm9N9b9DwoOK0svyu+OSsC6jOzCm5mTNrzrInVjzsAue4DIYOkmDiv8uaZZy/yf
	 MPW/26+Z4Ho5k7aYxgtr7bJa9kTKx5ZuPgaFIsKRIQ0kcJWayu9B6/4AJANMth5k66OF8
	 j23b+zcqbFrjnoQY/PErCKDIH8ek46ad6gEiIdvqrEN04L5Ql6HTiSvVWX25tsp995foU
	 XJ/vm5NTupXwRsD8h0HsxFuFUbsJRHwmHld51wl1J9FwJVgEf1ONMO0i0RLGhlu5RVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gYa7at57wf7YuryiFe5FHoX1YLGKbQt96ondebeGGO8=;
	b=QGCDNcNoyiKUtyDgGsWAmxHx/z18eW/1E5FVZDKqIptLQpO0RmS0To2UInVZdOm0tHIl
	 bruWyyssa1nlWNoJBzqbYAH2RS9V8TNguXsm379ROWaSJu7ZnI0k+eqWyW94HtzCT4EJM
	 7yMajph9chqkoXE+n05/hE2A5Ne7U0DP+95VldBPXmGdpKdfFijEPghFzXdEYCte3paw2
	 UtpQPN+vtQeqdTVC5ufJkAC8it+CG0293BxDRJzMI0Gd9rPTFoqpc8A3kvtC/CKR+gIdW
	 jkKV0i7fBlLniEaGYUPMY8HFX9cizUa/YsGg+R4+W7vOV0CDUxqzEMnk/ds47r+Vtbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QY32sWYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547A606A9FB;
	Sat,  7 Nov 2026 15:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QY32sWYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1554A1F0089F;
	Sat,  7 Nov 2026 15:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064790;
	bh=gYa7at57wf7YuryiFe5FHoX1YLGKbQt96ondebeGGO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY32sWYsEfDcsbgzY6ZIIFN3mlggysb/DFZryCnOBpdKUK2xcLjtwE8D0X8xXgfje
	 t2/O9ry+AIiDMBtD7/N3lnKDTJGp77+otFIy0u96g7RXqWJ8IjV82f8+MPD+pdXUTM
	 LXDn5+oBbtsveIAPbbHZnAREmeZ6Xxho7d7r/cRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Sashiko <sashiko-bot@kernel.org>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0736/1257] panic: kill the "buffer unavailable" redirect fallback
Date: Sat,  7 Nov 2026 08:50:32 -0500
Message-ID: <20261107134959.603518321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit 68d956e9e235c2e125f77a9e98831e297b624a75 ]

The redirect buffer is a disgusting terrible hack.  panic_force_buf is
kmalloc'ed in a late_initcall, and until then the redirect delivers this
as the panic message:

  Redirected panic (buffer unavailable)

The whole point of the redirect is to hand the panic message to the target
CPU, so the crash kernel boots knowing it panicked and not why.  And that
window is the entire boot, from the early_param to the late_initcall,
which is exactly when you most want the message.

Make it a static 1KB buffer and kill the initcall.  The cost is 1KB of
.bss in SMP crash dump builds, and it is only ever touched when
panic_force_cpu= is set anyway.  The local msg variable is gone too, the
buffer goes directly to panic_smp_redirect_cpu().

Link: https://lore.kernel.org/20260916182957.7788-7-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index e5e9dd38627e0..cec2716019355 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -307,7 +307,7 @@ atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 atomic_t panic_redirect_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_CRASH_DUMP)
-static char *panic_force_buf;
+static char panic_force_buf[PANIC_MSG_BUFSZ];
 
 static int __init panic_force_cpu_setup(char *str)
 {
@@ -326,17 +326,6 @@ static int __init panic_force_cpu_setup(char *str)
 }
 early_param("panic_force_cpu", panic_force_cpu_setup);
 
-static int __init panic_force_cpu_late_init(void)
-{
-	if (panic_force_cpu < 0)
-		return 0;
-
-	panic_force_buf = kmalloc(PANIC_MSG_BUFSZ, GFP_KERNEL);
-
-	return 0;
-}
-late_initcall(panic_force_cpu_late_init);
-
 static void do_panic_on_target_cpu(void *info)
 {
 	panic("%s", (char *)info);
@@ -380,7 +369,7 @@ static bool panic_try_force_cpu(const char *fmt, va_list args)
 {
 	int this_cpu = raw_smp_processor_id();
 	int old_cpu = PANIC_CPU_INVALID;
-	const char *msg;
+	va_list ap;
 
 	/* Feature not enabled via boot parameter */
 	if (panic_force_cpu < 0)
@@ -413,20 +402,11 @@ static bool panic_try_force_cpu(const char *fmt, va_list args)
 		return old_cpu != this_cpu;
 
 	/*
-	 * Use dynamically allocated buffer if available, otherwise
-	 * fall back to static message for early boot panics or allocation failure.
+	 * Do not consume args, the caller reuses them if we fail.
 	 */
-	if (panic_force_buf) {
-		va_list ap;
-
-		/* Do not consume args, the caller reuses it if we fail */
-		va_copy(ap, args);
-		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
-		va_end(ap);
-		msg = panic_force_buf;
-	} else {
-		msg = "Redirected panic (buffer unavailable)";
-	}
+	va_copy(ap, args);
+	vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
+	va_end(ap);
 
 	console_verbose();
 	bust_spinlocks(1);
@@ -441,7 +421,7 @@ static bool panic_try_force_cpu(const char *fmt, va_list args)
 		dump_stack();
 	}
 
-	if (panic_smp_redirect_cpu(panic_force_cpu, (void *)msg) != 0) {
+	if (panic_smp_redirect_cpu(panic_force_cpu, panic_force_buf) != 0) {
 		atomic_set(&panic_redirect_cpu, PANIC_CPU_INVALID);
 		pr_warn("panic: failed to redirect to CPU %d, continuing on CPU %d\n",
 			panic_force_cpu, this_cpu);
-- 
2.53.0



