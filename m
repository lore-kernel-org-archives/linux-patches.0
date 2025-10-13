Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8830F921;
	Mon, 13 Oct 2025 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368887; cv=none; b=Oul+DghtGv21L+gaH0O3d3gj7Q81zP1wI9P64+1ySmGZgYZMWW3fL9ThGNt+MMNf8mWs3B2y0FY8i0tiDG98LneM/xtuLvuVQx0/gDi27igVEvwtTGVy9V2TrEZukiQAu2sft71bd7S3AVwStTKgwHyN/TxTYskLmjfID4cIn4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368887; c=relaxed/simple;
	bh=twvoxi7SeblshpbjzrbcxtL3omHW1jRtCKH3NvAfbXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pf/2z83i+vaq4ANp4dmL1Oe22Nb/xFDtJpsoaQjzEcux5SECVhL1qi7yTUffDNZgGI6fhoHinGoDrmLCyU+QP2gBloCh/68b5sZAn0eWzyai7GOmutvWUi0x1qTJws4uGR5jEiK8HU5G1y2kQi8ErBg9pTmhoaDgaURnmnN/REg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XASV/aup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XASV/aup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9E6C4CEE7;
	Mon, 13 Oct 2025 15:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368887;
	bh=twvoxi7SeblshpbjzrbcxtL3omHW1jRtCKH3NvAfbXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XASV/auphLJJnDjVDZ2tARfrAO6s5R4SUoIFco6Rdgg6DOUXRMDtZLqwfRMXNEYGa
	 sckcgONqErZ0j/f4ZWYZKRcZwTR3bUU/auLcoi8Z9EoKOmHYv05+W5h2TSqR5HroV2
	 2D5TsUabpB0PrCeqEJH5qab8ybmOO7jil9QXaYRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 020/563] powerpc/8xx: Remove left-over instruction and comments in DataStoreTLBMiss handler
Date: Mon, 13 Oct 2025 16:38:01 +0200
Message-ID: <20251013144412.022580776@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d9e46de4bf5c5f987075afd5f240bb2a8a5d71ed ]

Commit ac9f97ff8b32 ("powerpc/8xx: Inconditionally use task PGDIR in
DTLB misses") removed the test that needed the valeur in SPRN_EPN but
failed to remove the read.

Remove it.

And remove related comments, including the very same comment
in InstructionTLBMiss that should have been removed by
commit 33c527522f39 ("powerpc/8xx: Inconditionally use task PGDIR in
ITLB misses").

Also update the comment about absence of a second level table which
has been handled implicitely since commit 5ddb75cee5af ("powerpc/8xx:
remove tests on PGDIR entry validity").

Fixes: ac9f97ff8b32 ("powerpc/8xx: Inconditionally use task PGDIR in DTLB misses")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/5811c8d1d6187f280ad140d6c0ad6010e41eeaeb.1755361995.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_8xx.S | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 56c5ebe21b99a..613606400ee99 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -162,7 +162,7 @@ instruction_counter:
  * For the MPC8xx, this is a software tablewalk to load the instruction
  * TLB.  The task switch loads the M_TWB register with the pointer to the first
  * level table.
- * If we discover there is no second level table (value is zero) or if there
+ * If there is no second level table (value is zero) or if there
  * is an invalid pte, we load that into the TLB, which causes another fault
  * into the TLB Error interrupt where we can handle such problems.
  * We have to use the MD_xxx registers for the tablewalk because the
@@ -183,9 +183,6 @@ instruction_counter:
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	mtspr	SPRN_M_TW, r11
 
-	/* If we are faulting a kernel address, we have to use the
-	 * kernel page tables.
-	 */
 	mfspr	r10, SPRN_SRR0	/* Get effective address of fault */
 	INVALIDATE_ADJACENT_PAGES_CPU15(r10, r11)
 	mtspr	SPRN_MD_EPN, r10
@@ -228,10 +225,6 @@ instruction_counter:
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	mtspr	SPRN_M_TW, r11
 
-	/* If we are faulting a kernel address, we have to use the
-	 * kernel page tables.
-	 */
-	mfspr	r10, SPRN_MD_EPN
 	mfspr	r10, SPRN_M_TWB	/* Get level 1 table */
 	lwz	r11, (swapper_pg_dir-PAGE_OFFSET)@l(r10)	/* Get level 1 entry */
 
-- 
2.51.0



