Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05786183CD5;
	Tue, 30 Jul 2024 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355667; cv=none; b=GdbDuA6R+NWGbqXWI0JqJEg7GUCACuHbzyagaZ6gbs30Txq9GT5Q0ez++P1TFj6DIethSVh4vxMnVO2IUEox3MODb5O6cS4aoEmJgkf7d1ko5CtJrNJiR8OhD9OWxjlV7ooV+ckf5oUvE8AsCd1yWdS7u9trQOgzxNFW+lmIGqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355667; c=relaxed/simple;
	bh=kDl+jRaJUSe3t746bjzJXRzDGxUHCeBlZEIPAMvL1UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj2IBbmW7++iCqGdl61CeTrEIPg7SEkgNsFibPrlt9yQy4y0rpDIC2Utdmo/ppqZRQxqYc7VA3kPoCaGriCgnOFtN6hsL9D9//8+mCO8t58Bx+veacHMWJoIF8cDcRSX3lt/9NNrpHO5E0CApy/5dKxFCBVS8hNd1HJvMV6olYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeWvnPuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeWvnPuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD50C32782;
	Tue, 30 Jul 2024 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355666;
	bh=kDl+jRaJUSe3t746bjzJXRzDGxUHCeBlZEIPAMvL1UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeWvnPuOg8gM32WY+zzXtTOIrdNRfnqDgGIzW9uRvU/cZMGGfqKglX0Zg4vFDtVZl
	 vrOsr3ImkUajBGqvGDDqHMdJPPC334P1uzVZgfkAsoz5s/1WDyUBJZGVDEnIRbrvxR
	 yT3XpUAepcMP0aYWLYdTAASRU2GTurlAdLalHl1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/568] arm64: dts: amlogic: setup hdmi system clock
Date: Tue, 30 Jul 2024 17:43:06 +0200
Message-ID: <20240730151642.949895254@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 1443b6ea806dfcdcee6c894784332c9c947ac319 ]

HDMI Tx needs the system clock set on the xtal rate.
This clock is managed by the main clock controller of the related SoCs.

Currently 2 part of the display drivers race to setup the HDMI system
clock by directly poking the controller register. The clock API should
be used to setup the rate instead.

Use assigned-clock to setup the HDMI system clock.

Fixes: 6939db7e0dbf ("ARM64: dts: meson-gx: Add support for HDMI output")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240626152733.1350376-3-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 5 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi       | 5 +++++
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi        | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index ff68b911b7297..0ff0d090548d0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -215,6 +215,11 @@ hdmi_tx: hdmi-tx@0 {
 				#sound-dai-cells = <0>;
 				status = "disabled";
 
+				assigned-clocks = <&clkc CLKID_HDMI_SEL>,
+						  <&clkc CLKID_HDMI>;
+				assigned-clock-parents = <&xtal>, <0>;
+				assigned-clock-rates = <0>, <24000000>;
+
 				/* VPU VENC Input */
 				hdmi_tx_venc_port: port@0 {
 					reg = <0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 041c37b809f27..ed00e67e6923a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -316,6 +316,11 @@ &hdmi_tx {
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
 	power-domains = <&pwrc PWRC_GXBB_VPU_ID>;
+
+	assigned-clocks = <&clkc CLKID_HDMI_SEL>,
+			  <&clkc CLKID_HDMI>;
+	assigned-clock-parents = <&xtal>, <0>;
+	assigned-clock-rates = <0>, <24000000>;
 };
 
 &sysctrl {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 067108800a58d..f58d1790de1cb 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -328,6 +328,11 @@ &hdmi_tx {
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
 	power-domains = <&pwrc PWRC_GXBB_VPU_ID>;
+
+	assigned-clocks = <&clkc CLKID_HDMI_SEL>,
+			  <&clkc CLKID_HDMI>;
+	assigned-clock-parents = <&xtal>, <0>;
+	assigned-clock-rates = <0>, <24000000>;
 };
 
 &sysctrl {
-- 
2.43.0



