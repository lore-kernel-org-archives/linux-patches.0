Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C833F59A;
	Sat, 12 Sep 2026 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213451; cv=none; b=PCFTrNV1mFpBQ9shQ62HrJx1v2CqEwjwbFsX6KTurZgkWRkXOZQVAiku/tYWK6+P7tH3KP9gaf/BKkpIV7e1UQS5NoI+fOJoO0N3WTq4GsW93VJQTeHyp/ZOIb0m0+kIRwJnYFXoxoFRsP8JPzqWYOayAvBMVwDhg2zmLEAKEfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213451; c=relaxed/simple;
	bh=XgiWzxZEJe8BqgurrcZ/d7YrDPOROZ/anajlZGNUtg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiOafgg+PPcZBPGdRpJEXkb3DHSjDFIOCpMBqoIBLJerpaKhMBelyzTzMnqJhI30kDQnc3vPySk6VCVuqv3o5iyIFdv9XC6Urnxn86J44YbX/WIkFArk3gKCy1gCC21FbX8lYKMRcaur7uYSszxeQZCgJ6TX8JZz9dX09PRHumo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shOBbKIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shOBbKIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0E41F000FF;
	Sat, 12 Sep 2026 11:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213449;
	bh=SyYdZyDuGa3tewEO2PTWPv5C1VoRqer0koCYP2UTvWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shOBbKIQlUPnlH14X2dookbBvXe+i+GD1LV9LsgiBi2tQttuDB2x0baY7AFJN8p2Z
	 w7qcSSsN4iWv0PcZHLeVdBwmkt5MK+wet5h1qeeMxiyO4lSNfmlGcn60aKEPOOK0GS
	 GXSfFFUV/DrYfwd9T43UvPwq/Qj5zwpVlozOt00A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 0123/1376] clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk
Date: Sat, 12 Sep 2026 08:42:29 +0200
Message-ID: <20260912065610.296281151@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

commit 944d0fb38cffe57a1d1ebf82c5c077bad82dcdbb upstream.

MDM9607 is similar to MSM8909, where the GCC_BLSP1_SLEEP_CBCR register is
read-only and only has the CLK_OFF bit to check if the clock is running.
This is a shared vote clock, the correct way to enable it is to vote for
BLSP1_SLEEP_CLK_ENA (BIT(9)) in GCC_APCS_CLOCK_BRANCH_ENA_VOTE (0x45004).

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-3-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -744,9 +744,10 @@ static struct clk_branch gcc_blsp1_ahb_c
 
 static struct clk_branch gcc_blsp1_sleep_clk = {
 	.halt_reg = 0x1004,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x1004,
-		.enable_mask = BIT(0),
+		.enable_reg = 0x45004,
+		.enable_mask = BIT(9),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_sleep_clk",
 			.parent_data = &(const struct clk_parent_data){


