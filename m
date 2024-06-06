Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB771974E8;
	Thu,  6 Jun 2024 14:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683541; cv=none; b=NdjPXH511CtaaxllhvPHnCdYLthSwjb/QIrB9OgOLGX+ZGQ7kRUenCU6xJLwLk8nGBncbCU7fj60ZktLHIgaYXEA6mXy3SjNX4+TM2tN9a2DpW99u1hzbpuBVMzR/XNPHO6Hf7ix4H1SrqT5LhOdvUArxN2EZ08yIdIa9YoXV8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683541; c=relaxed/simple;
	bh=vzhVSlRpe3oh/nV18Y0nfrr+6u9m93ZpL39z2hkfUWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkOiqr5HvvfQy+hki+5DmOvSXNcNRwuG5sREzDxilG8UYdi9J0iReC47mGieXaBXQ46eIpKt58MltLdSwogM6jmg4iFH2b1AGr1HWMD7Zxu17FU011WDoE+dKcGxyIdpDQWZCdl7pqmjjPEXMxm20vt/PNakV3LhitRzpATQPuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9Ok8ZwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9Ok8ZwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7E9C2BD10;
	Thu,  6 Jun 2024 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683541;
	bh=vzhVSlRpe3oh/nV18Y0nfrr+6u9m93ZpL39z2hkfUWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Ok8ZwFctPPyFhsve8qV0NPbX3yF4UCne9bjRM5hwC09nUUXN6+PkcB/c4TmetYp
	 lTTSBBMeC5F7s57vIXno/Cf1nIejw0o8uSGYMXDB0D9I05vNPhD/Ti74ncOkTL9yq+
	 w6jsltGKIHa3duidOTOncJW79GQG4m/7qPcuX4fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Tikhonov <danila@jiaxyga.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 480/744] pinctrl: qcom: pinctrl-sm7150: Fix sdc1 and ufs special pins regs
Date: Thu,  6 Jun 2024 16:02:32 +0200
Message-ID: <20240606131747.856369630@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 33657cf98fb9d..edb5984cd3519 100644
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



