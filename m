Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B41A6192;
	Tue, 30 Jul 2024 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359133; cv=none; b=qyxrVkl7pNTKp9RUxvUKbUiqbZMspUorwvmRcs0c0gu3A4tJVgM0kAGjOxW9k6902i9ShSzfW93QKomLMZNnR9y4i7roSNWPntYbMsk7UVuLzo2opxvorm9I2aA3vCFuc9K2RiFuZ1eHI3XbWDtatSWEH9Z7iHVhKx0PtSxA2dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359133; c=relaxed/simple;
	bh=w0Oj7KzR6oBJkPhFxeLHaA8gpxtLGp0bzIwy8uxFUdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6oyJDJ4J8Sv3K64K5msq2Zoy6y29c60OWY+Z5omgfagAU+jI2vLRn0lUfDaeQeUpXfbYOA7AvCPHWwB6t3kBPgdXscbiRDIBVrt01S+HW2FZ422S6k0cdoT3NucLJjdOgVhhaj5x+3te6hzk1kgK41HMqa9hdTcxb9poda9PJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rn+vD0g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rn+vD0g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1FBC32782;
	Tue, 30 Jul 2024 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359133;
	bh=w0Oj7KzR6oBJkPhFxeLHaA8gpxtLGp0bzIwy8uxFUdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn+vD0g6Lrd3wTBSeItexA8xljbwox7Fca5DqJsovVIT57rgflBZIfz78g7kwClnK
	 3AGg/Y7Slho8ifavxJGg8igHj2mQ9CVNsV/BwrQaOlmn7Vid4h1akN4ch3UeuS0GcQ
	 a+qV+fcwIGs5PHXSi5DdMNoXSeVgg+gdA+U33xIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 416/809] clk: qcom: gpucc-sa8775p: Update wait_val fields for GPU GDSCs
Date: Tue, 30 Jul 2024 17:44:52 +0200
Message-ID: <20240730151741.126793172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 211681998d706d1e0fff6b62f89efcdf29c24978 ]

Update wait_val fields as per the default hardware values of the GDSC as
otherwise it would lead to GDSC FSM state stuck causing power on/off
failures of the GSDC.

Fixes: 0afa16afc36d ("clk: qcom: add the GPUCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-6-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sa8775p.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gpucc-sa8775p.c b/drivers/clk/qcom/gpucc-sa8775p.c
index 1f7a02a7503d4..3deabf8333883 100644
--- a/drivers/clk/qcom/gpucc-sa8775p.c
+++ b/drivers/clk/qcom/gpucc-sa8775p.c
@@ -523,6 +523,9 @@ static struct clk_regmap *gpu_cc_sa8775p_clocks[] = {
 
 static struct gdsc cx_gdsc = {
 	.gdscr = 0x9108,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.gds_hw_ctrl = 0x953c,
 	.pd = {
 		.name = "cx_gdsc",
@@ -533,6 +536,9 @@ static struct gdsc cx_gdsc = {
 
 static struct gdsc gx_gdsc = {
 	.gdscr = 0x905c,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "gx_gdsc",
 		.power_on = gdsc_gx_do_nothing_enable,
-- 
2.43.0



