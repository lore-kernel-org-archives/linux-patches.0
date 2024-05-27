Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6615FCE9;
	Mon, 27 May 2024 19:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838031; cv=none; b=Xud/qphqO0bRqSq8BrAJa5rI5m5JXM/9fuz/fogl2Qg32CTduZgMmgvHTscD7W87fkmM0aEbn6hcbmsN6SXV67vabla7UUpNosXf69reOo0uHODAAc6lArXFj/WIbPQiJi2AqEkyCYDx2N2WSPkLD0AyuNWJ/DWfV47z7/7tB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838031; c=relaxed/simple;
	bh=hN9ZK1MqoIo0ZoM9gi+N6WkqYtCJ822h+z/+yEuOoqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTvyEHgVpDXCc6osKIP1WR0H9NJupfyAO3OAUIg4XPhp57a8qnmWQox0B1mODuR74dSu0zz7y33VcBAID7jKk6unqStfCENpDoMQR3oY5UksVSYqSJx8MbSC3uhoQ0wqAzzkA4juOi8Ix0/Ndiy7uf1yBryr2PbRlWr+r+kbz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbybRnm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbybRnm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C625C2BBFC;
	Mon, 27 May 2024 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838031;
	bh=hN9ZK1MqoIo0ZoM9gi+N6WkqYtCJ822h+z/+yEuOoqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbybRnm427W1IhuW3pc5cIWvBkhQfeNfjq8jzZ3K5S7/vqPDcicqf+IFaHog8PW5Z
	 rtB+Mh1NUFHu2NgzBYRGXUHCM/NJHUWV0CJvrAgjVe2kdxDeZhoczAB5t6dFPmYXct
	 aiztpQKVWBAxIRt4AogSDC3RkVfRNMfhDnhfnQH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 240/493] wifi: ath10k: populate board data for WCN3990
Date: Mon, 27 May 2024 20:54:02 +0200
Message-ID: <20240527185638.150072176@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 0032f8aa892ff..4e3736d7aff77 100644
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



