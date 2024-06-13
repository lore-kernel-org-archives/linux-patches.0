Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7DF143867;
	Thu, 13 Jun 2024 11:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278819; cv=none; b=NZWqxc1IEavHHiAFxhy7ZxAISJzE80urkDraUWeVW0dYKcJim7KTqSF9vdvbMwQFmg7A6Ato1hh97jvlENoU3NXCDLP3TygVAjZRb70hNPWe5NzLg/I+y8QknI41ZY5tFumUOgTpqXt/3eTb5xuYQbWp7RfqGmGElG9NGK8tehA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278819; c=relaxed/simple;
	bh=xTwRVmLu4hCJD48NghzVUwETed0UWo6lhGNa+B7r+S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an2mzCwdDTazyArjfbrW0IAaVI6heA7Ola0v50ILVSsyQfh1p5hBZ89/MpYQpQ6cOZ/MeGo8m/QGwrFpjPCG9GTUGSHF7/0+jw5Ww211UeuRApHVB6l0Ak7PpEunixuEAGrYpheCT6JX4yLwcfjGC0Hu733FqFoeblZvm3kgquc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrWzxPqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrWzxPqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AF2C2BBFC;
	Thu, 13 Jun 2024 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278819;
	bh=xTwRVmLu4hCJD48NghzVUwETed0UWo6lhGNa+B7r+S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrWzxPqYZl0skQxXzCeo9CPgcNEObLES/snpNZR0+0nln7OZ1QvBgCcM+u4cBsjwQ
	 PcecAjow05E5EDXPzDbQa+qqn1yUB9qifGWekE6WytoQT4svswLphNWWOkkybmXBWk
	 CXQj6AEaAHvqKrbAeDB/Hk6q24G3D52uKyGbkSIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/213] sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()
Date: Thu, 13 Jun 2024 13:31:37 +0200
Message-ID: <20240613113229.899836934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 241e903dd3ee2..89edac3f7c535 100644
--- a/arch/sh/kernel/kprobes.c
+++ b/arch/sh/kernel/kprobes.c
@@ -47,17 +47,12 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
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



