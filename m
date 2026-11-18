Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044086;
	b=PdPMh3mdsjOcRPfEo3JDbpBcD4uGNf0Uyse3T5STzgz0Nboxz0Dnn4ZdR2kXgox/mMTo
	 hrWM4Mp7IpFEuUHKS55R+G1/hjrDfQCx2a30SHiZoGDqaEQtl9bmaCuK7DGomV52/cM1i
	 1T9boXyUTpnJhVlo9fNzXFTZns+O18A2Zi5TppqZfprVnKSw6gzL7u/3b3RmtimBdepsT
	 sUWiX97Sw6QW8WhNd5FpVkuRvnS3i+SI0erf8dgeulUrn6sqdTy0ItcBIH8RGx6NQt8uf
	 r1TxbMm/4DSZicfyoeXpA4EEwqbz8g8/8/J4NNlp3UCpq7TmNtWGwZt5NbLgrkTBBjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/nDJ+xpYxnjNiDxhL0NdUTv6iuHARdt4lqwv5Kr+NiQ=;
	b=JURqAK6AIjNFISFC27W4pxWb+laoqzyOoD3gP7CDF2SZZQO8lAwXaFyh2hgv7i8/mWwp
	 XkNwb0/5k9B6Xqxvc1835U9b3rfbY5MuY4tt1RaYcaFK/lrm+XtCbmP5js3YmSLSJXhBC
	 fxPTNs+/BRnmAjkV4G0cMDua0jsFHPWvNyr0dKmgsPp6XH8oePl91xJyGunDmUx1kGrk9
	 hBX+q36VuknT/MkK4/dQXh7YrC+6EDI2Pd+mKpX4sfE7j2fRj2JWoJU4OjKg03YzFhUj/
	 dAQmQMA93oN0+o2/vz4+sNl0eYc1qdDMdNBCIQKsAPghRt6YK64ZoUW63njVNlkQe2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdDBVVOh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688FB606A31C;
	Wed, 18 Nov 2026 23:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UdDBVVOh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39DD1F000C4;
	Wed, 18 Nov 2026 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044086;
	bh=/nDJ+xpYxnjNiDxhL0NdUTv6iuHARdt4lqwv5Kr+NiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdDBVVOhQXPVAQVEV6KoHl+jkWhbj6IQp+IkvXHEwhigxCvk5PWFHiYDfAKBlswHi
	 fRaFyFSqF4yDKopxCoUrrOa9ZM9H5RcXoM5OpoXS4fSHRs6htF2uAi0DECq2TqFyzu
	 LmiU8a/YX7qXeeKGkysAvJgSpOeKbiMfsQPss7bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0441/2857] mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Wed, 18 Nov 2026 15:24:35 +0100
Message-ID: <20261118150217.250851727@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit a363c62a653cc8b3e21da9545fa4e028ef50f9c3 ]

dissolve_free_hugetlb_folio() doesn't check
hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
update_and_free_hugetlb_folio() silently bail for such folios, so it frees
a still-listed folio and, on vmemmap restore failure, the
add_hugetlb_folio() rollback corrupts the free list.

Link: https://lore.kernel.org/20260823044118.1097121-2-xialonglong2025@163.com
Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Codex:gpt-5.6-sol
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
[ sashal: Guard applied in dissolve_free_huge_page() using the page/head API, with the inline gigantic-without-runtime-support condition replacing the missing helper and the comment using the older function names. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f549adc0b6705..fc26639f87dc5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2352,6 +2352,16 @@ int dissolve_free_huge_page(struct page *page)
 	if (!page_count(page)) {
 		struct page *head = compound_head(page);
 		struct hstate *h = page_hstate(head);
+
+		/*
+		 * remove_hugetlb_page()/update_and_free_page() bail
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_page() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 
-- 
2.53.0



