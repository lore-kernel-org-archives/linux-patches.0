Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064787;
	b=nMM2j/qO/Rfgj3eeXQD8sugioa9LoTxf8QUHO26tJBnr0OanXAOI3UK8Z5zw6EZKq45Z
	 21HGU2+jUfaSJ4RvDMC0iIMgPJ6zqBYQhpDwPom8MET4COjJm60sWfNap7qKoVr/QBLzG
	 ZnkC4hUix60Cgw1fFwitsnGMknowGj/KWFx7z5Mjr+TIhlyDtWzvioga2CAoU3qGt3H6J
	 HNCiY0DfEyzbWuR+EB9T4iqM4t20cFk1P/c+nceKUdGrAeDWIYSUFcLQSrzfO3RFU/K/i
	 AexbuM4/N31qaFb6Y5GIsH+Lz/Vkn7qhQJq5mh43NB2C7Da5S5MgT8u+h0Nbn2MyjzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdEZcoj+S1l7uzfssZZzck2g2BXWiPiSSO+oSqZpGn0=;
	b=wZY5fQBlcev/hYmBkAvQEI5GXvfnliavAxYQTs8RxvGLcVxmtRcCd3TMnEjd6xjiNhRs
	 ZGN4pbsW4w8TBO1zEZTKY/QkMO2/w5H3cuGSR+b/bakzvBdv6ZQ7dnqsQH0UMslbR3+NN
	 kJVAvFe4mehfVswfKxEp9HGYezbvpp9b+ar56jXbdDJDAhgAe0MjQ5wBNAixI6nJWQ5FP
	 4kZCmyUoY0eZfuQW4TKKsZ6v0UF5H4Hn922yBj8GgXX3dy8EjP7uoCkFslxdZMsYOb77c
	 59FYxI+BY96GsifvbE2o+QsoJiao2xlG6M3TGCOI+6k5jQqJ8oWcRU/J2bpih1uKnrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxEO+mN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9982F606A9FB;
	Sat,  7 Nov 2026 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxEO+mN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184E41F008A1;
	Sat,  7 Nov 2026 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064787;
	bh=qdEZcoj+S1l7uzfssZZzck2g2BXWiPiSSO+oSqZpGn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxEO+mN65NIVXuayHlxAdGT5HwXKa7QZOx7JnMIqWthBNrf5gqricZ0lwTB5Ifu/B
	 /XjenVhyc3r4tbHDtJv48bwfFxjF+x6RtTvNSOGSs+ZnLhx9F8d/SoEY9d5lnX3DrF
	 YNQhBmvjTumsotkA6b1OEt+O7eO3K9LMJ5t6Ki/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0735/1257] panic: allow force_cpu redirect from an NMI
Date: Sat,  7 Nov 2026 08:50:31 -0500
Message-ID: <20261107134959.576832464@linuxfoundation.org>
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

[ Upstream commit 36c55a9625bb9ab7eb428ff8facc6d3d0a743180 ]

nmi_panic() claims panic_cpu via panic_try_start() before calling panic().
When the panic later reaches panic_try_force_cpu(), the
panic_in_progress() check sees panic_cpu set and refuses to redirect.  The
crash kernel runs on the CPU that took the NMI instead of the CPU
requested with panic_force_cpu=:

  nmi_panic()
    panic_try_start()              wins, panic_cpu = X
    panic("%s", msg)
      vpanic()
        panic_try_force_cpu()
          panic_in_progress()      true, panic_cpu is X
          return false             redirect bypassed
        panic_try_start()          already won
        __crash_kexec()            on X, not the requested CPU

Try the redirect before claiming panic_cpu instead, as suggested by Petr
Mladek.  nmi_panic() now calls panic_try_force_cpu() first and claims
panic_cpu only when no redirect happened.  The requested CPU claims
panic_cpu itself when it runs panic(), so panic_cpu does not need to be
handed off.  panic_try_force_cpu() copies the arguments before formatting
(patch 3), so nmi_panic() can pass them to vpanic() again when no redirect
happens.

The redirect IPI is sent with smp_call_function_single_async(), which is
not guaranteed to work from NMI context.  Treat it as best effort.  It is
worth the risk because the redirection is only used when the crash kernel
would not work on the panicking CPU anyway.

Keep returning when the panic is already running on this CPU.  A nested
NMI, for example with unknown_nmi_panic while this CPU is inside panic(),
must return and let the interrupted panic() continue instead of parking
the CPU in nmi_panic_self_stop().

Mark the redirecting CPU offline before stopping it, like vpanic() does,
so that panic_other_cpus_shutdown() on the target CPU does not wait for
it.

Link: https://lore.kernel.org/20260916182957.7788-6-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260708164312.19044-1-include@grrlz.net
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 43ac2b9b5e001..e5e9dd38627e0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -513,10 +513,11 @@ bool panic_on_other_cpu(void)
 EXPORT_SYMBOL(panic_on_other_cpu);
 
 /*
- * A variant of panic() called from NMI context. We return if we've already
- * panicked on this CPU. If another CPU already panicked, loop in
- * nmi_panic_self_stop() which can provide architecture dependent code such
- * as saving register state for crash dump.
+ * A variant of panic() called from NMI context. The panic is first
+ * redirected to the CPU requested via panic_force_cpu=, when configured.
+ * We return if we've already panicked on this CPU. If another CPU already
+ * panicked, loop in nmi_panic_self_stop() which can provide architecture
+ * dependent code for saving register state for crash dump.
  */
 void nmi_panic(struct pt_regs *regs, const char *fmt, ...)
 {
@@ -524,6 +525,16 @@ void nmi_panic(struct pt_regs *regs, const char *fmt, ...)
 
 	va_start(args, fmt);
 
+	/* Try to redirect to the requested CPU before claiming panic_cpu. */
+	if (panic_try_force_cpu(fmt, args)) {
+		/*
+		 * Mark ourselves offline so panic_other_cpus_shutdown() won't
+		 * wait for us on architectures that check num_online_cpus().
+		 */
+		set_cpu_online(raw_smp_processor_id(), false);
+		nmi_panic_self_stop(regs);
+	}
+
 	if (panic_try_start())
 		vpanic(fmt, args);
 
-- 
2.53.0



