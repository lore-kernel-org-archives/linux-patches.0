Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774942;
	b=I+zOTv13f7BRu/mRMUBv8w0Ex/M/FohMTRm+PYDt5WX8Vtj+JhyU23yjV97i6M7DzVQw
	 O1VJMRwWjnnqTxzUM5fR+pupdwCYaB5CdwvFnvgRe5Iw698eBNyHWToP56PVPg0CAYaXu
	 k5CHVxbPXKI2Csrh6+Dcx+P6jxffI20qNbtSkPlmOmpBnMtTs0Uyt46VOYFrMLfcU5h2t
	 08yRaQcXmXwUabr71p+uUEAa+frnb+pyIB/Rvd4pfUT39zadbEH1V3XwP5lzhJFTRzCG+
	 iJTenklmZc8a5HBscGyx+iUcOIuDei2Zf6K56vksaI/7Qr372u26+R79lKLVGjvj2Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NF8GQYGySVGRSAgF+L8wPZYv8PgY25OSPNTMHROhZu0=;
	b=qjPRn2KhHeWnyE1H2YgZVyPWsb8LJEdll3KqI1L5WgQ9MsliGIkJS2EpV+aWMt5mgdC9
	 ra7zkaBq7ZAB+q8a2upj7QJJIpQiCWo2ysmFekdWeeJlPkgRAmabSdVrXN5NmszJoyBGn
	 ZDsXaBJE5LmqWD5yxPRLXTDtAZ/XvHoGVZLz6Ip5iqFKbISxoR994m0ySCuHO540f5mVr
	 k25KFhfGCvi9KP5B4MSOj+wHSQ+Q1jPWSz9usERwkQtnVcAOmJv5JixEFtmAFJfbLvnMM
	 MX6MCTK+oKWRqG+WJbPpJ1/9w5/uoGtKczdB0EFVJZAHKzA+0ed3FFPLm6DkJ2NwcUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEEbt0vB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87E606A31F;
	Fri, 23 Oct 2026 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEEbt0vB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8941F01825;
	Fri, 23 Oct 2026 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774941;
	bh=NF8GQYGySVGRSAgF+L8wPZYv8PgY25OSPNTMHROhZu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEEbt0vBdRn75QGCBzBnemP0aUPh9KC0OvWD19cWaiOfx2cixFRRHfQP4Gok806Nv
	 JJ2LWx5l56U1S0JTk8Zd99NYNckVOxaiTJOgeWOVKqCQ1DbX1aeR5crpW6Yw/4iSbk
	 +F4Yaimzp9RM1rTvu4bi908+SPZ0qbXri+9AasOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 172/242] tracing: Do not initialize tracefs work if tracing is disabled
Date: Fri, 23 Oct 2026 18:40:14 +0200
Message-ID: <20261023163717.853278799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9285,6 +9285,12 @@ static struct notifier_block trace_modul
 
 static __init void tracer_init_tracefs_work_func(struct work_struct *work)
 {
+	/*
+	 * Do not attempt to initialize tracefs if tracing was disabled or
+	 * failed to allocate
+	 */
+	if (tracing_disabled)
+		return;
 
 	event_trace_init();
 


