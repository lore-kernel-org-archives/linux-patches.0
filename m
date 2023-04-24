Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B032108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D744C433D2;
	Mon, 24 Apr 2023 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343471;
	bh=Oxq6mVMZpRJp0IKkdMsadxuw2x1xrSwKInFhVM82lr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VuuVVmJMG8PrHsEQKw1+mO6mz2kWZgvSgKo86QGo+/IxC/nPnag9pFE4SzvhzU8g
	 Z22BUby3M8q3iu5VNxNRkD9AygA8CiHHCj5+mJ8Ek9o788qF/5kPs1UOepPCLZGP3t
	 1ea6qqc1/SA5YOlFuP+wCM7x3LX/n+Mw5v6UvrIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianqun Xu <jay.xu@rock-chips.com>,
	Sjoerd Simons <sjoerd@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/29] ARM: dts: rockchip: fix a typo error for rk3288 spdif node
Date: Mon, 24 Apr 2023 15:18:28 +0200
Message-Id: <20230424131121.202810025@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianqun Xu <jay.xu@rock-chips.com>

[ Upstream commit 02c84f91adb9a64b75ec97d772675c02a3e65ed7 ]

Fix the address in the spdif node name.

Fixes: 874e568e500a ("ARM: dts: rockchip: Add SPDIF transceiver for RK3288")
Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: Sjoerd Simons <sjoerd@collabora.com>
Link: https://lore.kernel.org/r/20230208091411.1603142-1-jay.xu@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 402b5e0fd616c..4de88ded6d9a1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -924,7 +924,7 @@
 		status = "disabled";
 	};
 
-	spdif: sound@ff88b0000 {
+	spdif: sound@ff8b0000 {
 		compatible = "rockchip,rk3288-spdif", "rockchip,rk3066-spdif";
 		reg = <0x0 0xff8b0000 0x0 0x10000>;
 		#sound-dai-cells = <0>;
-- 
2.39.2



