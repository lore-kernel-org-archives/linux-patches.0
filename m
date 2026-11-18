Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034923;
	b=JTsKUXmiP6gmIT/Nop1zQ3p95E0KSQwQp1IrJij8TJ96gsml6O55TCyh5bbCJgWnvXOf
	 YtWsGHb2LoK9fckOirOf4K2Q0KWsrMr8GrrEasKMYdmdDjgcgYgbWCBw8v/9n3HN6hZum
	 Pb4vuQUl6ZvxWl0WJm1lsulkOuZ2oULbixnQwGCeaZf/A5lKZojjN/qwxzA4sgfV56WDf
	 KgXNrLOULC88E5Abt48VHAYe9y8V7sCSIsCF2ohh8HZHQzNuAMOYSJYqUP+S62ohuzUCk
	 Fh+A+GTewyIHYwCQRl5mnS/rdZBPBkOUYp4/X469PnJNJc2xSVLx4pD6E1ahWdNVLKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MFDByEdy464XeMBvrRLWKee9WgjSmMTsl1KYzn2pf5I=;
	b=CbEPE4U7It1BeaWQzIW2/LvFmH93MEGgqvMxYDABpcBm9Q+fJMT3wG1ECFl2by0WNsJ1
	 XJ5WVNXqct++/HbNC1DC2OB9MKalV6ih6v5kSfgDuyCyWfeE1BOWNU96krYTpwKz2hcOo
	 +nebJsxcQhsJPtLmlj214q/079A4Ok6dVfO2kOa2UcEy+OFomYudSyKz/OXBMtDaFMsFS
	 DodnBn9okYUwvEhX+//BmyrDc563y3GB4dWV9y26DOW8a4qbG/gQuUfp1X7G0ZExdD54h
	 a3wLFsDWb0hfmEpS48HVwG4ZeOApMp1AhzRsjX6BAE2J3Oc2imX6r4nBSIc3j5J4Hog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0omfopjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCAC606A31C;
	Wed, 18 Nov 2026 20:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0omfopjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75DA1F000C4;
	Wed, 18 Nov 2026 20:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034923;
	bh=MFDByEdy464XeMBvrRLWKee9WgjSmMTsl1KYzn2pf5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0omfopjotdmO15Mxc7//amg3bETE+/HPfpRtrsxynF9MwYgMSyn2pnHdMljEB1+yn
	 1HJk94H6LbfZyftRv5S7l57dab+/hA9oJ4s3y392txcNMu4/SNrwR2PeCMp9UgG3z/
	 cuv+RkcJK1jHD09lFA+fToc1yzwQconNzaG8/eaQ=
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
Subject: [PATCH 6.6 0492/3318] mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Wed, 18 Nov 2026 15:18:34 +0100
Message-ID: <20261118150331.763033447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the missing hstate_is_gigantic_no_runtime() helper with the open-coded hstate_is_gigantic(h) && !gigantic_page_runtime_supported() check, and adjusted context for the older function name and missing local. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8bfaaa84bb3f7..bd5fceaea788e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2298,6 +2298,16 @@ int dissolve_free_huge_page(struct page *page)
 
 	if (!folio_ref_count(folio)) {
 		struct hstate *h = folio_hstate(folio);
+
+		/*
+		 * remove_hugetlb_folio()/update_and_free_hugetlb_folio() bail
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_folio() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 
-- 
2.53.0



