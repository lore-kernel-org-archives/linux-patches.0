Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF71FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A96C433EF;
	Fri,  3 Feb 2023 10:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419451;
	bh=pUeP8ftZNXqzoyeGesJQh4oaNTKIXyT6cqzQfaOr8D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zb7nWJ/ks1I5DQJvtQ0HJuY/IUzRMLXfZE3BOcoIJh9XYZYBjrnT2WvFlnyA9QfKC
	 4JS9w0LNfkjDF9+ToN3x8PRqnosbo278VDeRu7i7xh4lGpUQJ06Ea/S8nxkljlLNen
	 vfmHz+BhRj7y5OTGu9GAw9ijwhxhzbXaPQjzskvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/80] ARM: dts: imx6qdl-gw560x: Remove incorrect uart-has-rtscts
Date: Fri,  3 Feb 2023 11:11:56 +0100
Message-Id: <20230203101015.359877786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 9dfbc72256b5de608ad10989bcbafdbbd1ac8d4e ]

The following build warning is seen when running:

make dtbs_check DT_SCHEMA_FILES=fsl-imx-uart.yaml

arch/arm/boot/dts/imx6dl-gw560x.dtb: serial@2020000: rts-gpios: False schema does not allow [[20, 1, 0]]
	From schema: Documentation/devicetree/bindings/serial/fsl-imx-uart.yaml

The imx6qdl-gw560x board does not expose the UART RTS and CTS
as native UART pins, so 'uart-has-rtscts' should not be used.

Using 'uart-has-rtscts' with 'rts-gpios' is an invalid combination
detected by serial.yaml.

Fix the problem by removing the incorrect 'uart-has-rtscts' property.

Fixes: b8a559feffb2 ("ARM: dts: imx: add Gateworks Ventana GW5600 support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-gw560x.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
index b5986efe1090..143d249b821e 100644
--- a/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-gw560x.dtsi
@@ -463,7 +463,6 @@ &ssi1 {
 &uart1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_uart1>;
-	uart-has-rtscts;
 	rts-gpios = <&gpio7 1 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
-- 
2.39.0



