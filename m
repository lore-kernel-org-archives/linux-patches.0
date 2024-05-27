Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D615FCF0;
	Mon, 27 May 2024 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838618; cv=none; b=VR9rrtjnOkwZ1tD+18WsOU6yjKJZZ+79ZyOWrCMR3OFEACjMdAQ6yUtXfV82k0XOkwtpycMYI3Twmb9bDJsjayBB7fa8RQ5OFEQnGimqvQ+XsAAxlG67cX27MpB6qz3mKoqTON3bWTSuuEFJjxRI7yIuhF+wO1Tb9ghR0pEEYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838618; c=relaxed/simple;
	bh=b9I/8LIDwPAcgjM6gxUICXipoZo3ssPfNR8YVA3sMYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSCKN4MglU/NIdklhBKWTUD9qouIR0J5JJqMint6EZ0ZbOa/NrpayBDDg58cVaAdre4vOhTJzHe4orGz9mNE9hdXyz0RpC5fLbPhNSLCSm8gwGRxQBFz1oOyMlCorX1pp7PuSvsk1vrBM38lxi+XlCqzJIVON2J79xCkU85snrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQvzOLfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQvzOLfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA64FC2BBFC;
	Mon, 27 May 2024 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838618;
	bh=b9I/8LIDwPAcgjM6gxUICXipoZo3ssPfNR8YVA3sMYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQvzOLfGSKewEksaPrKnrAs6cpF9RpjM773PMSBzcT3iiC81fclQ8I1ad4zrt6RTA
	 Kraf6kFgIQB12lTHFSTniQ/FZrMg1RGExvhpv1gBbacXuTgrHM5IpaCnv0a5Q6Glh2
	 n6MXM21iSQ1PF5lB9ErfePAeWAtxaDAR2jFh/ZI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 462/493] clk: qcom: apss-ipq-pll: fix PLL rate for IPQ5018
Date: Mon, 27 May 2024 20:57:44 +0200
Message-ID: <20240527185645.304455062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit c55f7ee2ec239b6afd8639c7ac06493876deb0ea ]

According to ipq5018.dtsi, the maximum supported rate by the
CPU is 1.008 GHz on the IPQ5018 platform, however the current
configuration of the PLL results in 1.2 GHz rate.

Change the 'L' value in the PLL configuration to limit the
rate to 1.008 GHz. The downstream kernel also uses the same
value [1]. Also add a comment to indicate the desired
frequency.

[1] https://git.codelinaro.org/clo/qsdk/oss/kernel/linux-ipq-5.4/-/blob/NHSS.QSDK.12.4/drivers/clk/qcom/apss-ipq5018.c?ref_type=heads#L151

Fixes: 50492f929486 ("clk: qcom: apss-ipq-pll: add support for IPQ5018")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240326-fix-ipq5018-apss-pll-rate-v1-1-82ab31c9da7e@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/apss-ipq-pll.c b/drivers/clk/qcom/apss-ipq-pll.c
index 678b805f13d45..5e3da5558f4e0 100644
--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -73,8 +73,9 @@ static struct clk_alpha_pll ipq_pll_stromer_plus = {
 	},
 };
 
+/* 1.008 GHz configuration */
 static const struct alpha_pll_config ipq5018_pll_config = {
-	.l = 0x32,
+	.l = 0x2a,
 	.config_ctl_val = 0x4001075b,
 	.config_ctl_hi_val = 0x304,
 	.main_output_mask = BIT(0),
-- 
2.43.0



