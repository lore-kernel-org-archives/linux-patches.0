Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEBE4BC012;
	Sat, 28 Feb 2026 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301345; cv=none; b=FspYlZSQJT0KPIi6/S5FsPzsYicVfst7Ux1YB2Hoo6ea9HF4zh9XdyuVXr3BYlpOf85WDkmSgxWQXkMpEc4YsNZPqPvCyN6A8P1gsa08yBlHUJXQZ50arYg+Pc+8W26k90nLtjK0JQZEuLNtW6tDwYn3tehwyyeQM4/h6VIhff8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301345; c=relaxed/simple;
	bh=R70Y94bxuJC+tdy1f6T+8F3LOPZ3fkpgjtythSXEU8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM6JKGZ/aGmklx+pfSbwfloehOAjZ56bdS1x7xuwRtTBkgqEN14nnSNbz8PcSTyO0INXlzHMjKvkV0n3JignfKa+8SmdffgCh24qRYzzzd3o4Wbu+YMKS+1GYwoE3RvLG9Cx/jmUnPCl4kshkccWDUZtnvAQvMhde2dAwJMtRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4PYrqUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4PYrqUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25CAC19425;
	Sat, 28 Feb 2026 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301345;
	bh=R70Y94bxuJC+tdy1f6T+8F3LOPZ3fkpgjtythSXEU8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4PYrqUKwagBO3yQhjh/VxXN9z9zRMz9T+yIlOQwhZWkm+hBCYxwO1Rxd6+PrNziU
	 tP4L/01o7Ig0zWYJOvPrOdkA29tp5jX0voCRFrrnxblQZEihtp02EGZvcQTM9nKA0Q
	 a0mPySJaD2Nrmagpaqrgr0VurI5L/1max9Kc15LWJ+/7ZG0uLRIz5plo97N9lQXIDe
	 HKyZhYXA4tV0bO/0Ip8J2fibtx3ji19wjfq/q2zEHqKAxd5ejnaE3/7RwrtTg3FaVG
	 gacGi/z4zVeuTzmtgqNDNJumLrBYuOP1PxZ+qoDvVdP1Ua9J2Crzd69RGXp+LyLfoP
	 Pd91fLUbv5mVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bingbu Cao <bingbu.cao@intel.com>,
	stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 532/752] media: ipu6: Fix typo and wrong constant in ipu6-mmu.c
Date: Sat, 28 Feb 2026 12:44:03 -0500
Message-ID: <20260228174750.1542406-532-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 3e0fcc91277d5af114a58aaa68f34b44e8d8a411 ]

Fix two coding errors in ipu6-mmu.c:

1. Fix syntax error in page_table_dump() where the closing parenthesis
   and semicolon were swapped in the TBL_PHYS_ADDR macro call.

2. Fix incorrect loop bound in alloc_l2_pt(). When initializing L2 page
   table entries, the loop was incorrectly using ISP_L1PT_PTES instead
   of ISP_L2PT_PTES.

Fixes: 9163d83573e4 ("media: intel/ipu6: add IPU6 DMA mapping API and MMU table")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-mmu.c b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
index 6d1c0b90169d4..85cc6d5b4dd11 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-mmu.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
@@ -102,7 +102,7 @@ static void page_table_dump(struct ipu6_mmu_info *mmu_info)
 		if (mmu_info->l1_pt[l1_idx] == mmu_info->dummy_l2_pteval)
 			continue;
 
-		l2_phys = TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx];)
+		l2_phys = TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx]);
 		dev_dbg(mmu_info->dev,
 			"l1 entry %u; iovas 0x%8.8x-0x%8.8x, at %pap\n",
 			l1_idx, iova, iova + ISP_PAGE_SIZE, &l2_phys);
@@ -248,7 +248,7 @@ static u32 *alloc_l2_pt(struct ipu6_mmu_info *mmu_info)
 
 	dev_dbg(mmu_info->dev, "alloc_l2: get_zeroed_page() = %p\n", pt);
 
-	for (i = 0; i < ISP_L1PT_PTES; i++)
+	for (i = 0; i < ISP_L2PT_PTES; i++)
 		pt[i] = mmu_info->dummy_page_pteval;
 
 	return pt;
-- 
2.51.0

