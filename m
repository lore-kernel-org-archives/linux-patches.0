Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D39346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302627; cv=none; b=g7VnHwH3paZ/JxNPlCSBQKoMpObTGRAhY1CgeEzuwNA+AiSNc8+CKYR/++pI9i85NIgd7UzT6F13pK4WZr5hF3ULkOJJcBXKrCJLkB9Ot6CUYk0h8+E5VjJbnsoAD4a/JsH9j7dWNA1Wyn2O5xOQvcpBnYOS/jE2FYuXeTPvPPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302627; c=relaxed/simple;
	bh=D7K9nksfjBqqxUb2cRNNRyU2ks3697V+y1gGEFEi4Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC81Uw6HFknas2yv/7a0cC5xbz4DfoC+pVcFt20rs/hena0DCQQG32RFbsbVgmFS1g+gPhFfp9EVmuVU210HHUmpqnAdQOuSRsWlYSrar2FwecbjR/VbLTSz5Qq5iRAdDWYfIoIlCghnliLxQgqhqI+GQO70KFmqTjvSYX6BAGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFvQ2+aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFvQ2+aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77430C19423;
	Sat, 28 Feb 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302627;
	bh=D7K9nksfjBqqxUb2cRNNRyU2ks3697V+y1gGEFEi4Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFvQ2+aaX73ASIsywRTVmB/tWerHbokf3sN/8305B8SP03L53pvc8/+ftgz6lXHs6
	 RGvZrzniAVTyGejSks5tLGKiZenp6APOBEoImkyliEBEfDt/2Uuuoo4RBP9Mabj1bA
	 TcVOUN82W0s+W1Inv53+taNzrir0fUsivrdtS4WruDx5WnLEiZkb73j858kxfvEXgL
	 zqt4wTdSeQEkOjv4ztTnz5qU3+0BxB6dDVqnKdVDFxD8LxcfxwSVP4ZanQvLap4SHX
	 AB3uQGbD3row8Avr/+v+fZ25FZ9TCm+TJeqo+7Bx2E6659fibu1yeJ+o7OfcPXdejr
	 CKf126cXw7AMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
	Venkata Prasad Potturu <quic_potturu@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/164] pinctrl: qcom: Update macro name to LPI specific
Date: Sat, 28 Feb 2026 13:14:45 -0500
Message-ID: <20260228181505.1600663-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit 6454711015267fe38b6f05aba232e01be2cb9693 ]

Update NO_SLEW macro to LPI_NO_SLEW macro as this driver lpi specific.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Co-developed-by: Venkata Prasad Potturu <quic_potturu@quicinc.com>
Signed-off-by: Venkata Prasad Potturu <quic_potturu@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1650285427-19752-4-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: eabf273c8466 ("pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
index 586c5b70cba13..5e89fa4176a2c 100644
--- a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
@@ -40,7 +40,7 @@
 #define LPI_GPIO_KEEPER			0x2
 #define LPI_GPIO_PULL_UP		0x3
 #define LPI_GPIO_DS_TO_VAL(v)		(v / 2 - 1)
-#define NO_SLEW				-1
+#define LPI_NO_SLEW				-1
 
 #define LPI_FUNCTION(fname)			                \
 	[LPI_MUX_##fname] = {		                \
@@ -194,14 +194,14 @@ static const struct lpi_pingroup sm8250_groups[] = {
 	LPI_PINGROUP(3, 8, swr_rx_clk, qua_mi2s_data, _, _),
 	LPI_PINGROUP(4, 10, swr_rx_data, qua_mi2s_data, _, _),
 	LPI_PINGROUP(5, 12, swr_tx_data, swr_rx_data, _, _),
-	LPI_PINGROUP(6, NO_SLEW, dmic1_clk, i2s1_clk, _,  _),
-	LPI_PINGROUP(7, NO_SLEW, dmic1_data, i2s1_ws, _, _),
-	LPI_PINGROUP(8, NO_SLEW, dmic2_clk, i2s1_data, _, _),
-	LPI_PINGROUP(9, NO_SLEW, dmic2_data, i2s1_data, _, _),
+	LPI_PINGROUP(6, LPI_NO_SLEW, dmic1_clk, i2s1_clk, _,  _),
+	LPI_PINGROUP(7, LPI_NO_SLEW, dmic1_data, i2s1_ws, _, _),
+	LPI_PINGROUP(8, LPI_NO_SLEW, dmic2_clk, i2s1_data, _, _),
+	LPI_PINGROUP(9, LPI_NO_SLEW, dmic2_data, i2s1_data, _, _),
 	LPI_PINGROUP(10, 16, i2s2_clk, wsa_swr_clk, _, _),
 	LPI_PINGROUP(11, 18, i2s2_ws, wsa_swr_data, _, _),
-	LPI_PINGROUP(12, NO_SLEW, dmic3_clk, i2s2_data, _, _),
-	LPI_PINGROUP(13, NO_SLEW, dmic3_data, i2s2_data, _, _),
+	LPI_PINGROUP(12, LPI_NO_SLEW, dmic3_clk, i2s2_data, _, _),
+	LPI_PINGROUP(13, LPI_NO_SLEW, dmic3_data, i2s2_data, _, _),
 };
 
 static const struct lpi_function sm8250_functions[] = {
@@ -438,7 +438,7 @@ static int lpi_config_set(struct pinctrl_dev *pctldev, unsigned int group,
 			}
 
 			slew_offset = g->slew_offset;
-			if (slew_offset == NO_SLEW)
+			if (slew_offset == LPI_NO_SLEW)
 				break;
 
 			mutex_lock(&pctrl->lock);
-- 
2.51.0

