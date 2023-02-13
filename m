Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437D8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00C7C433D2;
	Mon, 13 Feb 2023 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300096;
	bh=mIpswickU1cU6+v2M56U3n8ZWhRc4t1EE2hD3nZnAcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UR9MvaedrmkX/9XG6Zf5+eukBria5SLgVIUR5ywKf616++ndtyM8TxWcs/UIdxOR/
	 6YfUy+Ir2l+Rmdc/jHe8RBSfJFlpyuz0T+z66jx6ePhMYo1E+I0YSziroZXfhCpxI6
	 ApQY7XgW1EMwBGX3rZBnVvKZBW7cUSIy4eu2EdUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Johansen <strit@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/114] arm64: dts: rockchip: set sdmmc0 speed to sd-uhs-sdr50 on rock-3a
Date: Mon, 13 Feb 2023 15:48:17 +0100
Message-Id: <20230213144745.443270542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Johansen <strit@manjaro.org>

[ Upstream commit bc121b707e816616567683e51fd9194c2309977a ]

As other rk336x based devices, the Rock 3 Model A has issues with high
speed SD cards, so lower the speed to 50 instead of 104 in the same
manor has the Quartz64 Model B has.

Fixes: 22a442e6586c ("arm64: dts: rockchip: add basic dts for the radxa rock3 model a")
Signed-off-by: Dan Johansen <strit@manjaro.org>
Link: https://lore.kernel.org/r/20230128112432.132302-1-strit@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 539ef8cc77923..44313a18e484e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -642,7 +642,7 @@
 	disable-wp;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc0_bus4 &sdmmc0_clk &sdmmc0_cmd &sdmmc0_det>;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
 	vmmc-supply = <&vcc3v3_sd>;
 	vqmmc-supply = <&vccio_sd>;
 	status = "okay";
-- 
2.39.0



