Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E5C79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D978DC433C1;
	Wed, 30 Nov 2022 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834256;
	bh=HsLGXRRJQ/APUtlGd+ovyydURbfrIHWxOV9hO6z8EaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYwgpPp+gcn/B4CEcEgzLiljPVZ3zb0vwd9WD8vT+zjF6RU2IeuMXxv4C9OZKOvL0
	 z5hyi/w4i3X2AAl/YjKdzCm3GhCy+oBSPtGeZHBZhKNDfM/RSu5SWBRKanoh/j6CDV
	 sUy87lB1K6XvDXGEplpV+KGNymt36/8Stx7uT1sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.0 169/289] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
Date: Wed, 30 Nov 2022 19:22:34 +0100
Message-Id: <20221130180547.964339480@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>

commit 91e8b74fe6381e083f8aa55217bb0562785ab398 upstream.

CRC errors (code -84 EILSEQ) have been observed for some SanDisk
Ultra A1 cards when running at 50MHz.

Waveform analysis suggest that the level shifters that are used on the
RK3399-Q7 module for voltage translation between 3.0 and 3.3V don't
handle clock rates at or above 48MHz properly. Back off to 40MHz for
some safety margin.

Cc: stable@vger.kernel.org
Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -207,7 +207,7 @@
 	cap-sd-highspeed;
 	cd-gpios = <&gpio0 RK_PA7 GPIO_ACTIVE_LOW>;
 	disable-wp;
-	max-frequency = <150000000>;
+	max-frequency = <40000000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc_clk &sdmmc_cmd &sdmmc_cd &sdmmc_bus4>;
 	vmmc-supply = <&vcc3v3_baseboard>;


