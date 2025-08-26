Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7E28635C;
	Tue, 26 Aug 2025 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208361; cv=none; b=AVfFOi+vIpnDV/FM/jedbOu4dyS1x+ylLnlVjLTIZgNaJcib3iv96/GCrsrLh8aXL2+yBHF94u1jInMusvLm/pW0nsv4NWa6gRu7R9T32PA6hHDAgHbbebuHA459sQcdwFlmDlToQq1LvJJi+YfFl/RNfdsNZ7zR1FuurXJUpRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208361; c=relaxed/simple;
	bh=jonD0Xxs6DimcgJBtQK6RfEcBWUehrsqzVl9Y0z6Ss4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay9ydUjtykEZWALP8kMRD92B7jlmraeP5Ce+Ea0GV1Ou9oXTyXSTWb1Ku/ysAujlVj9+nJWyZgPO4+qs6rQmhg11EpjrtcN1iEe+iRX/AcO4iUjFrMAq003mek91RA6a5v+IAzrpy2iP4pRcwK08cgKYHtnmcGq/MIRSrjY+q8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxhawe/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxhawe/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A665AC4CEF1;
	Tue, 26 Aug 2025 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208361;
	bh=jonD0Xxs6DimcgJBtQK6RfEcBWUehrsqzVl9Y0z6Ss4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxhawe/tIGHQY81H9nPyV5NVE7ovfg1bPb2BAgGcaom1KPkpndib4SFiJP8sT3OTA
	 fHxlM/7nf8xZ6Cj4IczAKIUDCx2Ywa8RqDfTOvR/dqfEALH2zEFD3f+NPoSrKHaATJ
	 f88M/EDXkjj7x7xcogtsE3rPBiabM8She7H2+ufs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 082/322] phy: qcom: phy-qcom-m31: Update IPQ5332 M31 USB phy initialization sequence
Date: Tue, 26 Aug 2025 13:08:17 +0200
Message-ID: <20250826110917.647830193@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit 4a3556b81b99f0c8c0358f7cc6801a62b4538fe2 upstream.

The current configuration used for the IPQ5332 M31 USB PHY fails the
Near End High Speed Signal Quality compliance test. To resolve this,
update the initialization sequence as specified in the Hardware Design
Document.

Fixes: 08e49af50701 ("phy: qcom: Introduce M31 USB PHY driver")
Cc: stable@kernel.org
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250630-ipq5332_hsphy_complaince-v2-1-63621439ebdb@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-m31.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-m31.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31.c
@@ -58,14 +58,16 @@
  #define USB2_0_TX_ENABLE		BIT(2)
 
 #define USB2PHY_USB_PHY_M31_XCFGI_4	0xc8
- #define HSTX_SLEW_RATE_565PS		GENMASK(1, 0)
+ #define HSTX_SLEW_RATE_400PS		GENMASK(2, 0)
  #define PLL_CHARGING_PUMP_CURRENT_35UA	GENMASK(4, 3)
  #define ODT_VALUE_38_02_OHM		GENMASK(7, 6)
 
 #define USB2PHY_USB_PHY_M31_XCFGI_5	0xcc
- #define ODT_VALUE_45_02_OHM		BIT(2)
  #define HSTX_PRE_EMPHASIS_LEVEL_0_55MA	BIT(0)
 
+#define USB2PHY_USB_PHY_M31_XCFGI_9	0xdc
+ #define HSTX_CURRENT_17_1MA_385MV	BIT(1)
+
 #define USB2PHY_USB_PHY_M31_XCFGI_11	0xe4
  #define XCFG_COARSE_TUNE_NUM		BIT(1)
  #define XCFG_FINE_TUNE_NUM		BIT(3)
@@ -164,7 +166,7 @@ static struct m31_phy_regs m31_ipq5332_r
 	},
 	{
 		USB2PHY_USB_PHY_M31_XCFGI_4,
-		HSTX_SLEW_RATE_565PS | PLL_CHARGING_PUMP_CURRENT_35UA | ODT_VALUE_38_02_OHM,
+		HSTX_SLEW_RATE_400PS | PLL_CHARGING_PUMP_CURRENT_35UA | ODT_VALUE_38_02_OHM,
 		0
 	},
 	{
@@ -174,10 +176,14 @@ static struct m31_phy_regs m31_ipq5332_r
 	},
 	{
 		USB2PHY_USB_PHY_M31_XCFGI_5,
-		ODT_VALUE_45_02_OHM | HSTX_PRE_EMPHASIS_LEVEL_0_55MA,
+		HSTX_PRE_EMPHASIS_LEVEL_0_55MA,
 		4
 	},
 	{
+		USB2PHY_USB_PHY_M31_XCFGI_9,
+		HSTX_CURRENT_17_1MA_385MV,
+	},
+	{
 		USB_PHY_UTMI_CTRL5,
 		0x0,
 		0


