Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D30B3DD851;
	Mon, 17 Aug 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979345; cv=none; b=lDuc2cqcQuMor2/aWuFm9JcOHObIblR+fxL1c/4M/DtAmSOR5cSmpJlND8z4kbABfMCz2qrolP4aWGSeTIBjoJsRwt4UQLnKT+VMbfcQs7MS8roW2oX7e60UzA0JHMisA5xQBw4ge0VWuB/bcxI/RgQuoacLhgrXBL44Fa2QCC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979345; c=relaxed/simple;
	bh=/+NSA4F8OOnHa4q5NrnngLXv42PFAjCKDM4kR3BMih4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gY6DkI8poL+SmX5LuLiFctEqw8IDUeVaIeWh/77dFJ74hpON2h5XsJvMwpLrtYDHtYp8hTBquiNW/OL7sScbgn2+OyavRyqigF4mk3uVF7B1I2IGNmwH4sNIEGIZ8VoDv73zbEeFIQoniSd2v0UGB41dO75hIus820QmKXF06UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDq6/QqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDq6/QqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF511F000E9;
	Mon, 17 Aug 2026 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979343;
	bh=tTmMmMjFMHoBddvC/k6DWWF3ik50C12GHjiUqFxFNjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDq6/QqEuRZAXDGto0Uy4W5J2OZ6Mi4BeRHKHQUyaw0c69uounmlPy2btguMSh1IA
	 DEuT2wJsoeorl0mw5/BdDD41EMvWNSmfeZum97muk9E3SQUZHj7HiOE4m04z3FmPFR
	 5MprdGrNVeJ4yz44scZQeO9YLq3t324TdkRxH8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/609] octeontx2-vf: set TC flower flag on MCAM entry allocation
Date: Mon, 17 Aug 2026 15:27:31 +0200
Message-ID: <20260817132549.199122189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7c7f8814fb3f95..cbf44f0d7d8bb6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -153,6 +153,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 	if (allocated) {
 		pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	}
 
 	if (allocated != count)
-- 
2.53.0



