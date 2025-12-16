Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E603233EE;
	Tue, 16 Dec 2025 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884001; cv=none; b=Jz6xLZ7FbwNdbvqQ/n32f6+oLSM+4tZUU2BF5nbHNvKQjxsHyLg0KkV1s4HuycyO3GZ7c5zrGLxeLopyJulcldY1AakvkSyPs5GRrLnyfp5Ox1gQJijG+rDNcp1UmN638zHB8UemIyvMgRW5tpfoQ/u09OxDX5ECtt+RAUm0TvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884001; c=relaxed/simple;
	bh=HkB8+nNA01OkUF89NfmYXd3CO5HAt2B7mcuECtI1UPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVVrZYD/HVSW33svRzWIM39tnEPCOtbzztfqL4zqF5RwBaKiLQ6B+Id6Voi/pcPnk9vvvSJvHvZ0iDaOGBbfV24Kc7Wtye0TVj0rqhdiPaQascmc9S7JCT0b/jRDFnhS/mkVSMrp5DGdHC2IxS6yn60mhpSaS9OS+cmdaDtQDq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axFOfrwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axFOfrwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9301C4CEF1;
	Tue, 16 Dec 2025 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884001;
	bh=HkB8+nNA01OkUF89NfmYXd3CO5HAt2B7mcuECtI1UPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axFOfrwUYn1IBtuybvhoxS+ohFVt3qJgL9m6X3ODGbUHOJklR/UlX43R8TekYHhgT
	 KLYkhvR7B9n46UNW6HB4YVrcKlBdBIf9c8lMrmN9v0rvPe6dfmnmKsTOigPbkwNlrN
	 tPO7gthDetbAuZ0ctYSMcu9DDVyC5kBDPsEMVJG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/354] clk: qcom: camcc-sm7150: Fix PLL config of PLL2
Date: Tue, 16 Dec 2025 12:10:28 +0100
Message-ID: <20251216111323.134482217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 415aad75c7e5cdb72e0672dc1159be1a99535ecd ]

The 'Agera' PLLs (with clk_agera_pll_configure) do not take some of the
parameters that are provided in the vendor driver. Instead the upstream
configuration should provide the final user_ctl value that is written to
the USER_CTL register.

Fix the config so that the PLL is configured correctly.

Fixes: 9f0532da4226 ("clk: qcom: Add Camera Clock Controller driver for SM7150")
Suggested-by: Taniya Das <taniya.das@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251021-agera-pll-fixups-v1-2-8c1d8aff4afc@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm7150.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/camcc-sm7150.c b/drivers/clk/qcom/camcc-sm7150.c
index 39033a6bb6160..ca0078428cb01 100644
--- a/drivers/clk/qcom/camcc-sm7150.c
+++ b/drivers/clk/qcom/camcc-sm7150.c
@@ -140,13 +140,9 @@ static struct clk_fixed_factor camcc_pll1_out_even = {
 /* 1920MHz configuration */
 static const struct alpha_pll_config camcc_pll2_config = {
 	.l = 0x64,
-	.post_div_val = 0x3 << 8,
-	.post_div_mask = 0x3 << 8,
-	.early_output_mask = BIT(3),
-	.aux_output_mask = BIT(1),
-	.main_output_mask = BIT(0),
 	.config_ctl_hi_val = 0x400003d6,
 	.config_ctl_val = 0x20000954,
+	.user_ctl_val = 0x0000030b,
 };
 
 static struct clk_alpha_pll camcc_pll2 = {
-- 
2.51.0



