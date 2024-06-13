Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5F2143C55;
	Thu, 13 Jun 2024 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279812; cv=none; b=a+RYe5Uiq7BnDwJYRrPzpWXRHox960fMnu/UZHLiW/dYhZnhIr4j72kbvnQuF4YOKu1sGHSrztftzd0pzTh08qD20fMlAq9Tx1DwT8XE0Uesw5VJ0wLlPWVWF4PaG2NkFvuMoNM3Ev9AFpbsgKxe4spp3lYvsdjaDe+Ltg0/5E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279812; c=relaxed/simple;
	bh=58uQ8VqzpJTAs4wWyzAoiMV3VJk8m0+JLdf/TQHU5jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEarB2FQUbpeqp9NziRXOLlsVCtJTgQxPy5PzCYHoITflpdrYfXojGa1zjjjcKXGj6u6bq5+521qaIPWyO+Kyzcsp2xBbTAyx+AoyO43wRaDatqL9uyuU/SOO7AyVnK1LaK8EPnVkkROtqwcCXxPMEITV8vnCcbhvZnXemjWfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3Tyw+tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3Tyw+tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8F4C2BBFC;
	Thu, 13 Jun 2024 11:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279811;
	bh=58uQ8VqzpJTAs4wWyzAoiMV3VJk8m0+JLdf/TQHU5jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3Tyw+tGpOo2PxXjIVhUbvUfDESbORO9+327tr03IHf23hokDCThdxywIjbRHG8Pd
	 V/SGWHWjk9/DYbkC4fAq83yLTwlXgXgMpOVa2mtqGO5ziRk9DdKoxG/yNiSxlPlLkG
	 h2J0pcFPD0eIRWc6ddPVM5q5l7GSp54nkArYPbAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/202] wifi: ath10k: populate board data for WCN3990
Date: Thu, 13 Jun 2024 13:32:22 +0200
Message-ID: <20240613113229.471801384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 09e77be6e3142..0b8d725338e25 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -579,6 +579,9 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.max_spatial_stream = 4,
 		.fw = {
 			.dir = WCN3990_HW_1_0_FW_DIR,
+			.board = WCN3990_HW_1_0_BOARD_DATA_FILE,
+			.board_size = WCN3990_BOARD_DATA_SZ,
+			.board_ext_size = WCN3990_BOARD_EXT_DATA_SZ,
 		},
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &wcn3990_ops,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 705ab83cdff43..eb27aeeb94c8f 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -132,6 +132,7 @@ enum qca9377_chip_id_rev {
 /* WCN3990 1.0 definitions */
 #define WCN3990_HW_1_0_DEV_VERSION	ATH10K_HW_WCN3990
 #define WCN3990_HW_1_0_FW_DIR		ATH10K_FW_DIR "/WCN3990/hw1.0"
+#define WCN3990_HW_1_0_BOARD_DATA_FILE "board.bin"
 
 #define ATH10K_FW_FILE_BASE		"firmware"
 #define ATH10K_FW_API_MAX		6
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index dff6c8ac9dba3..362508ac37fed 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -480,4 +480,7 @@ struct host_interest {
 #define QCA4019_BOARD_DATA_SZ	  12064
 #define QCA4019_BOARD_EXT_DATA_SZ 0
 
+#define WCN3990_BOARD_DATA_SZ	  26328
+#define WCN3990_BOARD_EXT_DATA_SZ 0
+
 #endif /* __TARGADDRS_H__ */
-- 
2.43.0



