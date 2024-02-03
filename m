Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EC21640B;
	Sat,  3 Feb 2024 04:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933807; cv=none; b=aHgW5MAYG7ess9Cgrb9UAmxL3j73SXmI66NT+qrOXGWzuNkxUU83JWI/jiTHL9tUvJTTJtez6uQrYcEyeosAFyST33+gRfev0tw3XmyDd21rk3b08EIDPxRmpN6/uUXnMAqcM6xBwHG9UabMHGv2M/3sZoJUHiiqNjHvX3THRHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933807; c=relaxed/simple;
	bh=mizRyWaMEEHmOjnXSGyknIujomLzXcrbe6ChKdaC0vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFgG77kEPbiv8dWhvGav/AGCrXfuXa+3B25J/0YUMeykciOQ2g2jDmDFSmzXFbB3WAjIdOB2DDGrppWrXafkfLLb/MW2zd1jRY52tPQRTYn5R3eS3FDvP9nftwbnWlRt2QKSVG41HvlCx+GRBf2/lGFzpNI4vzqh+xLlzXWWtlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alyvqLWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alyvqLWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C149AC43390;
	Sat,  3 Feb 2024 04:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933806;
	bh=mizRyWaMEEHmOjnXSGyknIujomLzXcrbe6ChKdaC0vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=alyvqLWsdnD5efgfQbaxfavoth7fLCcXsD1YR3QmHsPnY0MsMSCYuvGJgXFRL1ixA
	 qHmn6HlT+8OKt58iK7ZngYMUeI9JmwrNGA3rQ42eSUJHI/5Wsp/TIv0UBncQDIevUK
	 kwgi3aWpmkwX1+6E7+lPKqsja/Bes/ZmRYKqnQd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 122/353] ARM: dts: imx25/27: Pass timing0
Date: Fri,  2 Feb 2024 20:04:00 -0800
Message-ID: <20240203035407.604399538@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 11ab7ad6f795ae23c398a4a5c56505d3dab27c4c ]

Per display-timings.yaml, the 'timing' pattern should be used to
describe the display timings.

Change it accordingly to fix the following dt-schema warning:

imx27-apf27dev.dtb: display-timings: '800x480' does not match any of the regexes: '^timing', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/display/panel/display-timings.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts   | 2 +-
 .../dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts   | 2 +-
 .../dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts    | 2 +-
 arch/arm/boot/dts/nxp/imx/imx25-pdk.dts                         | 2 +-
 arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts                    | 2 +-
 arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts  | 2 +-
 arch/arm/boot/dts/nxp/imx/imx27-phytec-phycard-s-rdk.dts        | 2 +-
 arch/arm/boot/dts/nxp/imx/imx27-phytec-phycore-rdk.dts          | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
index fc8a502fc957..6cddb2cc36fe 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&qvga_timings>;
-			qvga_timings: 320x240 {
+			qvga_timings: timing0 {
 				clock-frequency = <6500000>;
 				hactive = <320>;
 				vactive = <240>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
index 80a7f96de4c6..64b2ffac463b 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&dvi_svga_timings>;
-			dvi_svga_timings: 800x600 {
+			dvi_svga_timings: timing0 {
 				clock-frequency = <40000000>;
 				hactive = <800>;
 				vactive = <600>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
index 24027a1fb46d..fb074bfdaa8d 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&dvi_vga_timings>;
-			dvi_vga_timings: 640x480 {
+			dvi_vga_timings: timing0 {
 				clock-frequency = <31250000>;
 				hactive = <640>;
 				vactive = <480>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx25-pdk.dts b/arch/arm/boot/dts/nxp/imx/imx25-pdk.dts
index 04f4b127a172..e93bf3b7115f 100644
--- a/arch/arm/boot/dts/nxp/imx/imx25-pdk.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx25-pdk.dts
@@ -68,7 +68,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&wvga_timings>;
-			wvga_timings: 640x480 {
+			wvga_timings: timing0 {
 				hactive = <640>;
 				vactive = <480>;
 				hback-porch = <45>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
index a21f1f7c24b8..f047a8487073 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
@@ -16,7 +16,7 @@
 		fsl,pcr = <0xfae80083>;	/* non-standard but required */
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 800x480 {
+			timing0: timing0 {
 				clock-frequency = <33000033>;
 				hactive = <800>;
 				vactive = <480>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
index 145e459625b3..d78793601306 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
@@ -16,7 +16,7 @@
 
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 320x240 {
+			timing0: timing0 {
 				clock-frequency = <6500000>;
 				hactive = <320>;
 				vactive = <240>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycard-s-rdk.dts b/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycard-s-rdk.dts
index 25442eba21c1..27c93b9fe049 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycard-s-rdk.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycard-s-rdk.dts
@@ -19,7 +19,7 @@
 		fsl,pcr = <0xf0c88080>;	/* non-standard but required */
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 640x480 {
+			timing0: timing0 {
 				hactive = <640>;
 				vactive = <480>;
 				hback-porch = <112>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycore-rdk.dts b/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycore-rdk.dts
index 7f0cd4d3ec2d..67b235044b70 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycore-rdk.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-phytec-phycore-rdk.dts
@@ -19,7 +19,7 @@
 
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 240x320 {
+			timing0: timing0 {
 				clock-frequency = <5500000>;
 				hactive = <240>;
 				vactive = <320>;
-- 
2.43.0



