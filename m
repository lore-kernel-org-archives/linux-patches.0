Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5981494AF;
	Tue, 25 Jun 2024 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308507; cv=none; b=R7RdNRbVY9wNuuvp7Ek+/mIAVmFESKBbBdTyN2zwB9OGeEahPQai5QquMc/CFqg/6Ov/RVSMmiPKB+HaGi4WLs4Dws/n2JSgYFmc+cEURNPU2hc2jIY0jlebQtCB6kXAt3anYcJYAODlP71m5B5qxIRBKB4W8YPfWlrmpaHCUK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308507; c=relaxed/simple;
	bh=7UAas5F9Xmm2wQaXxpyAr1vbDsxoqnhfYj+/hlMdpzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCGzoQ87xmyLn1qKGd/GbDbc56v9SQtwRtrNqhXrtJZG/D4pxrtWsbRQMmBQhWA6aZTpQXEA9O9nksFQAV29luI0OG8T+WHk1EETo0SGE4udf0LZLIDpImdqrKk//3NmlSr1M/i2AzzDu6gKEV6Yg/pleiRufTiaZQU1LvH3DzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGeoWmYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGeoWmYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2CEC32781;
	Tue, 25 Jun 2024 09:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308506;
	bh=7UAas5F9Xmm2wQaXxpyAr1vbDsxoqnhfYj+/hlMdpzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGeoWmYN9t9W5y3N5Aus2GAqqqpv6FtxHmmsUCSAslDFywcUwG3IbGCFH/D1p0r4B
	 L+GDIa3NEzMjRepB6uHm3bceGFTFxqk/HU8ftotbVwaVDOpZAJg2s6YO6SHBkTEtEf
	 zhMmOKqiOpzXWVKbC3UOjtBdrvyi+t43PQloXVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 145/250] phy: qcom-qmp: pcs: Add missing v6 N4 register offsets
Date: Tue, 25 Jun 2024 11:31:43 +0200
Message-ID: <20240625085553.624569404@linuxfoundation.org>
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

[ Upstream commit 99bf89626335bbec71d8461f0faec88551440850 ]

The new X1E80100 SoC bumps up the HW version of QMP phy to v6 N4 for
combo USB and DP PHY.  Currently, the X1E80100 uses the pure V6 PCS
register offsets, which are different. Add the offsets so the
mentioned platform can be fixed later on. Add the new PCS offsets
in a dedicated header file.

Fixes: d7b3579f84f7 ("phy: qcom-qmp-combo: Add x1e80100 USB/DP combo phys")
Co-developed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240527-x1e80100-phy-qualcomm-combo-fix-dp-v1-2-be8a0b882117@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h
new file mode 100644
index 0000000000000..b3024714dab4e
--- /dev/null
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2023, Linaro Limited
+ */
+
+#ifndef QCOM_PHY_QMP_PCS_V6_N4_H_
+#define QCOM_PHY_QMP_PCS_V6_N4_H_
+
+/* Only for QMP V6 N4 PHY - USB/PCIe PCS registers */
+#define QPHY_V6_N4_PCS_SW_RESET			0x000
+#define QPHY_V6_N4_PCS_PCS_STATUS1		0x014
+#define QPHY_V6_N4_PCS_POWER_DOWN_CONTROL	0x040
+#define QPHY_V6_N4_PCS_START_CONTROL		0x044
+#define QPHY_V6_N4_PCS_POWER_STATE_CONFIG1	0x090
+#define QPHY_V6_N4_PCS_LOCK_DETECT_CONFIG1	0x0c4
+#define QPHY_V6_N4_PCS_LOCK_DETECT_CONFIG2	0x0c8
+#define QPHY_V6_N4_PCS_LOCK_DETECT_CONFIG3	0x0cc
+#define QPHY_V6_N4_PCS_LOCK_DETECT_CONFIG6	0x0d8
+#define QPHY_V6_N4_PCS_REFGEN_REQ_CONFIG1	0x0dc
+#define QPHY_V6_N4_PCS_RX_SIGDET_LVL		0x188
+#define QPHY_V6_N4_PCS_RCVR_DTCT_DLY_P1U2_L	0x190
+#define QPHY_V6_N4_PCS_RCVR_DTCT_DLY_P1U2_H	0x194
+#define QPHY_V6_N4_PCS_RATE_SLEW_CNTRL1		0x198
+#define QPHY_V6_N4_PCS_RX_CONFIG		0x1b0
+#define QPHY_V6_N4_PCS_ALIGN_DETECT_CONFIG1	0x1c0
+#define QPHY_V6_N4_PCS_ALIGN_DETECT_CONFIG2	0x1c4
+#define QPHY_V6_N4_PCS_PCS_TX_RX_CONFIG		0x1d0
+#define QPHY_V6_N4_PCS_EQ_CONFIG1		0x1dc
+#define QPHY_V6_N4_PCS_EQ_CONFIG2		0x1e0
+#define QPHY_V6_N4_PCS_EQ_CONFIG5		0x1ec
+
+#endif
-- 
2.43.0



