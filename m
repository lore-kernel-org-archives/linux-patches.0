Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64DD2DC783;
	Mon, 17 Aug 2026 14:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976846; cv=none; b=BoAUDIvXvWRrR/xMCQZRdvFCTB/g2lf+rO9N5KwyZVSfqONhwtG0GQ0YQNSE+vBli+c3i+GXnq4CrRshZjQq01XO/p1s/sVuUGwEVsYaSAQbB8tp8ipwQEAOj1/i1iAqMItyOdj0t06Em2XBhHa4A0to+7qAg6X+jBI1GWvTUOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976846; c=relaxed/simple;
	bh=AjAaEw+Fo21AvQrCBG5Pv0haFb7S5/XHtbubtNI7E2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlDBFKEv1i/Djot9DeTge9NW1a7E8kcYI2jp8sYKVFKszpIBca9xhVd+3cqImOQhpeCBF/SLg3I5CNHef0vQyIq9VvbOQuY2lqCn9oiwA0YFUe9V3sJGLYKe9bQ/FhTXSTwlS7hFgLasXLoJkSnrHY5haP1lc157ADkKOGB2Twg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmBtAwCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmBtAwCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF14A1F000E9;
	Mon, 17 Aug 2026 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976845;
	bh=aLA87mifIre/IS8MNz9Zr/teNYWBbjrfjE8fUShHj1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmBtAwCAZBvBEMqeggChG65PqnwWmsDKxz7YUeNHvlLOT7TSajSeI4VtcBah3qCas
	 qbcn0se9VEQptrjhbCpffYy1RqUg1M+QEP3GDLYp2APeyw0yIAE/Sdn8v6Vrnm1wYm
	 0jwjIQq1GHqDJ1zEkrfe6NR4cxe7SrLPUyG3x3e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/456] octeontx2-vf: set TC flower flag on MCAM entry allocation
Date: Mon, 17 Aug 2026 15:28:34 +0200
Message-ID: <20260817132544.941937767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87e41b9a0ce63d..b7d528cf34328a 100644
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



