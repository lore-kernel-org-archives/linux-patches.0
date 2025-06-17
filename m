Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C439C2ECE80;
	Tue, 17 Jun 2025 15:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175853; cv=none; b=QDMrb9+ivpJmLRe0x67aMnvKi2kuHIgwn0d+GR6V0HiU3lvLvFT5jMdHzlMlkhQcL/yXClfi1pEtY5pvhiGpNJFibC4ecDhVRYV+NeeGTGqOg+IanaGrr/Kier90ooxpq9ZBCDblCyIDxdBcIv0nNzXZoKh3VPD/xFn6p7yfZtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175853; c=relaxed/simple;
	bh=jL1DVa3GLcpcYSoSMwkAf0Pe6nipGvpUg4vqx2cUyIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVifhGP8ly2KbQPy1BUG/dgzX/HI6+xbNvCVGEL0VWXFu05nB5PfMVg8uqyhwY+hSlICdxVlWwL6C4xqJDaifDOPuEZ2wEXW7lJBEKiS53HqQ3DDhTdkujIee+TVCJNaO8OQ5I+GkuVV8cRcS+oma5cpnYEYhRSdBScGGN5Is3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=An7BITY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="An7BITY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB656C4CEE3;
	Tue, 17 Jun 2025 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175853;
	bh=jL1DVa3GLcpcYSoSMwkAf0Pe6nipGvpUg4vqx2cUyIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An7BITY97xiHUW6x4Dc1AVgMAUFYy461f9C5JrfWUbRbeV+6GY2u7aqBsRsfbcONR
	 XoziCgR8ExcuVZoch/mpqBdhARkEVw4aqtURCeTeIwSpQeutZmDnC5Vh+ozgcA2MHs
	 BbnSsfcL9YOdeYoxPdULGqhSoLLflpIYYOpjHRqg=
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
Subject: [PATCH 6.12 169/512] clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz
Date: Tue, 17 Jun 2025 17:22:15 +0200
Message-ID: <20250617152426.470636267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7431c9a65044f..45193b3d714ba 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -432,7 +432,7 @@ static const struct parent_map gcc_xo_gpll0_gpll1a_gpll6_sleep_map[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0, 1 },
 	{ P_GPLL1_AUX, 2 },
-	{ P_GPLL6, 2 },
+	{ P_GPLL6, 3 },
 	{ P_SLEEP_CLK, 6 },
 };
 
@@ -1113,7 +1113,7 @@ static struct clk_rcg2 jpeg0_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_camss_mclk0_1_clk[] = {
-	F(24000000, P_GPLL0, 1, 1, 45),
+	F(24000000, P_GPLL6, 1, 1, 45),
 	F(66670000, P_GPLL0, 12, 0, 0),
 	{ }
 };
-- 
2.39.5



