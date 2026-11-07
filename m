Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064513;
	b=bSQ9CBa/EiWyW9+ZgDF0RKIMeHxv5no7jxXVL/8PDIQMAjhaJJRJ0f2RwyNooSNtOVU/
	 jasooNJ/SxtWkZl/tEiVtRBT8GOe9jjpQsLgemqaizFh7YNM+DeA1GoKzaUaCMHOsLUAB
	 +Wbes/zhsOmO2s8hK9F+vZ5IJx3YzznP4US6N1pWsqOvMnGI3N2kcm4Bn98OtFITWjKQr
	 M4u8wk/Wewc+ltp7E6D6zxhkYYuuqyCHyKQ0/+MUU+xQo4ww/V+8ZkZTVH1xfeXqQghhT
	 KDsbRhUqVKSRW+EuDcp3CdcmZcEeoV2s5Yk/XU8fPdP3B27HRG4e7jRsj393xEw9ZzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k+LHp4CAjoiwzYMPjZ898SFcwaaoqCMV95GIAXKFLpY=;
	b=LYP5/sB212uex2BhJTxJVhCrr1JDLZSP1nEgOGIJ0Vkp6cmXB677spddDZTO9c9DBhe7
	 Wl//QnWkLA3edgcpWhA1JAyulfQYZ7cAepltSWJaVVKhkXjbW17iHYXQTXxWS9PJtyi6L
	 Gus4BAhlJfBFxpHOwywFPRPkaeynolrAGREOsyctBziNN1WfjVR80HV4o7eqAp6iAM1jT
	 NviiLsxFAQny0vWS0celPDFSxsJryXIk6772R423JU0xxa2HU+cLmXUufhZot/OUMXmG0
	 kVwGf2Ehjk/T+d1MZIN4kSaTfLxvQynYavGvI9XiiP7gyIEJYGuwF/Ip4qLU1DZhu+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d+kbV/nH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1676606B891;
	Sat,  7 Nov 2026 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+kbV/nH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A37C1F0089F;
	Sat,  7 Nov 2026 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064512;
	bh=k+LHp4CAjoiwzYMPjZ898SFcwaaoqCMV95GIAXKFLpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+kbV/nHnnZzuset2694nTQvqBqDcJMotqcMJINJlQI5UagWll7fGHxfEb8Y60iDB
	 aMHyl45IpuD5vu++dwdZ5OJbmfG6Cbh2YVm9whHsgVk3r8BSYW4XwMYXrq77WBPKDd
	 XM9KgDIfkbNY9PGduHT8FNAfrPjSKj9jkCXHmbiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0506/1257] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sat,  7 Nov 2026 08:46:42 -0500
Message-ID: <20261107134953.406034699@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 1613ac9edf385c35f171a25610e2706a7e6afad6 ]

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2ab7b3842701e..9ddd1ec8202b7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -264,7 +264,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -302,7 +302,7 @@ static inline unsigned long damon_pa_de_activate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
@@ -350,7 +350,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
-- 
2.53.0



