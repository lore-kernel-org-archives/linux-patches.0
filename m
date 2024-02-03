Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B80B12E58;
	Sat,  3 Feb 2024 04:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933371; cv=none; b=gmarReX74ldtI3AqdWxLTlqKAIUbu7s9bqMjv3Ul4ktLln3a3sXSYFM8674qJcZljqyhOMq5SJrcflTUNNEVHmXz3b/f0swIcfg7KdubdliG85A708Cv8yyfJRON1kjemJXgMPqq8e2LaGvi1moD8QvJV+qDTpg695CWcxFXPZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933371; c=relaxed/simple;
	bh=H/4cwrHl+L3Se2Qzk3/YgXspEUIa8d45PFpMNJ4mWI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C41Jh3tfMpU3eEL9ZpvzmJA3MRviDQ9ro9zGOIapzxCMwMHEhtikoXWinobFOuPlsaUnoZSOqpSb8esMLVwlMLsQSMSacoiOtyTxThl34wE4zzdvhLbNDnN1gymGrxSblYp0iSZ8y0a6iOGOhyt+UG35wBcZhyMQoKj0iwDAgpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpGmMvhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpGmMvhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B7CC433F1;
	Sat,  3 Feb 2024 04:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933370;
	bh=H/4cwrHl+L3Se2Qzk3/YgXspEUIa8d45PFpMNJ4mWI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpGmMvhU8I8ub90kGvo0uhGMAcY9ycaRYBpYqiUMiGOR7egCkANFjVwh2zsX3aybX
	 y5wwhdgTU2UajBSc8izcTym2uNf8/3B6Fg4REi2u62XI5Dw+U+pm8GSsa7mEWMlvN1
	 0MfCfuWqnaPCTb8VzjBDG5dXB5bz1tE6dUuKG8jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/219] ARM: dts: imx27-apf27dev: Fix LED name
Date: Fri,  2 Feb 2024 20:04:12 -0800
Message-ID: <20240203035328.211907235@linuxfoundation.org>
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



