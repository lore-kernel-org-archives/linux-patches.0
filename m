Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063640;
	b=LA+NLWK7hKQfozzsh8Nu174f6AWySolulQFgRLM3mFgeONALaeFZJcCPzvJ6KTz9FAu+
	 y0YlzTNz7NUde2BcbYOTRRDm0jd1XzvhVdOxkL7As05/SRLbT8BmAh0CjsJJaVtapKuCT
	 AEN23J7IVDnvBxXIr67XqV5kbV3+CkrTav5DAeHfI9v90+uOoo94XZANbqfpa2m8yI9ka
	 QfxmmxthYMCFUEQJ18HYEiFJwnR0xZMIxLNq2HiXiFzRqmorMmPRz4dfM2Of/GZt/k7/h
	 u2fw5GWx3IjHMeoAhHX0Pup5jojF5Nr4OGKM+h5CZyMKNyDtv9xB1GhN4POx8C9OPEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VQnQOWx9ACtMAxLEs2CnQtIZAdA547mxasMVtjFm61w=;
	b=T/zJxaHKjSvRvJCKBciiUvrnQD+sAJsMEPyz7Z0IeH1OubGCHczpfJWmXHCTiZaqcmom
	 GWratgHAYw8lxjBFMyo3oDMt0IffJ6pEWIQBKgPQ3uQ/I70P6qZZrVKCMpkfoehdJW/gR
	 rdRJ57D/0xZ4Rb+v9A7YlPRUYOyzb+r56sTmJbSerTQGILJYBaXSFjak4M7pT2ZCiV+yu
	 2kU/Staof6HDxw5LQSB4Z40Nr4aYrJYCdKHS3TOAT7aMLgp/miyXt1C6n9Ozx+O7f2oSQ
	 +t8MGmWXIBYIT5IBUuXasYAgXWW4MaAlQAbb6qyYcfH/DAtkJinZxLfR7QKq3G1+nDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQZcCmHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AC606D833;
	Sat,  7 Nov 2026 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQZcCmHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FC01F0089F;
	Sat,  7 Nov 2026 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063640;
	bh=VQnQOWx9ACtMAxLEs2CnQtIZAdA547mxasMVtjFm61w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQZcCmHu29fAbXJ17KKaQZSWJ55RZtelLo1xcyLaokhRPTRBzaPkyhsG/FA/XXEAK
	 7Ut4wHt94o2OQeizmKtGMUBzxm41bZ/Nm9fMO8be/SkyflLmIu1fkcNN7lRU8+HCXC
	 a/scMpccAy/1d6EQSHIdCmNEwPXV0AlRyjXicFgM=
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
Subject: [PATCH 6.18 755/869] mm/mremap: populate calculated fields in vrm state correctly
Date: Sat,  7 Nov 2026 08:57:17 -0500
Message-ID: <20261107134918.328504472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index f023b05dfb3d9..593e6f94eba3d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -874,12 +874,6 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
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
@@ -892,6 +886,13 @@ static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
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
@@ -1422,6 +1423,7 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_populate_calculated(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
@@ -1694,8 +1696,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
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



