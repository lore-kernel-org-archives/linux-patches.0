Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025437;
	b=C8MddFFe4sc6GXRkoiChc9byz51GfIOBIFFhkIiyQ3gOJAi1UOw/U2KFZ8gyf5EJWGpW
	 KmVELLs+CtnwuaedY5/JlRaYiTX+etd8U0RFiKyljZvSUvMUAUvP/6u7pKUmwWR1YLTJv
	 UhQRCTpYkCGmimgtZ4RmrozlSbJTAyi/eaEduAhyz/kUV7fXb90387DvSlWbHHkd0IFph
	 +n1Wp+/t+E2HxAeU4DwwfSnUZ+Gy4j/LRbhKiwm9NFzVZchwWLNc4akn17qIHI0emgg1k
	 ekDlzGwoT4efixBlnHtnTeZ3cg8rJSB3pbPCRm6gy6/xXgnOfqi2nrTw9VMugNUBnRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NutC/2zw9Ai2CXZrk9v0IwUMvL4bZxICK1QDFcveEwQ=;
	b=RjmkzL9D6y+6zXWQOl1T9IJVap83Zu5cubPHCycMhtD3G3L4Mp9FBcwIoVuPmCzdMI31
	 uKwnt22D0XpbprEW7Cu5X7SKJ02rrTLoQXwEubfIYjOostVLYXxTutS1TYColV8s3oAJB
	 SyjKvfvtmuSpkDOHuUPEhQTYnJavawL2ChzXHZFCj1j8b5llt/KsVYGB0bGH/2zIaAIdl
	 4VNXqoevmOAY2KD5RDBD1+jA1ZcHX689Cnis6pJQHgpcfwVV83DlVgm7yFvoSLlmspEtu
	 +rGpF/KSt+37q3KY/+dXCi8xRR/oUDxx3qrRDgCuFOxAWpRVYXi1+bhFFSNISA4YTaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkEK+TiV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6428606A32C;
	Wed, 18 Nov 2026 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkEK+TiV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352421F000C5;
	Wed, 18 Nov 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025437;
	bh=NutC/2zw9Ai2CXZrk9v0IwUMvL4bZxICK1QDFcveEwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkEK+TiVN7lnOhV/J1+UO3EHnOKdAuk5Fao/5g8ZFYRccSI3z0zWn7D8Tz7P9Cdka
	 WqvXBLyh6nuDMmm+UxmhUDDN/lM4Wdz9Vjq4oMYp+hNTK5SPNqxhvfA5ekwWT1Qh6Z
	 6O5nGXraMfOXbxcaFeNNbsPI0jOy/VMneToqeSAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Eastwood <joachim.eastwood@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1080/2151] arm64: dts: rockchip: fix missing pcie rst pinctrl on rk3588s-nanopi-r6
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118150201.616785193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joachim Eastwood <joachim.eastwood@gmail.com>

[ Upstream commit 1d974afb0ea4e1ffc03535a2b2ae5a84d35738d7 ]

The pins are used as reset-gpios but not reserved through pinctrl.

Fixes: f3c6526d6fb2 ("arm64: dts: rockchip: Convert dts files used as parents to dtsi files")
Signed-off-by: Joachim Eastwood <joachim.eastwood@gmail.com>
Link: https://patch.msgid.link/20260903-nanopi-m6-v6-3-37416bbd6862@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
index d5bd8bc2beff6..aec62b5a78094 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
@@ -356,12 +356,16 @@ rgmii_phy1: ethernet-phy@1 {
 };
 
 &pcie2x1l1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie20x1_1_perstn_m2>;
 	reset-gpios = <&gpio1 RK_PA7 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc_3v3_pcie20>;
 	status = "okay";
 };
 
 &pcie2x1l2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pcie20x1_2_perstn_m0>;
 	reset-gpios = <&gpio3 RK_PD1 GPIO_ACTIVE_HIGH>;
 	vpcie3v3-supply = <&vcc_3v3_pcie20>;
 	status = "okay";
@@ -410,6 +414,16 @@ rtc_int: rtc-int {
 		};
 	};
 
+	pcie {
+		pcie20x1_1_perstn_m2: pcie20x1-1-perstn-m2 {
+			rockchip,pins = <1 RK_PA7 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+
+		pcie20x1_2_perstn_m0: pcie20x1-2-perstn-m0 {
+			rockchip,pins = <3 RK_PD1 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	sdmmc {
 		sdmmc_det_pin: sdmmc-det-pin {
 			rockchip,pins = <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_up>;
-- 
2.53.0



