Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03A11E2125
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 23:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110595; cv=none; b=VWcEWLe5tRXYpUuD/dqhUi5VYK9Mvm8bDT2z100j8X9A1Mwl8EATgwuci95aXasXf5Q74A6FpAptypgOelQkshhJAc2FfwMSPr0vJ7Ojp9Wnh1dNv63H+bPTdEQ47mVrCWNowVeyFo+oBy1bOO35IOs313WL44aKWAJHsqNjZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110595; c=relaxed/simple;
	bh=11LWC1dHsw1h3mwOO/q+bhPVSG1jtOalR/V6EhebHss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ugwkafv70zRa1oYmpaFfH+GkuWh/FtH6TsmY6lt8pQmYyfWVFFXEIqMtzYGDv8BGcFlhQQOSzyAKbO5DyNrdFtilMTxBVakUrc/hgrfvOal2jQzn9Ck5zGcGtH+GYNseBUYgeVWICHntBp7PoQa4gie9SPcwXgGa315IGcSszp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DhBHlB9k; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DhBHlB9k"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-202318c4f45so19620035ad.0
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 16:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724110593; x=1724715393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9Cd04T134NyakvqbnePNRvSvtAZOKVt3h8rY/EORRs=;
        b=DhBHlB9kPRE3OvlpNaYq0ulQewwfugg2tbXVt2xQstZKMbcw5KClBgKS22C6Hklw2o
         vHd23AdKdGyXyiJqJFd8hJXkI91CjAMn18l94Fe1Y9IdKr5UJoah4XvK9hspn2VCTjgM
         9q1zQMHhhtwaT0D88vzhOnvtDcbL821ZYf7Ao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110593; x=1724715393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9Cd04T134NyakvqbnePNRvSvtAZOKVt3h8rY/EORRs=;
        b=PoRHQzSEqBWdSpN5Y7xFyPP/xYakih4pMQ4PLqZ36oVoVAWME2YYh2r2BPnSg3LBAR
         HEKWchVxhR+My6HGLPZBy7ZB/kl/LEKwyatClBpNLm3XzLkKlaNgvowGUYWhMVVgr0H+
         Ufy3mgZnF/bynJMUQDtiVq/n9917AJbHZ9xjj87LchHLwzj9hChhb2uDbv5eBpkwW5f8
         C9he9gQPJ4geNzm3Gkpq3IrA5m0SA46vPUFVeglnaf74sVLzKPAkjZV+9+gWhmAR4woC
         SUypX10ZoVRfAQYJxNbC0q4hHFjxaPJWbjsHoUvX27oaUFhw2bEoXhcSoMAyJE3jV7iZ
         PJ2g==
X-Forwarded-Encrypted: i=1; AJvYcCXNS14DdENf2iByjIpZvK4HQT3qGBFgh7JGpuQLHfIYv5j83FdWgkxDPaSVPK8cJqFUouwQXopa@lists.linux.dev
X-Gm-Message-State: AOJu0Yx90iWINZ2sGpahUMNo7VVcuMBZ5tkymkA+7to7h2p4N+EG020p
	AGzUZCzhVtmmN1igCR61XpNGyiQ8ySnexuvvB6KpYaINdQRdbh5lJDUzyVXx0A==
X-Google-Smtp-Source: AGHT+IHMdQuQYTmr1VZjFq64pkXwFedtdel2DhVJEBi38KoF3VM1xbdsltPsvQqi4APbbL4RALu4+w==
X-Received: by 2002:a17:903:2307:b0:1fd:a5a2:5838 with SMTP id d9443c01a7336-20203e5518fmr187693085ad.6.1724110592977;
        Mon, 19 Aug 2024 16:36:32 -0700 (PDT)
Received: from localhost (210.73.125.34.bc.googleusercontent.com. [34.125.73.210])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-201f0302e84sm67507995ad.32.2024.08.19.16.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 16:36:32 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	linux-clk@vger.kernel.org,
	Konrad Dybcio <konradybcio@kernel.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 2/2] clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time
Date: Mon, 19 Aug 2024 16:36:27 -0700
Message-ID: <20240819233628.2074654-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819233628.2074654-1-swboyd@chromium.org>
References: <20240819233628.2074654-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Amit Pundir reports that audio and USB-C host mode stops working if the
gcc_usb30_prim_master_clk_src clk is registered and
clk_rcg2_shared_init() parks it on XO. Skip parking this clk at
registration time to fix those issues.

Partially revert commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
registration") by skipping the parking bit for this clk, but keep the
part where we cache the config register. That's still necessary to
figure out the true parent of the clk at registration time.

Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
Fixes: 929c75d57566 ("clk: qcom: gcc-sm8550: Mark RCGs shared where applicable")
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Reported-by: Amit Pundir <amit.pundir@linaro.org>
Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/clk/qcom/clk-rcg.h    |  1 +
 drivers/clk/qcom/clk-rcg2.c   | 30 ++++++++++++++++++++++++++++++
 drivers/clk/qcom/gcc-sm8550.c |  2 +-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
index d7414361e432..8e0f3372dc7a 100644
--- a/drivers/clk/qcom/clk-rcg.h
+++ b/drivers/clk/qcom/clk-rcg.h
@@ -198,6 +198,7 @@ extern const struct clk_ops clk_byte2_ops;
 extern const struct clk_ops clk_pixel_ops;
 extern const struct clk_ops clk_gfx3d_ops;
 extern const struct clk_ops clk_rcg2_shared_ops;
+extern const struct clk_ops clk_rcg2_shared_no_init_park_ops;
 extern const struct clk_ops clk_dp_ops;
 
 struct clk_rcg_dfs_data {
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 30b19bd39d08..bf26c5448f00 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1348,6 +1348,36 @@ const struct clk_ops clk_rcg2_shared_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
 
+static int clk_rcg2_shared_no_init_park(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+
+	/*
+	 * Read the config register so that the parent is properly mapped at
+	 * registration time.
+	 */
+	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &rcg->parked_cfg);
+
+	return 0;
+}
+
+/*
+ * Like clk_rcg2_shared_ops but skip the init so that the clk frequency is left
+ * unchanged at registration time.
+ */
+const struct clk_ops clk_rcg2_shared_no_init_park_ops = {
+	.init = clk_rcg2_shared_no_init_park,
+	.enable = clk_rcg2_shared_enable,
+	.disable = clk_rcg2_shared_disable,
+	.get_parent = clk_rcg2_shared_get_parent,
+	.set_parent = clk_rcg2_shared_set_parent,
+	.recalc_rate = clk_rcg2_shared_recalc_rate,
+	.determine_rate = clk_rcg2_determine_rate,
+	.set_rate = clk_rcg2_shared_set_rate,
+	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
+};
+EXPORT_SYMBOL_GPL(clk_rcg2_shared_no_init_park_ops);
+
 /* Common APIs to be used for DFS based RCGR */
 static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
 				       struct freq_tbl *f)
diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index 0244a05866b8..5abaeddd6afc 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -1159,7 +1159,7 @@ static struct clk_rcg2 gcc_usb30_prim_master_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_no_init_park_ops,
 	},
 };
 
-- 
https://chromeos.dev

