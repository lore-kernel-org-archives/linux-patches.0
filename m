Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC12568526;
	Wed,  9 Sep 2026 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962290; cv=none; b=ZL3Dq54UpGcHOnWKv1z4lAM0bXMNHW0Nub40hP3d3FZdn5YiVAOS1OO/A11nCx/VCr34xm0kJ0xcIdDY/nMW1Diu1lENdayagDD5mTfKcgEDQl5HR68QirNKYfnG7G9p0jqlCIqo5GR8lEmL8iAFQ8tYr4e2ACO8PaTZNAOW5mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962290; c=relaxed/simple;
	bh=XxFDhmdg9Ac1wI84aB39rOvYej1AqTh+RP0eiJILz5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy5TD7zsg1sgfeaOxxy8twdAxF41ww1Tc5eobb66Ah6I7KDM5xbG5SSTSnJKlb/zaSiEN3YMPzhZcnL1qFdzDVWNPGHAjkTkZQgaRhXndKjCrEaR1wzSQeT0FO/K0pDJDPcc9gpJ34aeWaL9uSVHshi2YIkLPMvPxpiDXHStw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdIthjwF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdIthjwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6591F00A3D;
	Wed,  9 Sep 2026 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962289;
	bh=7AEZk+fmKHXKiCaZV3RpGNNIhDU7WAM0DA59rWLKjrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdIthjwFROKmmTX6ga5WzEnV0JXddghKjREfkwlOdgazPuWj6dTzVLsy04SxmsUbU
	 /HGZGt/MXVH0cx8JzDbG7q40bpVnjHvwJcruOu8YmPIqzGwByAZ98Tkc+razm9N3Zh
	 hJAovy05ynzyXUrFEGrcRR6SHtB+8U4vKv2FrdbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 212/556] clk: qcom: gcc-msm8939: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Wed,  9 Sep 2026 15:38:12 +0200
Message-ID: <20260909134237.853424192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit fc611445b021262b0d4ace6f716a360663816287 upstream.

MSM8939 is similar to MSM8916, where the GCC_BLSP1_SLEEP_CBCR register is
read-only and only has the CLK_OFF bit to check if the clock is running.
This is a shared vote clock, the correct way to enable it is to vote for
BLSP1_SLEEP_CLK_ENA (BIT(9)) in GCC_APCS_CLOCK_BRANCH_ENA_VOTE (0x45004).

Cc: stable@vger.kernel.org
Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-2-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-msm8939.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -1929,9 +1929,10 @@ static struct clk_branch gcc_blsp1_ahb_c
 
 static struct clk_branch gcc_blsp1_sleep_clk = {
 	.halt_reg = 0x01004,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x01004,
-		.enable_mask = BIT(0),
+		.enable_reg = 0x45004,
+		.enable_mask = BIT(9),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_sleep_clk",
 			.ops = &clk_branch2_ops,


