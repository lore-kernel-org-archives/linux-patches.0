Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064910;
	b=EyIe0vMTFjzk2eD3+UqFc1tNjn5umUewiiEgSb4cccN6WjMKnZFktemHAqg+NUGs5HGU
	 Ff9fHGCULm4DisJK/V0vy0dXo4csJKYL5OE7dNQVi5+OeiauhGXTEFdcXLX5cFaDYFGO0
	 On0KxMaKu7oqpHyERzFPM3WFh5jEVe9mWNxiS+mjSV84tRPN84Wv1vYeKLdO5NmgAyaJv
	 y+IiAcFKhYjC4e1k9VfPcj4V7XdJlLsnvsMCVU/nId1J03VLIIvekUivn6J74wv6g4D2R
	 Xf8RXzNXGUf9N5OUgcA0+Ay9AM4r5oeqlk+yFXfuOzpXSYoYga0X119PPemKIRHUYnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ygvwXRl1h+Q0gh5KUKxStNzw4XVc+smOlKMlXoatgbs=;
	b=or6BhqM8niiYBpgVUsnGMbKCtCThp5kij/EGWzgSN7/xydNRr1kE+EpAktOe+zQXUCwK
	 hp8S6fEkQVIln4u8SKtdvmiTnMRQPRn3KPgls74mZCOjoM8lm0Z/SBnGMp9n+iNeTg4++
	 vMYe1zaT4ST0w0sy9Ot08fGxgv58VyPoy1KLzM+09jv5i9qBf+mxr5Nc1vZRTonJQBr3x
	 tVIUV1so+b/2cdB4Zxt6MRnazksWVHV4Ft6PJcjShhzAQPKRbb0E99hD+228COPYIpE0X
	 GRCLxShyHxFfXGaNn3Bjy9rfUui+OxCxPeN3be5Q3QJ3n/TlKdnirukFVrarBMhYhGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bVGHhcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B1606A9F0;
	Sat,  7 Nov 2026 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bVGHhcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DB91F0089F;
	Sat,  7 Nov 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064910;
	bh=ygvwXRl1h+Q0gh5KUKxStNzw4XVc+smOlKMlXoatgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bVGHhcLTL/r6uA28Bagb9/Bb3GaUMSoNQYwfn29Vm0e0v8SxW3vK9FSJh9FS14Lm
	 WI9I9JhljMDE/dnsEN/godKzeNLVqkQtjOegVTq4qyvIRIKUX0St73KGZUmZAXYNWA
	 qkrTGypDY5l7OjHrIQ+ISr+JWnkhhhB9kq1MMAs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0811/1257] iommupt: Do not allow PTEs to be split when dirty logging
Date: Sat,  7 Nov 2026 08:51:47 -0500
Message-ID: <20261107135001.742105428@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 04bcf84613346b973a8cc0c59238b6b5bc902688 ]

If a single PTE cannot be stored in the current bitmap that should be a
failure and reported back to userspace. Allowing a PTE to be split creates
a possibility that dirty memory will be reported as clean.

The gather must also cover the entire PTE that is being cleaned, not just
the part that fits within the bitmap.

Fix both issues by computing the full IOVA range of every PTE and using
that to update the bitmap and the gather. The bitmap code now rejects
ranges that don't fit in it, and the gather always combined ranges.

The selftest quietly relied on a bug where the CONT was split, that is why
the half page size for the mock domain saw alternating dirties. Increase
the dirty test page size to PAGE_SIZE so it still works as intended.

