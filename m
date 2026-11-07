Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065357;
	b=KrsO+DuEaf13e4UWweqyTe5knWn7PXKlgWO53cEtAT1i8TSfLtQ4TOX1vQwBinDov8Yc
	 C4AYSy6YE6DQheusCwM9UaatjXkwfXPxlujr1AyKiRyi6l2/iGFbU0qUEqQtGhJpdjjY/
	 D0dS7cpWgfaqry+DlX/t/5V4sno3SW6/vOsN2cYcXkQfF8BLtnVF+5lLs85xNFU82x1Ha
	 x2wxvZZQOPuAzpjodVhpKJONlYTQfdn9KsR+WEuRTu13qafL7X1NvxJh8ooOI2K6DIKYr
	 ECzGgnHwZbHZcZcZ8QzuPdXfrk4wzouvcAYPff8mxQY992TyVh3bL0ekB7EkPWUJwFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCYjgur4qBbGW2xcUAjb22RUClZSstLkTBXNKwX94Mk=;
	b=BdvgP88lpXwP/g9dyxqn0ALTDv3SE/t0w5jggiJLyUkvpNOixvomFiOkcUTMFMubMFs9
	 QS9koelr1yYueddayKpoMaKCO5mOElX6v+LkSn+5nkoPdRcfu7KfR/yzjdPaq6IvfJdn3
	 5hgn0rb7HLsTTcOhYFc+FZrXhwEcn8uzMP/M3eF9kwFhp2oOefeCpnEraAcs8WI/bpiX5
	 KPeyTSiXhtkznBq+85LQP/03QZrWarI1VRm7qzOZs1s7d7UiBX3cWEyrfaEX+dJyafpW7
	 MROvDsE9/+G/y7j8vRQaWIV268FCswxuVBpGGMNUfSFCXqwpmN8Wdu9+KP2PRpF6/+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l4qz/P85";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1F606A32C;
	Sat,  7 Nov 2026 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l4qz/P85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA9D1F008A1;
	Sat,  7 Nov 2026 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065357;
	bh=tCYjgur4qBbGW2xcUAjb22RUClZSstLkTBXNKwX94Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4qz/P85TGosE1z2McJLjYC/X3YddvKwCEdoMC8ZwEP2E9dZtlgnP9Rj4SpG0swsS
	 FHsY5UG+Al9ren08AxtsBaEwpLAZ+mugXdtHe4rqOA50iG5eCoToogAx7zencjiW14
	 nirQRPFAMdXkXN+ZTsMXPu1QzkXvLIgk0j4se9tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1093/1257] mm/mremap: populate calculated fields in vrm state correctly
Date: Sat,  7 Nov 2026 08:56:29 -0500
Message-ID: <20261107135009.453568897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 34e753f8d927069785f6b675f5769da5da4ef78e ]

Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
introduced the vma_remap_struct helper to pass state sanely through
mremap() logic.

Part of this state is vrm->delta - equal to the absolute difference between
vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
respectively).

This value is used to correctly charge accounted VMAs.

When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
having performed the shrink of the VMA first, prior to any potential move
(e.g.  MREMAP_FIXED | MREMAP_MAYMOVE specified).

However it does not recalculate vrm->delta, which results in incorrectly
overcharging the VMA when both moving and shrinking a VMA.

The charge leaks to Committed_AS globally, meaning a mischievous user can
cause allocations to fail across the system in strict overcommit mode.

Resolve the issue by abstracting the update of vrm->delta to
vrm_populate_calculated() and invoking this from mremap_to() when
vrm->old_len is changed.

Additionally, update vrm->remap_type whose value depends on vrm->delta.
The field is not read again after the shrink, but it is the logically
correct thing to do and protects against future changes which break this.

Link: https://lore.kernel.org/20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org
Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index ace0c6a343b1b..d5f34e87c518a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -887,12 +887,6 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 	return pmc_progress(pmc);
 }
 
-/* Set vrm->delta to the difference in VMA size specified by user. */
-static void vrm_set_delta(struct vma_remap_struct *vrm)
-{
-	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
-}
-
 /* Determine what kind of remap this is - shrink, expand or no resize at all. */
 static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 {
@@ -905,6 +899,13 @@ static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 	return MREMAP_EXPAND;
 }
 
+/* Populate calculated fields. */
+static void vrm_populate_calculated(struct vma_remap_struct *vrm)
+{
+	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
+	vrm->remap_type = vrm_remap_type(vrm);
+}
+
 /*
  * When moving a VMA to vrm->new_adr, does this result in the new and old VMAs
  * overlapping?
@@ -1523,6 +1524,7 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_populate_calculated(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
@@ -1795,8 +1797,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (is_vm_hugetlb_page(vma) && !align_hugetlb(vrm))
 		return -EINVAL;
 
-	vrm_set_delta(vrm);
-	vrm->remap_type = vrm_remap_type(vrm);
+	vrm_populate_calculated(vrm);
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = addr;
-- 
2.53.0



