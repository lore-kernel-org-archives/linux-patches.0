Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BCB148832;
	Fri,  6 Dec 2024 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496904; cv=none; b=EHVYdY6x03lMHvFiMsaNFJ6lnJoeDq6H8NBAjHqbinxDJBwfOMp5bmySPWaRwm7OErRF2yuqSZ3CRAwq3cH3vSDvBuoMUpelKrDIT8USz++lXzv1LroI1fJT6NoI/3ilTmNn7ozxGAocTz8Lj0OWPE4d9sMSDTflfFjZeEI+mVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496904; c=relaxed/simple;
	bh=1jb1+ckksGhEeVBKmtWmt7KXCRr7ih51V+Wv/X6rwwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E282ffyPeQjcyeqr512LAZE3fgclNReM8ZFDzvWvJR9SbuXhfXYlbJzHKtJCY7sHIYVH8YC48vxLLnyWuKbTbrovThTUvf9J2Hvaup+HzNMtwsHjNmEmXxyr7qIg617fUEABVShmL57Cn3kdShhKzH+hzqUx+Kv2zyMfg/FsAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kx6CwAzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kx6CwAzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524C1C4CED1;
	Fri,  6 Dec 2024 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496903;
	bh=1jb1+ckksGhEeVBKmtWmt7KXCRr7ih51V+Wv/X6rwwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx6CwAzY+yxJMg8XXLXu2xHMBPJdT6c08HjEirGoq66ju9+cFX1DCLEj+P2/l/vqo
	 3hehv/wiQOqMpxGkFwP+h8v9l8CcHsGyOtEnH3aB/URkusertw/NRXRTeIJdkBjYKn
	 cQtotMYgZ9D5qdASbD5FMXOxM2N9u/8fKDg+bI+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/676] arm64: dts: ti: k3-j7200: use ti,j7200-padconf compatible
Date: Fri,  6 Dec 2024 15:29:17 +0100
Message-ID: <20241206143658.746284550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit 4eb42afed5d488c4707be5362e8e0f0771f5218e ]

For suspend to ram on j7200, use ti,j7200-padconf compatible to save and
restore pinctrl contexts.

Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20231128-j7200-pinctrl-s2r-v1-3-704e7dc24460@bootlin.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: b7af8b4acb3e ("arm64: dts: ti: k3-j7200: Fix register map for main domain pmx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi       |  8 ++++----
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index cdb1d6b2a9829..484254a68d9da 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -395,7 +395,7 @@ cpts@3d000 {
 
 	/* TIMERIO pad input CTRLMMR_TIMER*_CTRL registers */
 	main_timerio_input: pinctrl@104200 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		reg = <0x0 0x104200 0x0 0x50>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
@@ -404,7 +404,7 @@ main_timerio_input: pinctrl@104200 {
 
 	/* TIMERIO pad output CTCTRLMMR_TIMERIO*_CTRL registers */
 	main_timerio_output: pinctrl@104280 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		reg = <0x0 0x104280 0x0 0x20>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
@@ -412,7 +412,7 @@ main_timerio_output: pinctrl@104280 {
 	};
 
 	main_pmx0: pinctrl@11c000 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x11c000 0x00 0x10c>;
 		#pinctrl-cells = <1>;
@@ -421,7 +421,7 @@ main_pmx0: pinctrl@11c000 {
 	};
 
 	main_pmx1: pinctrl@11c11c {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x11c11c 0x00 0xc>;
 		#pinctrl-cells = <1>;
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index 6ffaf85fa63f5..e5c35a53bb499 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -185,7 +185,7 @@ chipid@43000014 {
 
 	/* MCU_TIMERIO pad input CTRLMMR_MCU_TIMER*_CTRL registers */
 	mcu_timerio_input: pinctrl@40f04200 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		reg = <0x0 0x40f04200 0x0 0x28>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
@@ -195,7 +195,7 @@ mcu_timerio_input: pinctrl@40f04200 {
 
 	/* MCU_TIMERIO pad output CTRLMMR_MCU_TIMERIO*_CTRL registers */
 	mcu_timerio_output: pinctrl@40f04280 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		reg = <0x0 0x40f04280 0x0 0x28>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
@@ -204,7 +204,7 @@ mcu_timerio_output: pinctrl@40f04280 {
 	};
 
 	wkup_pmx0: pinctrl@4301c000 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x4301c000 0x00 0x34>;
 		#pinctrl-cells = <1>;
@@ -213,7 +213,7 @@ wkup_pmx0: pinctrl@4301c000 {
 	};
 
 	wkup_pmx1: pinctrl@4301c038 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x4301c038 0x00 0x8>;
 		#pinctrl-cells = <1>;
@@ -222,7 +222,7 @@ wkup_pmx1: pinctrl@4301c038 {
 	};
 
 	wkup_pmx2: pinctrl@4301c068 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x4301c068 0x00 0xec>;
 		#pinctrl-cells = <1>;
@@ -231,7 +231,7 @@ wkup_pmx2: pinctrl@4301c068 {
 	};
 
 	wkup_pmx3: pinctrl@4301c174 {
-		compatible = "pinctrl-single";
+		compatible = "ti,j7200-padconf", "pinctrl-single";
 		/* Proxy 0 addressing */
 		reg = <0x00 0x4301c174 0x00 0x20>;
 		#pinctrl-cells = <1>;
-- 
2.43.0



