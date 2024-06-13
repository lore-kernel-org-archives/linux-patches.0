Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EF1817;
	Thu, 13 Jun 2024 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281904; cv=none; b=jU+1xcZBHwIW2yceqZuoVSBgPwnxvu00046PKxlLRUyKaMDNqEch4Pupa+YAAUJJNxP57A1cRsBZCBREx/8tHO8agZsK9ESbw4C9Rv6TqIdFTR/tw18Uq/G5unB7dsso3iY6Q9GvNbMgB4nRyiX8MHK7xLenllcSxYDwXtifo3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281904; c=relaxed/simple;
	bh=P/BtLmoyE9tP2ZFdA4qcAQX0JReo9fsJa9e2XhSRZKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwXoB16kM7PC46RUJXS1hxHQI4fbxTDXQh1podO7IVxwJKmPlTQHylyjV3apQ4m8lbbWdBHLay3LyUJQrgbscwriHtXIzdIomFVWhQpaxKUzXpXu5tttpeSx0+kMnzFdyB14ICJ9xNeEEO8rca/t4QMdx8E0DGZOM//arUWjGCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOKvFci8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOKvFci8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711A9C2BBFC;
	Thu, 13 Jun 2024 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281903;
	bh=P/BtLmoyE9tP2ZFdA4qcAQX0JReo9fsJa9e2XhSRZKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOKvFci8HhXV29TXhyC/rc42d+Cj5iv7jfnsalJ64ZPupTg/ISTjv/57AKTuBMiqB
	 gOi6b4K8yeXDMwBWoMsC95eEdUx3AoZD2+KtIDzoPtP2offLn4aPCn8U73N5ofG1TL
	 28YH8HFL94ghmRN1hhSvi6DLNn9vIqUURK/bhfdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/402] sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()
Date: Thu, 13 Jun 2024 13:30:53 +0200
Message-ID: <20240613113305.884272255@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c7f358ef0be1..5db45517bb1e6 100644
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



