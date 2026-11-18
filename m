Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061314;
	b=sG8TPnCY7O0qiL2h/MWKjKcR8129qQEVmwWKu+cbLDO6hWl2xoPkdKlZsD07T8Hq9bCp
	 hM6j/UjHEiG6eBIuJKflVpNJlz7kiXlpS8dyeKYs4DKSR5K94n9wwqfQOnehWitr1fxlx
	 WVqmu566IqfEivMn+BLJp945/xT1gp+n3hI30xCrstH2h0rCPcNoyCQOQLv1ZYsSNhHbD
	 iHcA4GuRd9LeJD0iRJV3Ck6S7m3WkAK75jQto86sbs7CJ6g014yCIOOP+ZeKlGrFY8fyK
	 uYE1oc83Adt+1yYvfpslhF5B7NfR9fzIOInbdLNXGJi3b4rBHnYSVgk5nF4byQTYiSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2yjeimNZf3UH67B2xVlJsDIw/Sc7ZgCG/MqPvkGvdl4=;
	b=pUALYPcdREoEjobKdqg1supaWmKy+yS7NOxFNgY4lLt62HR0cjg8h/Nw5/9PPQpOrcZR
	 6ifRTw0ggj/1yxLTCLXWrcBNzsa+OesSn0As+z2MtPrKf5C2pFv1nmDPnUYrWiBs3ZKzw
	 3VpQDxThJi1Z2+SME06FiwZDWS47dJrk35ndS9+Stb1iavc6V/6bSYYR1HC76XOJU+qrc
	 L2XGPYIeCw31QJcA/djC7rVSf87l0TWCZP2I9ViJvL0yrCSeXAaOd7zPZuCJvBRC9HJr+
	 gg0s7BUMqCFZYjQz8Q5zqAOgAH0jrqeLCIovUF46jbOm0HbcaTb7C/p0G5Z0su/5yRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8RpWEV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB0606A325;
	Thu, 19 Nov 2026 04:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8RpWEV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F81F000C4;
	Thu, 19 Nov 2026 04:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061314;
	bh=2yjeimNZf3UH67B2xVlJsDIw/Sc7ZgCG/MqPvkGvdl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8RpWEV0oZpAjm7j4JX6vfd52ELPtU6tvuyQzXa1H9VNkt4JQdKeDq2m337fknp1k
	 UpXpVu55oVTxDhVkSMTw9JcPsjhlrEWFhJgylzpqYa1OfgEHVujY0gc2rZ7i14Diod
	 ifKACywPOQClMYaTvxbhBkvhcea8oGOM8RBk90v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1466/1848] arm64: dts: rockchip: add infrared receiver node to RK3399 Firefly
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150020.705001172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 4fab8e3655e476170281884d999c4d758d405fac ]

This adds the RK3399 Firefly’s infrared receiver to its dts.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20210613215237.830160-2-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 23eab1a5e360 ("arm64: dts: rockchip: fix analog headphone output on rk3399-firefly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index dc45ec372ada4..5725fa2df9fc7 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -88,6 +88,13 @@ power {
 		};
 	};
 
+	ir-receiver {
+		compatible = "gpio-ir-receiver";
+		gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_LOW>;
+		pinctrl-0 = <&ir_int>;
+		pinctrl-names = "default";
+	};
+
 	leds {
 		compatible = "gpio-leds";
 		pinctrl-names = "default";
@@ -572,6 +579,12 @@ pwrbtn: pwrbtn {
 		};
 	};
 
+	ir {
+		ir_int: ir-int {
+			rockchip,pins = <0 RK_PA6 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	lcd-panel {
 		lcd_panel_reset: lcd-panel-reset {
 			rockchip,pins = <4 RK_PD6 RK_FUNC_GPIO &pcfg_pull_up>;
-- 
2.53.0



