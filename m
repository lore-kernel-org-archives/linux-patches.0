Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207653;
	b=0umMXGjeFG64/AhHEBRgKld2WdNhKf0z13f8+/QFVljWmR8onTz/ZXr65Iv0r51PpqQH
	 a97LM22/S1MsKKNfUnrYXPZgHXmipacA1pTqguvquvPa97HOBtUJZzG7d1rkOYU3A4gpU
	 bi+DXdltK+GBuC4h+LJOA13Bj5qceWzw4hGsTSq7RNcvcQj1ZXp7YXjxPQTq8PHPgbFFw
	 RDQ3erBbzw0yQyQrbtRKAqcdvMHXWoAHZP2UDPB1TzsYDipyDXtB3vEFh4CAi4aQ9rDt5
	 7LWAMLdOqOZyHYf3BClID2raY94abzgMud1/V8CywhZLC2E/FrLv2Y6NVIOaE1hjIxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4SiyTiZv2AK0t2V6XjhfEnLO/KXPhv6oE+hvGE0NGig=;
	b=Kjae4McxnEZg1tkCe1MCdJzIfTCJLxOvvqXIZzaomNmEatDvZu5Tj4AclZCWcGXBtTlQ
	 fwMvivzPY51y28CWRFx52bUePW8UJiguFvRbrS4nu5ywBs/grRlDvv3oUY22AwNoRaXiR
	 u0EZwWd+3f8JIQOSBIIC4E8KlBYzkSuRtgg+HgQYCNmZx1IPB+7Y5HFzzduCwb4gHreKL
	 E1TjMi+SC/fTV5CIJSA2T0fLOkeviH4EL+6Uc3pQHtsBYgxpBxnIvvFKPwALeVPQLSBMm
	 emCAY8CZZypOqUL9x5Gta6Jlx0Kfv7lU8avHP26Iccnt1k/ZqhF725RdMDg/ezajmeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0pZZFAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80448606A31A;
	Wed, 28 Oct 2026 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0pZZFAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38711F01829;
	Wed, 28 Oct 2026 17:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207653;
	bh=4SiyTiZv2AK0t2V6XjhfEnLO/KXPhv6oE+hvGE0NGig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0pZZFAeWy1zRKij/XEboFmb8pooYeqj2L5ST5fBc/dUUr4S9yCK4QcaEJ10XREea
	 KvXGvh6pPRClWKGjw3tvGL4mUH2PFucOToEumbQVUM2u2WoY3PcvgerwleP+u5NTtN
	 snwfQX6chX99zlFf/Lg/6prVPmcGksY0mGAwtZ4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 093/247] tracing: Do not initialize tracefs work if tracing is disabled
Date: Wed, 28 Oct 2026 17:58:16 +0100
Message-ID: <20261028165949.596723264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10005,6 +10005,12 @@ static struct notifier_block trace_modul
 
 static __init void tracer_init_tracefs_work_func(struct work_struct *work)
 {
+	/*
+	 * Do not attempt to initialize tracefs if tracing was disabled or
+	 * failed to allocate
+	 */
+	if (tracing_disabled)
+		return;
 
 	event_trace_init();
 


