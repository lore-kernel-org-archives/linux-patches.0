Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017543;
	b=p6Q0trNR8I1eLOQJWqDLCAmTmviZJJl9O+/zbQeaW1ZzTbSqj32nxxKd8Z8N+PIDKaj/
	 wIOfZHoGNDu+Jdk4gPo++Ia/vFjKMi+FFfRWEoGT3b4VFbICRYvldmGnFbu/9vRz8tx4o
	 3dhH8hkDvPg3h4ns4w3/GUROvC+p5lF8DT4k4i14Hh5/mv1RN5ioLudcaMQ/z/ON8na9e
	 mr5QM4rfS8dp99QWbD8gUGuy10Sl7CxxICO+J6keInYK19/ksvstUZ8sqc6zBQpxNmZm4
	 6hiIpMkk2DoPJToEUEqnWP1ykGU0HBDpMYSpO9re+Q3tLh3HdFtbMAEj8y9YaBIoOOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HA9irH5uRRssaipcbNAh3zyPSAi0ZPNFp1fv7Ux87qE=;
	b=yRJxktUZpWWluIHPqAgeFQbGYBfM6R+UnSCFI9jBTLkyRk3w6qhEM5IQ/yq6IbMnlBBe
	 iPLsVi/cM0QwUXQMKjqIdylPDigoILDmCSlvI+PH5bnB0evPSh9CXhZMHK7VH1t7gLHov
	 fYsZ+96Bk+OtFSFqJoOhlxu8Px5zyabWgNK5D49ywX6lA5TMIMSg0YZaFpsdN4yYu5INx
	 TBAgxXMjoE2pbAXkg3cKfYmO/npWAs62Mei1HqIAW032ePngggDjIvDkLJjVPcUQyaRbh
	 KF2fp6/di4sMcUTcRTdIl7dslXG6+ecD92dOwp2d9fSPuZyH8GnB55FU9QgWAjjwE3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yja6PlFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB97606A32C;
	Wed, 18 Nov 2026 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yja6PlFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8B11F000C5;
	Wed, 18 Nov 2026 15:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017543;
	bh=HA9irH5uRRssaipcbNAh3zyPSAi0ZPNFp1fv7Ux87qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yja6PlFZfOFazibQIxRFvuCR6fxhutpauoVm204ZJKhNfqHNK0zXHd/ben9JmzbHE
	 irXYPhVGHouOpruz1IFFxHrGEydIleF9Pd0Ig8yqcwe+2Bozl4SbTr9fMoCokORP8e
	 vFSnA/2eEy5zBjSCPkUjtOaac/ARL03tbA65v+yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0923/2651] iommu/vt-d: Fix page table level calculation in compute_vasz_lg2_ss()
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118150321.120323023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

[ Upstream commit d00ac5f7b52bb1f3a2b605f0e773b0397c8e325a ]

compute_vasz_lg2_ss() finds the optimal Second-Stage page table level by
intersecting the maximum guest address width (mgaw) with the hardware's
SAGAW capability register.

The VT-d spec maps the SAGAW bit field positions as:
  - Bit 1: 39-bit AGAW (3-level page table, top_level = 2)
  - Bit 2: 48-bit AGAW (4-level page table, top_level = 3)
  - Bit 3: 57-bit AGAW (5-level page table, top_level = 4)

The fallback paths use bit shifts that are one position too large,
causing ffs() to select a deeper page table level than the mgaw window
requires:

  - mgaw > 39: "3 + ffs(sagaw >> 3)" evaluates to top_level = 4 (5-level)
    instead of top_level = 3 (4-level) when hardware supports both
    48-bit (Bit 2) and 57-bit (Bit 3) AGAW.
  - mgaw > 30: "2 + ffs(sagaw >> 2)" evaluates to top_level = 3 (4-level)
    instead of top_level = 2 (3-level) when hardware supports both
    39-bit (Bit 1) and 48-bit (Bit 2) AGAW.

In both cases the selected level is still one that the hardware advertises
in its SAGAW capability, so IOVA translation remains functionally correct.
However, an unnecessarily deep page table may be selected, adding an extra
level of page walk overhead and reducing TLB and cache efficiency without
providing any increase in addressable IOVA space beyond what the mgaw
window already caps.

Fix by decreasing the shift offset by one in each fallback case, ensuring
ffs() targets the correct SAGAW bit position and selects the smallest
page table level that fully covers the mgaw range:

  - mgaw > 39: "2 + ffs(sagaw >> 2)" correctly yields top_level = 3
  - mgaw > 30: "1 + ffs(sagaw >> 1)" correctly yields top_level = 2

Fixes: d856f9d27885 ("iommupt/vtd: Allow VT-d to have a larger table top than the vasz requires")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2e3b3ab216f8f..05f351833d0b5 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2911,10 +2911,10 @@ static unsigned int compute_vasz_lg2_ss(struct intel_iommu *iommu,
 		*top_level = 4;
 		return min(57, mgaw);
 	} else if (mgaw > 39 && sagaw >= BIT(2)) {
-		*top_level = 3 + ffs(sagaw >> 3);
+		*top_level = 2 + ffs(sagaw >> 2);
 		return min(48, mgaw);
 	} else if (mgaw > 30 && sagaw >= BIT(1)) {
-		*top_level = 2 + ffs(sagaw >> 2);
+		*top_level = 1 + ffs(sagaw >> 1);
 		return min(39, mgaw);
 	}
 	return 0;
-- 
2.53.0



