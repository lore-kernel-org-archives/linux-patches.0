Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A4333438F;
	Thu, 30 Jul 2026 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425898; cv=none; b=Ewzz4KVGjhT4+qxp2UECTtlJHN5uenecAV76SlTCcDozcWj6PLYalPJB6j48cnkZLn2ZnCF0sMugimfQMaVFPKt4AXb4mz0UMBx7vU6CTWqVFZJBIffjbpebDvmcNgVTJTbW5XkHQUsIBzPA0zbV8iZblyf9cxAcF2XFZ/33w/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425898; c=relaxed/simple;
	bh=o9kvqaSnw4Pi9LpUXDAKhFnb10WAi3p6rcN+0Wkl/4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2bSNSVyow4wsoo6/V8jNCsEWlybzofR3DZYuSWxrK68GUbqPLJdGfLoUwYVOCKcTJEss8Iyhg6xZ4YSUTaCDBQfys4+o05MhhpVv8y+0Zmz4KMgBS90URxRjnKXDEvz1NCcpPsH3vGiaRbasDHFLDD9aqKP7LNCcco2dNMt79M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsUsModb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsUsModb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493181F000E9;
	Thu, 30 Jul 2026 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425897;
	bh=TgAj7VEvN7rvvsHRRQE5tUbRFgjeJkavNxEZYFAUTeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsUsModb9NVKpRbBVzSfbsyf44hb1dz4sTDZ1kzM/yawpYJ5m47SNpG90OTFqHPO9
	 MPZWmPJRFyzPCiOHyAoA7+/3Sx+47kBkBoP7uC5DI5JSCWKI0b1vkFWlzdXquSn4+b
	 iauvNFSfwDxxbjHk4OxZUlj4Zeyewnxld6TqpbJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/602] octeontx2-vf: set TC flower flag on MCAM entry allocation
Date: Thu, 30 Jul 2026 16:10:20 +0200
Message-ID: <20260730141440.753316624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 0d4d31e3cc5dd6204fa1495c4107f5075acce5ed ]

When MCAM entries are allocated for a VF netdev via the devlink
mcam_count parameter, only OTX2_FLAG_NTUPLE_SUPPORT was set. That
enabled ethtool ntuple filters but not tc flower offload. Also set
OTX2_FLAG_TC_FLOWER_SUPPORT when entries are successfully allocated.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260715052007.2099851-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 2750326bfcf8b1..a9057711b62255 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -151,6 +151,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 	if (allocated) {
 		pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	}
 
 	if (allocated != count)
-- 
2.53.0



