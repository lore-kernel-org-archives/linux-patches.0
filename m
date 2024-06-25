Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F5F12EBEA;
	Tue, 25 Jun 2024 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308504; cv=none; b=pLQIbqNdKkSW6pSf96Ls139AtSyyexg/KnB+Ai8bYceKyo2nPOA7k9UJWKqZxp1W4+49qb4h18LG2qbiJ+Ve7SmPbwTg2MjsG7yHPumkQ+TuO+LAeEd6HSgASPyWk6n3S44aw4EgMxlBHpO6aYUHtc0ZWAkXARKy64O+FDbYlwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308504; c=relaxed/simple;
	bh=IZBnk+8FxYoGotCeyFYvQ1O8ApcHVQyfWcKrzvZLEzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvYxbrLx95xbpnkwroELxJu0FM4Kg/EW4h9OY31EjXlcG8bUivr5/64NB/Hhu02L08YgpV3mfN1AXu8o4JBdpfXJFthCCwjOEbXfq4RC9mTSvuL5FPPKv1vrMUYCMHBaja5iL0Vv15+Qv+cKeb6i51e56KEBoXr22fTGWh44OCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYa4mkXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYa4mkXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BA0C32786;
	Tue, 25 Jun 2024 09:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308503;
	bh=IZBnk+8FxYoGotCeyFYvQ1O8ApcHVQyfWcKrzvZLEzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYa4mkXzUwxQ1tG71WzbJ83pN7Tr0tTYO5/E/pemUBeYTtQvxFY8dX6itVkxHb0Sj
	 MrgGFYAY9oKQg+55p+8qSOhsxCgRCeGIi7gUAR4Kan9nyUNQdtnVChf+UjTi7Baj8Q
	 Jbr/+jek9ZMhnXmZyQKcLk4ZnuoMXPqDaEa/2us0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 144/250] phy: qcom-qmp: qserdes-txrx: Add missing registers offsets
Date: Tue, 25 Jun 2024 11:31:42 +0200
Message-ID: <20240625085553.585544997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 5314e84c33e7ad61df5203df540626ac59f9dcd9 ]

Currently, the x1e80100 uses pure V6 register offsets for DP part of the
combo PHY. This hasn't been an issue because external DP is not yet
enabled on any of the boards yet. But in order to enabled it, all these
new V6 N4 register offsets are needed. So add them.

Fixes: 762c3565f3c8 ("phy: qcom-qmp: qserdes-txrx: Add V6 N4 register offsets")
Co-developed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240527-x1e80100-phy-qualcomm-combo-fix-dp-v1-1-be8a0b882117@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h  | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h
index a814ad11af071..d37cc0d4fd365 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h
@@ -6,11 +6,24 @@
 #ifndef QCOM_PHY_QMP_QSERDES_TXRX_V6_N4_H_
 #define QCOM_PHY_QMP_QSERDES_TXRX_V6_N4_H_
 
+#define QSERDES_V6_N4_TX_CLKBUF_ENABLE			0x08
+#define QSERDES_V6_N4_TX_TX_EMP_POST1_LVL		0x0c
+#define QSERDES_V6_N4_TX_TX_DRV_LVL			0x14
+#define QSERDES_V6_N4_TX_RESET_TSYNC_EN			0x1c
+#define QSERDES_V6_N4_TX_PRE_STALL_LDO_BOOST_EN		0x20
 #define QSERDES_V6_N4_TX_RES_CODE_LANE_OFFSET_TX	0x30
 #define QSERDES_V6_N4_TX_RES_CODE_LANE_OFFSET_RX	0x34
+#define QSERDES_V6_N4_TX_TRANSCEIVER_BIAS_EN		0x48
+#define QSERDES_V6_N4_TX_HIGHZ_DRVR_EN			0x4c
+#define QSERDES_V6_N4_TX_TX_POL_INV			0x50
+#define QSERDES_V6_N4_TX_PARRATE_REC_DETECT_IDLE_EN	0x54
 #define QSERDES_V6_N4_TX_LANE_MODE_1			0x78
 #define QSERDES_V6_N4_TX_LANE_MODE_2			0x7c
 #define QSERDES_V6_N4_TX_LANE_MODE_3			0x80
+#define QSERDES_V6_N4_TX_TRAN_DRVR_EMP_EN		0xac
+#define QSERDES_V6_N4_TX_TX_BAND			0xd8
+#define QSERDES_V6_N4_TX_INTERFACE_SELECT		0xe4
+#define QSERDES_V6_N4_TX_VMODE_CTRL1			0xb0
 
 #define QSERDES_V6_N4_RX_UCDR_FO_GAIN_RATE2		0x8
 #define QSERDES_V6_N4_RX_UCDR_SO_GAIN_RATE2		0x18
-- 
2.43.0



