Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F0F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EDBC433D2;
	Mon, 30 Jan 2023 14:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087877;
	bh=MMB9CQ2KpKN+7UXWcI6GtILonH1QPGIf1UDRa32Q6C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClGmauPZa5oynOcylOX5sV7iuYIicYKudl0M/NZ3oljC7KR6EqDj84yasUVGTpHde
	 BTM1dV7z+yeZtDAEmMJytdhU+KahKvok6qGTMSt+WJiYxRbrXUsDBpfiwr/ILpjM0U
	 3dry7l/XoqjjFTwb68xdZ+/C/P77P+ik/mE1c88I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/204] arm64: dts: imx8mm-beacon: Fix ecspi2 pinmux
Date: Mon, 30 Jan 2023 14:49:34 +0100
Message-Id: <20230130134316.716598775@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 5225ba9db112ec4ed67da5e4d8b72e618573955e ]

Early hardware did not support hardware handshaking on the UART, but
final production hardware did.  When the hardware was updated the chip
select was changed to facilitate hardware handshaking on UART3.  Fix the
ecspi2 pin mux to eliminate a pin conflict with UART3 and allow the
EEPROM to operate again.

Fixes: 4ce01ce36d77 ("arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
index 94e5fa8ca957..bb18354c10f0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-baseboard.dtsi
@@ -70,7 +70,7 @@ sound {
 &ecspi2 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_espi2>;
-	cs-gpios = <&gpio5 9 GPIO_ACTIVE_LOW>;
+	cs-gpios = <&gpio5 13 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
 	eeprom@0 {
@@ -186,7 +186,7 @@ pinctrl_espi2: espi2grp {
 			MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK		0x82
 			MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI		0x82
 			MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO		0x82
-			MX8MM_IOMUXC_ECSPI1_SS0_GPIO5_IO9		0x41
+			MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13              0x41
 		>;
 	};
 
-- 
2.39.0



