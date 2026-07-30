Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22F442FBC;
	Thu, 30 Jul 2026 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422110; cv=none; b=sutFt1pmaBs4ihOPsD5x8AWWA2ItL2PZnZ1kvMF4DwB0qzyhTYInE+zCzndzIFvkkkgVwCP8jmzAnpjXTGvJ1hMiPGYvL0a6VrspK40fheywoFvMgn/LHxTDRdB/Lx2WZORrBbj/XmBUNC9nwdaGrR2A9g+MMJxLAzSrP8eHSoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422110; c=relaxed/simple;
	bh=sGWuT6RqzVcKqwaHG8ep461ZJAEJFsPRrgWesfC61Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaKUjCY2vLHkrfjWTFL7ooNCIsa0oBpWgbTjt2gdtq2KFQWXY5EeNOgD3IKZF+mRnNHEHMz3rU7AIG69fyPA3ftVI1GakpuAjFRoflFVkE4EIeGhaBxL3a3gXDtZ7WQMgVDMyC7jDSNL/1y6fVQlDlRR7BloyM3GXzlX2hVqKGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIA/Jlog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIA/Jlog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F391F00A3E;
	Thu, 30 Jul 2026 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422107;
	bh=pjqvPEHYrDQTAgPcl0G1O/LvTQDKEQ0zFf9bsobDUv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIA/JlogeIdLvGo8mUF8UIyFpRq4jUnpbRTPRknHLu9Wv0/qAM7vrV9fWBaijGTRt
	 g719AfZ5EakEvbGjdUPq4ro+8dx/0KhcQPneok20DrhRIfBYbyajV+dgfZQ8WvfwYq
	 ZT/DZmtFxgbWhj+ZoCiXnT7AbtmDkzSHB4SjUpTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 328/744] octeontx2-vf: set TC flower flag on MCAM entry allocation
Date: Thu, 30 Jul 2026 16:10:01 +0200
Message-ID: <20260730141451.257028774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38cc539d724d84..3b3eee15715f75 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -270,6 +270,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 	if (allocated) {
 		pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	}
 
 	if (allocated != count)
-- 
2.53.0



