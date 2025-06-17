Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCE20F090;
	Tue, 17 Jun 2025 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174893; cv=none; b=ICQzCD+0V2RTK9jL1a6t7hCx3MW5tGrq3ZrDIqsnS/zgOtpDuXTUkG6KHL9aA1zdO27G5QxYIB79gxeXQqPwTIt96SZLm1NbSLmDEJIeZBwHEYuUcaAoBlNAQRjWne01rnB/T4WwUlRUCsj0BK8r7Cz1f9ZmK5UOWLDAdCek3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174893; c=relaxed/simple;
	bh=LyToWkC2Ggt/Xj461Pdm5K7hxVv7cr3oSpx58s8OFxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLP4zUJe6KXvXxzYS/Gwv0bXrYfpL2VHZd20pq+OlFZ4bSN/7QLp7uhpszpPafmvZCUNA6o1YHmHzNsD6kgU4T528g86zrQuCoaz8SmuIDuSSuujoRY2xOwkYlQ3DS6G+ZjUe6xGPi6piFQ0DiCE0sKz1koS/Ws9ItPHEpKx9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6cunzRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6cunzRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F61C4CEE3;
	Tue, 17 Jun 2025 15:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174892;
	bh=LyToWkC2Ggt/Xj461Pdm5K7hxVv7cr3oSpx58s8OFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6cunzRl2mw6Z8ehiEuog7uI1LQtPRW5EDazPwS7vEdiIgLb+ld88vbTYgzkP5dya
	 u/Qm1u7UQ5oxKgMEq7wHeEST67hamTGWiU8FAp8/q6S8yKblZ+WpOI4xpPRzkQUQuA
	 9eji1fKScv3Rdj2j/sJcfP2bB/qOi9iv181lhzdA=
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
Subject: [PATCH 6.6 123/356] clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz
Date: Tue, 17 Jun 2025 17:23:58 +0200
Message-ID: <20250617152343.180867582@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b45f97c07eeb6..e4a44377b75f7 100644
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
 
@@ -1100,7 +1100,7 @@ static struct clk_rcg2 jpeg0_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_camss_mclk0_1_clk[] = {
-	F(24000000, P_GPLL0, 1, 1, 45),
+	F(24000000, P_GPLL6, 1, 1, 45),
 	F(66670000, P_GPLL0, 12, 0, 0),
 	{ }
 };
-- 
2.39.5



