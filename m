Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7C183CD5;
	Tue, 30 Jul 2024 16:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355656; cv=none; b=ThQn7aWyT7wx6nW5dqz0by6NHp27nCDi+myi/niigrHLnwAYGqLdKmpqYAMu8L3RoW7KzQYsxnwamC4o4mZ9HZJYIGcVEh/O/clA79aF2V5bXro8+clJdHSYyMjsOLMXE0F3HBubVK2x2hZwLhIZu1nGUyAM8eYO9fTB8NYz1pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355656; c=relaxed/simple;
	bh=j1mU/lFA4tRN7hG0jG0gW4CfGYCPHmQ4sE04G7tS+RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bz1IKCZ1JtkQRqQPc91W/W6zEaE9M+jKX5JCmIzMAYr9OfFwr+pcFWi5e0J5YYlTMfeWh+zkvavsvEXrIiysDVSFL0p6HvDpemGfkYJBk7sORg7t3dkrL9QDg0hEQL5adFEhvmv/N+YmpBpw78WBVEVcTZsBR4fTJRt8b+6+/kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCExj5WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCExj5WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD3CC32782;
	Tue, 30 Jul 2024 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355656;
	bh=j1mU/lFA4tRN7hG0jG0gW4CfGYCPHmQ4sE04G7tS+RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCExj5WKvr4pyBk9/+3gJ+lsXpFJyVzq1729w1kos84lGzRkN25cXFZtBcvt74VEX
	 5FmBfmYWoZKBmXRQLL/b/JqdrLeP4PC69/EF/l8RQ89IKRH2WnSjKdU5JUjUqJCPUK
	 iO6ZeygnRNDT/OlcwChxmphIBOmTy/TXpg4tOUiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/568] arm64: dts: amlogic: add power domain to hdmitx
Date: Tue, 30 Jul 2024 17:43:05 +0200
Message-ID: <20240730151642.911036650@linuxfoundation.org>
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

[ Upstream commit f1ab099d6591a353899a2ee09c89de0fc908e2d2 ]

HDMI Tx needs HDMI Tx memory power domain turned on. This power domain is
handled under the VPU power domain.

The HDMI Tx currently works because it is enabling the PD by directly
poking the power controller register. It is should not do that but properly
use the power domain controller.

Fix this by adding the power domain to HDMI Tx.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20240625145017.1003346-3-jbrunet@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Stable-dep-of: 1443b6ea806d ("arm64: dts: amlogic: setup hdmi system clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12.dtsi  | 4 ++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 1 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 1 +
 arch/arm64/boot/dts/amlogic/meson-sm1.dtsi  | 4 ++++
 4 files changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12.dtsi
index 6a1f4dcf64885..7b655e07e80cf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12.dtsi
@@ -367,6 +367,10 @@ &ethmac {
 	power-domains = <&pwrc PWRC_G12A_ETH_ID>;
 };
 
+&hdmi_tx {
+	power-domains = <&pwrc PWRC_G12A_VPU_ID>;
+};
+
 &vpu {
 	power-domains = <&pwrc PWRC_G12A_VPU_ID>;
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index a15c1ef30a88b..041c37b809f27 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -315,6 +315,7 @@ &hdmi_tx {
 		 <&clkc CLKID_HDMI_PCLK>,
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
+	power-domains = <&pwrc PWRC_GXBB_VPU_ID>;
 };
 
 &sysctrl {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index a53b38045b3d2..067108800a58d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -327,6 +327,7 @@ &hdmi_tx {
 		 <&clkc CLKID_HDMI_PCLK>,
 		 <&clkc CLKID_GCLK_VENCI_INT0>;
 	clock-names = "isfr", "iahb", "venci";
+	power-domains = <&pwrc PWRC_GXBB_VPU_ID>;
 };
 
 &sysctrl {
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
index fcaa1a273829c..13e742ba00bea 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1.dtsi
@@ -518,6 +518,10 @@ &gpio_intc {
 		     "amlogic,meson-gpio-intc";
 };
 
+&hdmi_tx {
+	power-domains = <&pwrc PWRC_SM1_VPU_ID>;
+};
+
 &pcie {
 	power-domains = <&pwrc PWRC_SM1_PCIE_ID>;
 };
-- 
2.43.0



