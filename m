Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028738;
	b=s6MzLHnEMlS/Sl5RIVyAnF4wOlf6YWOhG8o19GYNjygq7n+dRvCJz7FIw+POxgY8gulw
	 mGwh8+lnYxGoWUG/QFxxG84kRhfEbCFLu5YM4Hy4CyD/pGOSVVVQD3WTWL7DtKW1tgYED
	 J/44oPNdZBKKjbPmxL2d9CO022jlwq2kobaWRX6qW7WoCh8Einn8e0UiYzbJSkjLjSc8+
	 ORIIe+knkckapVfWCWdnvCrwJ8oejsdZUVV5n9US6KuUoyu6zeAODQkEv9uY6s4ljnY0x
	 ubu6uAj5n5kXGg7ZxiU4P2SmOwninH2LavtCqjcqnTBumvHbV4/fukbkcDlnPh1plIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sTPxZUvCqKXxXtPnoR6dURv+BnsLVJDUVhvSH7q5vi8=;
	b=ybYS7x43WQM7qmq30Zii47Go1ET/yietOyHleFdhe0sz4QVxSO9/VuwYjPF4zNv2lpMY
	 r6lYjJvhFfn9GVa+xaalSpBibcouVQewC6c2alqBUSNPQ3aHL4dr6ypnD0X6jBcz2NlQg
	 GJ5EF8hOpxkzivEkYihz0DS141efVWcQt2vue/9fzOwCf7G7VSRy4JZtnscz/zRyAc85D
	 viS2qhkvuqz9q3LvvkBpgMTuFq3kZLGOg4AJnXYFUTeTNTJkEckueGXRKMkR3fKIciKN7
	 9nQffg9Qx7AIXbcudfYZfIPvz462sFbAJUEjI31sOsn28BKh4N92o/lXXXovxgBS99Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzGYIRgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EBB606A339;
	Wed, 18 Nov 2026 19:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzGYIRgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC561F000C4;
	Wed, 18 Nov 2026 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028738;
	bh=sTPxZUvCqKXxXtPnoR6dURv+BnsLVJDUVhvSH7q5vi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzGYIRgl7UA7U1G1W+JDSraQ3I3h2a/N8/G9XwEWiauQOKyA6VM5jhISxwlYUgesC
	 0kpsd0eaCmXhK1SiQn12R/lvKO0xIGRV3W2bDv8L1eCKXo7h2dI93J0fvrMU5s8oMx
	 wwb/xeywo81lAvmkYXD0YjjA6Is49S14wBt69cS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0101/1756] mm/rmap: handle device-exclusive entries in folio_referenced_one()
Date: Wed, 18 Nov 2026 15:37:08 +0100
Message-ID: <20261118150012.257552347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f3c493d2f42b5f44a5c134d8d7ea7f960caf5e2c ]

page_vma_mapped_walk() can return non-present device-exclusive entries,
but folio_referenced_one() passes them to PTE young-bit accessors that
require present PTEs.

We must neither call clear_flush_young_ptes_notify() nor
folio_pte_batch() with non-present entries. For example, clearing the
young bit on non-present PTEs can corrupt the entry: on arm64
PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
entry into an ordinary swap entry.

folio_pte_batch() will VM_WARN_ON_FOLIO.

Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
treat these entries as old from the CPU's perspective and obtain their
young state through the MMU notifier.

Skip PTE batching and MGLRU look-around for non-present entries, and
don't modify non-present PTEs.

Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-9-d6437171ecc3@kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adapted batched PTE reference checks to the existing single-PTE walker. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1bf83e939583f..ad0c6b1eebfec 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -850,6 +850,7 @@ static bool folio_referenced_one(struct folio *folio,
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int referenced = 0;
 	unsigned long start = address, ptes = 0;
+	pte_t pteval;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
@@ -892,12 +893,25 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
-		if (lru_gen_enabled() && pvmw.pte) {
+		if (pvmw.pte)
+			pteval = ptep_get(pvmw.pte);
+
+		if (lru_gen_enabled() && pvmw.pte && pte_present(pteval)) {
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+			bool young = false;
+
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			if (pte_present(pteval))
+				young = ptep_clear_flush_young(vma, address, pvmw.pte);
+			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
+								address + PAGE_SIZE);
+			if (young)
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-- 
2.53.0



