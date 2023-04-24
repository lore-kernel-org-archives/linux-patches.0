Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80717C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9C8C4339B;
	Mon, 24 Apr 2023 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342948;
	bh=558TS+8mHcQ/PtVYRqDmvCYhlgnr5r7Y1jjXylo/zbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDbwjyymYrr5emKjTvPywDCfSTIm8rNCgAvz/WU7DmvTRabYhknJe6RW2gf6C5EgF
	 HO9js7r1W9F/9XawTfCdImAwTbesxZINebugPpQBaJFWRAAd0aA/CiMv31izBvovkt
	 9aJJ01t6iR9J4uZmhyrrHrBsfrAEQqh+fhBN9N3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Johansen <strit@manjaro.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/110] arm64: dts: rockchip: Lower sd speed on rk3566-soquartz
Date: Mon, 24 Apr 2023 15:16:24 +0200
Message-Id: <20230424131136.234397113@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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

[ Upstream commit 5912b647bd0732ae8c78a6e5b259c82efd177d93 ]

Just like the Quartz64 Model B the previously stated speed of sdr-104
in soquartz is too high for the hardware to reliably communicate with
some fast SD cards.
Especially on some carrierboards.

Lower this to sd-uhs-sdr50 to fix this.

Fixes: 5859b5a9c3ac ("arm64: dts: rockchip: add SoQuartz CM4IO dts")
Signed-off-by: Dan Johansen <strit@manjaro.org>
Acked-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20230304164135.28430-1-strit@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
index ce7165d7f1a14..102e448bc026a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
@@ -598,7 +598,7 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc1_bus4 &sdmmc1_cmd &sdmmc1_clk>;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
 	vmmc-supply = <&vcc3v3_sys>;
 	vqmmc-supply = <&vcc_1v8>;
 	status = "okay";
-- 
2.39.2



