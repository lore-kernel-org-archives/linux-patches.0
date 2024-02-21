Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2078B4B;
	Wed, 21 Feb 2024 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524247; cv=none; b=lj5yw0U7XMs3CpAqr+rt8hSu8UZlRxRKPxQSkNjtMgeiGMXQBJDCyG9X2sG5Vub43PFnwo/Bx7GKu35/pVRTE/alUGPeQww59lyct6YSg2Bkoglsk/r7+300Vy0COMlT5mqMw2LOPtZQW5UqyZTgBFrae2pxuOgNC5prXEOB+KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524247; c=relaxed/simple;
	bh=zXzjFrVGFWRXUlJ93zfphXKdISAS4rWTyRs9rIUXYAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwacgYqMAokI1OFTLD0Tr5yxEnv2XxJ3cGpg52yYAFjE9SRaKA72ZPwuWPV3ZoZ2unK2FcCYH338cJPu4IUHgSB2P6586DdjbCNWl0PmRb9pUaIAUz1qjgt0IvVvBd555Cy1hUl9fndeB/AblkQCchYbEH8uAVGCjsQjDBdscjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpG9VWaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpG9VWaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1471EC433F1;
	Wed, 21 Feb 2024 14:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524247;
	bh=zXzjFrVGFWRXUlJ93zfphXKdISAS4rWTyRs9rIUXYAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpG9VWaw5Fixo8h4eu+ME7cuwIgllOGZ2aJPrnmnpl9GNCdGmffvJsY6GLP38dT6Q
	 fwow9C1/5iWTBF9S8cFLxADwcgTCVJj7zw8BpTex71iI46whoGLuz5l/l3YXUwuS7N
	 ZqSIrSSasK5MbZ+MxpdxwtlJ4vHkw08JDIt40btw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/379] ARM: dts: imx27-apf27dev: Fix LED name
Date: Wed, 21 Feb 2024 14:05:40 +0100
Message-ID: <20240221125959.680623796@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit dc35e253d032b959d92e12f081db5b00db26ae64 ]

Per leds-gpio.yaml, the led names should start with 'led'.

Change it to fix the following dt-schema warning:

imx27-apf27dev.dtb: leds: 'user' does not match any of the regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/leds/leds-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27-apf27dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index 68fcb5ce9a9e..3d9bb7fc3be2 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -47,7 +47,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gpio_leds>;
 
-		user {
+		led-user {
 			label = "Heartbeat";
 			gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
-- 
2.43.0



