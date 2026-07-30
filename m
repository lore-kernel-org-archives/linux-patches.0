Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6403750CF;
	Thu, 30 Jul 2026 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424163; cv=none; b=gUnsvcOsRfq895NlU1uv//eMU/zbHk4Znl6AEZTIRYON6s4y7PPvkvpogriWsyeVhBC1p6NuvnbPA0NqXJeJaXVpqlc8jsQupVzdhAe6EPQL6lO/2osTHdOYpLQiFfFvYpc6PxbV+ektUW+jsdwVGGNYHIIW9qMXQRayhe2knsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424163; c=relaxed/simple;
	bh=beAGkmiJQv4Rhvi8LxEZKaU5wyr3jdROg6IoBOstDJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju8izzFVt+YD2lwDpyxfHA9Lin5Iqqt0NGjF4Wof9XNyoyc3RcjpkVw0t0JrR/6m/JUtwpnC4LxdoM1cvlTmsTPYdk/WxzBp26IZXu66Vds3uqGoZJjiKPBGZUkLJo8YRipiFOXRVFQFJM0PsrZzHkRLPTZZ92mxEJQz5sUDiDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXnFrbJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXnFrbJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3691F000E9;
	Thu, 30 Jul 2026 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424162;
	bh=h8vM5jh/yfP7QfrROY35/3Zxi7gJDbqvqZsa7PbAnSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXnFrbJtlZi65Upg55RB8t7FnqjdzwcRrmSbDs0Jl90scRLCeB/wYuiEcyzq4/KvF
	 6NHKG6l1zucrQJl/xzEigAVX78zKpod60b2dWOed+lDLi3Dq5RTMZd1JGtg1PVhfuH
	 nKCJuvLODY610h4zaGKRIsjTFkuKLTqCAswAz1fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 296/675] octeontx2-vf: set TC flower flag on MCAM entry allocation
Date: Thu, 30 Jul 2026 16:10:26 +0200
Message-ID: <20260730141451.413573006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 64c6d9162ef644..17e8f6e51808b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -146,6 +146,7 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 	if (allocated) {
 		pfvf->flags |= OTX2_FLAG_MCAM_ENTRIES_ALLOC;
 		pfvf->flags |= OTX2_FLAG_NTUPLE_SUPPORT;
+		pfvf->flags |= OTX2_FLAG_TC_FLOWER_SUPPORT;
 	}
 
 	if (allocated != count)
-- 
2.53.0



