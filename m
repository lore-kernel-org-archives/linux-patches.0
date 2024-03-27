Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F31A152501
	for <patches@lists.linux.dev>; Wed, 27 Mar 2024 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571267; cv=none; b=JCGNPrQBJdLKTnXUgIZJxy+7k6tNRhrWFQzSZQLWhSvcUG75Pi8nAEN81eAnUWxZwmPZTA26cu/AdBJndJssSow45cgt6pj4evf68Z5xq01JVLyzm3r0JN01HqiLHhWKYxyK7CL4+czBaJwQxAfCZdl0MBQsni1k0gwjG5S6CtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571267; c=relaxed/simple;
	bh=5oad9tk6xdefUEpfxlO0qYtx6N8maziQMfOniCqwJyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hm3RZwDkV/hnlF27bGS5ggCOYYqpIxoD8FjviKI1PeCS3bMxPnsdluxjA88I7gZ3JXwUnFSLhI8Vq6f1n+NNKQMnVePj+PgRDDAc99FtN5INf/lXPLU25UPeKFsOBZCGW5ML9NTBP44dyTTtcNVpEiM+e+wNojUSuTNwLklKlIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=F18lpRsq; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F18lpRsq"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-29deb7e2f7aso217107a91.1
        for <patches@lists.linux.dev>; Wed, 27 Mar 2024 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711571265; x=1712176065; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOsAStJoLrdj/BC0nTULl44A6A/+Mu8syVTsqrg00QY=;
        b=F18lpRsqumP0lYGUQZ7ssxekwwnCw0JAa+zw1QW+HSXdUyHnuTdcKBYCq/MwlN6tk+
         VwRCiSDDO0jHfq6W9Xu90zJFrDWNrZ7RwPLWvUFKNPYuUM/JIoco3XPnJJiLU81TBw+p
         WBGr33ihwLCqB/A9x1FPWVRcA92mMqVOuCFus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711571265; x=1712176065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOsAStJoLrdj/BC0nTULl44A6A/+Mu8syVTsqrg00QY=;
        b=r+PE4c7F8525KqzYiGBBOjv23q1D/D0aOGtrlwko7xpZ+E3nYHYxeOfUQ9ObKerU9a
         xeoQ/lahhgXFEWzn5BJAislCsxpWX5XV6gIA1DLZhPQXfis8HSfq6jdvzF5NAMpuVDfl
         vpulQPEMLeB0dv2EeXvud4Qk6VWdFvaVMaI5iYc80z//hWTQDuNsQXIsyq046CrwI50L
         GbC5HToH+TTm7w0OUm+LuEQxXilbS3VhMUO8Rg5WxDNA6tR90EoBg5HvNcNsBtXSr3Fo
         t7Pq5kKE0FeytnIyAXRHWGzOf4U3z2RtUYqalDPTEbkklDX/x2/1/AM6JQrIID083+k1
         d7lw==
X-Forwarded-Encrypted: i=1; AJvYcCUcMghi6GQlVBqYo4eOQ9HEzV1MRDD9ht9/9BMf41tgpqxphw2rhAXxZtdHpjkH/br5DU4SJii3k0YrXXarOh6dE3drD5o/eQ==
X-Gm-Message-State: AOJu0YxH+viaW+iQZN0QlrOMcnl9OFmjgATb9+LvkqIRRpPdTXVzr9Bm
	4ml05Znr7FWn3L058jwF3jgEg4oJyE4O0iJ38fqH+ijUlxTXHVLwfrP9jiDXWA==
X-Google-Smtp-Source: AGHT+IEsci/FRTRW4pt6BJLZbr1PpuxpETOrv0oWRHOV5f+8PsFRccHqiRauOWrEOQ+yKC5ucYNhyg==
X-Received: by 2002:a17:90a:8402:b0:299:72d7:5b9a with SMTP id j2-20020a17090a840200b0029972d75b9amr706179pjn.24.1711571265285;
        Wed, 27 Mar 2024 13:27:45 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id si13-20020a17090b528d00b0029fe0b8859fsm3602158pjb.1.2024.03.27.13.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 13:27:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: [PATCH 1/2] clk: qcom: dispcc-sc7180: Force off rotator clk at probe
Date: Wed, 27 Mar 2024 13:27:37 -0700
Message-ID: <20240327202740.3075378-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
In-Reply-To: <20240327202740.3075378-1-swboyd@chromium.org>
References: <20240327202740.3075378-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'disp_cc_mdss_rot_clk' is parented to 'disp_cc_pll0' and enabled out
of boot on sc7180 Trogdor devices. This is a problem because the mdss
driver (the driver for compatible node "qcom,sc7180-mdss") turns off
'disp_cc_mdss_mdp_clk' and that clk is also parented to 'disp_cc_pll0'.
When the display pll turns off, the rotator clk gets stuck on.

We don't really care about this clk being on through boot, so simply
disable the clk during driver probe to avoid this issue.

Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/clk/qcom/dispcc-sc7180.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
index 9536bfc72a43..a3356a7758b3 100644
--- a/drivers/clk/qcom/dispcc-sc7180.c
+++ b/drivers/clk/qcom/dispcc-sc7180.c
@@ -705,6 +705,20 @@ static int disp_cc_sc7180_probe(struct platform_device *pdev)
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
+	/*
+	 * Force off 'disp_cc_mdss_rot_clk' so that the driver for the
+	 * "qcom,sc7180-mdss" compatible node can disable
+	 * 'disp_cc_mdss_mdp_clk', which in turn disables 'disp_cc_pll0',
+	 * without making this clk stuck on. When the mdss driver runtime
+	 * suspends, the mdss_gdsc will turn off. If 'disp_cc_mdss_rot_clk'
+	 * isn't off or parked on XO at this time it will wedge the GDSC and
+	 * then 'disp_cc_mdss_mdp_clk' will fail to turn on because the GDSC is
+	 * wedged.
+	 */
+	regmap_update_bits(regmap,
+			   disp_cc_mdss_rot_clk.clkr.enable_reg,
+			   disp_cc_mdss_rot_clk.clkr.enable_mask, 0);
+
 	/* 1380MHz configuration */
 	disp_cc_pll_config.l = 0x47;
 	disp_cc_pll_config.alpha = 0xe000;
-- 
https://chromeos.dev

