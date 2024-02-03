Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DD24E1C3;
	Sat,  3 Feb 2024 04:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933808; cv=none; b=t2ED6oYRREQSoVu6A2GoLO7/PaEhV5UmXrSUqLwBu7iqS3B8VC/FCiGCJtF4WYVi8rpQVJHRDHUXw58AfnSVu34NSgPo1XbFqz5weA/QnY5Hc5o/yE9gz1+AX3/lkQNzovk4SW7M8wDgpNVfx1fZFrIXqR7L4lqnV85TgTVMifY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933808; c=relaxed/simple;
	bh=CYyMWxmXEQNDMlbRuA29/hjPqtlLNn++bPdAFP0mlDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+PUee51NmtT/iHQVpL4fQhgsIMwcb+c3dgWTxTOsGSUr0ZELPTcLJhZrQwl7rgr9w7Nhl6bYnINtCWCsNRn2ISC+bQu38aucRxLfjZYasvDkDpxnU96VxppmtOkKgxV5JuCLBKeQiBTzyZcd5ZMLuNWIC8CAgATWeZLcnuQCuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFpKBtsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFpKBtsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91789C433C7;
	Sat,  3 Feb 2024 04:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933807;
	bh=CYyMWxmXEQNDMlbRuA29/hjPqtlLNn++bPdAFP0mlDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFpKBtskKGq90YwyZ2urnM09oe/KqGrrY5Ml5ayqy2+I7URmD+x3XFa/oDhyOsaNL
	 O6LYyxBxyCoGZ0ZTlEz6bYNFkVgvAiHDwiKZO/SJZaBRs1K4exrGtCFaxTA6BPHydv
	 no/x8C6WssCbre0QOgZpA3ocNp8tDEF4pMBoJewY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 123/353] ARM: dts: imx27-apf27dev: Fix LED name
Date: Fri,  2 Feb 2024 20:04:01 -0800
Message-ID: <20240203035407.635488353@linuxfoundation.org>
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

[ Upstream commit dc35e253d032b959d92e12f081db5b00db26ae64 ]

Per leds-gpio.yaml, the led names should start with 'led'.

Change it to fix the following dt-schema warning:

imx27-apf27dev.dtb: leds: 'user' does not match any of the regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/leds/leds-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
index f047a8487073..849306cb4532 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
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



