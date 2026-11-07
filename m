Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064458;
	b=y/1MKJtGLEBOpdl/dOD6+RFxKJxhDw67AXHQNuNVcmUf8SLuaZAgdaW/QEudgUFIFDqv
	 k5s6d70HfDCYM3kfVAqZT1X8/T+6cINguB677Yd7A+LppYVPStg1+nqwBcHegvdBd01Q2
	 3c6uohuAMzLyGYrZoXYihCozt4rZK+wGbWOxshlkRCAWhw6JJMhU+d7zZOxq7zIYpcr4L
	 2+VYw+Ohr12IqQjP3nl8KP/0oEBHmDEK+RNrpgnm9iLOSiRl5F8JEBwEVTQahajzl+2xt
	 +kDHkymmziJunkTmg9Po/X6f5B8P2McnLFDkktdHrcX8l+IScvq6OD/bPY46Kl7ed/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rc5luCszvGzsVSNBzMLasHxVhVRRZyIwc4Y+R1RFkbM=;
	b=0See/fbTub/Bz8UmYf+IxlghMcuq/Z8FxY3kjPnFQsaOYKXaEpNJ396tO0ABRrnWQiLU
	 U4bECtmSF74e564HNwKVCtjerWor85Fbyfocf2ZbwDmCBbt/hf5LMiPOyRBU8qRhtLoRD
	 /5DGYercc6YMtMEhTnTDsrEByqx1Q3hQQGdvbDVg0d0TuuQjir06ZfCO3OYliT/Bx/r6b
	 xb0ELnZHUARIzmJD8xSStkcPv44vuiw+kVcuksaFEDE5isZdC4XWJmpODysgDnwHyONGu
	 OrS1IF26uvLBpZFVOjUIcBQYcTf5iPn6jjXxayJp6YRH+khffhzzsRvfovQGt3sLHrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IT8ZxUny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CFE606A9E9;
	Sat,  7 Nov 2026 15:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IT8ZxUny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1681F008A4;
	Sat,  7 Nov 2026 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064457;
	bh=rc5luCszvGzsVSNBzMLasHxVhVRRZyIwc4Y+R1RFkbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IT8ZxUnynIkl6wwNrdnJO/jTrmwlrlz3tjhV0rkJ1yBp/m+s0C9UdZaI8VHVbL36i
	 qcCM1fxyssh3D8FVawOEV301obiKdh/E1RJYUP8aTXJiVyZzrlaxww06L8Ay9hSU75
	 1NKrQ1xztwA0Z+m9dC/IxMiQEzmxqG5EDRhvFOYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Byungchul Park <byungchul@sk.com>,
	Dev Jain <dev.jain@arm.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0499/1257] mm/madvise: skip zone device folios in cold/pageout PMD range
Date: Sat,  7 Nov 2026 08:46:35 -0500
Message-ID: <20261107134953.214138770@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit ab7ace574f3da7f167fe1883116480a00c52150c ]

madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD via
pmd_folio() and ages or reclaims it without checking for zone device
memory.

The surrounding guards do not cover every zone device case:

  - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
    (so device DAX is filtered)

  - !pmd_present() branch above rejects device-private and
    migration entries, which are non-present.

  - A present zone device PMD - e.g. a device-coherent THP - is
    not filtered by any of these, nor by pmd_folio() (unlike
    vm_normal_page_pmd(), it performs no special/pfnmap check),
    and would be aged or paged out here.

Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.

Link: https://lore.kernel.org/20260817220810.1175596-3-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f4..73c2901b9adbf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -404,6 +404,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_zone_device(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
-- 
2.53.0



