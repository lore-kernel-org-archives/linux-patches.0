Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679871A680F;
	Sat, 30 May 2026 17:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163523; cv=none; b=JfqDSwQd6v131QPVSL+M/KJ5tlclDiTOtEb9HbwSFOIX9JrXsq0aM7jROwDjJwcuz6wnvdjnhQO3KgrXMulANafVL/ARxGM6X4WBFW5JO01WWEthhshU9ntndszXAKiAd+10TDxcuZoE/T2PS/HRjtTWob9bB+EVASKFfh/ny2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163523; c=relaxed/simple;
	bh=Z1O83j0x/OkxXtDDmkaHuWRb/y0jGYGLbj55z4qVVZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW/shSvNHKBgnThw/T+RFWHrIqAtawO+56QvCukWVUylHtukL3w6aZ0n1ik/fofry/nBOCaZrOdBq6oxv7vUX0N5Z20zd/hezxsBH9CjO+57QQ3+BXA0Y3FFsmMIHzNV44y7zkGUl9IasmTmzOCoeMqxNtgtPphR++yMWyp85Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3DScL+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3DScL+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0A61F00893;
	Sat, 30 May 2026 17:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163521;
	bh=FXQw8T8CrVJ4I1bLFly/SKS5X8jJKDhIuiBpRIp0684=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3DScL+gkLkrxXZKn3nAEe4RhYwZNdzfwVYyy+O5ySYq6vBNnMEABJfGsyM9Kr/JX
	 1nfeDp4D3li2wh8JlakKXI9T/6fqCYyWFE51TVKN1VyUyQkfuDx4rgOQVeEm5cllF1
	 O5irn3mjD19UXY69vuNkMc0C5YcJykPpDHTBafjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/776] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c
Date: Sat, 30 May 2026 17:59:57 +0200
Message-ID: <20260530160247.870161957@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit bd3110bc102ab6292656b8118be819faa0de8dd0 ]

Adding error pointer check after calling otx2_mbox_get_rsp().

Fixes: 9917060fc30a ("octeontx2-pf: Cleanup flow rule management")
Fixes: f0a1913f8a6f ("octeontx2-pf: Add support for ethtool ntuple filters")
Fixes: 674b3e164238 ("octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index c3e5ebc416676..3c46cb0bd0de0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -119,6 +119,8 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 		rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 			(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp))
+			goto exit;
 
 		for (ent = 0; ent < rsp->count; ent++)
 			flow_cfg->flow_ent[ent + allocated] = rsp->entry_list[ent];
@@ -195,6 +197,10 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 
 	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return PTR_ERR(rsp);
+	}
 
 	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev,
-- 
2.53.0



