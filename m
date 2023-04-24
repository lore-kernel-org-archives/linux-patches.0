Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A97C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BACC433D2;
	Mon, 24 Apr 2023 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342671;
	bh=Awu7IQueBdlpb8JBbsQQXr6uY30ejPbsQqjZv0z4sBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5sdYH6jEG6w/QsP8uH/udjSZC+72+rZegUySUpuo9L9lO8QUHLh0ivm19IwrCIrx
	 fSnZ62tf2eayTc0LQgeGl4oHPkQ5BYCioJL/MTCs7WlnKgpafAu2aoKqMM0iwkWbVz
	 puJQ+Yr5bxXUDRSbMbuFf83B872W1b1tiTNZQ02E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Johansen <strit@manjaro.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/98] arm64: dts: rockchip: Lower sd speed on rk3566-soquartz
Date: Mon, 24 Apr 2023 15:16:25 +0200
Message-Id: <20230424131133.927095381@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
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
index 5bcd4be329643..4d494b53a71ab 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-soquartz.dtsi
@@ -540,7 +540,7 @@
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



