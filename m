Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF6718E028;
	Tue, 30 Jul 2024 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356095; cv=none; b=cW9eOwQdsNJjUUz5pJRg0xpmgISfoSgMT1EttLtpSYOhtIsh8f98SQdGxcd89MkROb1zvTFLmdW/LJnUi49XW5MDzC81QxPGc1QtJqAaxLQ9nIRrfECpg9CcxyQGlLYE4Wl9CqIHck8VQGL3VWG+t5e5zt7GqKU0w2O4QJhUhrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356095; c=relaxed/simple;
	bh=YmvbVkV+PUVlbp5CfGGrgSAzwDvEpCwqRgp5gSKzofM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJbl9Tt/sk1OEPA0tGVslw5l1aTJ4w/x/qFYeFdkpaj+8CSBIQWi52jxq6zGA6VivQIS5bNdXR+NNbxCU526th+J3DODo/ePJ5jFwJHvyTX7azGTi8QfUAR+4Xa7fixwhcEoMu8FBceXVSZ0ep7A7yHhyYImcIZM9jeGn7g4JJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwVuEf53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwVuEf53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F05C32782;
	Tue, 30 Jul 2024 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356094;
	bh=YmvbVkV+PUVlbp5CfGGrgSAzwDvEpCwqRgp5gSKzofM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwVuEf53ZUkKH9eSjUPtRY+UGkcKRfeqUc3dqJFVF4+Z+gOa/H0yl4CViYv0hBFVB
	 339VeYftqqeUZ6m0kMQOtFkYnjmPUA6Wmd+ETROs0tJr/6VI7zNa/4twq0KJuBB1EZ
	 vmZxcv3EUbgbOBa3TnhDZH8VJlWYS+2Fw1dLQOFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 098/809] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Tue, 30 Jul 2024 17:39:34 +0200
Message-ID: <20240730151728.503556736@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index 78cbc2df279e6..668d33d1ff0c1 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -732,7 +732,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0



