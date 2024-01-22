Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6328C08;
	Tue, 23 Jan 2024 00:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969606; cv=none; b=Nfsr8py4OXNMFzft1ep+QemnumhGKKAU43/MtkI0+7+C1MFZsxHunl2qyB4qht6gDZG5qC7QDruTDwsAKDWJehgY+gR3WTgnfntTus1PDNEupLr84ym6XT+bjQb/nX3V+r/Lk9ojxWWcXpa/dUu8dciQvG7Wm26fZMy6zd9d+TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969606; c=relaxed/simple;
	bh=n7qg2hFYrCo1VzrV8f8lsJonzl55W+cpJJtlRMS1OqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgj3Nm4j+qMKvZoaApnBgNUWgGgD3FgyI3WC0TuEeq4uk8vbstcysMfntROWxsVIPfvq/rKvLmH4CW9mXLnWuqHu95UNuQMrt+bEMESI7bFFAWhjSdGw8jgKKJBRqQZxgbllnQL4NckNzBDy1vHkWXVfyJoh4UqFYuB/cGSz6dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaAHzAqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaAHzAqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAE8C433C7;
	Tue, 23 Jan 2024 00:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969606;
	bh=n7qg2hFYrCo1VzrV8f8lsJonzl55W+cpJJtlRMS1OqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaAHzAqZc2Jx4IF5vTvBOFwUEtlQmFoWoi5Wmxmv+yQfD/LeFCwYYNUmunVGy+Doh
	 NBD/tKu2kTp3Iq6nbtBDv9xzPhDquQ9Y968jkcC+Yzm3DE4iy9MwJJmPwZBFpMGYL1
	 cUJdDjwS5cA9eftKznPZe1K1WSsrDTkcnGLUTtJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 353/641] clk: qcom: dispcc-sm8550: Use the correct PLL configuration function
Date: Mon, 22 Jan 2024 15:54:17 -0800
Message-ID: <20240122235828.977508290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit c559bcb92564cbaedd43c749cf9b6fbb3d53ad5e ]

To ensure that all fields (particularly CAL_L and CAL_L_RINGOSC) are
filled properly, use the correct prepare function for OLE PLLs.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-9-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 0b8f0904b339..f96d8b81fd9a 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -1774,8 +1774,8 @@ static int disp_cc_sm8550_probe(struct platform_device *pdev)
 		goto err_put_rpm;
 	}
 
-	clk_lucid_evo_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
-	clk_lucid_evo_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
+	clk_lucid_ole_pll_configure(&disp_cc_pll0, regmap, &disp_cc_pll0_config);
+	clk_lucid_ole_pll_configure(&disp_cc_pll1, regmap, &disp_cc_pll1_config);
 
 	/* Enable clock gating for MDP clocks */
 	regmap_update_bits(regmap, DISP_CC_MISC_CMD, 0x10, 0x10);
-- 
2.43.0



