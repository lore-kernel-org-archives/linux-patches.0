Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25548429CC8;
	Sat, 12 Sep 2026 11:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213428; cv=none; b=CURuK3q/sP1ndiLeflG6GBwrzuVW0RoB6Z8bLj/Vo/X5vpFvNZfKxKFpr89nIcQFd6GjYIcp6e7IuarhKyvOu12wOHLN6gR/HzvRZ/dt7z8/tSqDWGZ2IefpwsaJy7th8Fb0MBpe2A+IIyVBaJcP0tdx7Di7rJ2X9CNa1b3Z9AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213428; c=relaxed/simple;
	bh=LiaTB1cEJ0jwtyhzm9VESCHCOvTYkdcgvB5tCw3dCHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW0QxKyaS7UmNjfWmCZRqzrXkFs5PvZtNt2k+BRb3HtGq3ba3j+LnyR9N0ZSywQ6C9RrO4xqgbGq9GvkYih9GKwsMuuQZtk4D39G5RrycntzGnResZ8mJ3OEVafMlVCwxYTwu5ex8pRn6aF30O29q5BwbZT/lgU0EvfCOkMb1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTqCVbiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTqCVbiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00181F000FF;
	Sat, 12 Sep 2026 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213425;
	bh=pCYZ3i8xXoyvssiD81xJnq4sbT5DYyLGsQNwCE+HQ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTqCVbiM01neemax+G1G1Wz5DTlB4iIIvFb0O86y06YmqRfczfW9R1N7/fNHvRQnC
	 74CI2viyZPdB4gjgeJEei1tI+0aJ9HulW2aOOsphJG4MY2ulyuLY2/7VdMNsJk1/LN
	 FXZpwDFp7ss/am/i/ANKGzmwDzhZ8fEabVDi+PNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 0119/1376] clk: qcom: gcc-msm8939: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Sat, 12 Sep 2026 08:42:25 +0200
Message-ID: <20260912065610.206512989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


