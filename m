Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045763;
	b=wDPD5rUIgPUQJLg36VOGICToEZR6xOrc2z4HzAOuAu1vuGETSI3fJRi1ZWjUIAXMZkfC
	 htBxsvgeoVTXvsblNDyVwQFjkCwmA4zFWalT8IyZmMefXS6UjhQS6HtZWYg/VOc7un6iY
	 d8SC1CmdAnk5qNpL+MxNHLXe7IIkislb1XyU3mP1A1wTKYEcXTswIn10FTHNxZoDIgkLe
	 cHks8zGXa5da+/4YzkMs4b87bcMtYxw7Cg4Jml6OwOtn9Q2qzxR1cLZjHIdq5+NZwYF7a
	 heBgFM0j1ifC9DFxPrMv+JCdH45G21xFR13dLTCYTzTCRXwMGseWUN0KqXvsHyFHvAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2KAz/7bGT961H79aWtZy7fVhF7mFiI44fX+HR0wKTps=;
	b=ATUifT1Ev7IEhiW2J0VOTEf0fvChSbOBDdaBKEJzYnpLlrnAQA5ndKjNJoMBtlEJzolC
	 L9Rl1byYNNBG4W1NIrL3C4XHqDbbt40IFFD6qg4QYZMbdgiCEEbGQNNH+g1SuhuPKpzY4
	 QkXeRIFCdeh2dflucEKFpWyd4EaSQdF0sfJ6rkczp4s7IfzCZxOJzfr5Qd7lqbLPOpV4Z
	 Iot9WTrpHIJ2f0syz9/PClmJaercvjrblfyG4tfzZTwQ3CiNuagyOjobxVMxmmNFU4K1T
	 f8YSrJrzOIbtr39lDt2Ocop90VvxdU6sLP3xG9EcdAPkEmpJt8ZM3LO64h1LN/c6p6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mi10IN92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEE5606A325;
	Wed, 18 Nov 2026 23:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mi10IN92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0A61F000C5;
	Wed, 18 Nov 2026 23:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045763;
	bh=2KAz/7bGT961H79aWtZy7fVhF7mFiI44fX+HR0wKTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mi10IN92VInV8ovBYcrVhtGVelc7ySrvHqFTMpgfk/6QFpwnoyC2RwDHp4es4eH3T
	 5ZfyNYGfa8z+KlSnI2SFpGekan8lCqktIZqFn7BeTweIuSCJnAIDK5Cq9tV5p3E6ri
	 YUyuMfkFb34sl/LDBn5LqF3EzFc+7zi8MbCAFbJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	tongtiangen <tongtiangen@huawei.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Yaxing Guo <guoyaxing@bosc.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1041/2857] riscv: mm: exclude invalid THP PMDs from page table check
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118150239.079296983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit bdda2887cbf3937c2d0f56589c2124c4167324e1 ]

RISC-V THP splitting uses a temporary invalid PMD state where
pmd_mkinvalid() clears _PAGE_PRESENT and _PAGE_PROT_NONE but leaves
_PAGE_LEAF set so the MM code can still recognize the PMD as a THP split
in-progress entry.

That temporary state no longer describes a user-accessible mapping, but
page_table_check currently treats it as one because the RISC-V PMD
user-accessibility test only checks whether the PMD is a leaf and has user
permissions.

As a result, when a PMD-sized anonymous THP is split during a COW fault,
page_table_check can account the invalid intermediate PMD as a live PMD
mapping, and then account the replacement PTE mappings again when the
split installs the PTE table.  This leaves stale PMD accounting behind and
later triggers page_table_check failures such as a non-zero anon_map_count
when the folio is freed.

Fix this by tightening pmd_user_accessible_page() so PMD page-table-check
accounting only considers leaf PMDs that still carry either _PAGE_PRESENT
or _PAGE_PROT_NONE.  This preserves the THP split semantics required by
the MM code while preventing page_table_check from treating invalid split
PMDs as live user mappings.

With CONFIG_PAGE_TABLE_CHECK=y and CONFIG_PAGE_TABLE_CHECK_ENFORCED=y,
tools/testing/selftests/mm/cow completes successfully on RISC-V after this
change.

Link: https://lore.kernel.org/20260523042052.35476-1-cuiyunhui@bytedance.com
Fixes: 3fee229a8eb9 ("riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: tongtiangen <tongtiangen@huawei.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Yaxing Guo <guoyaxing@bosc.ac.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d25871c608832..2fb15a97cbf58 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -668,7 +668,14 @@ static inline bool pte_user_accessible_page(pte_t pte)
 
 static inline bool pmd_user_accessible_page(pmd_t pmd)
 {
-	return pmd_leaf(pmd) && pmd_user(pmd);
+	/*
+	 * page_table_check() must ignore THP split invalidation entries created by
+	 * pmd_mkinvalid(). These retain _PAGE_LEAF so pmd_present()/pmd_leaf() stay
+	 * true during the split, but they no longer describe a user-accessible
+	 * mapping once both _PAGE_PRESENT and _PAGE_PROT_NONE are cleared.
+	 */
+	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) &&
+		(pmd_val(pmd) & _PAGE_LEAF) && pmd_user(pmd);
 }
 
 static inline bool pud_user_accessible_page(pud_t pud)
-- 
2.53.0



