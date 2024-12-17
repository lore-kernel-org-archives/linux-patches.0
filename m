Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A7A1F8685;
	Tue, 17 Dec 2024 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456602; cv=none; b=YCI2I7pW7VLIqAEyN1bCenrd3i8zgkSzrx7q822KvxgRhFyqgEQpD7YQbJnRfNbh9ahcqjhFo8nlPvNZc2BoNfYWYde/mW7n0lAfqBeFT3Xa41vk2ttkFgj7BbIITt75gMqBFx1J8u4d/HcEraLMbS6BztMK9yzteyi/0B80VfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456602; c=relaxed/simple;
	bh=oTnbVSmDAFk+yTNjgzMnBq/0VfWUq6OBu+G8AduxG4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAKWPyPPRZHMgKkWwKIKAv24pJED2TFlC3oaOheNosVvyDZ9JlG13pME/Whwt0oMlQA5ojbb+hOR3bBR8hX155MxuKwBSyMH7znGa7pXrUvWLsI8NmwF7s6PVOvfKFrdOSbdUeUogaxGxQrLz/UVfAbjROwcT5RDf35nw+vSRtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp8xSX2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp8xSX2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AAAC4CED3;
	Tue, 17 Dec 2024 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456602;
	bh=oTnbVSmDAFk+yTNjgzMnBq/0VfWUq6OBu+G8AduxG4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp8xSX2PA/RFJRXQ20PUZrd6JtzxUqMY6B8nGr5vH1eU0wOexUkdzXLe5nD5aZrhd
	 r8+gM1p9aZVKb0syP6C7SmYPs2AaKtvYNrmIxOZ5cUuRKRWxq+L7I9/wd6H7KwhdA3
	 QgKGvcUaVXphqXECkEuUUFgaPDubKLmat8EBkTGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Hironori KIKUCHI <kikuchan98@gmail.com>,
	Chris Morgan <macromorgan@hotmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/172] regulator: axp20x: AXP717: set ramp_delay
Date: Tue, 17 Dec 2024 18:07:44 +0100
Message-ID: <20241217170550.804520752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philippe Simons <simons.philippe@gmail.com>

[ Upstream commit f07ae52f5cf6a5584fdf7c8c652f027d90bc8b74 ]

AXP717 datasheet says that regulator ramp delay is 15.625 us/step,
which is 10mV in our case.

Add a AXP_DESC_RANGES_DELAY macro and update AXP_DESC_RANGES macro to
expand to AXP_DESC_RANGES_DELAY with ramp_delay = 0

For DCDC4, steps is 100mv

Add a AXP_DESC_DELAY macro and update AXP_DESC macro to
expand to AXP_DESC_DELAY with ramp_delay = 0

This patch fix crashes when using CPU DVFS.

Signed-off-by: Philippe Simons <simons.philippe@gmail.com>
Tested-by: Hironori KIKUCHI <kikuchan98@gmail.com>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Fixes: d2ac3df75c3a ("regulator: axp20x: add support for the AXP717")
Link: https://patch.msgid.link/20241208124308.5630-1-simons.philippe@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/axp20x-regulator.c | 36 ++++++++++++++++++----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index a8e91d9d028b..945d2917b91b 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -371,8 +371,8 @@
 		.ops		= &axp20x_ops,					\
 	}
 
-#define AXP_DESC(_family, _id, _match, _supply, _min, _max, _step, _vreg,	\
-		 _vmask, _ereg, _emask) 					\
+#define AXP_DESC_DELAY(_family, _id, _match, _supply, _min, _max, _step, _vreg,	\
+		 _vmask, _ereg, _emask, _ramp_delay) 				\
 	[_family##_##_id] = {							\
 		.name		= (_match),					\
 		.supply_name	= (_supply),					\
@@ -388,9 +388,15 @@
 		.vsel_mask	= (_vmask),					\
 		.enable_reg	= (_ereg),					\
 		.enable_mask	= (_emask),					\
+		.ramp_delay = (_ramp_delay),					\
 		.ops		= &axp20x_ops,					\
 	}
 
