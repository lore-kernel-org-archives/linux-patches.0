Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945DD2E8DFC;
	Tue, 17 Jun 2025 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176987; cv=none; b=hxs/gS5ETFlifzm1+qrM2YFdE9orRoYkNwy/JxyU+p+6PrXy6FZXhR6NQYY+sKMS4udk51q4NU4UmPyiqNFjJyXOew1adpYVIamK4S1ws36CvPgq39xKyje05G5ESXQ3Z2As/GepF9eVjL8xOKuQENL5SbUosWqh7ZGX3Lhbzy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176987; c=relaxed/simple;
	bh=syJAWsSup3LWXZh7L3Avgbt7aqFoBAeaxMOFeZy4uQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUlKP1kW6rAfViHvlm+lN8kfKr+VEjYKtHZxpeimDaPPA+BSLTiVv5z89x9b1OjpNZelLkxMWFz2gmsFAbSgX0JrOgEAcJM5Jg3g/fULepzLjj3+hWrcs35Rmw87dp/b+UFOGXxvOigziFOwYO5J8+CNuS6gDUrZ+e+uPsu8JAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZ9/1T5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZ9/1T5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1857FC4CEE7;
	Tue, 17 Jun 2025 16:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176987;
	bh=syJAWsSup3LWXZh7L3Avgbt7aqFoBAeaxMOFeZy4uQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ9/1T5Xo0MxE7mfoTCKBZeX5opxKSyD6Dw2hjwOIgAD0A0MZpgUAxxfnRd6IUFYH
	 MRf+I5cMiFNAjC0pPfyWi86wp3fszt2HXhzHorGl8VIOvdODHj63biRflYaAJlcnp0
	 0rzAq7Sy0RSz5n+eq/+LxvrMhBSKzHv3P+x3KvUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 246/780] clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:19:14 +0200
Message-ID: <20250617152501.472159042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit d988b0b866c2aeb23aa74022b5bbd463165a7a33 ]

Compared to the msm-4.19 driver the mainline GDSC driver always sets the
bits for en_rest, en_few & clk_dis, and if those values are not set
per-GDSC in the respective driver then the default value from the GDSC
driver is used. The downstream driver only conditionally sets
clk_dis_wait_val if qcom,clk-dis-wait-val is given in devicetree.

Correct this situation by explicitly setting those values. For all GDSCs
the reset value of those bits are used, with the exception of
gpu_cx_gdsc which has an explicit value (qcom,clk-dis-wait-val = <8>).

Fixes: 013804a727a0 ("clk: qcom: Add GPU clock controller driver for SM6350")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250425-sm6350-gdsc-val-v1-4-1f252d9c5e4e@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sm6350.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gpucc-sm6350.c b/drivers/clk/qcom/gpucc-sm6350.c
index 35ed0500bc593..ee89c42413f88 100644
--- a/drivers/clk/qcom/gpucc-sm6350.c
+++ b/drivers/clk/qcom/gpucc-sm6350.c
@@ -413,6 +413,9 @@ static struct clk_branch gpu_cc_gx_vsense_clk = {
 static struct gdsc gpu_cx_gdsc = {
 	.gdscr = 0x106c,
 	.gds_hw_ctrl = 0x1540,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0x8,
 	.pd = {
 		.name = "gpu_cx_gdsc",
 	},
@@ -423,6 +426,9 @@ static struct gdsc gpu_cx_gdsc = {
 static struct gdsc gpu_gx_gdsc = {
 	.gdscr = 0x100c,
 	.clamp_io_ctrl = 0x1508,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0x2,
 	.pd = {
 		.name = "gpu_gx_gdsc",
 		.power_on = gdsc_gx_do_nothing_enable,
-- 
2.39.5



