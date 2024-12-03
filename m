Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851271F9EC0;
	Tue,  3 Dec 2024 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240558; cv=none; b=Svvukb+zTHeR0M5JySTAEMFpWLV3OxFTsJUTaN1SGUaGk1FD+CaTCDLRYjF47aM077Zub9czg2B+TsNIhg2eXfOf8LOSK4Qw8NastsE2yLmp3Uw4vNE99Eq2JID8gAxeBDaewJmeExVcuNqbSCLG2KaoxaCc5OuBYYojVBZdx0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240558; c=relaxed/simple;
	bh=of4jIEJ13ulclsTkVCjnqMNs8ri6kv9m70D7kQyHGMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw7wBaixlqGQifH1mkNJYtYPCLQfb3YK7TnCq6nxYD3ZlGGHKm3fkw244Eu90uXGMx5JR4SmTvbOz+8E299iHjLF0J0sO4PeaiqiEz2BW8zv0KvJZLWSMePy7ii9VLBtJ/mCv1RgMIlQzGY5eEwwzD1cvjqGv+oBAVR4x/dUBNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA5FL+au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA5FL+au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCB9C4CECF;
	Tue,  3 Dec 2024 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240558;
	bh=of4jIEJ13ulclsTkVCjnqMNs8ri6kv9m70D7kQyHGMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fA5FL+au/V3f65EpE1lAL9KyHQjJdhyE+bN9d6At0w4N8FNo3SpIp8uwlk8taqMBt
	 05VtCLa0sKWAquSlH0JwlMUb/DOnRqDz0iiTIZUVldSfp/8EoamOziqZvWSEu3Qroc
	 Wq+vkgsR1oSsa/+DU787Vl8kHbBmXmWcY/4MyGSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Muhammed Efe Cetin <efectn@6tel.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/826] arm64: dts: rockchip: Remove enable-active-low from two boards
Date: Tue,  3 Dec 2024 15:37:47 +0100
Message-ID: <20241203144749.204262342@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 4a9d7e6596f90631f21bca9cb46c6de05d8e86d4 ]

The 'enable-active-low' property is not a valid, because it is the
default behaviour of the fixed regulator.

Only 'enable-active-high' is valid, and when this property is absent
the fixed regulator will act as active low by default.

Both the rk3588-orange-pi-5 and the Wolfvision pf5 io expander overlay
smuggled those enable-active-low properties in, so remove them to
make dtbscheck happier.

Fixes: 28799a7734a0 ("arm64: dts: rockchip: add wolfvision pf5 io expander board")
Cc: Michael Riesch <michael.riesch@wolfvision.net>
Fixes: b6bc755d806e ("arm64: dts: rockchip: Add Orange Pi 5")
Cc: Muhammed Efe Cetin <efectn@6tel.net>

Reviewed-by: Michael Riesch <michael.riesch@wolfvision.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-10-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso     | 1 -
 arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts              | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
index ebcaeafc3800d..fa61633aea152 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
+++ b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
@@ -49,7 +49,6 @@ vcc1v8_eth: vcc1v8-eth-regulator {
 
 	vcc3v3_eth: vcc3v3-eth-regulator {
 		compatible = "regulator-fixed";
-		enable-active-low;
 		gpio = <&gpio0 RK_PC0 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc3v3_eth_enn>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
index feea6b20a6bf5..6b77be6432495 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
@@ -71,7 +71,6 @@ vcc5v0_sys: vcc5v0-sys-regulator {
 
 	vcc_3v3_sd_s0: vcc-3v3-sd-s0-regulator {
 		compatible = "regulator-fixed";
-		enable-active-low;
 		gpios = <&gpio4 RK_PB5 GPIO_ACTIVE_LOW>;
 		regulator-name = "vcc_3v3_sd_s0";
 		regulator-boot-on;
-- 
2.43.0



