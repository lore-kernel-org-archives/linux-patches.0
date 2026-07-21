Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BE917A2F6;
	Tue, 21 Jul 2026 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661461; cv=none; b=JQ5PVMaVdOTCk3Upff+xlSJT2mXu+islEvUV14M1tiwqZFCp26HrncOAchqRPgYaZz8hz+81UVTN2dzlqUAROZGuCasn7Yf/zPag96Szkl9tSnQBL8Pt3STbJh/mTFaungFo1W336KCLsEhYI2MBIDrUoQw99RtYS4hqc4YenR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661461; c=relaxed/simple;
	bh=K6myNvMN7NTCKISqZfhPyVS9iDYf9fERUMJlCs6UU/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prWiJ9fZfuZIyTZjNVcEV5uHD/M3k1QzcHfyF5vgPLScxb7oo42haSO3gWcT+GVw64mbkpbiTWBg551Tv7qVo6uwrqvCPAOr+bUebUrAZilHNfIDdz2PbC7itK1t+k3dip4QIcu50cxWkF48ZbHGQzYa8Q+AW9mzdCJzEFsHRxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3827YDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3827YDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48921F000E9;
	Tue, 21 Jul 2026 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661460;
	bh=ViV3TP4S06V/QdAyBdwpMAWf4YMOmNof0r49e8eCPKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3827YDNbatwxI9X1Zk5Rv1Xsj2xwHOalcmCKP1akdINNWHovyv54UAb4qRcuT8zu
	 UNrOJaB2kIK2x0ot0u//XpiU5HQdNdgCSL0y6M9nqEF6oaeDfT6+ISuGIIusFP63w+
	 cFBuPku5hmIi2JuAwNqNCwQ+gjdxRfEjKKKqBIkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0074/1276] arm64: tegra: Fix Tegra234 MGBE PTP clock
Date: Tue, 21 Jul 2026 17:08:37 +0200
Message-ID: <20260721152447.751198991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 8f0cc929a4bad534c5a860a53d88912cf16d9c9c ]

The Tegra MGBE PTP clock is incorrectly named as 'ptp-ref' and not
'ptp_ref' and this causing the initialisation of the PTP clock to fail.
The device-tree binding doc for the device and the Tegra MGBE driver
have been updated to use the correct name and so update the device-tree
for Tegra234 as well.

Fixes: 610cdf3186bc ("arm64: tegra: Add MGBE nodes on Tegra234")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 2601b43b2d8cad..75428e70a69252 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3529,7 +3529,7 @@ ethernet@6800000 {
 				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
@@ -3571,7 +3571,7 @@ ethernet@6900000 {
 				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE1_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE1_MAC>,
@@ -3613,7 +3613,7 @@ ethernet@6a00000 {
 				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE2_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE2_MAC>,
@@ -3655,7 +3655,7 @@ ethernet@6b00000 {
 				 <&bpmp TEGRA234_CLK_MGBE3_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE3_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE3_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE3_MAC>,
-- 
2.53.0



