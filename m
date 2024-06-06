Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA3196DA5;
	Thu,  6 Jun 2024 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683269; cv=none; b=MffP7uv8QjzPhJfrOr8dI6Bh+3mNH48/atJSKTv7co59JJV5/TOS5Ipb8r5eiM3OkwxKHVsCce5e46/zZfnnCn9HrBVH5U+yzGJm/R7K9aNjz/oEn0MvwnLt430qFHLYgsSGNBTp383bc7YwLnUH5PBg79GaejeXIBRHrgxPM18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683269; c=relaxed/simple;
	bh=voyqgFSt3+OFgd2F+k4fPu4J3CF7DSbcyq02egCU44E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMCqy8VARxLAptH16UzpbNpeIqHLglnUR6JUKDcyIgf7xOZzsuXY73dCrTXDmjbW68nMR/MIknOX4+LAM4iGmb+Uh/9J+JM/ge2ZWlMlQPCiCx5j99fVqzHUNMegf7/Q6YPYrvoqISHDYNnfJg26tZZk7h9WeWl/MCh/SPsayYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCFWBTWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCFWBTWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F65C2BD10;
	Thu,  6 Jun 2024 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683269;
	bh=voyqgFSt3+OFgd2F+k4fPu4J3CF7DSbcyq02egCU44E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCFWBTWAPyOZ0PcpwCaPTqWyaMcPNg3J4dwwIEsebpEqdzACg1ckkdJ99jTZOaG5d
	 NDTVMEOXaOVjQCtVh1y2aSoMi+hunPcMaRDGkXJO9cBJlOmd7ROuX4j4/T6S9gxGSp
	 rkzzOvfR61dGbK8FMQYkgTCaCmPkgVJrpmca8FLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/473] sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()
Date: Thu,  6 Jun 2024 16:01:17 +0200
Message-ID: <20240606131704.843673722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1422ae080b66134fe192082d9b721ab7bd93fcc5 ]

arch/sh/kernel/kprobes.c:52:16: warning: no previous prototype for 'arch_copy_kprobe' [-Wmissing-prototypes]

Although SH kprobes support was only merged in v2.6.28, it missed the
earlier removal of the arch_copy_kprobe() callback in v2.6.15.

Based on the powerpc part of commit 49a2a1b83ba6fa40 ("[PATCH] kprobes:
changed from using spinlock to mutex").

Fixes: d39f5450146ff39f ("sh: Add kprobes support.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/717d47a19689cc944fae6e981a1ad7cae1642c89.1709326528.git.geert+renesas@glider.be
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/kernel/kprobes.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/sh/kernel/kprobes.c b/arch/sh/kernel/kprobes.c
index aed1ea8e2c2f0..74051b8ddf3e7 100644
--- a/arch/sh/kernel/kprobes.c
+++ b/arch/sh/kernel/kprobes.c
@@ -44,17 +44,12 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (OPCODE_RTE(opcode))
 		return -EFAULT;	/* Bad breakpoint */
 
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
 	p->opcode = opcode;
 
 	return 0;
 }
 
-void __kprobes arch_copy_kprobe(struct kprobe *p)
-{
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-}
-
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
 	*p->addr = BREAKPOINT_INSTRUCTION;
-- 
2.43.0



