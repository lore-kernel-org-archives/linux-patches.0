Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034213;
	b=d75mShUUZY2EJZjBt8CS5/FFNdpt3sklTRf33cNZyH1ta11DuhSSf/p0ns6hjxzAHvL5
	 e51X9ZJfzlXZqebdjJS90JNP9BS3ZmxGZDFfgroq9y/uw0/cS2RjbfMNUwnnd70tDECFa
	 KCeiR53q4VbSTyk+Y9KsvpdTdLgzBS1PYijHoYI8x0ZSTFxIpt8y2r/b3eY/eo+NjlXpz
	 aOnGjRizOQCrOJdaSmpz6iFa5CtdGJwIialhL1D41wIBB5Gb3s93GVw5xVHCOe6eDoVUF
	 jzlKJyHmvja7h5wAI+gAQ8yj6kqPQ6213tU78RrJN2lfJZ3NfNPuYLedstZ5IZAOB/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9y+VNa/LMQvTGEE1p/Cqmg7SDP8dupzdCMhNceByTs=;
	b=R5oB8knvIbuJrAqGk9prPhlSyfnKJhOrvtRUg0dc/XGfDhOgY744FWhVDR7lKwSgcY90
	 NsStGsJz6xRV0LJ5AlTpu6DMr565gyblpCW3lINKtoafPx6l3Eq5YXkdZMs3KvAJ03XX3
	 6UumNmeFBmQaqWpn16LYpRW2ZeY61KRGcN9v0OXBZt55DgIUQbZvaihl97qINs/y4Ovt6
	 T7hx/q+l0BXoqKNb7/a/oSePnawYA1Oesg11qhZDdqcIohlaxxZQuICfp6C9ZQmqH+BDY
	 LpeVx5BO6XtpkMoTibRalWi6pMKbHgllad7ft2R0902QVTIDXG7DIeGd1PsLNyn9NIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GhgDBYAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06444606A32F;
	Wed, 18 Nov 2026 20:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GhgDBYAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468FE1F000C4;
	Wed, 18 Nov 2026 20:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034212;
	bh=+9y+VNa/LMQvTGEE1p/Cqmg7SDP8dupzdCMhNceByTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhgDBYAdBHpUx2gNiPB5Wiqj7CbcxHCzFk9ODDy39AVNmPLQy/eIK9FLb4VOeKYmK
	 4Bh6V+d1g3qvANeRBxXxk3JL6KdgtY9r8XueVrC0LPy6/HnYaOAbWCfld3KEDRf6uS
	 XAZVAnKHh5O8wTDEQ31LcCW6t/FZBHBjAW6TPLAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0254/3318] riscv: kprobes: Prevent probes in breakpoint handlers
Date: Wed, 18 Nov 2026 15:14:36 +0100
Message-ID: <20261118150322.946821276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit e7d8ea6c6d1bc685a8943ffad2d3679be92d164f ]

The ftrace selftest multiple_kprobes.tc registers kprobe events on
the first 256 text symbols from /proc/kallsyms. If handle_break() is
selected as a probe target on RISC-V, the breakpoint exception path
can trap again before it reaches the kprobe breakpoint handler. That
recursively enters do_trap_break() and can make the system
unresponsive.

Mark handle_break() and its local probe dispatch helpers as nokprobe
symbols so they are added to the kprobe blacklist, matching other
low-level breakpoint exception paths.

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20260806043807.2583001-1-qirui.001@bytedance.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 314c4d7671ca0..55337e54fc0b0 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -256,6 +256,7 @@ static bool probe_single_step_handler(struct pt_regs *regs)
 
 	return user ? uprobe_single_step_handler(regs) : kprobe_single_step_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_single_step_handler);
 
 static bool probe_breakpoint_handler(struct pt_regs *regs)
 {
@@ -263,6 +264,7 @@ static bool probe_breakpoint_handler(struct pt_regs *regs)
 
 	return user ? uprobe_breakpoint_handler(regs) : kprobe_breakpoint_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_breakpoint_handler);
 
 void handle_break(struct pt_regs *regs)
 {
@@ -287,6 +289,7 @@ void handle_break(struct pt_regs *regs)
 	else
 		die(regs, "Kernel BUG");
 }
+NOKPROBE_SYMBOL(handle_break);
 
 asmlinkage __visible __trap_section void do_trap_break(struct pt_regs *regs)
 {
-- 
2.53.0



