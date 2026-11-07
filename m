Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063013;
	b=you/7DXhIg7Jl+wLRi0sxtTFMzVYSmUifOy2JqYfKotQXhgssSpnA0d8hsvv9vZgxYcz
	 eC9f0jc99sqB2apc53NPc8GgJplGz1ttw5naTSh0OftRyRKLBvT1AJE2w/rUnVdaRRpZC
	 X1KXbnODUCAOQco+no0sUDmu1G1jfzfjQLp19A5Q4X8nRlBqEXSoq36S5y8Miy92krA1s
	 fLI1GOkjF8nCzyB0lED303THXswJI0jkvwD3RhDFIVrAt2gjogkxVcUqSOLoq5Xg3dcms
	 fXAmhTnI3S5uXhuFu3/2NYc45gucxl6Lp3/uvdvsUdeB6RJEdN8M1W/KiQ+Oi1U7VXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8qatMfzpB0FjSpYdStFKE23H4ucO3uoPPnxWsA0Ly8=;
	b=EFiF+kEumnmgb9brOxVxyJooghoVP8pzurOzGXHv0FyquwoLjgziW2ADnp1VEEdjyUq8
	 l4+VkT14OGRdWlXiuJjxKwg950slHyCC8Vpm4VcMkUvfVETWlQ+sL/+n9Wn0EgW2txV3O
	 wu+C/7Fh9GUWLO8v+jHj4M+0wsjPPwd0OcN1er35cKP0Y6DiKmzzBwgf3vQEjZs2d1FSX
	 Ruu8bFpDgUlOLIFMfwv4QuANYNoJo4EpA7vhWAu1b+Heib39YCb/DyzcaNlyNP401PqCZ
	 IgJmnM73e+fuzFXbC9Uz7FJgwpAW+ovBeNChhQNek1ySKrnYTysDgxDSZSqEZViQU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdqweuiq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE9606D80D;
	Sat,  7 Nov 2026 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kdqweuiq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEA61F0089F;
	Sat,  7 Nov 2026 14:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063013;
	bh=N8qatMfzpB0FjSpYdStFKE23H4ucO3uoPPnxWsA0Ly8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdqweuiqI5NFgbdlL/S375udT+OvU15ZAaZbIKCjrN5M0Sm5XJK2ucDSJ5qqF1Csd
	 dHng4LZEK/ZsX+OFfco4EYtWUqi2sPRawP9RwYnN8NVF8FNzlr7AvxcyleHiISJUX4
	 0NV+4eEVrtCHwy9W0oCRsZ6T9hN5jirGnBm+QZIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/869] iommu/vt-d: Avoid out-of-range shift in qi_desc_dev_iotlb_pasid()
Date: Sat,  7 Nov 2026 08:49:06 -0500
Message-ID: <20261107134900.681113438@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit ddea230c9fc28d1f2090ceeab3d66ce2bea658e9 ]

Callers request a full Device-TLB flush by passing MAX_AGAW_PFN_WIDTH
(64 - VTD_PAGE_SHIFT == 52) as @size_order.  Two expressions in
qi_desc_dev_iotlb_pasid() are not prepared for a value that large:

  unsigned long mask = 1UL << (VTD_PAGE_SHIFT + size_order - 1);
  ...
  if (!IS_ALIGNED(addr, VTD_PAGE_SIZE << size_order))

The second evaluates to 1UL << 64, which is undefined on all
architectures.  On x86_64 the shift count masks to zero, IS_ALIGNED(addr,
1) is trivially true, and the alignment sanity check silently degrades
into a no-op.

The first evaluates to 1UL << 63.  That is well defined on 64-bit builds,
where unsigned long is 64 bits wide, but is undefined on 32-bit ones.  In
practice x86 masks the shift count to five bits, so the expression yields
1UL << 31 and ~mask becomes 0x7fffffff.  That value is zero-extended when
applied to the 64-bit descriptor, so

  desc->qw1 &= ~mask;

clears qw1[63:32] as well as bit 31, collapsing the ADDR field that had
just been filled with ones.  Reaching that requires a scalable-mode PASID
configuration on 32-bit x86, which is not a realistic deployment, but the
construct is wrong regardless.

Compute the mask with BIT_ULL() so that it is 64-bit on every
architecture, and skip the alignment check for a full flush, where it is
both meaningless and the source of the out-of-range shift.

Note that @size_order must not be clamped below 64 - VTD_PAGE_SHIFT.  With
S set, hardware derives the invalidation range from the least significant
zero bit N of ADDR and matches bits [63:N+1] of the incoming address.  For
size_order 52 the descriptor sets ADDR[63:12] and clears bit 63, making
N = 63 and the comparison range empty, so everything is invalidated.
Reducing @size_order to 51 would instead leave N = 62 and cause hardware
to compare address bit 63; since callers pass an address of 0, only the
lower half of the address space would be invalidated.  Bound @size_order
at 64 - VTD_PAGE_SHIFT so that a bogus caller cannot reintroduce an
out-of-range shift, without altering the full-flush encoding.

The non-PASID variant qi_desc_dev_iotlb() already uses 1ULL and is
unaffected.

Fixes: f701c9f36bcb7 ("iommu/vt-d: Factor out invalidation descriptor composition")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260623060122.3796325-1-guanghuifeng%40linux.alibaba.com
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.h | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index e696e019e9697..33c9e06df63f9 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1183,12 +1183,20 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
 					   unsigned int size_order,
 					   struct qi_desc *desc)
 {
-	unsigned long mask = 1UL << (VTD_PAGE_SHIFT + size_order - 1);
-
 	desc->qw0 = QI_DEV_EIOTLB_PASID(pasid) | QI_DEV_EIOTLB_SID(sid) |
 		QI_DEV_EIOTLB_QDEP(qdep) | QI_DEIOTLB_TYPE |
 		QI_DEV_IOTLB_PFSID(pfsid);
 
+	/*
+	 * The widest range the descriptor can express is a full flush, encoded
+	 * by making bit 63 the least significant zero bit of ADDR, that is
+	 * @size_order == 64 - VTD_PAGE_SHIFT.  Bound @size_order there so that
+	 * a caller passing something larger cannot produce an out-of-range
+	 * shift below.
+	 */
+	if (size_order > 64 - VTD_PAGE_SHIFT)
+		size_order = 64 - VTD_PAGE_SHIFT;
+
 	/*
 	 * If S bit is 0, we only flush a single page. If S bit is set,
 	 * The least significant zero bit indicates the invalidation address
@@ -1198,7 +1206,8 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
 	 * Max Invs Pending (MIP) is set to 0 for now until we have DIT in
 	 * ECAP.
 	 */
-	if (!IS_ALIGNED(addr, VTD_PAGE_SIZE << size_order))
+	if (size_order < 64 - VTD_PAGE_SHIFT &&
+	    !IS_ALIGNED(addr, BIT_ULL(VTD_PAGE_SHIFT + size_order)))
 		pr_warn_ratelimited("Invalidate non-aligned address %llx, order %d\n",
 				    addr, size_order);
 
@@ -1214,7 +1223,7 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
 		desc->qw1 |= GENMASK_ULL(size_order + VTD_PAGE_SHIFT - 1,
 					VTD_PAGE_SHIFT);
 		/* Clear size_order bit to indicate size */
-		desc->qw1 &= ~mask;
+		desc->qw1 &= ~BIT_ULL(VTD_PAGE_SHIFT + size_order - 1);
 		/* Set the S bit to indicate flushing more than 1 page */
 		desc->qw1 |= QI_DEV_EIOTLB_SIZE;
 	}
-- 
2.53.0



