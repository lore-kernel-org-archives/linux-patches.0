Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E7C2D5436;
	Tue, 21 Jul 2026 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655635; cv=none; b=err/4ifJJDiQb6MXR8pwDyGHlBGznXN7V75+Vng9S4hsB1wQ0RWNtjo8qKwyhtNlwrcorHMpKJpgBL6gSOAamCHhOAT1M7NrwWIOkXoGxH+EOuYYsf5jBrWs/jg6g3P7Xxx3VWhLtwasnMd2W2tz04eaBzWDBMBm0lUmIZvf5Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655635; c=relaxed/simple;
	bh=JhK7KyWCjdB4KZmugMj2/gXZNWT8wnxpHBiYBzKrZRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMawCDoqNjiVfuT/HAau86VK6Pcp7YuVbed8IrHsQfDMrEn61bRZMB3uXuuIi3cBZf+sPTiOAcb2p5vPu+hvsPZPg7YgqJF3rI617h2QM8lKcIpqv3Oy8pmujBPBrzoLNXQBHlYQ6Rj/C2JHT9E1Dnh7arbfowxiE0/g7CP0jD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjexyedN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjexyedN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6741C1F000E9;
	Tue, 21 Jul 2026 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655633;
	bh=8B6o/cHVXxVC2vFM/K2cAyw5gA1qull1JzYgMpcrQjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjexyedNKcaTT/1e/uI7KdLwlb0BQVxQkRFQqcZfeS8CyQSieNC9ErRpANydi9OOw
	 BJHLBNVQJorRJD5vOfOHQPD12JoTw4uNDd6DukarG82MnOK8GP9HRf0UzBGjiAgQY1
	 ONAyPzduF6XSpxgihd105G4/8pDxJTnZulntMV+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0082/1611] arm64: tegra: Fix Tegra234 MGBE PTP clock
Date: Tue, 21 Jul 2026 17:03:18 +0200
Message-ID: <20260721152516.690559553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5657045c53d90d..5b245977d6a037 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3602,7 +3602,7 @@ ethernet@6800000 {
 				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
@@ -3644,7 +3644,7 @@ ethernet@6900000 {
 				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE1_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE1_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE1_MAC>,
@@ -3686,7 +3686,7 @@ ethernet@6a00000 {
 				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS_M>,
 				 <&bpmp TEGRA234_CLK_MGBE2_RX_PCS>,
 				 <&bpmp TEGRA234_CLK_MGBE2_TX_PCS>;
-			clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+			clock-names = "mgbe", "mac", "mac-divider", "ptp_ref", "rx-input-m",
 				      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
 				      "rx-pcs", "tx-pcs";
 			resets = <&bpmp TEGRA234_RESET_MGBE2_MAC>,
@@ -3728,7 +3728,7 @@ ethernet@6b00000 {
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



