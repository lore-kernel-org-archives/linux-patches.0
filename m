Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6058513AD05;
	Mon, 27 May 2024 19:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838211; cv=none; b=gIdzXFiQaYP2Np06FXJdu3mvpLOzrWYYSc7CL2vYwwU3AR/hH7LcsWrk7/8t5X4LFiMpN4AiOMpbgiELB/b4q3VjTUqMvB5hggoZ2LVXgDFeG2I/pyBi3f/F3Wc6nJziGRTYg8J07inaBVqJwrOEn2lRbCUIRiK/hvm80bmn7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838211; c=relaxed/simple;
	bh=cFpo5I0dRt5uYfv7VB7VwPWRIJG6NF4/fFKK57mDfDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgezqlEv+TGkYhKMcgglwvJBof9KLPULzH3t4d4Lym7vG4tZ7T+rAWsVMe/YjO2S4bPV2oqf12h+m3Dt++oAU9QH8z8/nuLVpzv6xyCpAhu/lQvwrR4zRDLHttd6CWhb4l++UM3JlMmLwPGqriyB1FnC7o9F/bXHxvdZJ6HD4DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5mX+Sp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5mX+Sp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE63C2BBFC;
	Mon, 27 May 2024 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838211;
	bh=cFpo5I0dRt5uYfv7VB7VwPWRIJG6NF4/fFKK57mDfDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5mX+Sp0rPkQyvpQmVrLKPIT5mt6VKOdTcIuUjxzOrTCcddj8Wfs83s8QhblosA6W
	 uVj7rMs4R9sQhNBDMpLYLuPyplrJ39zPv+bv1jlBrs24MxUqVl/wFGOv6dTYrBw3JD
	 3dUoErMQ+DiMxhh+SZpCmYJ8w4AFW5pe2Sy/ct2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 267/493] sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()
Date: Mon, 27 May 2024 20:54:29 +0200
Message-ID: <20240527185639.024110951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



