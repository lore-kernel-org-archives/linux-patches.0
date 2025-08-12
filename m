Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311381A3029;
	Tue, 12 Aug 2025 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025860; cv=none; b=Tnqu3xxRD4tEyn+uELTVrYWIxRn6kAhdOILbhR6+T8P2Nz8gERvM6qVy5YKhlfXaM7AYTZQfclkZeIttAEniJdAVSqgaJwnGXJzCy1G/5GJu0HzZ0H+/Fyut4AAg3w2vy1WK6+RF0YvkfAuTtHsTYx/XOQew8wwhLkeFM9gyoYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025860; c=relaxed/simple;
	bh=dDChgbniBwFOiKCnc0TrJ1ENgqi7Mm/zaa4btDbdcac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm8N4O/phMvLFzTNwbOrw0qXNwyt+oMcDB/E/EFuYWM/KJzD5SqBNh6cLo1Ti9QqByeRcGeqo/XimMgPcMa69A+9g5nrfoXV6u9KIZAddcM8zJasg9DblzLFBZyoKdaq3owcAb+3wZlcH9nc0yaW0yRgbZwcTlZjQRYyCPwvhwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTYA8XRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTYA8XRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9209FC4CEF0;
	Tue, 12 Aug 2025 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025860;
	bh=dDChgbniBwFOiKCnc0TrJ1ENgqi7Mm/zaa4btDbdcac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTYA8XRnGB8qjiVMOpxRyRRzTCaIasTXHNz4S0oDiKupBQwYipFL9C0uEs+LO8JXH
	 Xbj66/e9m4tVzmc1VFVRMZ2cflmIpIGo4x75sud7IxbT3ae+yIDg7J7SwAbNRLcOPr
	 3mAdrWUC7MjU6/LiX1v18hQRdi7e9beA5A07tQcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 166/480] wifi: ath12k: Use HTT_TCL_METADATA_VER_V1 in FTM mode
Date: Tue, 12 Aug 2025 19:46:14 +0200
Message-ID: <20250812174404.370298299@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e8dbba0c3bb7..4003e81df535 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -425,6 +425,7 @@ enum htt_h2t_msg_type {
 };
 
 #define HTT_VER_REQ_INFO_MSG_ID		GENMASK(7, 0)
+#define HTT_OPTION_TCL_METADATA_VER_V1	1
 #define HTT_OPTION_TCL_METADATA_VER_V2	2
 #define HTT_OPTION_TAG			GENMASK(7, 0)
 #define HTT_OPTION_LEN			GENMASK(15, 8)
diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index faf58e91d3eb..5e741b221d87 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -1107,6 +1107,7 @@ int ath12k_dp_tx_htt_h2t_ver_req_msg(struct ath12k_base *ab)
 	struct sk_buff *skb;
 	struct htt_ver_req_cmd *cmd;
 	int len = sizeof(*cmd);
+	u32 metadata_version;
 	int ret;
 
 	init_completion(&dp->htt_tgt_version_received);
@@ -1119,12 +1120,14 @@ int ath12k_dp_tx_htt_h2t_ver_req_msg(struct ath12k_base *ab)
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



