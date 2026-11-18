Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025435;
	b=UYnWkqhTsox6P8vQvObTGNTcv88qDVlqPmPdODDRDx2mBzx6zeFyOiDVNG91N3NYeHrI
	 zAZlR2WFoMHv9OF5c8x7jb6SQZccbVBrtAj5sY7iQ7x3JIL1gjMMiHpeie6kkglJnNQ+s
	 srJ8F503VVChZ0jO87+6GNBqIDYfa+jRScmN2Z4Gl1JA0O2r9AWK57POJLxlCO/hRRUxP
	 RHo3DnfYGp1+K4Mca6AJOyEBPUwfrHeXIJpvnKVWCTll0E7oNs2R31+qTYhVUZR/1mwfp
	 lhV0nDylIVSOnsQTYaKh3FEYQSvbOxvngZ4XummfjURvzqhEEzMi9WZQo4AOUltuF4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K8n3QOI4ABzQwzFu3tu6ptI5BOyReLXLqp2+M83BFgw=;
	b=k9HjwY3K/quBidzSZDy+75AtbVioF8Bqg7ade9J5mVAtv9Mg6KRb3IT1udxQqcLP6so7
	 +q8AyxZP8DdTbKyPAbwWmJCc2y9x5y9vfAlIjSc4Gq84pa886jxt4yU9ctlnCFAqv1GWW
	 tKo73Ma+ERdP8BFZjKGsv86qZPzd0F/tIlUk3WpOi0fBz01Fm36iKQsq9AUsMk7kjElq4
	 PlYBvs85xTNlaWKAWwryEXDHyqinIMcoTazxzZQtKCYeH/plz7k4O8aPUFxB5uzwIQlnh
	 PRDeJoP6jfKEmIkRBsjJ47OcsNDan1X7UUWFcjC7oEwBY/ejyddM+mV7/L0D23I+aRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZM3RWB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EFB606A32F;
	Wed, 18 Nov 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZM3RWB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E451F000C4;
	Wed, 18 Nov 2026 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025434;
	bh=K8n3QOI4ABzQwzFu3tu6ptI5BOyReLXLqp2+M83BFgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZM3RWB6zlVy95ITfJBYBNZW29eeWSGvyBS79pf5mEbiD9Wz3tAStakAlbF/c+Z3e
	 uZC0aLjKpIqw5BFMoKcAUxTPZtvO+idE3pbRRYhMRQAWO3KUaO+AERtqn0DtHm6ebD
	 v8koy34ICdRdJkUaFUR/rTU2RNxAAUy33X3wjsvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Eastwood <joachim.eastwood@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1079/2151] arm64: dts: rockchip: fix missing sdmmc cd pinctrl on rk3588s-nanopi-r6
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118150201.579701953@linuxfoundation.org>
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

[ Upstream commit 30fcc62cf5d27fe264145bb743407af62f8ff240 ]

The cd (card detect) pin is used, but not reserved through pinctrl.

Fixes: 95147bb42bc1 ("arm64: dts: rockchip: Fix the SD card detection on NanoPi R6C/R6S")
Signed-off-by: Joachim Eastwood <joachim.eastwood@gmail.com>
Link: https://patch.msgid.link/20260903-nanopi-m6-v6-2-37416bbd6862@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
index 1b6a59f7cabce..d5bd8bc2beff6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
@@ -411,6 +411,10 @@ rtc_int: rtc-int {
 	};
 
 	sdmmc {
+		sdmmc_det_pin: sdmmc-det-pin {
+			rockchip,pins = <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+
 		sd_s0_pwr: sd-s0-pwr {
 			rockchip,pins = <4 RK_PB4 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
@@ -486,6 +490,8 @@ &sdmmc {
 	no-mmc;
 	no-sdio;
 	sd-uhs-sdr104;
+	pinctrl-names = "default";
+	pinctrl-0 = <&sdmmc_bus4 &sdmmc_clk &sdmmc_cmd &sdmmc_det_pin>;
 	vmmc-supply = <&vcc_3v3_sd_s0>;
 	vqmmc-supply = <&vccio_sd_s0>;
 	status = "okay";
-- 
2.53.0



