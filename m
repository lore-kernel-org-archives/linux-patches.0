Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AAF134D9;
	Sat,  3 Feb 2024 04:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933370; cv=none; b=s700dz++7/fcPcFsHTXfNh9JU4nozLRwkfY1Td+qxl91iq5uHIwvubpnzLMC+gIYUDSag9l49c481VjIQ/5bPGdUszlYW2xDl6I+GS/9IX8OOOhdS2g0y7wL74J/T9piYf1CF3QoIw93DAhRG+Nx/agZvIhBeW3mmgbzKpTnbmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933370; c=relaxed/simple;
	bh=BDi2W4RLrcEuBmSzBdgVfo9yPgnjQtHWk4B3ThVI0qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uioyAXITKWlXh+h6nKo0htpQGZUM5n2jXKl+P+gfs4kaTmK6OSq5cTHDNH0SN3wLAFeknEHnWS+62qfAlOVGntjzO8u15kWAbsrnPIuaD3qKVYqdDVPS27l13iTmhX7vCsgJfmIdbVAo62itiSdYRgSMahAZSN0eUNXtlQ2HeTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbchAoTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbchAoTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E655C433C7;
	Sat,  3 Feb 2024 04:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933370;
	bh=BDi2W4RLrcEuBmSzBdgVfo9yPgnjQtHWk4B3ThVI0qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbchAoTe/G+1oVey87UeqvBPjkc84Goa+pwHqoZaOheSrlzG+S8+0PbDHPGlpJClA
	 QZ0+58Z5F5q0fsr/Pl4Z6lKS7c2nmNoJETAA8hUcz2A2Fk1ykyp+fUwyvHhCnLMYHN
	 UklZEfUhnUf5iGCiUei6S9lmGKntpieFL2/S9kYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/219] ARM: dts: imx25/27: Pass timing0
Date: Fri,  2 Feb 2024 20:04:11 -0800
Message-ID: <20240203035328.022727932@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts | 2 +-
 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts | 2 +-
 arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts  | 2 +-
 arch/arm/boot/dts/imx25-pdk.dts                                 | 2 +-
 arch/arm/boot/dts/imx27-apf27dev.dts                            | 2 +-
 arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts          | 2 +-
 arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts                | 2 +-
 arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts                  | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
index 7d4301b22b90..1ed3fb7b9ce6 100644
--- a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
+++ b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-cmo-qvga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&qvga_timings>;
-			qvga_timings: 320x240 {
+			qvga_timings: timing0 {
 				clock-frequency = <6500000>;
 				hactive = <320>;
 				vactive = <240>;
diff --git a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
index 80a7f96de4c6..64b2ffac463b 100644
--- a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
+++ b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-svga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&dvi_svga_timings>;
-			dvi_svga_timings: 800x600 {
+			dvi_svga_timings: timing0 {
 				clock-frequency = <40000000>;
 				hactive = <800>;
 				vactive = <600>;
diff --git a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
index 24027a1fb46d..fb074bfdaa8d 100644
--- a/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
+++ b/arch/arm/boot/dts/imx25-eukrea-mbimxsd25-baseboard-dvi-vga.dts
@@ -16,7 +16,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&dvi_vga_timings>;
-			dvi_vga_timings: 640x480 {
+			dvi_vga_timings: timing0 {
 				clock-frequency = <31250000>;
 				hactive = <640>;
 				vactive = <480>;
diff --git a/arch/arm/boot/dts/imx25-pdk.dts b/arch/arm/boot/dts/imx25-pdk.dts
index fb66884d8a2f..59b40d13a640 100644
--- a/arch/arm/boot/dts/imx25-pdk.dts
+++ b/arch/arm/boot/dts/imx25-pdk.dts
@@ -78,7 +78,7 @@
 		bus-width = <18>;
 		display-timings {
 			native-mode = <&wvga_timings>;
-			wvga_timings: 640x480 {
+			wvga_timings: timing0 {
 				hactive = <640>;
 				vactive = <480>;
 				hback-porch = <45>;
diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index 6f1e8ce9e76e..68fcb5ce9a9e 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -16,7 +16,7 @@
 		fsl,pcr = <0xfae80083>;	/* non-standard but required */
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 800x480 {
+			timing0: timing0 {
 				clock-frequency = <33000033>;
 				hactive = <800>;
 				vactive = <480>;
diff --git a/arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts b/arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts
index 9c3ec82ec7e5..50fa0bd4c8a1 100644
--- a/arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts
+++ b/arch/arm/boot/dts/imx27-eukrea-mbimxsd27-baseboard.dts
@@ -16,7 +16,7 @@
 
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 320x240 {
+			timing0: timing0 {
 				clock-frequency = <6500000>;
 				hactive = <320>;
 				vactive = <240>;
diff --git a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
index 188639738dc3..7f36af150a25 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
+++ b/arch/arm/boot/dts/imx27-phytec-phycard-s-rdk.dts
@@ -19,7 +19,7 @@
 		fsl,pcr = <0xf0c88080>;	/* non-standard but required */
 		display-timings {
 			native-mode = <&timing0>;
-			timing0: 640x480 {
+			timing0: timing0 {
 				hactive = <640>;
 				vactive = <480>;
 				hback-porch = <112>;
diff --git a/arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts b/arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts
index 344e77790152..d133b9f08b3a 100644
--- a/arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts
+++ b/arch/arm/boot/dts/imx27-phytec-phycore-rdk.dts
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



