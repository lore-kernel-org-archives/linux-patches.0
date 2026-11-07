Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060937;
	b=a8u8FQXEEPyv380Vc2PRzralDEPKmR4fyViJLo6+Ui1gx4BiGgDIzeqGA9KwJFvbUSKb
	 VHGcZqP1mCRu9q9fl8C/21S5Q99PmF2aZcUqBbLx9WRusLfahHOyOFidHgSMe+2RlfEv9
	 zyMlL535wMVZ0jeCj7RX1y11rQSVRwcCXonxPKCQfBAbaYuScrrsc/QUNqWb5Ad5+BuZ0
	 8ULz3s2oL9yLlusnNacxKE2/IHc267Cy5ehCk6VtOrmgN/77nDcIMivZWiu/yjgpLChkj
	 PAgkHZJ6v3GNR/KIkZALZowBGDxzIR0jKRxFjlKsWjmN2p3P2LVhbrffIpmwUj30xyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tLNDpi4x3nbm+orKfNATKANLWyCUrewvfBgqeQTs6rU=;
	b=x5gbgBClzddD6tr0Zh/wxEBup+JM7y4PfazMHwy3Ztx1Lr4ErLokgXZVF232/lcunm8Y
	 bRLlHX1ZG+cuQsfjRCGmcmwic37TfJimY/FOmnuNa4U0B+kQzMIDxmAod8YEzd9ounhdn
	 Y9SJpHFXX2xRia7Dfeiuc7X01+jYB+HY+Fcy+vnM+ghhz5KZn2oAwQo4VHNiD95dxnJr3
	 eySQXIx5UheLxQwXtSbWfHq+EBkylr2MtWafkdFnvau6GDpYNB5aqEtuZ7XliXbmV2jK1
	 /OXdgQXK6hqSVY/Ik36VkSs4EykNIYZ/7wetKegRJ2+QsWUJIfpnBb/YpRqpWAP4OBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmlU8bcu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E45606A326;
	Sat,  7 Nov 2026 14:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmlU8bcu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0029A1F0089F;
	Sat,  7 Nov 2026 14:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060937;
	bh=tLNDpi4x3nbm+orKfNATKANLWyCUrewvfBgqeQTs6rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmlU8bcuKOPlyHJhOJ9FX1wB/NTPV9l+Y2bMjajNWWlsGAzlbOqDz7lL3wl4UyVKf
	 pLZpEnjMzYSjX98/k78ey7GuSFt/X+4D4QYRn8c51zXdbiyt1iKrUcMublFxxF+aK2
	 tWttJCrKxrSzAmnCLPrhDhgOLyO4k5QuTMnczxH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0301/1536] riscv: kprobes: Prevent probes in breakpoint handlers
Date: Sat,  7 Nov 2026 08:38:37 -0500
Message-ID: <20261107135006.180180891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47afea4ff1a8d..e7e45cbb08999 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -272,6 +272,7 @@ static bool probe_single_step_handler(struct pt_regs *regs)
 
 	return user ? uprobe_single_step_handler(regs) : kprobe_single_step_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_single_step_handler);
 
 static bool probe_breakpoint_handler(struct pt_regs *regs)
 {
@@ -279,6 +280,7 @@ static bool probe_breakpoint_handler(struct pt_regs *regs)
 
 	return user ? uprobe_breakpoint_handler(regs) : kprobe_breakpoint_handler(regs);
 }
+NOKPROBE_SYMBOL(probe_breakpoint_handler);
 
 void handle_break(struct pt_regs *regs)
 {
@@ -303,6 +305,7 @@ void handle_break(struct pt_regs *regs)
 	else
 		die(regs, "Kernel BUG");
 }
+NOKPROBE_SYMBOL(handle_break);
 
 asmlinkage __visible __trap_section void do_trap_break(struct pt_regs *regs)
 {
-- 
2.53.0



