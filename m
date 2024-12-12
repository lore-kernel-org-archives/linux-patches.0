Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549E7223304;
	Thu, 12 Dec 2024 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019363; cv=none; b=ekP5MS4AjdbFAkoUHYaur5yAseTUUizEOOImcreMCS2d3W9CUFXKtxu4oixhsGeDEe0jNiHBfuH81JY4SlH8YitFvML+xJHQvNzzFIpj2Whh44Qz3HUzbcu3vyz/LfpSDzyVnGncA3is5hXykwh51I50ITXaGwqzwJPTDAtybvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019363; c=relaxed/simple;
	bh=zjVlyBvB0CZjTmGCeIZXSmrzLVdD8OABLWGLt1EYCOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW6cYmmvH7bT5nDL2DVBkOCOp3V6w3uHhOgsBwY0JlgHv0a2qzXtp/+xoYT8khQU7fPQA4BmqbmnhjJ4YRB32vTKRFIS8gWOxS0uH4njQ/Q41zMhSMOQtnK8u1eIMkX+9JltwkLRh7bIQntd0GcGNwNhQFMx9+jbeHlA3U70pws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+FNM9rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+FNM9rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2E8C4CEDE;
	Thu, 12 Dec 2024 16:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019363;
	bh=zjVlyBvB0CZjTmGCeIZXSmrzLVdD8OABLWGLt1EYCOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+FNM9rLaNE5to/b1Buf6Y26uHG2naX/eeOk+/YQMc8H/lyonhgSjd1E6egCtmbjK
	 CBYo0k/LfVAvK8zQaHHcqVRvuCyhud2vg+HubPaSyJob7erxPjKYkIwgITR4OsJJIR
	 r+hrrFeMP0d9tzUSPk9XidRgTFdwxG2BOqPo1dic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/772] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c
Date: Thu, 12 Dec 2024 15:51:45 +0100
Message-ID: <20241212144356.540623691@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c757508322b9..7c7f8814fb3f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -121,6 +121,8 @@ int otx2_alloc_mcam_entries(struct otx2_nic *pfvf, u16 count)
 
 		rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 			(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp))
+			goto exit;
 
 		for (ent = 0; ent < rsp->count; ent++)
 			flow_cfg->flow_ent[ent + allocated] = rsp->entry_list[ent];
@@ -199,6 +201,10 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 
 	rsp = (struct npc_mcam_alloc_entry_rsp *)otx2_mbox_get_rsp
 	       (&pfvf->mbox.mbox, 0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return PTR_ERR(rsp);
+	}
 
 	if (rsp->count != req->count) {
 		netdev_info(pfvf->netdev,
@@ -234,6 +240,10 @@ static int otx2_mcam_entry_init(struct otx2_nic *pfvf)
 
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



