Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2989421ABD0;
	Tue, 12 Aug 2025 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023940; cv=none; b=UpLBXKpUAokj1dL8mLnyvlx7tvPdJ8GT5keah1RC6nBEE2T+jA3RbIAOZPo4VzC6chpstNkfWmcLaWk7kv6BWqo5tyWycK/J2qDQvpGd4DeoOjkqrFXriSWuixLEoe5rjkZNLH0bYLB7Pd3aScQ2WhxHmFma9pvVTrFhE9VX5WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023940; c=relaxed/simple;
	bh=VJKB2iGsR3dpZMG8s0/1/5waHzn34++2Hp7enbyex8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCZfwbeX0dkYPVmoaAmRbavdrxom2slPZN+403PvD3kQRiIedTkPErznswRsqUyH62AKZoI0OQK4lrmoabuPrJdw7JSkmK7Y7DoGCZ8WUIffRfKLpd4a8ajEbtTNSFNqEkt/HOG9o2pml6775TuaclDy9DM8It6/5IxY1T/b2Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAOFHFHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAOFHFHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A314C4CEF0;
	Tue, 12 Aug 2025 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023940;
	bh=VJKB2iGsR3dpZMG8s0/1/5waHzn34++2Hp7enbyex8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAOFHFHBL/iJHzKj3RlyG5O3HLCBChKewin9tnxr0r6z+8Ch+zFxJ8n3c2o1qH1SQ
	 siGxusIZRpC767LAWBfjY8KlKFEckGZtaITDWgxqf/Sbg9dtTzl0DzgKCAK/aoFvHp
	 NnrMer+U8rHwQRoPxXc4ZDzzUcowK7zFxGOA8jzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 226/627] wifi: ath12k: Use HTT_TCL_METADATA_VER_V1 in FTM mode
Date: Tue, 12 Aug 2025 19:28:41 +0200
Message-ID: <20250812173427.883487869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 66b3ebc77d23d6574a965bdbfe41de8aeb7f384e ]

Currently host sends HTT_TCL_METADATA_VER_V2 to the firmware
regardless of the operating mode (Mission or FTM).

Firmware expects additional software information (like peer ID, vdev
ID, and link ID) in Tx packets when HTT_TCL_METADATA_VER_V2 is set.
However, in FTM (Factory Test Mode) mode, no vdev is created on the
host side (this is expected). As a result, the firmware fails to find
the expected vdev during packet processing and ends up dropping
packets.

To fix this, send HTT_TCL_METADATA_VER_V1 in FTM mode because FTM
mode doesn't support HTT_TCL_METADATA_VER_V2.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1

Fixes: 5d964966bd3f ("wifi: ath12k: Update HTT_TCL_METADATA version and bit mask definitions")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250711035420.1509029-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.h    | 1 +
 drivers/net/wireless/ath/ath12k/dp_tx.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index a353333f83b6..2f0718edabd2 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -469,6 +469,7 @@ enum htt_h2t_msg_type {
 };
 
 #define HTT_VER_REQ_INFO_MSG_ID		GENMASK(7, 0)
+#define HTT_OPTION_TCL_METADATA_VER_V1	1
 #define HTT_OPTION_TCL_METADATA_VER_V2	2
 #define HTT_OPTION_TAG			GENMASK(7, 0)
 #define HTT_OPTION_LEN			GENMASK(15, 8)
diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 075912eacfaa..7470731eb830 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -1182,6 +1182,7 @@ int ath12k_dp_tx_htt_h2t_ver_req_msg(struct ath12k_base *ab)
 	struct sk_buff *skb;
 	struct htt_ver_req_cmd *cmd;
 	int len = sizeof(*cmd);
+	u32 metadata_version;
 	int ret;
 
 	init_completion(&dp->htt_tgt_version_received);
@@ -1194,12 +1195,14 @@ int ath12k_dp_tx_htt_h2t_ver_req_msg(struct ath12k_base *ab)
 	cmd = (struct htt_ver_req_cmd *)skb->data;
 	cmd->ver_reg_info = le32_encode_bits(HTT_H2T_MSG_TYPE_VERSION_REQ,
 					     HTT_OPTION_TAG);
+	metadata_version = ath12k_ftm_mode ? HTT_OPTION_TCL_METADATA_VER_V1 :
+			   HTT_OPTION_TCL_METADATA_VER_V2;
 
 	cmd->tcl_metadata_version = le32_encode_bits(HTT_TAG_TCL_METADATA_VERSION,
 						     HTT_OPTION_TAG) |
 				    le32_encode_bits(HTT_TCL_METADATA_VER_SZ,
 						     HTT_OPTION_LEN) |
-				    le32_encode_bits(HTT_OPTION_TCL_METADATA_VER_V2,
+				    le32_encode_bits(metadata_version,
 						     HTT_OPTION_VALUE);
 
 	ret = ath12k_htc_send(&ab->htc, dp->eid, skb);
-- 
2.39.5