+#define AXP_DESC(_family, _id, _match, _supply, _min, _max, _step, _vreg,	\
+		 _vmask, _ereg, _emask) 					\
+	AXP_DESC_DELAY(_family, _id, _match, _supply, _min, _max, _step, _vreg,	\
+		 _vmask, _ereg, _emask, 0)
+
 #define AXP_DESC_SW(_family, _id, _match, _supply, _ereg, _emask)		\
 	[_family##_##_id] = {							\
 		.name		= (_match),					\
@@ -419,8 +425,8 @@
 		.ops		= &axp20x_ops_fixed				\
 	}
 
-#define AXP_DESC_RANGES(_family, _id, _match, _supply, _ranges, _n_voltages,	\
-			_vreg, _vmask, _ereg, _emask)				\
+#define AXP_DESC_RANGES_DELAY(_family, _id, _match, _supply, _ranges, _n_voltages,	\
+			_vreg, _vmask, _ereg, _emask, _ramp_delay)	\
 	[_family##_##_id] = {							\
 		.name		= (_match),					\
 		.supply_name	= (_supply),					\
@@ -436,9 +442,15 @@
 		.enable_mask	= (_emask),					\
 		.linear_ranges	= (_ranges),					\
 		.n_linear_ranges = ARRAY_SIZE(_ranges),				\
+		.ramp_delay = (_ramp_delay),					\
 		.ops		= &axp20x_ops_range,				\
 	}
 
+#define AXP_DESC_RANGES(_family, _id, _match, _supply, _ranges, _n_voltages,	\
+			_vreg, _vmask, _ereg, _emask)				\
+	AXP_DESC_RANGES_DELAY(_family, _id, _match, _supply, _ranges,		\
+		 _n_voltages, _vreg, _vmask, _ereg, _emask, 0)
+
 static const int axp209_dcdc2_ldo3_slew_rates[] = {
 	1600,
 	 800,
@@ -781,21 +793,21 @@ static const struct linear_range axp717_dcdc3_ranges[] = {
 };
 
 static const struct regulator_desc axp717_regulators[] = {
-	AXP_DESC_RANGES(AXP717, DCDC1, "dcdc1", "vin1",
+	AXP_DESC_RANGES_DELAY(AXP717, DCDC1, "dcdc1", "vin1",
 			axp717_dcdc1_ranges, AXP717_DCDC1_NUM_VOLTAGES,
 			AXP717_DCDC1_CONTROL, AXP717_DCDC_V_OUT_MASK,
-			AXP717_DCDC_OUTPUT_CONTROL, BIT(0)),
-	AXP_DESC_RANGES(AXP717, DCDC2, "dcdc2", "vin2",
+			AXP717_DCDC_OUTPUT_CONTROL, BIT(0), 640),
+	AXP_DESC_RANGES_DELAY(AXP717, DCDC2, "dcdc2", "vin2",
 			axp717_dcdc2_ranges, AXP717_DCDC2_NUM_VOLTAGES,
 			AXP717_DCDC2_CONTROL, AXP717_DCDC_V_OUT_MASK,
-			AXP717_DCDC_OUTPUT_CONTROL, BIT(1)),
-	AXP_DESC_RANGES(AXP717, DCDC3, "dcdc3", "vin3",
+			AXP717_DCDC_OUTPUT_CONTROL, BIT(1), 640),
+	AXP_DESC_RANGES_DELAY(AXP717, DCDC3, "dcdc3", "vin3",
 			axp717_dcdc3_ranges, AXP717_DCDC3_NUM_VOLTAGES,
 			AXP717_DCDC3_CONTROL, AXP717_DCDC_V_OUT_MASK,
-			AXP717_DCDC_OUTPUT_CONTROL, BIT(2)),
-	AXP_DESC(AXP717, DCDC4, "dcdc4", "vin4", 1000, 3700, 100,
+			AXP717_DCDC_OUTPUT_CONTROL, BIT(2), 640),
+	AXP_DESC_DELAY(AXP717, DCDC4, "dcdc4", "vin4", 1000, 3700, 100,
 		 AXP717_DCDC4_CONTROL, AXP717_DCDC_V_OUT_MASK,
-		 AXP717_DCDC_OUTPUT_CONTROL, BIT(3)),
+		 AXP717_DCDC_OUTPUT_CONTROL, BIT(3), 6400),
 	AXP_DESC(AXP717, ALDO1, "aldo1", "aldoin", 500, 3500, 100,
 		 AXP717_ALDO1_CONTROL, AXP717_LDO_V_OUT_MASK,
 		 AXP717_LDO0_OUTPUT_CONTROL, BIT(0)),
-- 
2.39.5



