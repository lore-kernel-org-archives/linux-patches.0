Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394425178C;
	Mon, 23 Jun 2025 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685341; cv=none; b=Qxppsq6/t1QjEplAFdbWYozeqqzEbPuPgiRfVdL8YcDgRa7LGOVZsz6C1uS6jySAemiYT9UU3watUORNVqgxBQRFf7WL7oqhtp676zMJ9AX4Hr7dgc+k6xNs70a/yZNl0Lu7ehjuTpM7dbnnbAa03oMFjYdmmCWLPFlOD4QA9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685341; c=relaxed/simple;
	bh=Zbt6ZBaqWAzyCtgAF7ybJG5UjgRgJlTeVAvX5CgG8UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN60hJbXwEjPe+KEtzFXL3blHC3yBKbY2EEbBXIg7IpYt331jyl75+G3hJPkHs02m2uQL/r9Br/BXKetUaZp5r69BESZ9v9b0Xs5v60oivFa0ZubcBKY4CJxpxUG5/D5j0x1DXt824W/+4G5sq22WoPjq6Xaj8E3lQBKAM6vzrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2PN/oho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2PN/oho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B60C4CEEA;
	Mon, 23 Jun 2025 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685341;
	bh=Zbt6ZBaqWAzyCtgAF7ybJG5UjgRgJlTeVAvX5CgG8UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2PN/ohoVh+HIFNHkvZk23hrPCKFWjdYK/5EGx86QCm4nw9QEAPv+42IwBvrZPpER
	 6O8MiF8e2d98whZdtT7kM4dOQEbSN34ZWaafEGJmclOnUwsu7TtxiBj9iXWaK18GTg
	 esGR1nP4EMCAl9X2JNPmFZYNxsH8tugiJD8EZdLY=
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
Subject: [PATCH 5.10 047/355] clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz
Date: Mon, 23 Jun 2025 15:04:08 +0200
Message-ID: <20250623130628.243810724@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39ebb443ae3d5..a51f5c25782f9 100644
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
 
@@ -1075,7 +1075,7 @@ static struct clk_rcg2 jpeg0_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_camss_mclk0_1_clk[] = {
-	F(24000000, P_GPLL0, 1, 1, 45),
+	F(24000000, P_GPLL6, 1, 1, 45),
 	F(66670000, P_GPLL0, 12, 0, 0),
 	{ }
 };
-- 
2.39.5