Cc: stable@vger.kernel.org
Fixes: 4a00f9434891 ("iommupt: Add read_and_clear_dirty op")
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/all/20261013165814.309255
Link: https://patch.msgid.link/r/0-v1-5bb926ff73ec+576-iommufd_dirty_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/generic_pt/iommu_pt.h     | 30 +++++++------------------
 tools/testing/selftests/iommu/iommufd.c | 10 ++++-----
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 07ec2b3ab986a..837d835e4fad8 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -240,27 +240,14 @@ struct pt_iommu_dirty_args {
 };
 
 static void record_dirty(struct pt_state *pts,
-			 struct pt_iommu_dirty_args *dirty,
-			 unsigned int num_contig_lg2)
+			 struct pt_iommu_dirty_args *dirty)
 {
-	pt_vaddr_t dirty_len;
-
-	if (num_contig_lg2 != ilog2(1)) {
-		unsigned int index = pts->index;
-		unsigned int end_index = log2_set_mod_max_t(
-			unsigned int, pts->index, num_contig_lg2);
-
-		/* Adjust for being contained inside a contiguous page */
-		end_index = min(end_index, pts->end_index);
-		dirty_len = (end_index - index) *
-				log2_to_int(pt_table_item_lg2sz(pts));
-	} else {
-		dirty_len = log2_to_int(pt_table_item_lg2sz(pts));
-	}
+	unsigned int lg2sz = pt_entry_oa_lg2sz(pts);
+	pt_vaddr_t start_va = log2_set_mod(pts->range->va, 0, lg2sz);
+	pt_vaddr_t dirty_len = log2_to_int(lg2sz);
 
 	if (dirty->dirty->bitmap)
-		iova_bitmap_set(dirty->dirty->bitmap, pts->range->va,
-				dirty_len);
+		iova_bitmap_set(dirty->dirty->bitmap, start_va, dirty_len);
 
 	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
 		/*
@@ -268,8 +255,8 @@ static void record_dirty(struct pt_state *pts,
 		 * dirty tracking bits can't work together
 		 */
 		pt_entry_make_write_clean(pts);
-		iommu_iotlb_gather_add_range(dirty->dirty->gather,
-					     pts->range->va, dirty_len);
+		iommu_iotlb_gather_add_range(dirty->dirty->gather, start_va,
+					     dirty_len);
 	}
 }
 
@@ -289,8 +276,7 @@ static inline int __read_and_clear_dirty(struct pt_range *range, void *arg,
 			continue;
 		}
 		if (pts.type == PT_ENTRY_OA && pt_entry_is_write_dirty(&pts))
-			record_dirty(&pts, dirty,
-				     pt_entry_num_contig_lg2(&pts));
+			record_dirty(&pts, dirty);
 	}
 	return 0;
 }
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index d44b34b05757e..22af28aef13b4 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2175,9 +2175,9 @@ FIXTURE_SETUP(iommufd_dirty_tracking)
 	test_ioctl_ioas_alloc(&self->ioas_id);
 
 	/*
-	 * For dirty testing it is important that the page size fed into
-	 * the iommu page tables matches the size the dirty logic
-	 * expects, or set_dirty can touch too much stuff.
+	 * Disabling huge pages maps in PAGE_SIZE units, which can span
+	 * multiple contiguous MOCK_PAGE_SIZE entries. The dirty tests must
+	 * expect the entire mapping to be reported dirty.
 	 */
 	cmd.object_id = self->ioas_id;
 	if (!variant->hugepages)
@@ -2335,7 +2335,7 @@ TEST_F(iommufd_dirty_tracking, device_dirty_capability)
 
 TEST_F(iommufd_dirty_tracking, get_dirty_bitmap)
 {
-	uint32_t page_size = MOCK_PAGE_SIZE;
+	uint32_t page_size = PAGE_SIZE;
 	uint32_t ioas_id = self->ioas_id;
 	uint32_t hwpt_id;
 
@@ -2377,7 +2377,7 @@ TEST_F(iommufd_dirty_tracking, get_dirty_bitmap)
 
 TEST_F(iommufd_dirty_tracking, get_dirty_bitmap_no_clear)
 {
-	uint32_t page_size = MOCK_PAGE_SIZE;
+	uint32_t page_size = PAGE_SIZE;
 	uint32_t ioas_id = self->ioas_id;
 	uint32_t hwpt_id;
 
-- 
2.53.0



