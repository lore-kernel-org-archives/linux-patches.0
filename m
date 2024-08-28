Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D28B1A4B7F
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865449; cv=none; b=QOfbEKteDq4prE+v3Pz50n8CXw6ca4iaawhIBKeLMBzD47s5swbc3yRG4+p8CIb72fOBQ/5E7hqKy09q8k9IOtVg4kopibR+A6E/plcDgZfE4N1DI5BBTtmbXebQdw5wzJWf8ZIdJfVSzZKB5VKlrzt1+2L9BZUscbopsPnyxVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865449; c=relaxed/simple;
	bh=bwSfvGk4ew41Pt/E/xxobSD02oCnd1HApU3EHn2TPXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bmz9plxzfJZw3izgk1Q1H/1bn7T4Iz+UIDxWjQs6wNmyVP/12y7WNOxDQo/jfF8qtkRfpBA1kYhV6nBZkHcVtD+Yv6gqPxCbjNrLVVal3dDnO8INd9LKlZC6IpGmtaJg9XEYFAxk4sKbSh+Lo5wqH0sZBN1Gji8p6UUzTzxkRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=OOc6YJen; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OOc6YJen"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fee6435a34so48716685ad.0
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 10:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724865447; x=1725470247; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obx3p45lH094wmMafo9xf2AcgFRs0OVi52Qu0+34Bqo=;
        b=OOc6YJenlmtQcVuS1W/SIW39DvYsgFHl5skPsoBdsCpbYVrUDyJ1U44NbaFk8khovu
         8wvJfUWG4s1V1Y6yfbjDksI2+37ngr/+OmjgWHimGec5D+h5Q8oHhqhD72W5QU285QAQ
         jwGGmWNxbJfZMdoXKayI//VWoXxHoYJmxPC8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724865448; x=1725470248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obx3p45lH094wmMafo9xf2AcgFRs0OVi52Qu0+34Bqo=;
        b=qNp/iwE2o1OZxipPaePQFzRo2Ija97yDvJycbfrwP0tCx3x/FiqeeGhiKXbhHkD4Nr
         6m6zBRQq5VWfKywOq8kvX2WvvSeuFEJMrhV6poNILKVRuWI4cx/IfQBaCEZYXVPEZy9y
         CXQzYhSUyIKK9q4DpA6Fg7lSDzdVI95BgARIUQY6aK751c5xYdBNOBbRKzjC49quirr7
         KO3P7Uyn8urZBPiHpH+bmgV6/LHUUu3pjkowQ5/ARaM3mtThVp73nvUAmIvKg9N+Ux6a
         L5gJgutcpQMSy0VLecdedEn+nVpuyXW57RlPcKYpRlzZPtRQZhZlD6+rjyGH98hDYcDw
         6CeA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ3PkUlsPEJzHcb/J7p09Vdfa3XsBrT6G+x6AeUX2tcapCMZO+W6grwKw2mMJWt9y0bx5FXsEr@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7NCvSSYAex5CoZcWd6mS23aQ8qmH8/r0Gt9oIqwMu1M4h+N8v
	1sMuqAPChU29lxJ2JJN7SzRZxo9/TcOSmegw8ymU3/gbC9+doyYAXyHQOtAzO1zP97Jv16uwM5s
	=
X-Google-Smtp-Source: AGHT+IFo3yNR44JAQjq7tPpX6XRV0bUKv+iJl4hPJ7g/ZEOViXftZwzGkPdFX7wZrnrsNHYoVWKkMw==
X-Received: by 2002:a17:903:2a85:b0:1fd:9a23:90cc with SMTP id d9443c01a7336-2050c34c67dmr2292795ad.26.1724865447375;
        Wed, 28 Aug 2024 10:17:27 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-20385ae81afsm101148885ad.252.2024.08.28.10.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 10:17:26 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH v3 1/2] clk: qcom: dispcc-sc7180: Only park display clks at init
Date: Wed, 28 Aug 2024 10:17:07 -0700
Message-ID: <20240828171722.1251587-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240828171722.1251587-1-swboyd@chromium.org>
References: <20240828171722.1251587-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Amit Pundir reports that audio and USB-C host mode stops working on
sm8550 after commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
registration"). That's because the gcc_usb30_prim_master_clk_src clk is
registered and clk_rcg2_shared_init() parks it on XO. Running USB at a
slower speed than the link supports is effectively under-clocking the
USB link and probably confusing the downstream USB devices.

