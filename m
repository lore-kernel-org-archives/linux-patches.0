Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25147346E77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302239; cv=none; b=O5PUmzIiDipRXLelzY0aa5kxEOixiIUCyvOk0icslbjfdy/HNZBQWkBFesRhQGeFNYBZ64Lx4XuvRzpTdcdUujUFHAX1ZZDCVbDmTM+x2tywdQ8Jk/oSCnk49P2jAIYnhXnJdzeYxlTjSVaQohivqzR93NA0Kcqf/p3dt/roTOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302239; c=relaxed/simple;
	bh=mLpwdX+LT3Vb7On9CyMNReOHeRKCQcJXLAcOsT5Gv68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ox9j+BBexqzuLPph615TZp6jdlZ4/swzMR/67+xGHCs4SsHesXQmdIkmcfsvMGj0mmOUIs1ftkrLD021ki6pUX2K3bzyLy8P/h8AKvrGsG7QdacbaM1JEMQWzs3Pv+R5l/qYqLvNZxMqAYgjVgCXcawiZjpoXnaVnj7HHAad+9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yhv9oFaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yhv9oFaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB18C19424;
	Sat, 28 Feb 2026 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302239;
	bh=mLpwdX+LT3Vb7On9CyMNReOHeRKCQcJXLAcOsT5Gv68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yhv9oFaCuq6ssx8yUCgpuYxFeUCI6BObaKf2m0c/SjoUp2FnniIhus7JvAGwddqlO
	 vY/AJAFMOAN0LrIdiNFjCZ7VTsG0Kv5ykgplDpQMZur4Zb3ABAxAe9nWxBplBcK5FX
	 QmL4UZWDViPSWFRnuEwFCwWUCYpbYqsBLc0KAczEY7Kv20kMmdvUWaW8x2jGA3ClAt
	 uo/9JbtfcLK3fZ44v0pDnQX78Q1/vf2tm7kDIqOVADXBYvaFJBS5zRCeS2RzuN3U1S
	 tw3XPm8QK/XybJ2ccg3D+ReBjLF497b2sPuh9760GcTNGDYoWtkkVxHMG6hKVtIqE9
	 hukFTT0OzooQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/283] backlight: qcom-wled: Support ovp values for PMI8994
Date: Sat, 28 Feb 2026 13:06:32 -0500
Message-ID: <20260228180709.1583486-250-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index b19e5f73de8bb..79337e84069fb 100644
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

