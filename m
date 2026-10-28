Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210056;
	b=ZCZMc0PGVgmh9ApFCfz1kqXN/a8oQw9E+iu8yGadjjBy+VhXxV3XpK9b9waGsAQiUL4I
	 zhJ0AYySyi360HTQqHZSO0T1+H2D8Vxowa1gUmWOW1gQZMGQaknH2zpwnYoTx7hytfV4g
	 bPWvlxoHf6Gu0zSLttI5/7Ckfh8LlfXeKWzvwfqpUhtEkUt6GTreBnB8iYVQF00LPyxr4
	 /BTN8evh4OP76IaW8T7RzTctv+XhrUCgw7o1k6n7w6DnmtBkotToQODSqXmxz1YzE1m+A
	 Lfx1PnkGi1Wyw6TPbkozrAIl9y6r2WOoBK6i0ovB7ituE0+mkiAuFBnth0s8YpBLTJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3N5fxn2oXEclWOdPXfOKDnQPR/TTe87P2E74Y7ng+Q0=;
	b=yxsQNrkoWj/U1pkmoaq3U+ek74/x/cq2LBMNuYdhhaqWicjYw9vLfqsk8Doqev7xqrYt
	 H+VVbZOzOCxbSWmFFAmapYj8eldDGIAXYzWJfIIos4yO0abUvafXhD0nwXdBl/7qk86A+
	 wE+zfaJWrnTJowMQ3+kC6oflEEAD8X0VfouOU9O7gHvZfX/QFqygNdeuXHaCZvmcfVT+q
	 CJFDp8aj+Kh0sB1NTdaXWiiHqbOAg+AZCOifAvYl7pBhtUhDC7TzGxORXviqEWmF5UoYp
	 bhMhMGZpz7sdui8vLTAbAmmO+Ln8dDeAOnBhQm14nJaNCJYqVeIayf+DAnoVamvkgvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+Ftr+iO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A6C606A31A;
	Wed, 28 Oct 2026 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+Ftr+iO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E631F01825;
	Wed, 28 Oct 2026 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210056;
	bh=3N5fxn2oXEclWOdPXfOKDnQPR/TTe87P2E74Y7ng+Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+Ftr+iORSPWc2lXu+/09WGARU1/JuV6CrLEjwg0NBROJYdVfG8f9quSfmKMnNFLz
	 Z142HRnG7zUIf7fJdJiU5Id1A/MU+tbSqvYoEUlIFgCL3jIdmMtPqsKgL0L4xEHXmV
	 T/yeZ6eRupD9xszlYrPSO4J3V+Y6fFbQup+ru5gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 062/168] tracing: Do not initialize tracefs work if tracing is disabled
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028165944.551308249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit b3b974008388ab59e44d764ba7a63c988fec2524 upstream.

If trace buffer allocation fails during early boot (e.g.  in
early_trace_init() -> allocate_trace_buffers()), tracing_disabled is
left set to 1 and the global trace array events list remains
uninitialized.

Later during boot, tracer_init_tracefs() (invoked via fs_initcall)
queues tracerfs_init_work asynchronously without checking if tracing was
disabled.  When tracer_init_tracefs_work_func() runs, it calls
event_trace_init() and init_tracer_tracefs(&global_trace, NULL)
unconditionally.  This leads to __find_event_file() dereferencing an
uninitialized tr->events list, causing an early boot NULL pointer
dereference Oops:

  BUG: Kernel NULL pointer dereference on read at 0x00000010
  Faulting instruction address: 0xc000000000485be0
  Oops: Kernel access of bad area, sig: 7 [#1]
  ...
  NIP [c000000000485be0] __find_event_file+0x70/0x3c0
  LR  [c000000000448874] init_tracer_tracefs+0x274/0xc80
  Call Trace:
   init_tracer_tracefs+0x274/0xc80
   tracer_init_tracefs_work_func+0x50/0x320
   process_one_work+0x1e8/0x5c0
   worker_thread+0x1dc/0x3d0
   kthread+0x194/0x1b0
   start_kernel_thread+0x14/0x18

Check tracing_disabled at the beginning of tracer_init_tracefs_work_func()
and return immediately if tracing is disabled or failed to initialize,
preventing the crash.

Cc: stable@vger.kernel.org
Fixes: 6621a7004684 ("tracing: make tracer_init_tracefs initcall asynchronous")
Link: https://patch.msgid.link/20261009163557.88467-2-amachhiw@linux.ibm.com
Reported-by: Michal Suchánek <msuchanek@suse.de>
Closes: https://lore.kernel.org/all/arYskzbiaNzBR9MD@kunlun.suse.cz/
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Tested-by: Michal Suchánek <msuchanek@suse.de>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10040,6 +10040,12 @@ static struct notifier_block trace_modul
 
 static __init void tracer_init_tracefs_work_func(struct work_struct *work)
 {
+	/*
+	 * Do not attempt to initialize tracefs if tracing was disabled or
+	 * failed to allocate
+	 */
+	if (tracing_disabled)
+		return;
 
 	event_trace_init();
 


