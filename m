Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C08198825;
	Thu,  6 Jun 2024 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682930; cv=none; b=oQj68i/ZucKORFpBKETFtwJ/reNpnAM3LVY2Q6BvKPKYE3KbZVvkqVlVYbCTq143Z2poao5zdufPTAGz5kxrLSMTf3lrcRaRRWhempQFsmRCxhgmSKLuhN/KqEgXTKKLUcyC/nfTsBrabYsPQmxs+9cMJYTFZM9D7uWfNtVkQsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682930; c=relaxed/simple;
	bh=vubF7ZUCqtML9m2Y0q+Ydw7ikwxUBk1vF9Nvyg1C+nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/+Vv6NeFTQ7NuYRKoJvSgW4R9kSOxuh0HoR2QMVLSWu6JtXTDOA2BfgWSHN35nJ+TqubL/grwOlnzMbWi4z3g2mcNMCYCyAkNsfc99EPMCAZNrTCB+BBk82s6j6u0c1md7mP6bBj+0G2ZDxWw5vLgD5sdpmVt1W53ssiGLVl74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPfd51yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPfd51yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B9FC2BD10;
	Thu,  6 Jun 2024 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682930;
	bh=vubF7ZUCqtML9m2Y0q+Ydw7ikwxUBk1vF9Nvyg1C+nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPfd51yIqC6AOyjMaYZzYEfAPYGmHiD7NfinGBnAHh3AVJVUZcFuUDQZLZcTyCd8R
	 Rwqh6ME5uokTkzdCW+p8DGqDBEvcxsecdPQg/K1gTBeBy9l8amsrgbKTnJyawzh65L
	 gC4MlA60JmYAmnSMtLnSWJE0I7lpMSUZI1vHTQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Tikhonov <danila@jiaxyga.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/374] pinctrl: qcom: pinctrl-sm7150: Fix sdc1 and ufs special pins regs
Date: Thu,  6 Jun 2024 16:00:55 +0200
Message-ID: <20240606131654.402179545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Tikhonov <danila@jiaxyga.com>

[ Upstream commit 5ed79863fae5c06eb33f5cd6b6bdf22dd7089392 ]

SDC1 and UFS_RESET special pins are located in the west memory bank.

SDC1 have address 0x359a000:
0x3500000 (TLMM BASE) + 0x0 (WEST) + 0x9a000 (SDC1_OFFSET) = 0x359a000

UFS_RESET have address 0x359f000:
0x3500000 (TLMM BASE) + 0x0 (WEST) + 0x9f000 (UFS_OFFSET) = 0x359a000

Fixes: b915395c9e04 ("pinctrl: qcom: Add SM7150 pinctrl driver")
Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
Message-ID: <20240423203245.188480-1-danila@jiaxyga.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm7150.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm7150.c b/drivers/pinctrl/qcom/pinctrl-sm7150.c
index c25357ca1963e..b9f067de8ef0e 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm7150.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm7150.c
@@ -65,7 +65,7 @@ enum {
 		.intr_detection_width = 2,		\
 	}
 
-#define SDC_QDSD_PINGROUP(pg_name, ctl, pull, drv)	\
+#define SDC_QDSD_PINGROUP(pg_name, _tile, ctl, pull, drv) \
 	{						\
 		.grp = PINCTRL_PINGROUP(#pg_name, 	\
 			pg_name##_pins, 		\
@@ -75,7 +75,7 @@ enum {
 		.intr_cfg_reg = 0,			\
 		.intr_status_reg = 0,			\
 		.intr_target_reg = 0,			\
-		.tile = SOUTH,				\
+		.tile = _tile,				\
 		.mux_bit = -1,				\
 		.pull_bit = pull,			\
 		.drv_bit = drv,				\
@@ -101,7 +101,7 @@ enum {
 		.intr_cfg_reg = 0,			\
 		.intr_status_reg = 0,			\
 		.intr_target_reg = 0,			\
-		.tile = SOUTH,				\
+		.tile = WEST,				\
 		.mux_bit = -1,				\
 		.pull_bit = 3,				\
 		.drv_bit = 0,				\
@@ -1199,13 +1199,13 @@ static const struct msm_pingroup sm7150_groups[] = {
 	[117] = PINGROUP(117, NORTH, _, _, _, _, _, _, _, _, _),
 	[118] = PINGROUP(118, NORTH, _, _, _, _, _, _, _, _, _),
 	[119] = UFS_RESET(ufs_reset, 0x9f000),
-	[120] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x9a000, 15, 0),
-	[121] = SDC_QDSD_PINGROUP(sdc1_clk, 0x9a000, 13, 6),
-	[122] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x9a000, 11, 3),
-	[123] = SDC_QDSD_PINGROUP(sdc1_data, 0x9a000, 9, 0),
-	[124] = SDC_QDSD_PINGROUP(sdc2_clk, 0x98000, 14, 6),
-	[125] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x98000, 11, 3),
-	[126] = SDC_QDSD_PINGROUP(sdc2_data, 0x98000, 9, 0),
+	[120] = SDC_QDSD_PINGROUP(sdc1_rclk, WEST, 0x9a000, 15, 0),
+	[121] = SDC_QDSD_PINGROUP(sdc1_clk, WEST, 0x9a000, 13, 6),
+	[122] = SDC_QDSD_PINGROUP(sdc1_cmd, WEST, 0x9a000, 11, 3),
+	[123] = SDC_QDSD_PINGROUP(sdc1_data, WEST, 0x9a000, 9, 0),
+	[124] = SDC_QDSD_PINGROUP(sdc2_clk, SOUTH, 0x98000, 14, 6),
+	[125] = SDC_QDSD_PINGROUP(sdc2_cmd, SOUTH, 0x98000, 11, 3),
+	[126] = SDC_QDSD_PINGROUP(sdc2_data, SOUTH, 0x98000, 9, 0),
 };
 
 static const struct msm_gpio_wakeirq_map sm7150_pdc_map[] = {
-- 
2.43.0



