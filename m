Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019425;
	b=J8PqPufhurkSBwjVL/EL74IoOAWiDPhJHRZLkMlZJ62GJJGC3XiJWxfpkGVC+URAkCLn
	 b85yd0fi52Ifk7Bpo7n7e1G49kZfz5/RqRiB7oM4N+4zN43JoMEDNj1nDkUhnvgvsxM8J
	 krYi22ODFCG9UrWEwGSvii2UEqHzuWKF3MWrHCFbv9pNxLlm3XwnKSp0m5nZLtufqXy2K
	 u5FYWmaAoMBiIFvYkfHl9DIxKQkdt5AEiCIDp7G8qw42NWt7Pk805jLmQX8Rrzodg50qK
	 8Gid6zO2GcInwf8k18g105lFj0QhtFUMytUiOckXXTJybcTcMb5GaBs1Unt6nx7UqQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DE2sPf5+y3oM4c2cV0wr4bi1uHWSze3Mb6/5pPGGZBc=;
	b=kQxLbd8ofYvKXD1k/pAjBFlhQ9WSOmti5EdmsZXCwJTfnKBKkTtQJ2lEWhDL5jT7zV0J
	 7pl4xbRsYjnX5E8bEwbVs6bfR+7ir97wA5TZaeDlZIm/T8qnSDuGsQ7VZMpNkPughr9pX
	 Sh57ZAlOV5rH81mmZmzVpz2kQ9Q4WMTrUjSgBnTSXloO9fF2ou3xmfyiHhZrCMMDOqKxZ
	 dfUpwh8kxSY6QOg6bUDOxtu5Yk4ho/6q8a0A9f1Qgzk8ExP9IfdmuFu/n32vN+L6+4XmP
	 HOZhhsoueSyspPDgGci+X8P00YRsGMbMVZy3BaDmhn5JnFVC/riEucq0IhIKjinSAjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FeDG3cnT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203EB606C3EF;
	Wed, 18 Nov 2026 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FeDG3cnT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734FC1F0280A;
	Wed, 18 Nov 2026 16:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019425;
	bh=DE2sPf5+y3oM4c2cV0wr4bi1uHWSze3Mb6/5pPGGZBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FeDG3cnT+qiwNooPlczRa35Qg+9L3r+co192wPDccgna2rDHR55ijMX9fppA+oRDx
	 3SxY2jpKcXXKoghd+m+6NuNu0dl7XBnpygPAxkwvpSKwR2haBBCua6VWFC/WL41fyw
	 Mzl63CBi07YixT3KcXSNAb+KB/OfSbW5zkaH9SXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1591/2651] arm64: dts: rockchip: remove FRL GPIO for 100ASK DshanPi A1
Date: Wed, 18 Nov 2026 15:47:11 +0100
Message-ID: <20261118150345.180415175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 99feb764fa6c3b260e03903f5d30e15428fedc08 ]

According to the schematic [1], the 100ASK DshanPi A1 board does not
have an hdmi_tx_on_h pin, so removed the non-existent FRL GPIO.

[1] https://dl.100ask.net/Hardware/MPU/RK3576-DshanPi-A1/DshanPi-A1-RK3576-SCH_V1.1.pdf

Fixes: 2cd97880fbc4 ("arm64: dts: rockchip: Add frl-enable-gpios to rk3576 boards")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://patch.msgid.link/20261010100000.2236931-1-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts b/arch/arm64/boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts
index 05fb4a7f9a167..41c90414e898e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts
@@ -278,9 +278,6 @@ &gpu {
 };
 
 &hdmi {
-	frl-enable-gpios = <&gpio2 RK_PB0 GPIO_ACTIVE_LOW>;
-	pinctrl-0 = <&hdmi_txm0_pins &hdmi_tx_scl &hdmi_tx_sda &hdmi_tx_on_h>;
-	pinctrl-names = "default";
 	status = "okay";
 };
 
@@ -741,12 +738,6 @@ hp_det: hp-det {
 		};
 	};
 
-	hdmi {
-		hdmi_tx_on_h: hdmi-tx-on-h {
-			rockchip,pins = <2 RK_PB0 RK_FUNC_GPIO &pcfg_pull_none>;
-		};
-	};
-
 	pcie {
 		pcie_reset: pcie-reset {
 			rockchip,pins = <1 RK_PB7 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.53.0



