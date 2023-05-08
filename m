Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F87168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C7BC433EF;
	Mon,  8 May 2023 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545161;
	bh=IZEgaRIaxIfcMamfLugvk7FgPFzcCz3PuZZj/kiup4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIzAmgcwSlDhl+/WE/tj2uI2nMgAipKANX7ydJVtwZb4PPvPYIGOrjEtL7F9+EZTO
	 yVBjkA+nAPc5X8CZyeeHw5u/PnEJM2hHuhLFeEdvyKD1Kn/nKxQTXt5wmjMu6GAsdR
	 7wI3NqjEZRvZyrCDOxheDrEye1cIKR4TKd9d0h+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Rafi Shaik <quic_mohs@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 614/694] clk: qcom: lpassaudiocc-sc7280: Add required gdsc power domain clks in lpass_cc_sc7280_desc
Date: Mon,  8 May 2023 11:47:29 +0200
Message-Id: <20230508094455.367571817@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohammad Rafi Shaik <quic_mohs@quicinc.com>

[ Upstream commit aad09fc7c4a522892eb64a79627b17a3869936cb ]

Add GDSCs in lpass_cc_sc7280_desc struct.
When qcom,adsp-pil-mode is enabled, GDSCs required to solve
dependencies in lpass_audiocc probe().

Fixes: 0cbcfbe50cbf ("clk: qcom: lpass: Handle the regmap overlap of lpasscc and lpass_aon")
Signed-off-by: Mohammad Rafi Shaik <quic_mohs@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230407092255.119690-4-quic_mohs@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpassaudiocc-sc7280.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/lpassaudiocc-sc7280.c b/drivers/clk/qcom/lpassaudiocc-sc7280.c
index 1339f9211a149..134eb1529ede2 100644
--- a/drivers/clk/qcom/lpassaudiocc-sc7280.c
+++ b/drivers/clk/qcom/lpassaudiocc-sc7280.c
@@ -696,6 +696,8 @@ static const struct qcom_cc_desc lpass_cc_sc7280_desc = {
 	.config = &lpass_audio_cc_sc7280_regmap_config,
 	.clks = lpass_cc_sc7280_clocks,
 	.num_clks = ARRAY_SIZE(lpass_cc_sc7280_clocks),
+	.gdscs = lpass_aon_cc_sc7280_gdscs,
+	.num_gdscs = ARRAY_SIZE(lpass_aon_cc_sc7280_gdscs),
 };
 
 static const struct qcom_cc_desc lpass_audio_cc_sc7280_desc = {
-- 
2.39.2



