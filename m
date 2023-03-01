Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF616847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3143CC433EF;
	Wed,  1 Mar 2023 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694342;
	bh=pJ9qyWBsr9mPd+z6Cn2KF2wKt9ulc41prE/bP5SrksQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMLP6bljUTXhDng60X6oEdXRVEAdu/kq5bUQdYdFaDBLcnskzLulR5rMm4Rs9fdTC
	 BJa9bUxfUdsuJUB717f5XXQ3NS03uBaM/11jAuTX61u6JWmZxiLOwUuzRflIo9z8rX
	 I6lkJjIvOn9SU9wlmwns1ecxbH8S4T2pj5V/IN4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/42] arm64: dts: rockchip: fix probe of analog sound card on rock-3a
Date: Wed,  1 Mar 2023 19:08:27 +0100
Message-Id: <20230301180657.313878008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 1104693cdfcd337e73ab585a225f05445ff7a864 ]

The following was observed on my Radxa ROCK 3 Model A board:

  rockchip-pinctrl pinctrl: pin gpio1-9 already requested by vcc-cam-regulator; cannot claim for fe410000.i2s
  ...
  platform rk809-sound: deferred probe pending

Fix this by supplying a board specific pinctrl with the i2s1 pins used
by pmic codec according to the schematic [1].

[1] https://dl.radxa.com/rock3/docs/hw/3a/ROCK-3A-V1.3-SCH.pdf

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Acked-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20230115211553.445007-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 44313a18e484e..bab46db2b18cd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -521,6 +521,8 @@ &i2s0_8ch {
 };
 
 &i2s1_8ch {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s1m0_sclktx &i2s1m0_lrcktx &i2s1m0_sdi0 &i2s1m0_sdo0>;
 	rockchip,trcm-sync-tx-only;
 	status = "okay";
 };
-- 
2.39.0



