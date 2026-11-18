Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022797;
	b=MJcdA929WcKlZvSBnOKB04E3dHhUb7DA6wZWohWPF9dJx+KL5UmPnKEj+IRr5oeylmEc
	 NjudwN588XylCLMW0XcpsrxvO02FOGdlVkmYsAMVOV9SVKADQhEQthG0FntEyVcM/6/c2
	 3EYmKmRKqwBcJa9ckDar92Q9yBJLDlMEZ+YZ8fLQoxCvNHsHFlmsUltRGjZAFEdbF1Aum
	 qFVPPkC495rburBcm6ZU6EiObUwQcvEyR9iyg0XLNjWXFrsf9LPMJjv579iP1yeqCUyvX
	 GpZ60JTqDebsKGtcQtgc5m2z4WnEUGTFaaL41/tMDBJz0E7tWZyVwrfyw+ItBidzKHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EG6ixbZaPZQWDDQf7s5VQDTBvdVGHIuPX7Ed29/0Dn8=;
	b=WHreJ1Uxl0AEUln95CGWKmk8N4MOQKIMRzbjGZgZ8nsUHFL29sSYnFz5TeHUaDxR7T13
	 TEozizrEErMLFz3rUrYdHYrO0y4tqsFI8VQ81fTAmYKqvSmifMURbPOiRiYhjNLAM6DFt
	 KbI93LCC4sutaNGg9QDAq1EuXf3DSCW4JT62JmbKBZjKKpbYkAVeAnV7losWP6MXwrwY8
	 yW1WZm3tmUl+Y5E4+Kj1gBgQ6iSJYjLNGX8GB2+99H4tXOHfTTVxT3G8Z+2reKEwjbmkv
	 1a4SlMPuhZo/tz4dh4wDwmKFirPPdFeKu6jbH53YT+PZ44VMr5uKFAhlwzWH4wtYMgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5HKgsMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B7D606B5E2;
	Wed, 18 Nov 2026 17:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5HKgsMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A631F000C4;
	Wed, 18 Nov 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022796;
	bh=EG6ixbZaPZQWDDQf7s5VQDTBvdVGHIuPX7Ed29/0Dn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5HKgsMSpX+w34iANdN769/57kZ6Af5pg/4KZDgzQ0BwbEkwCdwCIWJcFtYb7/u4G
	 dizS0pYNSthrIxNEi77pLu/VfyC+3A8aCvf3Yf25iqTttA2ST/zjIygTnahe6nO9JT
	 tUns4wOrLsPXb5yRU1qjyjndreY2ApL0lwuyback=
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
Subject: [PATCH 6.18 0100/2151] mm/rmap: handle device-exclusive entries in folio_referenced_one()
Date: Wed, 18 Nov 2026 15:30:35 +0100
Message-ID: <20261118150125.444549753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: adapted batched PTE handling to the existing single-PTE APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/rmap.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 03d7d666cc578..14b5d9f2093fd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -858,6 +858,7 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	pte_t pteval;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
@@ -901,12 +902,25 @@ static bool folio_referenced_one(struct folio *folio,
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
+							      address + PAGE_SIZE);
+			if (young)
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
-- 
2.53.0



