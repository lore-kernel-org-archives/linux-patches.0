Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774080;
	b=A+NUbo/q5WcY6UBcBiP+Sw87mMVQvlww/tVePbyktK0dS1i11/YQFvkwSu5Oa0YlrQKk
	 jKrYvZEfDS0lh4v2SZgeLzlAVLerHXoBUwz2Fbj2ALdmHJqgAIVJnuRKY1BE2DoSsZc7d
	 PHyHXyMvSQoahT5Oehlbo5MrheiBB868QqRCy4hZKQgjrCnQzjV9bK95c60K0ntWuUTI3
	 5+/1/BB1sWPVvd/84sYPm/AimXGWlpKAQTb0tTgpWvEU3p6Q5XSA3eJnOWWMLZZlflXsG
	 R73P1lx4sMF7qUJ66A0DxS32DOUcWa0LwOu2yp4vlP1BT7QGmb+Z0NFmm6hhFmjvL4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BlVn02zjGpJSmrSjrVhczvE+80hJVQb3Kmo1B9ZHxdA=;
	b=cgglOFYIIhdE18eQH5+/LhxNpgjDCbvhWRvkZ1tpESJ0SDSRRq0QCWM1v2TOkIAjUlp0
	 RzsqkeVxMi9OY8wPZ97SB7a/EOZRGFJvo2nnw6LWrcW5uJqZFTNeCCQbCp6paXVAcaJjE
	 lkiujiaoC/xXuaZRklfrK0Rm0+HABatHFbcT1JGD2Uppnb5iT1doePbWBkdix7sRkjGqG
	 15rF4dWx0RxRjH6rq/DrWkp1SjyJ4NIejCwY4wJPXGHZ/4qLyTtgB9rdzsN3H6pSY5Y3c
	 1IrezoKr2A8lfa1lb0eTqFlqwkYEjp5AC4Y8Zlq0oOYcooFaQeDLCfc1zPjk8JvfJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeyhMGIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C5606A31B;
	Fri, 23 Oct 2026 16:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeyhMGIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FE51F01825;
	Fri, 23 Oct 2026 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774080;
	bh=BlVn02zjGpJSmrSjrVhczvE+80hJVQb3Kmo1B9ZHxdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeyhMGISvytWOStM9r1MMr82k/GRicFqbIcOy6eS4kr9YLzCfT/YojYWu7mk9Zg4O
	 MBp3+VNc5MxS/yUQEb7enb6rEMC0WY5ENofkLsrA3SU//4linr1SHd+EWbpSJx3QKP
	 ggnL8doMRNRaVYn24KoLY5usomRby1vXJ98sRNW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 114/193] tracing: Do not initialize tracefs work if tracing is disabled
Date: Fri, 23 Oct 2026 18:36:31 +0200
Message-ID: <20261023163716.902598291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10730,6 +10730,12 @@ static struct notifier_block trace_modul
 
 static __init void tracer_init_tracefs_work_func(struct work_struct *work)
 {
+	/*
+	 * Do not attempt to initialize tracefs if tracing was disabled or
+	 * failed to allocate
+	 */
+	if (tracing_disabled)
+		return;
 
 	event_trace_init();
 


