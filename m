Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C345248881;
	Wed, 25 Feb 2026 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983499; cv=none; b=DBWI/IB3Fj0B7FTVs0aIcMye39bzj4fyxPhLv6/qb1+zXyKsm9WDVT7vYuiaAJJZ1s9V5k8hNlpKQeCldHVP/V7kH+a2CL0X1WNDSsKTnaWuzPIKAfG6U0Fxq4HNosqYkf4IvhcEVC3JP8hFQBHL/pizlsQ+8kpq1OP2XrT0uoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983499; c=relaxed/simple;
	bh=PwIU2QL4nCLuXkww2/5ivuk0n/6oQyFgDMxM8ZS7DUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HS77t3AYBRYx7il8RREsrI4l31YSAKzrqyZMzqE21d3osTkqmd1Bdh/hnhZsOSJXyyYcX8hS4643ELxOZjjUGvo+qSOYzMDz2QOPMYPJZbCMg5DdWTYIl8PaSz9T3C9bncm6WvAqs1a/eylmgiTYfLHpCunzVlrfcHEfDxrB894=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mufNaIF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mufNaIF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE8CC116D0;
	Wed, 25 Feb 2026 01:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983499;
	bh=PwIU2QL4nCLuXkww2/5ivuk0n/6oQyFgDMxM8ZS7DUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mufNaIF6FkdHDJ2cfyejJ50HjT1trDFr1dOvOcF7eLXVd8KqVgQ/7qXdM5iXkUC9g
	 NmrnJQlAC/6U0SZXLUrjwhVleTi0QxpAU43vpf5aKPKtm0J9twpXiP5QlFdTdmNzbK
	 e6aYalUTBVn6l9wJeE+IDxAneydmZgIJtZqp7iHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 608/781] backlight: qcom-wled: Support ovp values for PMI8994
Date: Tue, 24 Feb 2026 17:21:57 -0800
Message-ID: <20260225012414.707385934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index a63bb42c8f8b0..5decbd39b7899 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1244,6 +1244,15 @@ static const struct wled_var_cfg wled4_ovp_cfg = {
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
@@ -1357,6 +1366,29 @@ static int wled_configure(struct wled *wled)
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
@@ -1423,8 +1455,13 @@ static int wled_configure(struct wled *wled)
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



