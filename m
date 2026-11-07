Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064183;
	b=vjCxBNnGYBDXl5ExiUM41PZuVH0HDPJXoPeDAdismFuMvnQf61AHGRKJh462JITxFQUy
	 rRAxLluM6BdzYqUmtyWoMloVLrEmwN7LU/+bPf/aw/B+Thv1mOJw5LD+QDMEPRQGRh+e1
	 7LqgghqpJfxt4yqEqds1z0M7ibWWds148MMHP7hEApX6BgPzNLWpGnhKcZAZmZOOUO2vI
	 EtwNa9zBjiX4OEtO1yhv6+a040dOxZ+zcSWckXwxh8nuw6vtFUkLWif2zAGtXb3cIa8Gm
	 fWQEffjj6xHE05tWf5aTFC/+dsVlfTs7ZBLALErFUfjp7Ns6skHev0XCRhHz7pp0D1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SrFEOm3nHrXbVgCnxWuXKbhNokPwqAZ+T2nJ9ewAAAU=;
	b=1cFPwG2eW/LHeRQc/4PkAgZWvOrn4nXAH7ya1XnBzAtVD3rIdsddegcCvxvd12jGK8mS
	 kdfpMAho6eCM7ms4xEFdC5Br2hPeiq3Aqq0IaSH3JBqfQOn9JMqMzY+PMwt7ecrx50ymc
	 but0n/PFKQbT3rkheuxW5RzoZFratDIEmeCia3c2h41co7efclq9vU8jdjpUf3z1z06cc
	 +FKLOAtP6kegSDfl6dONIAaT+8jL2YqR1YBw+OxjG9Nuy6Quiv3oibK/VvdYx8f5KTpAq
	 0EOpGjMrVpFEqdGPzUZTloXzNrQWzjPvQUVUlqx38lOqhHarWgM2rVuONKKM1VAW4eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqaTIX89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9206606D809;
	Sat,  7 Nov 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqaTIX89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654A1F0089F;
	Sat,  7 Nov 2026 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064182;
	bh=SrFEOm3nHrXbVgCnxWuXKbhNokPwqAZ+T2nJ9ewAAAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqaTIX89s3gmRiuhCIBi5bFeXLNO56SXIWpTcrqBuGrdkneuFh/FzPRJpDioSEPHq
	 h/OpK4EVNQRckoS0pXsmr6dPBzuW7EP6VHZn03IYPOci7zkJdcgkvgvyUwXViw9KkQ
	 J3RlC970O5ABFMuBZWly2g/xkW09uRXLTBM6ZbUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0325/1257] iommu/vt-d: Avoid out-of-range shift in qi_desc_dev_iotlb_pasid()
Date: Sat,  7 Nov 2026 08:43:41 -0500
Message-ID: <20261107134948.399577441@linuxfoundation.org>
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
index 23dbe6c24439f..5b3d234ae2659 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1105,12 +1105,20 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
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
@@ -1120,7 +1128,8 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
 	 * Max Invs Pending (MIP) is set to 0 for now until we have DIT in
 	 * ECAP.
 	 */
-	if (!IS_ALIGNED(addr, VTD_PAGE_SIZE << size_order))
+	if (size_order < 64 - VTD_PAGE_SHIFT &&
+	    !IS_ALIGNED(addr, BIT_ULL(VTD_PAGE_SHIFT + size_order)))
 		pr_warn_ratelimited("Invalidate non-aligned address %llx, order %d\n",
 				    addr, size_order);
 
@@ -1136,7 +1145,7 @@ static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
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



