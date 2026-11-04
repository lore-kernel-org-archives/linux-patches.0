Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830862;
	b=3g9PD9yMrPMWgVAUBn0iMVdxLnpWCiLkV2XuO+zdBmEbUO3uDsLvPC2nptSgG1rj63O3
	 F1YqidT/TuW6FNCuNmdeg+Vi3w46X2odrgKgE+J72CkL3D2vIzotp848+XMYr6sdVsslL
	 Qe7dBP4Wdq26KhVRM3V/fiplI33sXOUa7Onm9SZrkhdOpS9KIOCVPL20wC/EdGNNC79Nq
	 t3LUBgx6PIpwrNFMx+XizDVX+xeW8vv5z1RYvWsVVUIDe54bNspQHoXOWzIEejeQUtwch
	 7flksB47FYAVOmc6aKfXMGf9L2S6VC0rgLv7qBfPljNO92TBVP1INehv6vzdc/F6RuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slQTGDTP6a9JQp/c7CxqCuFX7Z+F7e3G78QygI+9xCQ=;
	b=Glpsr+Z/mLLDWV+cqOJIXMeWdCMlSgJkWrSH/obnEGFJRYjRyVn1soB5pk+F7+F68Emv
	 6d8pUtN9K6klzC+ZVaoUB9k6MPnDqvgfrzh/dsj+qHxYHCrnI5rpzkMpL8zta5AFx6Fzg
	 I9Te7MAbcbt1mFNz8A9hun4ohkVjn8XWrCRyL7Q9lQVcjEr/NZcQHAacmMDepXqb/wErv
	 7cn2/ghvr/5HS/CpVVbUW9ZFHZ45g/MHT4UL04rtpveKQu1V8EweSN1ijw/qj62uliDf6
	 U78Iv1zkRWyZI4ZT1/fz8EbqOIDOP0kpott5JvN8ZVnh/dVYAAXVym4P86W8eBZDV0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLTwRs8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D230606D80A;
	Wed,  4 Nov 2026 22:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLTwRs8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD551F000C1;
	Wed,  4 Nov 2026 22:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830862;
	bh=slQTGDTP6a9JQp/c7CxqCuFX7Z+F7e3G78QygI+9xCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLTwRs8pRstnPHu1AAsfH8iEuRxXkfpN4PF0EVZaLaYZahu3WwQ54XQlFi7zXufHB
	 9Kvvwpsv88caENL0+Yq2DgishpWp5sQgZyrYPGOxrUkcY4bDED5Dheyktqsq0xGhPW
	 +yoCyCR5caGh6xdUP1oUlGUBnzgMVLHkPNuGz+uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0366/1005] riscv: kprobes: Prevent probes in breakpoint handlers
Date: Wed,  4 Nov 2026 16:01:39 -0500
Message-ID: <20261104211054.339756717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



