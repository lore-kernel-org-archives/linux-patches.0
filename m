Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8B71863F;
	Mon, 27 May 2024 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837339; cv=none; b=n98HByC6vixxjb8qqK8QrRCn0kIVD7n45V4O3c1x3K48YRtEVZKuckvJ5T3q757sCe4etaE0JyKVTH8F9TPRmHPddJt3Wj7dODmgAzxy/IqIm+GeBqFkOayb47PCFJyI+v773+ZWiHgPxfzX3k6zwaciD1IcgIe7OO6DrQ04/n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837339; c=relaxed/simple;
	bh=fSjlYyDKRcQZem0ihPpAf1fvM5QY38UM0d6nR8+JSaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLV9oDJmvDJWWS+Oki+/VT9DjFERFFXbZhXPd9kqSk9MzZr3+g4nLwk7cl3ps2Lt4gD7MpeR4FxaOgv1pTXttjRtYh/LJ0di/fKBWJWzWutkaykYG4CE+JHaN42myz1af9UCDFBvBKBPdIegM++NttvPSPLmCFxiMRbJ9Lx8I1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZ0mhpJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZ0mhpJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F891C2BBFC;
	Mon, 27 May 2024 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837339;
	bh=fSjlYyDKRcQZem0ihPpAf1fvM5QY38UM0d6nR8+JSaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZ0mhpJ4hvf8sh1cJfIbq0KTlRJg/LW7MageGFeWd9ZgaUYuBlJmDW7WvFsdI2TRy
	 dKStMv0j06ll+GOLfaNMx4zSIc2XLVrzeR+XK8j2t4uMNqKkZhCH8D3adZowD4xyV9
	 VHmOiUKcvVAlmGmF+3y74iqJKO3EqHE8cFYc19gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 400/427] clk: qcom: apss-ipq-pll: fix PLL rate for IPQ5018
Date: Mon, 27 May 2024 20:57:27 +0200
Message-ID: <20240527185635.098103235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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



