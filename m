Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F122410E0;
	Fri,  6 Dec 2024 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497154; cv=none; b=K1lWMLO2jx4I8LH050TnpiULA6eTTXb6xPj32uZIxdMKkXVhWKdPw7IgUQW7ytJgazcWF7w3DPW0N6Dg66NAki5aT/QTvA9DrO0fkb1Hl6/wtF2V/4Y7LD70H3n21TVPoTpUKugKW83uicDsq9n6TD90OIHXHiiTUcSNxX9Ew9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497154; c=relaxed/simple;
	bh=ec2XMR4ntXZvUzsdSf6sRwFEDJlquacsZktagp8EOsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxWE8g+JBWi3bWiYBnO9RhmgstJ/oU4Wlvw4Fhjhb9AOakkHANmMgkr/JscUGO1ggSGt0ZLtzvO6xy4neEDVtaR9kOJQxwGpsvh9wUXl6w4Q/nVK+Cnux9IY6JimhkAKDonpjNXPcfWrl6k3nuIe0+z1twtLVzoJaQVLg/YkuqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej0QDvWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej0QDvWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EBAC4CED1;
	Fri,  6 Dec 2024 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497153;
	bh=ec2XMR4ntXZvUzsdSf6sRwFEDJlquacsZktagp8EOsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej0QDvWhfsE74QUBJ9bJ+IdtPcPo5V7cisvBGiG1ZHKO4HBwDm0X6mw4SCsBxgFsU
	 Oo591MJNrX046CcyCSGVGN7JdqUeK24FXStQ/HW32uRh/62FZMIhi4263DK4wt3KAl
	 Ledz2haM3FaZxyvlcty0P79dB+uhtHE1aLeKeCgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/676] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_flows.c
Date: Fri,  6 Dec 2024 15:30:27 +0100
Message-ID: <20241206143701.467606780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97a71e9b85637..e6082f90f57a5 100644
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



