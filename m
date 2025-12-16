Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2A3644BD;
	Tue, 16 Dec 2025 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886966; cv=none; b=mJqziw8ypnAbTx0j0NRpiB3EBrD1uvkeqmmfP2UsszWr7bAB8ZTEPaniRIKcnJcTLksBb/fKFN4giQGxhpenhNTuH32puwxcgB5C6pYlBsdQiANOmehXGUzQTT+EkSjZjQ9y7CdJm9nSKjLptFKm+qmJZEeLBzfgCO52G++x1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886966; c=relaxed/simple;
	bh=WJG49EBU+nxohv4oOtcvuTYGBqu7NA2OFzj67IBrPdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrOKnWE2tEtZFbu1xi4nzow+Wyn3eaYitDwiDXIKacKnMlp6Qgl/d/jw0Hao4ByqF2XTaCArUFvCX7JWanQaFb73EiUdVheZkesFwoChw/8Qum11YGhAzFGgs99JLAYJBh3/zOUm/9ALAkvmt/XEyOfx/Ik0UTAT3ULsznaYzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZH+F98h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZH+F98h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB56C4CEF1;
	Tue, 16 Dec 2025 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886965;
	bh=WJG49EBU+nxohv4oOtcvuTYGBqu7NA2OFzj67IBrPdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZH+F98hU8Hg2A7R7HqMg3oB/9x/02GkvH7W/NYfD3kLGsXYCST8xFLOzOUqxRiP5
	 jCPnL4RdTLFiOvDrZekyLiGQOp3QdTt7DqOe6CdLITeucbbaEwcBV0VmMIkyo+Vo11
	 +kAEN+kMhqEDZx0XFhP4cuLvmTCP3zTk5NQKVDvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/614] clk: qcom: camcc-sm7150: Fix PLL config of PLL2
Date: Tue, 16 Dec 2025 12:07:33 +0100
Message-ID: <20251216111404.438820417@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4a3baf5d8e858..590548cac45bf 100644
--- a/drivers/clk/qcom/camcc-sm7150.c
+++ b/drivers/clk/qcom/camcc-sm7150.c
@@ -139,13 +139,9 @@ static struct clk_fixed_factor camcc_pll1_out_even = {
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



