Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831198;
	b=Ias3gS9/WVnjzzd/vTJJU0B8LYvDx4fFrEJNYI7zW0xcBgD5z6kX7x+h3hVhn1D5DseY
	 A6OGPQH4/mlSWAWoTZXOka/i1p/h70ZTZupoSq9UQ54BviMi50Mj2bKqWnlNDyALZykfU
	 LvZFe/2lHJh0gCKFiCXlYuTBSKQRZIStR14sI/tbUwXRLnYEqa5g4Y6IwGfFkbBOUIRL5
	 R+s01DdG80+WiwrCX3b233YFsqfKMy9Imq3Af7CcLQ/tgKeRHtI0TIeJWScdZtgWW2tnw
	 DxAoTtn+l9yM6h2C9EdSb0otyfrgO8u53/J7/ZemyzmTuvLmZiCGmjy9dIdam5XxJMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=geMaccEvDtH0RrQnUFUnyufBn8vVHi4j3w6F9DCHrFg=;
	b=r54u26l4YhYtRkxHQ8nzGrqZdzvQ6O48gJkbs7YlZkpap2wkGkODTsuP/SEPTQXy33gm
	 XyBWUi/uXstn3JO61PNqWLPhL597EI5I6R6IWSkDsiJDQP2FZoDUju6IJ00d+u+alOqEZ
	 Pr9mhfTvnMq/rxiiljOWPeDNpKT4jzhYLtnC4j96Rf3/CD1+7s79056HmfjvgrxCuwZlT
	 kA3gKh0NRvTXT/2vjaDD5tHycb/fMTU9LqZi/gJhPUlOkds4tWwogbhdBsRVtk3sX3HKY
	 k1R89Y+EY95eVmZAXYkm/6/zT/180I0kZ1+5d7hMma/yVXtdJ9Qd21jCRSTsw1PJYPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVP7JitK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21643606A337;
	Wed,  4 Nov 2026 22:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVP7JitK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF861F00919;
	Wed,  4 Nov 2026 22:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831197;
	bh=geMaccEvDtH0RrQnUFUnyufBn8vVHi4j3w6F9DCHrFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVP7JitKW1l2ob6HT64bIKzKJ8PbaupCstmdLU67NbOnS724oCb5FjhvVP5y3r8cc
	 TxVB27ERgn2ZH/2ThPEOw2dwoANmDduPRw7d6xEQXqS/LoGh2/ijWzOjgNh3n1syqy
	 exo7TpF0wsQcaei3BJ0DBRtRdUK0RVs7GnDq0FoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arvind Yadav <arvind.yadav@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0559/1005] mm/migrate_device: clear stale mapping after freeing swapcache
Date: Wed,  4 Nov 2026 16:04:52 -0500
Message-ID: <20261104211059.552702511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit 34a00895d032a414830d41106a09329ae6c251b6 ]

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap().  When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it use the
mapped-folio path for a folio that is no longer in swapcache.  It can then
operate on swap_space.i_pages with invalid reference accounting,
eventually triggering a folio reference count BUG.

After a successful split, nr still contains the number of pages in the
original large folio, although each resulting page is now a separate
order-0 folio.  Reset nr to 1 so each split folio is processed separately,
including its own swapcache removal and mapping lookup.

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

Link: https://lore.kernel.org/20260728062832.1107127-1-arvind.yadav@intel.com
Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Dropped the THP-only nr = 1 reset hunk and kept only the mapping = folio_mapping(folio) refresh after folio_free_swap(), since the split path doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4abceeae55ab0..6ae954ec01108 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -765,6 +765,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 					continue;
 				}
+
+				/*
+				 * folio_free_swap() removed the folio from the swap
+				 * cache. Refresh the saved mapping before migration.
+				 */
+				mapping = folio_mapping(folio);
 			}
 		} else if (folio_is_zone_device(newfolio)) {
 			/*
-- 
2.53.0



