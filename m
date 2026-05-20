Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D090236D9EA;
	Wed, 20 May 2026 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295930; cv=none; b=C1EnDoVJyP2Xnp02qNMQuLh9mBZw8LzJw8nuEa+f+wEqd0tUbVbYb/CE3XnDnGp9clyDzXpruQ+mYt5CbmSr7pXA6ELFRlHfj+qU+3LlRxpVLjG4ooAopJFuwSMai84SRHqFmvpntBGCEFrRoecALVuYqVhEQBpVi5X/sUnAiao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295930; c=relaxed/simple;
	bh=BnUBuzjxfvNOjbivFtg7rqnNU9XNW8kZL2xwLoZ93wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1q6v5AYxSZPagTjnrl9wr7HHoDt9oTKgYU3s/zTgFvd/TrM/DqWTxuivpZyx4lmXJVEmccHPQNymRaqc6ul4uLPctxMfV2nbr5DCt1dmP+R3UPpJvH4yi8vgbJXLh4D2gESazgMZzjKh6IG3/GCH3JjI0ZxRS3qLHwP4VaSSmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoKF5U3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoKF5U3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6191F00893;
	Wed, 20 May 2026 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295928;
	bh=Vm64RBOTgx6bfKNjcUB/pOPS1lNPqk9WWXfNcVHEb+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoKF5U3CnVntRc9/VX58rHO7ftczlbMjeVSX9F9VzzMguui1Bc/fn8qbliXLnWQs1
	 9FBXrFiX3ccEyi9kk8xrq3WcUrndW8I9q4bC0PCCct7Ji4lwPWYhCMvKq7UhiIPGQE
	 QxerMaOWiP993jhlbRNu7VGRekyfHCpEtPKALwuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0566/1146] ARM: dts: imx27-eukrea: replace interrupts with interrupts-extended
Date: Wed, 20 May 2026 18:13:36 +0200
Message-ID: <20260520162200.994349775@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 0477a6b31e2874e554e3bcfac9883684b8f8ca2d ]

The property interrupts use default interrupt controllers. But pass down
gpio<n> as phandle. Correct it by use interrupts-extended.

Fixes: d8cae888aa2bc ("ARM: dts: Add support for the cpuimx27 board from Eukrea and its baseboard")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi      | 8 ++++----
 .../boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
index c7e9235848782..9f0e65526d5f9 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi
@@ -106,7 +106,7 @@ uart8250@3,200000 {
 		compatible = "ns8250";
 		clocks = <&clk14745600>;
 		fsl,weim-cs-timing = <0x0000d603 0x0d1d0d01 0x00d20000>;
-		interrupts = <&gpio2 23 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio2 23 IRQ_TYPE_LEVEL_LOW>;
 		reg = <3 0x200000 0x1000>;
 		reg-shift = <1>;
 		reg-io-width = <1>;
@@ -119,7 +119,7 @@ uart8250@3,400000 {
 		compatible = "ns8250";
 		clocks = <&clk14745600>;
 		fsl,weim-cs-timing = <0x0000d603 0x0d1d0d01 0x00d20000>;
-		interrupts = <&gpio2 22 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio2 22 IRQ_TYPE_LEVEL_LOW>;
 		reg = <3 0x400000 0x1000>;
 		reg-shift = <1>;
 		reg-io-width = <1>;
@@ -132,7 +132,7 @@ uart8250@3,800000 {
 		compatible = "ns8250";
 		clocks = <&clk14745600>;
 		fsl,weim-cs-timing = <0x0000d603 0x0d1d0d01 0x00d20000>;
-		interrupts = <&gpio2 27 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio2 27 IRQ_TYPE_LEVEL_LOW>;
 		reg = <3 0x800000 0x1000>;
 		reg-shift = <1>;
 		reg-io-width = <1>;
@@ -145,7 +145,7 @@ uart8250@3,1000000 {
 		compatible = "ns8250";
 		clocks = <&clk14745600>;
 		fsl,weim-cs-timing = <0x0000d603 0x0d1d0d01 0x00d20000>;
-		interrupts = <&gpio2 30 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio2 30 IRQ_TYPE_LEVEL_LOW>;
 		reg = <3 0x1000000 0x1000>;
 		reg-shift = <1>;
 		reg-io-width = <1>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
index d78793601306c..c71f802983304 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts
@@ -76,7 +76,7 @@ ads7846@0 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_touch>;
 		reg = <0>;
-		interrupts = <&gpio4 25 IRQ_TYPE_LEVEL_LOW>;
+		interrupts-extended = <&gpio4 25 IRQ_TYPE_LEVEL_LOW>;
 		spi-cpol;
 		spi-max-frequency = <1500000>;
 		ti,keep-vref-on;
-- 
2.53.0



