Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38243636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301154; cv=none; b=an2e8Hb2NwEJCPuztWatfxm5ZA1vILQQBTP6ytPDk+pltyaiLA+nfWWrX8awi/TWBpg8VXSTVsTnSE6H03myQm7sR4y7TRrcZLHLjJQ+QSNmq+ijqj2iWlsrZ9D6w6Zk/+cDoMVIZEd1pyMZ2hRL7zj9nYbXgtws7HcsQMTWQos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301154; c=relaxed/simple;
	bh=/4RIoFWQvmnECXfpoZ2li00lAcsTSHybmqIwvfbhU54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC5NFAsQFQWCs3Wk5vpEVP9VcCC7uR85C2NizkpiNnZS9lcw+qlXQyVQLGsZP5ivlFMyc103y/+KhlzTGc6jzadIHDd+OQPWwWTFQBXzewSLvOtK8Jja1LqWzw1BQybEI2VxwXVwOpC48vi/7PiUb8q2A4syCCbfzUom+Ar7jhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiUtmuVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiUtmuVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786D9C116D0;
	Sat, 28 Feb 2026 17:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301154;
	bh=/4RIoFWQvmnECXfpoZ2li00lAcsTSHybmqIwvfbhU54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiUtmuVuJT2yPCrxFrSSZFasoMcwHT/pKj46pwz6YOjPNx3nNq1v5eyn03glCiUMS
	 qVOdNQM7DtfxL98NPF9l30TSAwtgGkYsZaL+mmS3l1j5+3+O6fz6sRcxGzbqO23ogc
	 Ym1kyq8LzfNpzG5anHHPuOUM8r+gwaT+WRWm2Nr/dQml1owPvahpeLr2AkT9eJ53h6
	 jkpVpWw0RITg5SVPRyWUmiEmpT86mwtBHSIKzV9vvQFm3vw+GAQgNImaX2SL3RGfSV
	 DYQIRQMI/Wl1JV6/Bk0Ev9KR1wQobjp8CJbD69Igkm0wGGJTi0FxMnGOlkZgBGJRga
	 yHSXBKIMaBuMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuan Liu <chuan.liu@amlogic.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 317/752] clk: amlogic: remove potentially unsafe flags from S4 video clocks
Date: Sat, 28 Feb 2026 12:40:28 -0500
Message-ID: <20260228174750.1542406-317-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuan Liu <chuan.liu@amlogic.com>

[ Upstream commit 4aca7e92023cac5018b4053bae324450f884c937 ]

The video clocks enci, encp, vdac and hdmitx share the same clock
source. Adding CLK_SET_RATE_PARENT to the mux may unintentionally change
the shared parent clock, which could affect other video clocks.

Signed-off-by: Chuan Liu <chuan.liu@amlogic.com>
Link: https://lore.kernel.org/r/20250919-add_video_clk-v6-3-fe223161fb3f@amlogic.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/s4-peripherals.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/clk/meson/s4-peripherals.c b/drivers/clk/meson/s4-peripherals.c
index 6d69b132d1e1f..bab4f5700de47 100644
--- a/drivers/clk/meson/s4-peripherals.c
+++ b/drivers/clk/meson/s4-peripherals.c
@@ -1106,7 +1106,6 @@ static struct clk_regmap s4_cts_enci_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1122,7 +1121,6 @@ static struct clk_regmap s4_cts_encp_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1138,7 +1136,6 @@ static struct clk_regmap s4_cts_vdac_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1169,7 +1166,6 @@ static struct clk_regmap s4_hdmi_tx_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_hdmi_tx_parents,
 		.num_parents = ARRAY_SIZE(s4_hdmi_tx_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.51.0

