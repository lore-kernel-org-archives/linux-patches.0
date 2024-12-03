Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09932C80;
	Tue,  3 Dec 2024 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240877; cv=none; b=t6NFbEY0+EndpdIPgUZPpZ30S0BrtUj80URfnTtgNPiy2yCl1FBjd6ml5mCbh6HUUFHd8dBJq1KGSi7yP/xKTqOwxX++bHGN4uOXYrOn0Ux+fT8QUOvOeGNgqLBFZ/etYSTnRaON3+t1bfvoSp+RxokAc7v8L2bxDFZkZWxVGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240877; c=relaxed/simple;
	bh=HUyIxAsye3RjOdht3pwD0YJRzzJtdQypRvdxWfUE83A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km9hiZAMhpi2TyoOG1a+OqMy1dAjPTcdu1UfG3rZGWZ2RGBocBsm+A6W9pWG+T90BL91vF8mmUGi8GJ/2EgjlQJPs8AZ5FNDCdVrJF16fKSIUwGVx/KL/JqreS6r6ooqc5Gvq4ROUwY2AH1K54+0mIgJC/o8e79v+wM8TgPyv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qOVG2wS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qOVG2wS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B8BC4CECF;
	Tue,  3 Dec 2024 15:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240876;
	bh=HUyIxAsye3RjOdht3pwD0YJRzzJtdQypRvdxWfUE83A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qOVG2wSmm00AF1o0E11U6YICCZqbnnXnQY4gaVPgdHCMtMOSNLaLBF7dvjjjlw0b
	 OYRQqjex1SP2Ix2Q/TkIpOiiIC6nYs61BLMwhbdt9neHhLBmojcIkT2+K7dx9bHcP/
	 +xir3FrWq3cB5+jNyqz7KZH9N9AbVA9iB5PKJ71Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/826] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c
Date: Tue,  3 Dec 2024 15:39:48 +0100
Message-ID: <20241203144753.945758199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit bd3110bc102ab6292656b8118be819faa0de8dd0 ]

Adding error pointer check after calling otx2_mbox_get_rsp().

Fixes: 9917060fc30a ("octeontx2-pf: Cleanup flow rule management")
Fixes: f0a1913f8a6f ("octeontx2-pf: Add support for ethtool ntuple filters")
Fixes: 674b3e164238 ("octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_flows.c    | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 98c31a16c70b4..58720a161ee24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -119,6 +119,8 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 		rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 			(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp))
+			goto exit;
 
 		for (ent = 0; ent < rsp->count; ent++)
 			flow_cfg->flow_ent[ent + allocated] = rsp->entry_list[ent];
@@ -197,6 +199,10 @@ int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 
 	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return PTR_ERR(rsp);
+	}
 
 	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev,
@@ -232,6 +238,10 @@ int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 
 	frsp = (struct npc_get_field_status_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &freq->hdr);
+	if (IS_ERR(frsp)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return PTR_ERR(frsp);
+	}
 
 	if (frsp->enable) {
 		pfvf->flags |= OTX2_FLAG_RX_VLAN_SUPPORT;
-- 
2.43.0



