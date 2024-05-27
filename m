Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B91078F;
	Mon, 27 May 2024 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836763; cv=none; b=rlh62idIPglHuFqIlZTHv16e1/58gqRDrbWGS/vCvREVK+PmbxhiJ0tLde8kGcy3vaIIISlutvsuAxj7pvFyNDdRc2R4UhF58RP4dNbQiV92SazdI2IT+PP3P8rIu5yOn5Y4kFGL9VKsGdDJWDeLvjECNCotHNDtcxr3NnuqO0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836763; c=relaxed/simple;
	bh=MW1RHBaPr1p1fN8R/8eGpzxvmLgk4AxFh90wdGhuUS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d14eu/PdMV7wwoQPYMWFRVJh9Nrd3CDvn2xbFeltn6UZr4a0bkISLEe5lu8rTCzbhh98rLVPKpeDyThuaKNXu+nB3E6BOvODQTqOB04HE2TVdco8Fu3hbL8sFq3aOvQNjcpHr/U+NRxwrchRT3vtSU0L7thRN5iWz6zxrtULzVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dwiYUuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dwiYUuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FBDC2BBFC;
	Mon, 27 May 2024 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836763;
	bh=MW1RHBaPr1p1fN8R/8eGpzxvmLgk4AxFh90wdGhuUS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dwiYUuA0EYx2Cr6L2wDFLnyQ1h7U2SB9phUJUEno/jLvREi1Q92keaoLVhDobslJ
	 KuD8BKAvSg9ey9Rzz0kla8AkV9f2d8a/lMHkuAdZVnQmFckgtHRGmWRYld8C04442k
	 RNLcHlHaf6G3eJp2QXHWPsTktbV6Bn81TnzjQXIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 176/427] wifi: ath10k: populate board data for WCN3990
Date: Mon, 27 May 2024 20:53:43 +0200
Message-ID: <20240527185618.666092561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f1f1b5b055c9f27a2f90fd0f0521f5920e9b3c18 ]

Specify board data size (and board.bin filename) for the WCN3990
platform.

Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Fixes: 03a72288c546 ("ath10k: wmi: add hw params entry for wcn3990")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240130-wcn3990-board-fw-v1-1-738f7c19a8c8@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c      | 3 +++
 drivers/net/wireless/ath/ath10k/hw.h        | 1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9ce6f49ab2614..fa5e2e6518313 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -720,6 +720,9 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.max_spatial_stream = 4,
 		.fw = {
 			.dir = WCN3990_HW_1_0_FW_DIR,
+			.board = WCN3990_HW_1_0_BOARD_DATA_FILE,
+			.board_size = WCN3990_BOARD_DATA_SZ,
+			.board_ext_size = WCN3990_BOARD_EXT_DATA_SZ,
 		},
 		.sw_decrypt_mcast_mgmt = true,
 		.rx_desc_ops = &wcn3990_rx_desc_ops,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 93c0730919966..9aa2d821b5078 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -133,6 +133,7 @@ enum qca9377_chip_id_rev {
 /* WCN3990 1.0 definitions */
 #define WCN3990_HW_1_0_DEV_VERSION	ATH10K_HW_WCN3990
 #define WCN3990_HW_1_0_FW_DIR		ATH10K_FW_DIR "/WCN3990/hw1.0"
+#define WCN3990_HW_1_0_BOARD_DATA_FILE "board.bin"
 
 #define ATH10K_FW_FILE_BASE		"firmware"
 #define ATH10K_FW_API_MAX		6
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index ec556bb88d658..ba37e6c7ced08 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -491,4 +491,7 @@ struct host_interest {
 #define QCA4019_BOARD_DATA_SZ	  12064
 #define QCA4019_BOARD_EXT_DATA_SZ 0
 
+#define WCN3990_BOARD_DATA_SZ	  26328
+#define WCN3990_BOARD_EXT_DATA_SZ 0
+
 #endif /* __TARGADDRS_H__ */
-- 
2.43.0