We didn't need to change all the shared RCGs to park on XO at
registration time in commit commit 01a0a6cc8cfd ("clk: qcom: Park shared
RCGs upon registration"). Instead, we only needed to park the few
display related clks on sc7180 to fix the issue.

Fix sm8550 (and likely other qcom SoCs) by skipping the parking part of
clk_rcg2_shared_init(). Make that the default init clk_op for shared
RCGs, but keep the part where we cache the config register as that's
still necessary to figure out the true parent of the clk is. Introduce
another set of clk_ops 'clk_rcg2_shared_init_park' that does what
clk_rcg2_shared_init() was doing and use that for the display clks on
sc7180. This fixes the sm8550 problem and limits the "park upon
registration" logic to the display clks that need it.

Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/clk/qcom/clk-rcg.h       |  1 +
 drivers/clk/qcom/clk-rcg2.c      | 36 +++++++++++++++++++++++++++++---
 drivers/clk/qcom/dispcc-sc7180.c |  8 +++----
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
index d7414361e432..5f479a29d969 100644
--- a/drivers/clk/qcom/clk-rcg.h
+++ b/drivers/clk/qcom/clk-rcg.h
@@ -198,6 +198,7 @@ extern const struct clk_ops clk_byte2_ops;
 extern const struct clk_ops clk_pixel_ops;
 extern const struct clk_ops clk_gfx3d_ops;
 extern const struct clk_ops clk_rcg2_shared_ops;
+extern const struct clk_ops clk_rcg2_shared_init_park_ops;
 extern const struct clk_ops clk_dp_ops;
 
 struct clk_rcg_dfs_data {
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 30b19bd39d08..5f0b729d7115 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1305,6 +1305,31 @@ clk_rcg2_shared_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 }
 
 static int clk_rcg2_shared_init(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+
+	/*
+	 * Cache the cfg so that the parent is properly mapped at registration.
+	 */
+	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &rcg->parked_cfg);
+
+	return 0;
+}
+
+const struct clk_ops clk_rcg2_shared_ops = {
+	.init = clk_rcg2_shared_init,
+	.enable = clk_rcg2_shared_enable,
+	.disable = clk_rcg2_shared_disable,
+	.get_parent = clk_rcg2_shared_get_parent,
+	.set_parent = clk_rcg2_shared_set_parent,
+	.recalc_rate = clk_rcg2_shared_recalc_rate,
+	.determine_rate = clk_rcg2_determine_rate,
+	.set_rate = clk_rcg2_shared_set_rate,
+	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
+
+static int clk_rcg2_shared_init_park(struct clk_hw *hw)
 {
 	/*
 	 * This does a few things:
@@ -1335,8 +1360,13 @@ static int clk_rcg2_shared_init(struct clk_hw *hw)
 	return 0;
 }
 
-const struct clk_ops clk_rcg2_shared_ops = {
-	.init = clk_rcg2_shared_init,
+/*
+ * Like clk_rcg2_shared_ops but also park the clk at init to avoid the parent
+ * from being shutdown, getting the clk stuck when it is turned on
+ * automatically by the GDSC.
+ */
+const struct clk_ops clk_rcg2_shared_init_park_ops = {
+	.init = clk_rcg2_shared_init_park,
 	.enable = clk_rcg2_shared_enable,
 	.disable = clk_rcg2_shared_disable,
 	.get_parent = clk_rcg2_shared_get_parent,
@@ -1346,7 +1376,7 @@ const struct clk_ops clk_rcg2_shared_ops = {
 	.set_rate = clk_rcg2_shared_set_rate,
 	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
 };
-EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
+EXPORT_SYMBOL_GPL(clk_rcg2_shared_init_park_ops);
 
 /* Common APIs to be used for DFS based RCGR */
 static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
index 4710247be530..068af819f23e 100644
--- a/drivers/clk/qcom/dispcc-sc7180.c
+++ b/drivers/clk/qcom/dispcc-sc7180.c
@@ -154,7 +154,7 @@ static struct clk_rcg2 disp_cc_mdss_ahb_clk_src = {
 		.parent_data = disp_cc_parent_data_4,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_init_park_ops,
 	},
 };
 
@@ -263,7 +263,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 		.name = "disp_cc_mdss_mdp_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_init_park_ops,
 	},
 };
 
@@ -291,7 +291,7 @@ static struct clk_rcg2 disp_cc_mdss_rot_clk_src = {
 		.name = "disp_cc_mdss_rot_clk_src",
 		.parent_data = disp_cc_parent_data_3,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_init_park_ops,
 	},
 };
 
@@ -305,7 +305,7 @@ static struct clk_rcg2 disp_cc_mdss_vsync_clk_src = {
 		.name = "disp_cc_mdss_vsync_clk_src",
 		.parent_data = disp_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_init_park_ops,
 	},
 };
 
-- 
https://chromeos.dev

