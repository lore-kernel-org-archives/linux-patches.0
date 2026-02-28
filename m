Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16B348895
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302631; cv=none; b=g+/UQ1Vo36TL2B/zJMEHLVkBJvZ021F0qRCERi0LPMIrBDOp5JvHcV6N+rijMY1Xwd3RL84ya5lFPXpxglOnk7cKtrJAKk3OZ7bae6nYVWW0xzqox74rN5xur9LdxIzpaNEiBeYMTdmp6rfSfhrn/X/ZRnk2gw9Lg7vXSqiyzJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302631; c=relaxed/simple;
	bh=5giB7c1Sm6qKdwPaiAA9A+QRmrIw1lZHae2P0u3buhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JhYQ0m58/sv2QCXae3V49fafW80LddzTtB8s+5IVJpUoxBJl1r+Juu9bLlgrTDQjPdeutFf+Dmi09GYVRS4wh5bSYpWlRBcxscDdN7wi1dovi40/fyDo+lfy3CLqwz8K1uIKVzsLMtMis6a2oAb5MdGdGE0KPYLbXfHXQuH92hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9qMPd0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9qMPd0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249D2C116D0;
	Sat, 28 Feb 2026 18:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302631;
	bh=5giB7c1Sm6qKdwPaiAA9A+QRmrIw1lZHae2P0u3buhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9qMPd0QoM/LlY1FIOZSAnKohNKTCwiD1UhY6pX1rJv0dn24WFLRg9qA4ogmK+8Pn
	 5XfPJb7lImv+LCt68J6mtZqEMEqFu5Sb5PBkd8fs2gI1GQTHchQ7Z5lgouPEsy6+0O
	 vy+p33UK7rCB2wwfwqno9ZVbakWD0vZvKQj/yYZrFdmVd89W0qfPFgDmymppQ91IaP
	 1k1lWmcgTq5BjLYRq5G3ilk3ZeLEYtLNxUVDskWLFfYeSM0djeXIbvNM54DAqanuRT
	 3bMWcgmqHJGZlqfUu9vcaejjre4HEuytoGI1bIs/QoeN4nsNKfDeUoYJ7fkj2B6rel
	 6HABJi+mMyGXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/164] backlight: qcom-wled: Support ovp values for PMI8994
Date: Sat, 28 Feb 2026 13:14:50 -0500
Message-ID: <20260228181505.1600663-151-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit f29f972a6e7e3f187ea4d89b98a76c1981ca4d53 ]

WLED4 found in PMI8994 supports different ovp values.

Fixes: 6fc632d3e3e0 ("video: backlight: qcom-wled: Add PMI8994 compatible")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20260116-pmi8950-wled-v3-2-e6c93de84079@mainlining.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 41 +++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 21c1fba64ad5d..2ecfbe1b0d3d4 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1242,6 +1242,15 @@ static const struct wled_var_cfg wled4_ovp_cfg = {
 	.size = ARRAY_SIZE(wled4_ovp_values),
 };
 
+static const u32 pmi8994_wled_ovp_values[] = {
+	31000, 29500, 19400, 17800,
+};
+
+static const struct wled_var_cfg pmi8994_wled_ovp_cfg = {
+	.values = pmi8994_wled_ovp_values,
+	.size = ARRAY_SIZE(pmi8994_wled_ovp_values),
+};
+
 static inline u32 wled5_ovp_values_fn(u32 idx)
 {
 	/*
@@ -1355,6 +1364,29 @@ static int wled_configure(struct wled *wled)
 		},
 	};
 
+	const struct wled_u32_opts pmi8994_wled_opts[] = {
+		{
+			.name = "qcom,current-boost-limit",
+			.val_ptr = &cfg->boost_i_limit,
+			.cfg = &wled4_boost_i_limit_cfg,
+		},
+		{
+			.name = "qcom,current-limit-microamp",
+			.val_ptr = &cfg->string_i_limit,
+			.cfg = &wled4_string_i_limit_cfg,
+		},
+		{
+			.name = "qcom,ovp-millivolt",
+			.val_ptr = &cfg->ovp,
+			.cfg = &pmi8994_wled_ovp_cfg,
+		},
+		{
+			.name = "qcom,switching-freq",
+			.val_ptr = &cfg->switch_freq,
+			.cfg = &wled3_switch_freq_cfg,
+		},
+	};
+
 	const struct wled_u32_opts wled5_opts[] = {
 		{
 			.name = "qcom,current-boost-limit",
@@ -1421,8 +1453,13 @@ static int wled_configure(struct wled *wled)
 		break;
 
 	case 4:
-		u32_opts = wled4_opts;
-		size = ARRAY_SIZE(wled4_opts);
+		if (of_device_is_compatible(dev->of_node, "qcom,pmi8994-wled")) {
+			u32_opts = pmi8994_wled_opts;
+			size = ARRAY_SIZE(pmi8994_wled_opts);
+		} else {
+			u32_opts = wled4_opts;
+			size = ARRAY_SIZE(wled4_opts);
+		}
 		*cfg = wled4_config_defaults;
 		wled->wled_set_brightness = wled4_set_brightness;
 		wled->wled_sync_toggle = wled3_sync_toggle;
-- 
2.51.0

