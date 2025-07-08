Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAB08F5E;
	Tue,  8 Jul 2025 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993428; cv=none; b=F5Qk1RV6vEAS/GtEZ1BThem/PxeBeAoTFOYw79cYOiAHbuzX2VndZi2UQwKFWJJezZYMcgA92gYt1J+DhC8lRB6QevrjRPgguMGjYO4ZyqPd5dWm9fMwHKtcmmk3vT+Hxr970xhdy/NB+tGnFwEr1y3GDHbuACoCQhKuzM/hwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993428; c=relaxed/simple;
	bh=peQ/0zPOJXxLvNmH/Uc8HM6jfIkFpaMOXW3VQpy5v/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTKCyOPWdFs2KOo/3ZFVYiI8CqJgmnXvp3IOZpVo3GjrG9Xv3+vHXyxlAlnsXwen/ETd3HTmS/W5I1UgzMo4e3zrfWQM3c49BR32xlYHmRqDMPMk71JpIJnVqzrd3dZD8QBrParx4GhbUenptxdO3liEVruee5CumfCGWT8SUU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6DScqXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6DScqXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16553C4CEED;
	Tue,  8 Jul 2025 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993428;
	bh=peQ/0zPOJXxLvNmH/Uc8HM6jfIkFpaMOXW3VQpy5v/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6DScqXlz7qW0RSg6iyV1pxqOPi+Vzb5WIIurdbWFncCDXBCrhNneGYOuagSKPIlr
	 IVlmrs5GtaypbB6vO8PzZXP7wZF5mvLRNjk4mSvEzMKaurW2RsXiKjeO1SBg6xueYc
	 AFEVCMAoXdTNNjkeUFH2o2J80JSg3ZJBmmJXimt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 041/178] arm64: dts: apple: Move touchbar mipi {address,size}-cells from dtsi to dts
Date: Tue,  8 Jul 2025 18:21:18 +0200
Message-ID: <20250708162237.752947861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: Sven Peter <sven@kernel.org>

[ Upstream commit 08a0d93c353bd55de8b5fb77b464d89425be0215 ]

Move the {address,size}-cells property from the (disabled) touchbar screen
mipi node inside the dtsi file to the model-specific dts file where it's
enabled to fix the following W=1 warnings:

t8103.dtsi:404.34-433.5: Warning (avoid_unnecessary_addr_size): /soc/dsi@228600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" property
t8112.dtsi:419.34-448.5: Warning (avoid_unnecessary_addr_size): /soc/dsi@228600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" property

Fixes: 7275e795e520 ("arm64: dts: apple: Add touchbar screen nodes")
Reviewed-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250611-display-pipe-mipi-warning-v1-1-bd80ba2c0eea@kernel.org
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103-j293.dts | 2 ++
 arch/arm64/boot/dts/apple/t8103.dtsi     | 2 --
 arch/arm64/boot/dts/apple/t8112-j493.dts | 2 ++
 arch/arm64/boot/dts/apple/t8112.dtsi     | 2 --
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
index e2d9439397f71..5b3c42e9f0e67 100644
--- a/arch/arm64/boot/dts/apple/t8103-j293.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
@@ -100,6 +100,8 @@ dfr_mipi_out_panel: endpoint@0 {
 
 &displaydfr_mipi {
 	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	dfr_panel: panel@0 {
 		compatible = "apple,j293-summit", "apple,summit";
diff --git a/arch/arm64/boot/dts/apple/t8103.dtsi b/arch/arm64/boot/dts/apple/t8103.dtsi
index 97b6a067394e3..229b10efaab9e 100644
--- a/arch/arm64/boot/dts/apple/t8103.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103.dtsi
@@ -404,8 +404,6 @@ displaydfr_mipi: dsi@228600000 {
 			compatible = "apple,t8103-display-pipe-mipi", "apple,h7-display-pipe-mipi";
 			reg = <0x2 0x28600000 0x0 0x100000>;
 			power-domains = <&ps_mipi_dsi>;
-			#address-cells = <1>;
-			#size-cells = <0>;
 			status = "disabled";
 
 			ports {
diff --git a/arch/arm64/boot/dts/apple/t8112-j493.dts b/arch/arm64/boot/dts/apple/t8112-j493.dts
index be86d34c6696c..fb8ad7d4c65a8 100644
--- a/arch/arm64/boot/dts/apple/t8112-j493.dts
+++ b/arch/arm64/boot/dts/apple/t8112-j493.dts
@@ -63,6 +63,8 @@ dfr_mipi_out_panel: endpoint@0 {
 
 &displaydfr_mipi {
 	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	dfr_panel: panel@0 {
 		compatible = "apple,j493-summit", "apple,summit";
diff --git a/arch/arm64/boot/dts/apple/t8112.dtsi b/arch/arm64/boot/dts/apple/t8112.dtsi
index d9b966d68e4fa..7488e3850493b 100644
--- a/arch/arm64/boot/dts/apple/t8112.dtsi
+++ b/arch/arm64/boot/dts/apple/t8112.dtsi
@@ -420,8 +420,6 @@ displaydfr_mipi: dsi@228600000 {
 			compatible = "apple,t8112-display-pipe-mipi", "apple,h7-display-pipe-mipi";
 			reg = <0x2 0x28600000 0x0 0x100000>;
 			power-domains = <&ps_mipi_dsi>;
-			#address-cells = <1>;
-			#size-cells = <0>;
 			status = "disabled";
 
 			ports {
-- 
2.39.5



