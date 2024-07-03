Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C991741FB;
	Wed,  3 Jul 2024 10:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003596; cv=none; b=NvqKjUa0dQQ5nmXRD+17PEkeiSFL47XBYCoNm99ctKp4ZeAhFH2Fu2Ecwq2L3Qj+mWqCThMMc2VvL1Zw1Usxngc6A0U9tgAe0W8XwrvPDRjvAFghWCDoGy7Kyq5G5W/r5NWm1JzdRmXKfUDKm+fdreLlNszKPf/jbiLlfvJBpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003596; c=relaxed/simple;
	bh=bzMlgWOQt9n7TAVuFEM30FLglZ5hblrdRNayRCvsx64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR7ULa3mUyOIkHrVTjYk0TejSggvSQZYI3wCRBsuvdiAl7seet4iMyxrHeYCgQESQzI35YnFrUrHdFsF8Oi15+NVPJ8exVdEIYPmsuAJ4brHRxSEM2KrqVJh594okUwuxicTt/xvWWh8VDrTvtKHkoValTgseYRmdvN4d2s5V/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CXpcO5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CXpcO5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8039EC2BD10;
	Wed,  3 Jul 2024 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003595;
	bh=bzMlgWOQt9n7TAVuFEM30FLglZ5hblrdRNayRCvsx64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CXpcO5F6IYXbSxBmG6SWtDbB32NOD551s9808PWX9JsR/sex9b58hEiqDDYhwdk9
	 0PUSMH/U3SNA8olEyv6teeIsdNYIM46tNV/0+MRN5+NHVd9jkRgXo347Rp7xd9FVvV
	 obDwDAAYxdxDveqDWGYoGTEmVgu6F/r3B08ugmRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang-Huang Bao <i@eh5.me>,
	Heiko Stuebner <heiko@sntech.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/139] pinctrl: rockchip: fix pinmux bits for RK3328 GPIO3-B pins
Date: Wed,  3 Jul 2024 12:39:58 +0200
Message-ID: <20240703102834.257224426@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang-Huang Bao <i@eh5.me>

[ Upstream commit 5ef6914e0bf578357b4c906ffe6b26e7eedb8ccf ]

The pinmux bits for GPIO3-B1 to GPIO3-B6 pins are not explicitly
specified in RK3328 TRM, however we can get hint from pad name and its
correspinding IOMUX setting for pins in interface descriptions. The
correspinding IOMIX settings for these pins can be found in the same
row next to occurrences of following pad names in RK3328 TRM.

GPIO3-B1:  IO_TSPd5m0_CIFdata5m0_GPIO3B1vccio6
GPIO3-B2: IO_TSPd6m0_CIFdata6m0_GPIO3B2vccio6
GPIO3-B3: IO_TSPd7m0_CIFdata7m0_GPIO3B3vccio6
GPIO3-B4: IO_CARDclkm0_GPIO3B4vccio6
GPIO3-B5: IO_CARDrstm0_GPIO3B5vccio6
GPIO3-B6: IO_CARDdetm0_GPIO3B6vccio6

Add pinmux data to rk3328_mux_recalced_data as mux register offset for
these pins does not follow rockchip convention.

Signed-off-by: Huang-Huang Bao <i@eh5.me>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 3818e4a7678e ("pinctrl: rockchip: Add rk3328 pinctrl support")
Link: https://lore.kernel.org/r/20240606125755.53778-3-i@eh5.me
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 51 ++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 5d14b77d65285..849bd2f9dfd27 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -662,17 +662,68 @@ static  struct rockchip_mux_recalced_data rk3128_mux_recalced_data[] = {
 
 static struct rockchip_mux_recalced_data rk3328_mux_recalced_data[] = {
 	{
+		/* gpio2_b7_sel */
 		.num = 2,
 		.pin = 15,
 		.reg = 0x28,
 		.bit = 0,
 		.mask = 0x7
 	}, {
+		/* gpio2_c7_sel */
 		.num = 2,
 		.pin = 23,
 		.reg = 0x30,
 		.bit = 14,
 		.mask = 0x3
+	}, {
+		/* gpio3_b1_sel */
+		.num = 3,
+		.pin = 9,
+		.reg = 0x44,
+		.bit = 2,
+		.mask = 0x3
+	}, {
+		/* gpio3_b2_sel */
+		.num = 3,
+		.pin = 10,
+		.reg = 0x44,
+		.bit = 4,
+		.mask = 0x3
+	}, {
+		/* gpio3_b3_sel */
+		.num = 3,
+		.pin = 11,
+		.reg = 0x44,
+		.bit = 6,
+		.mask = 0x3
+	}, {
+		/* gpio3_b4_sel */
+		.num = 3,
+		.pin = 12,
+		.reg = 0x44,
+		.bit = 8,
+		.mask = 0x3
+	}, {
+		/* gpio3_b5_sel */
+		.num = 3,
+		.pin = 13,
+		.reg = 0x44,
+		.bit = 10,
+		.mask = 0x3
+	}, {
+		/* gpio3_b6_sel */
+		.num = 3,
+		.pin = 14,
+		.reg = 0x44,
+		.bit = 12,
+		.mask = 0x3
+	}, {
+		/* gpio3_b7_sel */
+		.num = 3,
+		.pin = 15,
+		.reg = 0x44,
+		.bit = 14,
+		.mask = 0x3
 	},
 };
 
-- 
2.43.0



