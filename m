Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0371325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300975; cv=none; b=UaJ6DkMESKdlKKODJ8brGZt2XgA/i7/kiZcJf6kNkxKRSbq0J/12EPYljsIIf6uF/RN1zmUZZDhTv/+z2wb44zmJZ7lvpICyeubhm3qF7Pj00Xocc1yg74+FzAcDxp+6uOaI2iRX7fRS1GiRNmasStiRBU+rOaON6R0m9Ja1dgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300975; c=relaxed/simple;
	bh=xaIgGtio2hQ3S0ThiGuPtYQV1KuDGEDcRMPFl0mXZ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAmgnmie72vqeUr61hIaNqDvwEDlWv/xa84Et1BrfyRCj4Hq760dK0US2NpoHwA6maNlhvCCdvi3oE61rwtKLpSp3YdUKy3xUsO89F/dKtdp9sysffZROok0tmM0FOw86+gvjTwMzikpH5rc1CAcib3BtCcJmFme3oIiLvVtWPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+cVkNRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+cVkNRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0431AC19423;
	Sat, 28 Feb 2026 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300975;
	bh=xaIgGtio2hQ3S0ThiGuPtYQV1KuDGEDcRMPFl0mXZ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+cVkNRtD+3fZdSaPTy/w3lnkKbuwGxpDOWm8ikUoDWDiL01EANoGQOQ278/ABVMs
	 L7g5JrW6bR7rYWxMoizKzRNiwKIumEBUGrPgvrQJHf4mmTSTA+Hh9s4EQ7Up5nrvq1
	 AdIz3KRtp2vtyiSUBZ497fWJ7k2s+x9s5p2zG2SVrFeu3dfLHVe0UcgTOPce3CLgYo
	 I3g+OwfaeDicSvIIIZn8k8azsWJfy6/9jS3gR71em9QRjlrd80F2pdBa0RexNNxYDD
	 A/VDH3yRrJ8yvBcNaDQttxNkg2ZhtqxpmqlEvQpb7Zb7haF/2IxhzEIRarTj94DrSy
	 CwIAa7QMjjUYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/752] x86/sev: Use kfree_sensitive() when freeing a SNP message descriptor
Date: Sat, 28 Feb 2026 12:36:54 -0500
Message-ID: <20260228174750.1542406-103-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit af05e558988ed004a20fc4de7d0f80cfbba663f0 ]

Use the proper helper instead of an open-coded variant.

Closes: https://lore.kernel.org/r/202512202235.WHPQkLZu-lkp@intel.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://patch.msgid.link/20260112114147.GBaWTd-8HSy_Xp4S3X@fat_crate.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/sev/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e65..c8ddb9febe3d9 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2008,8 +2008,7 @@ void snp_msg_free(struct snp_msg_desc *mdesc)
 	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
 	iounmap((__force void __iomem *)mdesc->secrets);
 
-	memset(mdesc, 0, sizeof(*mdesc));
-	kfree(mdesc);
+	kfree_sensitive(mdesc);
 }
 EXPORT_SYMBOL_GPL(snp_msg_free);
 
-- 
2.51.0

