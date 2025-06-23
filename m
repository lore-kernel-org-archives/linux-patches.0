Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BE253B47;
	Mon, 23 Jun 2025 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685438; cv=none; b=PXY/SbkRviw7L6rFi6njG/8y2U4LRRbiTbix9I0R2CzTq83v7QfygkaXLTCR48kWOND8NW4hApJS395rIP2xZKPrN6QSwSCQ9kMtFiJ6UkahTUYxffklmiReogt5V/P7Eor3iR2/Ci6qwMfN4tJ9IAForwsGrkoCEDhNnTPsSvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685438; c=relaxed/simple;
	bh=9bwwbRu6CklhZOMvpfaCq44R8evY4e3W5mOzjQfrsFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYgGSib3xsdtQ19sLDy7h4g1scA2Zt0jVaZUKKUM0hTc9RcluV+Gn8JHHouPSsqpjCxbC/UFoBsstsBMOzGeWWYs9MMnW8buA/00kIQLyXDHHMH5QVE+Dhqq3HtN0abhgoRiLVcksIdM1z1hlSgUc/Yrb22rKUidCU2TI5twm8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbT7dlQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbT7dlQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0343C4CEEA;
	Mon, 23 Jun 2025 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685438;
	bh=9bwwbRu6CklhZOMvpfaCq44R8evY4e3W5mOzjQfrsFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbT7dlQ8v6zokrqEN+ucEy7r+6q3gZw7FIN63KlHV5XOr7wBGRV/U7s7/AlwTwEoH
	 t1vGRxGWGLObrcxJjleKRYegGKf7NdHpbjb1emHmu8u+6Nxk1GIPVfuzH1fnEibDLz
	 oMz825ibFEbtKzrwI2ReO/Xjpf/QMO6vqfmPCnfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vincent Knecht <vincent.knecht@mailoo.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/411] clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz
Date: Mon, 23 Jun 2025 15:03:23 +0200
Message-ID: <20250623130634.761528308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Knecht <vincent.knecht@mailoo.org>

[ Upstream commit 9e7acf70cf6aa7b22f67d911f50a8cd510e8fb00 ]

Fix mclk0 & mclk1 parent map to use correct GPLL6 configuration and
freq_tbl to use GPLL6 instead of GPLL0 so that they tick at 24 MHz.

Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Suggested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vincent Knecht <vincent.knecht@mailoo.org>
Link: https://lore.kernel.org/r/20250414-gcc-msm8939-fixes-mclk-v2-resend2-v2-1-5ddcf572a6de@mailoo.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8939.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8939.c b/drivers/clk/qcom/gcc-msm8939.c
index de0022e5450de..81db8877acc2c 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -433,7 +433,7 @@ static const struct parent_map gcc_xo_gpll0_gpll1a_gpll6_sleep_map[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0, 1 },
 	{ P_GPLL1_AUX, 2 },
-	{ P_GPLL6, 2 },
+	{ P_GPLL6, 3 },
 	{ P_SLEEP_CLK, 6 },
 };
 
@@ -1087,7 +1087,7 @@ static struct clk_rcg2 jpeg0_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_camss_mclk0_1_clk[] = {
-	F(24000000, P_GPLL0, 1, 1, 45),
+	F(24000000, P_GPLL6, 1, 1, 45),
 	F(66670000, P_GPLL0, 12, 0, 0),
 	{ }
 };
-- 
2.39.5



