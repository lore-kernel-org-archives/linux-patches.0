Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024699;
	b=ql/BYljr6ZDBTFBNPQddzBc8OacTswRCh4qKETGi1lSgLkecmy9eIg3czVNrFkIizHaV
	 nm3hgkSPcq4210yNz8BJCjJ/1gBNjRdf8FUoDLYb2q2/36rVL8iSJLraio3dMlACTmTR4
	 p9NZDPY9TESqZVQ4xkoy6MOcUDfVqrV47vkgZkaaGefbj+MlgdfjTsZo2ToTE1iEFUssi
	 LKJtojC0jwXHyYXprk/TcpjrDAmZUp9cJsvnXgmhdkOMytQcH1cMZzc7A9qXNQvtVTf+G
	 CUehfp8zlUJkTqHP1hN3VWDONDKX+tsIwOzXouJwJku7c7qw/B9Cphv0nG65GshIV6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ryL0IFRAuxJ8YIjkc0iYqgL5EGXdMJKX7tQzr3heHRk=;
	b=HVqFU34fbzezmhhOXx6XVDZq7DTjB6vYHfO/wltpLO6WQ+qPk+gYt9uVsQKdh2ki/pIH
	 ZbIJujoGsRO45v9GEoEjAtdyjKxt5viO+qbDdWBH7s2pEdmpI/qFSTlPRYQv1kPiFnJhi
	 1z0e+DRw6iHuxkoWEGFOWXcUZ7iG3TcaXZV8WkEHXa22lx4rv2NFqNRUGOJHCZITZUF8t
	 rP6D82QFRHTb5bhqaAo5E8dpy6cHZHg4wWR86COklylh8I4Dmv4bec+bzgN74xn8tzbuM
	 GMSclZqIcnxcWaGtlywUIUU27w9tiYdlnwFyz4ncsXAG89qAHr3FUt9eVHavKBgev5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQZF2l98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003D606A32C;
	Wed, 18 Nov 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQZF2l98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB301F000C9;
	Wed, 18 Nov 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024698;
	bh=ryL0IFRAuxJ8YIjkc0iYqgL5EGXdMJKX7tQzr3heHRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQZF2l98Zdq/WucuBpPjmWQVHik8Dmsuh4DRSueJVdvrTYmbol4fgr6I9OUuaFXqR
	 9Z9OFM8Of6ImSGXZEJyKdQt12UrLebh25sbDvuEJu0/WuEx30SHNjc0UTb0NiYiYJd
	 lAYGd/NLXGbHKoRJ2HqOPboSlvyGmV1a7ENx5Nr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0781/2151] arm64: dts: qcom: hamoa-iot-evk: add MCP2518FD CAN on spi18
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150150.566125098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 181bef739979466b6ede95b34d6c94d0250b1c0e ]

Enable the Microchip MCP2518FD CAN-FD controller on hamoa. The controller
is connected via SPI18 and uses a 40 MHz oscillator.

Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260515-hamoa-spi-can-devicetree-v2-1-d0e922608065@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 723ce02feb13 ("arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 6d69f239928ce..368781045d0db 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -27,6 +27,14 @@ backlight: backlight {
 		pinctrl-names = "default";
 	};
 
+	clocks {
+		mcp2518fd_osc: clock-40000000 {
+			compatible = "fixed-clock";
+			clock-frequency = <40000000>;
+			#clock-cells = <0>;
+		};
+	};
+
 	wcd938x: audio-codec {
 		compatible = "qcom,wcd9385-codec";
 
@@ -969,6 +977,19 @@ tpm@0 {
 	};
 };
 
+&spi18 {
+	status = "okay";
+
+	can@0 {
+		compatible = "microchip,mcp2518fd";
+		reg = <0>;
+		interrupts-extended = <&tlmm 68 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&mcp2518fd_osc>;
+		spi-max-frequency = <14000000>;
+		microchip,xstbyen;
+	};
+};
+
 &swr0 {
 	status = "okay";
 
-- 
2.53.0



