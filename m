Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C52E88A5;
	Tue, 17 Jun 2025 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174798; cv=none; b=DzulaZzXKBsnRc+Fmtga6jOdfuYX62SQUhYzmLsS0j3xwIuZUURERgWGQRMDyPJChAVtFfKqJ7+bFBqjLZCjDSoV7EfwG2OCOB//2fAbh+fsJE4aDP9dVh4QzMrBYYBlH1ZDojTN3rxLo7nuaLFU4Fl7Um6YoZclotQwC7j6vZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174798; c=relaxed/simple;
	bh=tXVLEE4xR6SA1yLmJLcfpTLvJE/85e3jDqo8gNjs3f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i538558wuAJrfhCRWm1zuVZKfHbgq3XVrqHa0Umv8f7LyYAwZpLU9LC/pWW7sJN65vmV5qfw5xpr5BFtWCLt1OAd7293ilN/W3K11H39LLOZulp3+sVfqF4wFsUPoRkx5V3DtP6+5HaTkqj5y1kApS+Wg6vuAdOTxw7Gn/+SJyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlrOnJXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlrOnJXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8049C4CEE7;
	Tue, 17 Jun 2025 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174798;
	bh=tXVLEE4xR6SA1yLmJLcfpTLvJE/85e3jDqo8gNjs3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlrOnJXJIofLkq+wepsF7WUOnV2oc3OKQQea5J8UWKIqSxdAzRYUTtv/1rOt1bcsf
	 tK/XwLxFUUpeLIbjyXLq0tTv3Qs04WXLdzEUfFiSnDavXQOfwh+TKSCU/6MF8yqp8z
	 44g0adHPxRbRvvbRAmpbzstHYM3fcLAeE0IbD1lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/356] clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:23:49 +0200
Message-ID: <20250617152342.812137567@linuxfoundation.org>
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
index 0bcbba2a29436..86c8ad5b55bac 100644
--- a/drivers/clk/qcom/gpucc-sm6350.c
+++ b/drivers/clk/qcom/gpucc-sm6350.c
@@ -412,6 +412,9 @@ static struct clk_branch gpu_cc_gx_vsense_clk = {
 static struct gdsc gpu_cx_gdsc = {
 	.gdscr = 0x106c,
 	.gds_hw_ctrl = 0x1540,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0x8,
 	.pd = {
 		.name = "gpu_cx_gdsc",
 	},
@@ -422,6 +425,9 @@ static struct gdsc gpu_cx_gdsc = {
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



