Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018577;
	b=2Ny72vSph/981Fe8XtdSdkGDV/eJG+qHBezsAKjngwrz2YIdUiKey4c55ksN3IgxCFs3
	 7idEdZFPtf+lAEPvG3tjpGfhv4uKBcAHH/ecPp6XDTAAtnkC/DU2rg0QGbrG5U9VdvcaE
	 7JclukvqhysqnNJkkwIrr5H1ysRPsDMJ3ayoTvjOb3pT631RZzD67XI+3s9q+1/7FgTOC
	 H2mlO8+S5GkHC4WNfXkAfNDJYFznwIo1JilmsrXs42iGIjomGE8RnNKrZlOtSZrLPeFZ/
	 oQLkEucx4AErAvyYbujUyMnKdZ/WoQ6/Qo+ZQb28DL3jbSszadvx8LYrCas9FI+xm4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBgS1zqmtEnRgSx4ivAFqjDioNTLoEurjKQm4sXXUkQ=;
	b=WljymPQbR5viCa9kWcUVT+xOlSxsB5HSvt6v0/xEcH5HzgISqnjSJa32oS00j+tsMLfO
	 R7k/zSNNbHbW+ChI0R1aPdY3t5cZmPodv8qRrwrUKDsUh8YuA+6hNJXfszYSbFpc2UpSy
	 XvyguMOS+rSzeM5ZZfwf1acjAsMQ5Wda4oJJcvi6xzba0VAdC4FLxW0w448CaNfzuvth/
	 5wZ6IZREHzn+yLGwuGZgFctrfEs4nUGFRYIFrrShC1aGrJxmDpVXxlcM4bdaMyWlP+aM4
	 TcX26kEcf6iAR54CcPlgKcczSrzWg11ggNr+BizoDppmsiI+N3qv/m8mGLs9/pTj2mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XI/31Lk1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1743606A31C;
	Wed, 18 Nov 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XI/31Lk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F42A1F000C4;
	Wed, 18 Nov 2026 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018577;
	bh=JBgS1zqmtEnRgSx4ivAFqjDioNTLoEurjKQm4sXXUkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XI/31Lk150/2j+6K4B3+R4uU8fGgRXa2HlYEq/UitJpWEpaxo3x4E2hf785FZXWmC
	 g4RyYyiwNkKm0Q++h690BIVXOP8eyiJVa8ZjwkNBkYrNpsYthZ1uwYu7fGspYRmIEU
	 tpneZERv20SYhDYSyRvgAyQ7SaoiEmm9r8RT9S4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joachim Eastwood <joachim.eastwood@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1289/2651] arm64: dts: rockchip: fix missing sdmmc cd pinctrl on rk3588s-nanopi-r6
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150334.346455151@linuxfoundation.org>
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
index 91b6eefd7abf5..3ee6853b8752e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi
@@ -421,6 +421,10 @@ rtc_int: rtc-int {
 	};
 
 	sdmmc {
+		sdmmc_det_pin: sdmmc-det-pin {
+			rockchip,pins = <0 RK_PA4 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+
 		sd_s0_pwr: sd-s0-pwr {
 			rockchip,pins = <4 RK_PB4 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
@@ -496,6 +500,8 @@ &sdmmc {
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



