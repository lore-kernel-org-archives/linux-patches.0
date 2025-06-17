Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7342F3643;
	Tue, 17 Jun 2025 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175701; cv=none; b=esr/vePBttCPAxci5dzhSEC0QpFIXTY2QRqRMWzx6DIgXWp1Uuv6RGQ4w5WpAkqIf5k77qdSEtsgBpER8u5ZtcO7qI8wpbb7UVZhXkjZYyrb1R1YBVI1sah27qDzthy+gZpC9brLABUlraPLzHQIg5NZygx6ZZa18iWf2w1EEmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175701; c=relaxed/simple;
	bh=YEWWEWb3NTdb6Dh0pVS+BbnD7AQTjeLxF17gPz4/Cac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BksfBd3U3B02wHS4dps9iAkbVq7BZm/IpRWSWn8seK4w8IVHWEVVHDVm6PLwgW6S9aZPwueji5xoMfN42KtkZ39c2n5KUtMAlyxYMt/pWn00xT8D4HnofT6HrHwb+hCV/ASr955D/zQr3ba/pwlsLmpuv6/GqysJZi7bdm2qVjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNiKfLfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNiKfLfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D98C4CEE7;
	Tue, 17 Jun 2025 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175701;
	bh=YEWWEWb3NTdb6Dh0pVS+BbnD7AQTjeLxF17gPz4/Cac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNiKfLfPxYV5JauMztMDXqac0l/4z3cykZF0/+jf58oCAFFLkwCZNgBaWVZM+8WCz
	 eSgahaTafnQffoC7IkKTLFEA+dZ9UBXRUnqnloE6xn72lSgQjxHgE441bDN3vX2YFx
	 gi+CshcMIpmkXxN2XmbVEER8I6u9WIqmBMR5FDwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/512] clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:22:01 +0200
Message-ID: <20250617152425.888538044@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1e12ad8948dbd..644bdc41892c6 100644
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



