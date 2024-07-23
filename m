Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5851581F4;
	Tue, 23 Jul 2024 18:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760164; cv=none; b=lBryyTa/XtBEYtmr05YYuew3uBDFoJu8DY/+qpCKI45QbF4/gJCTW3UbDuwFQGLdpu+NqGpxsyQyLO7S3yk9Y7uhrwciXs4Pxyu32xOGGy6NtjTyHXAIvqAZtMIZdGJnAoqtfVvio8vQGgOtUqZ3B3o8B63ueHDsbZcRSoBKPJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760164; c=relaxed/simple;
	bh=2wKien1XtKTYrTP7ZpuigxqTAUntQwoHcYzffovaZ64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s17SukM/wkdnZASZ3s+GC7O3/SnGJjVG++Zb3AepuHlmra7yLIjxCOmMfXDUTQFKYhOxj/rwb4rSBvGgiz6GdDSfBDEOI09eV7fqwX65mxu9vd9DzBjYr4tQUWzUah+vBfgYT78jvCABLxj41thpYZxtlCnZOUy6lxOTbNUirS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTAsPEqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTAsPEqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E0CC4AF0B;
	Tue, 23 Jul 2024 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760163;
	bh=2wKien1XtKTYrTP7ZpuigxqTAUntQwoHcYzffovaZ64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTAsPEqoRX48qBClDpGESli+tpQngNOF+xkbIXs36ntEa77jIOQT5nY1Jl2N/EZHz
	 yPD5SJrSKSBTRRyfFKqH91j+kjigvxXssXBcoKgDOWPQu4r1r27+2/pT0zX9I+C+5N
	 XqlcCyhaBcNZPyz9hV4L2GQLPfsuE53zmZ7ncqM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 123/163] clk: qcom: apss-ipq-pll: remove config_ctl_hi_val from Stromer pll configs
Date: Tue, 23 Jul 2024 20:24:12 +0200
Message-ID: <20240723180148.225170400@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 2ba8425678af422da37b6c9b50e9ce66f0f55cae ]

Since the CONFIG_CTL register is only 32 bits wide in the Stromer
and Stromer Plus PLLs , the 'config_ctl_hi_val' values from the
IPQ5018 and IPQ5332 configurations are not used so remove those.

No functional changes.

Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240509-stromer-config-ctl-v1-1-6034e17b28d5@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq-pll.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/apss-ipq-pll.c b/drivers/clk/qcom/apss-ipq-pll.c
index d7ab5bd5d4b41..e12bb9abf6b6a 100644
--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -100,7 +100,6 @@ static struct clk_alpha_pll ipq_pll_stromer_plus = {
 static const struct alpha_pll_config ipq5018_pll_config = {
 	.l = 0x2a,
 	.config_ctl_val = 0x4001075b,
-	.config_ctl_hi_val = 0x304,
 	.main_output_mask = BIT(0),
 	.aux_output_mask = BIT(1),
 	.early_output_mask = BIT(3),
@@ -114,7 +113,6 @@ static const struct alpha_pll_config ipq5018_pll_config = {
 static const struct alpha_pll_config ipq5332_pll_config = {
 	.l = 0x2d,
 	.config_ctl_val = 0x4001075b,
-	.config_ctl_hi_val = 0x304,
 	.main_output_mask = BIT(0),
 	.aux_output_mask = BIT(1),
 	.early_output_mask = BIT(3),
-- 
2.43.0



