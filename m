Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7B12E11BF;
	Tue, 12 Aug 2025 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025683; cv=none; b=E+CsMPugi+nZ4KrbEuZ0bz8h5EFiSSh9CsVE/eoGmjfQ6TSF12uFjWo7QZ0/TyHzsI/QJSm/+LQZiuF8uo+gq29sG70EaWv69d1tI6PlDiu31Dro65/LoXMr6P68L6xae2iiyjJMoRjlwdwByvVgJSix0A2PJEC+jHwnSdUrey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025683; c=relaxed/simple;
	bh=w+tLfne1CBczTofRgYANJ0rTnWdfOOs6RBwPjNkid8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GalAr8sqaOJB80bvMELBMIIh+Id8ws7jIOg8sXFtuixn9UjIcUdRP3P8pgzH13KZHPMfUdOMXevAlooG3MLEHlYwR3YWtf0p32lXYUepRo2AcC40YAGfFoBw8xxZwf67NEiPKww0RUh84Cm9ig0sAQkPeLsGAOaaXJz41/ljaGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liVAFhCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liVAFhCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0B8C4CEF0;
	Tue, 12 Aug 2025 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025683;
	bh=w+tLfne1CBczTofRgYANJ0rTnWdfOOs6RBwPjNkid8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liVAFhCVReCWFZvsHgzq0AdFSaXI9ethJ9fcu+GA5zFu91gFJdxiVaffBuKqztsL7
	 QQQfx408tJn3oJAmsCcxnMgQKMGnpxzMi4EVJKx6fJrcbEOWIXnSweBUsJSyx6O1/v
	 +UdZMeKqWfuwcx2sK21jBVcbKNNv/gwLWK/W/C7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 080/480] arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed
Date: Tue, 12 Aug 2025 19:44:48 +0200
Message-ID: <20250812174400.751637416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit e16ad6c79906bba5e2ac499492b6a5b29ab19d6c ]

The reference manual for the i.MX8MN states the clock rate in
MMC mode is 1/2 of the input clock, therefore to properly run
at HS400 rates, the input clock must be 400MHz to operate at
200MHz.  Currently the clock is set to 200MHz which is half the
rate it should be, so the throughput is half of what it should be
for HS400 operation.

Fixes: 36ca3c8ccb53 ("arm64: dts: imx: Add Beacon i.MX8M Nano development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index bb11590473a4..353d0c9ff35c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -297,6 +297,8 @@ &usdhc3 {
 	pinctrl-0 = <&pinctrl_usdhc3>;
 	pinctrl-1 = <&pinctrl_usdhc3_100mhz>;
 	pinctrl-2 = <&pinctrl_usdhc3_200mhz>;
+	assigned-clocks = <&clk IMX8MN_CLK_USDHC3>;
+	assigned-clock-rates = <400000000>;
 	bus-width = <8>;
 	non-removable;
 	status = "okay";
-- 
2.39.5



