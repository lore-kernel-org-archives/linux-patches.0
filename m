Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24AE2585
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F35C433D2;
	Mon, 12 Dec 2022 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850713;
	bh=kuMPUkubI3lgAaCiXGGGR2/9HtVVVMM/J328jfyGQRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGFINTepthv7pR0W5576PRC/cJ3st8/ot9TXKC+2O80VpWbcZ+5G3YuKR+VeBrcR7
	 gv87etU7KO1IUxE4DT02yY0cNbzeXBF8rMHggxBs43P54CczLF1KvZVJwkOBb5xw7z
	 kVOxTcmXGBGRCGk6AyxzwMWIbpP0q5ywzDtm7sjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/106] arm64: dts: rockchip: fix ir-receiver node names
Date: Mon, 12 Dec 2022 14:09:14 +0100
Message-Id: <20221212130925.368395182@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit de0d04b9780a23eb928aedfb6f981285f78d58e5 ]

Fix ir-receiver node names on Rockchip boards,
so that they match with regex: '^ir(-receiver)?(@[a-f0-9]+)?$'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/e9764253-8ce8-150b-4820-41f03f845469@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index fbcb9531cc70..213c0759c4b8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -13,7 +13,7 @@
 		stdout-path = "serial2:1500000n8";
 	};
 
-	ir_rx {
+	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PC0 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
-- 
2.35.1



