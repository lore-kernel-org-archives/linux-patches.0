Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5770C11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC201C433CB;
	Mon, 11 Sep 2023 14:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443398;
	bh=8Ha5QwuthDCTuSTdno7NVc2jZVl+XQ8RSS3edhH+Ijo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqiUK2I84wE/GjJFbt4a8TAXt6u9/YljXvxESlXB3Slqx2lskaBe2G8agxUlxJ7qY
	 GfxAOVxRg4sgv1WnD9ly4CJBQ5CIJZ4kjey/tZ42Xw4A3j7lOol2WlIAb4Z+JqVlKo
	 oRDRzderOLE0vqUWJ+jkJocXz5DuTIOv1lxeLscg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 336/737] arm64: dts: rockchip: Enable SATA on Radxa E25
Date: Mon, 11 Sep 2023 15:43:15 +0200
Message-ID: <20230911134659.921082198@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 2bdfe84fbd57a4ed9fd65a67210442559ce078f0 ]

The M.2 KEY B port can be used for WWAN USB2 modules or SATA drives.

Enable sata1 node to fix use of SATA drives on the M.2 slot.

Fixes: 2bf2f4d9f673 ("arm64: dts: rockchip: Add Radxa CM3I E25")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20230724145213.3833099-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dts b/arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dts
index f0e4884438e39..72ad74c38a2b4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-radxa-e25.dts
@@ -99,6 +99,10 @@ vcc3v3_pi6c_05: vcc3v3-pi6c-05-regulator {
 	};
 };
 
+&combphy1 {
+	phy-supply = <&vcc3v3_pcie30x1>;
+};
+
 &pcie2x1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie20_reset_h>;
@@ -178,6 +182,10 @@ &pwm12 {
 	status = "okay";
 };
 
+&sata1 {
+	status = "okay";
+};
+
 &sdmmc0 {
 	bus-width = <4>;
 	cap-sd-highspeed;
-- 
2.40.1



