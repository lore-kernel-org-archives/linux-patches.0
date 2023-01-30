Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035128EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CC1C433D2;
	Mon, 30 Jan 2023 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087886;
	bh=HXHQ3K+7VWf8N+rflSXKhLHMPLwqLCrk/zU4ysxEbnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtzlclOxTnBd9ARqzy5v4QB6Fx6KyDac0MmNfLwpnHPxlemxlO7ezzlwHwTZ5JcEj
	 ceSsA3ZIynjXa6atcum/nvpdLSihcXFGPEKssxC7e77HQk44vndUomXhfG2pScBsdS
	 EhEYE/JF8ZAdj6g6Di0dn+0MHbZWLAQBgot+4Zu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/204] arm64: dts: imx8mm-venice-gw7901: fix USB2 controller OC polarity
Date: Mon, 30 Jan 2023 14:49:37 +0100
Message-Id: <20230130134316.843608187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit ae066f374687d7dd06bb8c732f66d6ab3c3fd480 ]

The GW7901 has USB2 routed to a USB VBUS supply with over-current
protection via an active-low pin. Define the OC pin polarity properly.

Fixes: 2b1649a83afc ("arm64: dts: imx: Add i.mx8mm Gateworks gw7901 dts support")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
index bafd5c8ea4e2..f7e41e5c2c7b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dts
@@ -675,6 +675,7 @@ &usbotg1 {
 &usbotg2 {
 	dr_mode = "host";
 	vbus-supply = <&reg_usb2_vbus>;
+	over-current-active-low;
 	status = "okay";
 };
 
-- 
2.39.0



