Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC85FBE1;
	Mon, 11 Dec 2023 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5TVULot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A82C433C7;
	Mon, 11 Dec 2023 18:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319474;
	bh=75UYJQIGRXmJtrUf7d+nqvraSoBs5yW78KJ0uS/m+wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5TVULotKq9mrzrP/zPafKN95jZYcaPZBDdynV0XcnZ2y/2BqypQkB+T+C3I5sTQt
	 NrYPJ62kT8BiucveKH6GtM2YAAwspaZQlpGCqAyc+VD65Nm+wKgF4ai2wW6f3HQw+5
	 lHxfmx9uKPqBx9UVT6yvG2rU2jEZ/55znEwTw6YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/244] arm64: dts: imx8-ss-lsio: Add PWM interrupts
Date: Mon, 11 Dec 2023 19:20:12 +0100
Message-ID: <20231211182051.145316201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 6c32f75d67a8c1ea94295234db7c11a29c189e6f ]

The PWM interrupt is mandatory per imx-pwm.yaml.

Add them.

This also fixes the followig schema warning:

imx8qm-apalis-v1.1-ixora-v1.2.dtb: pwm@5d000000: 'oneOf' conditional failed, one must be fixed:
	'interrupts' is a required property
	'interrupts-extended' is a required property
	from schema $id: http://devicetree.org/schemas/pwm/imx-pwm.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: d863a2f4f475 ("arm64: dts: freescale: imx8-ss-lsio: Fix #pwm-cells")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
index ea8c93757521b..7b8bbf5e6a867 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-lsio.dtsi
@@ -37,6 +37,7 @@ lsio_subsys: bus@5d000000 {
 		assigned-clocks = <&clk IMX_SC_R_PWM_0 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <2>;
+		interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -49,6 +50,7 @@ lsio_subsys: bus@5d000000 {
 		assigned-clocks = <&clk IMX_SC_R_PWM_1 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <2>;
+		interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -61,6 +63,7 @@ lsio_subsys: bus@5d000000 {
 		assigned-clocks = <&clk IMX_SC_R_PWM_2 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <2>;
+		interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
@@ -73,6 +76,7 @@ lsio_subsys: bus@5d000000 {
 		assigned-clocks = <&clk IMX_SC_R_PWM_3 IMX_SC_PM_CLK_PER>;
 		assigned-clock-rates = <24000000>;
 		#pwm-cells = <2>;
+		interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 		status = "disabled";
 	};
 
-- 
2.42.0



