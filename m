Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB2E11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E023C433C8;
	Mon, 11 Sep 2023 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443633;
	bh=a9EX2WBfgG1fqeyTJU8pZe6sXUcqDqL2WYREXuikm2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4tYxaJJP+lGN2BVxzDYiKv1RKgbkliB3HS8BZadZnJcFqpPpTfomOKM+HRIOVjWt
	 dk2z28HEAq2lvYw7Kw+QlZk1KhZLHsjqUvRlMLw1/U4R2op0ioYhHf8c0oDbzfuiy6
	 QwSzv0Hx7ZLkXStJvZZyjt36VmKo+8f/dfWEyKks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 446/737] clk: imx8mp: fix sai4 clock
Date: Mon, 11 Sep 2023 15:45:05 +0200
Message-ID: <20230911134703.059980799@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit c30f600f1f41dcf5ef0fb02e9a201f9b2e8f31bd ]

The reference manual don't mention a SAI4 hardware block. This would be
clock slice 78 which is skipped (TRM, page 237). Remove any reference to
this clock to align the driver with the reality.

Fixes: 9c140d992676 ("clk: imx: Add support for i.MX8MP clock driver")
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20230731142150.3186650-1-m.felsch@pengutronix.de
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8mp.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mp.c b/drivers/clk/imx/clk-imx8mp.c
index 1469249386dd8..670aa2bab3017 100644
--- a/drivers/clk/imx/clk-imx8mp.c
+++ b/drivers/clk/imx/clk-imx8mp.c
@@ -178,10 +178,6 @@ static const char * const imx8mp_sai3_sels[] = {"osc_24m", "audio_pll1_out", "au
 						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
 						"clk_ext3", "clk_ext4", };
 
-static const char * const imx8mp_sai4_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
-						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
-						"clk_ext1", "clk_ext2", };
-
 static const char * const imx8mp_sai5_sels[] = {"osc_24m", "audio_pll1_out", "audio_pll2_out",
 						"video_pll1_out", "sys_pll1_133m", "osc_hdmi",
 						"clk_ext2", "clk_ext3", };
@@ -567,7 +563,6 @@ static int imx8mp_clocks_probe(struct platform_device *pdev)
 	hws[IMX8MP_CLK_SAI1] = imx8m_clk_hw_composite("sai1", imx8mp_sai1_sels, ccm_base + 0xa580);
 	hws[IMX8MP_CLK_SAI2] = imx8m_clk_hw_composite("sai2", imx8mp_sai2_sels, ccm_base + 0xa600);
 	hws[IMX8MP_CLK_SAI3] = imx8m_clk_hw_composite("sai3", imx8mp_sai3_sels, ccm_base + 0xa680);
-	hws[IMX8MP_CLK_SAI4] = imx8m_clk_hw_composite("sai4", imx8mp_sai4_sels, ccm_base + 0xa700);
 	hws[IMX8MP_CLK_SAI5] = imx8m_clk_hw_composite("sai5", imx8mp_sai5_sels, ccm_base + 0xa780);
 	hws[IMX8MP_CLK_SAI6] = imx8m_clk_hw_composite("sai6", imx8mp_sai6_sels, ccm_base + 0xa800);
 	hws[IMX8MP_CLK_ENET_QOS] = imx8m_clk_hw_composite("enet_qos", imx8mp_enet_qos_sels, ccm_base + 0xa880);
-- 
2.40.1



