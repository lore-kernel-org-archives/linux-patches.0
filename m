Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5481A6192;
	Tue, 30 Jul 2024 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357555; cv=none; b=dHLNjNrJMyh+I6KTdWD7U0cgP7neCHIovkwABiX00VBBGy5iFic0YC141GC987VZoYpROA2YMy1cQ5Z5Yo4rp7Hr/EZ+boIWLVfE3DZO7cxU2GbuYvQbMV3IIgQCFd2qMIgepE6GsAhHo1cTTYQzpJhyqcCxKNXJXLO/EJEVQbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357555; c=relaxed/simple;
	bh=UYpN1fXeGxmI7mqw28kPeiviea+oNcqQG/sWSRPZZtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfI+lQ6MwQrH89VomByk0kjh4k1Z0QuuDWH8kKNyMy/iTz2m8TnYlJ9+IPYHqUiH+kdkBCs+is5dJz/HfAQAjfpBRNoFZER5pcmLM1lL16j4Mvv9hYBydGjXuRN7Iyl602BZXlwmrpYF9QGiy+y6Pi9Kht/pSsZWHrNaHpdGmuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NB6Ezpp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB6Ezpp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59CBC32782;
	Tue, 30 Jul 2024 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357555;
	bh=UYpN1fXeGxmI7mqw28kPeiviea+oNcqQG/sWSRPZZtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NB6Ezpp0/tdtTdDTwsn+vIeuP5RvvJhDpSBVY/iRPWFSajJoFRnxvCoaj63iAYzxD
	 scaaKITKa5IKgGP4j+rKUJdvARYs4S7EORPgDS8EAcY5PNJWaUuADQ+syRoNBtDmFz
	 MYj979TWKV0P1DaNRhAiE4NXI+Nra0tTS+QSNgv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/568] clk: qcom: gpucc-sa8775p: Update wait_val fields for GPU GDSCs
Date: Tue, 30 Jul 2024 17:46:16 +0200
Message-ID: <20240730151650.394504600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 211681998d706d1e0fff6b62f89efcdf29c24978 ]

Update wait_val fields as per the default hardware values of the GDSC as
otherwise it would lead to GDSC FSM state stuck causing power on/off
failures of the GSDC.

Fixes: 0afa16afc36d ("clk: qcom: add the GPUCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-6-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sa8775p.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gpucc-sa8775p.c b/drivers/clk/qcom/gpucc-sa8775p.c
index abcaefa01e386..0d9a8379efaa8 100644
--- a/drivers/clk/qcom/gpucc-sa8775p.c
+++ b/drivers/clk/qcom/gpucc-sa8775p.c
@@ -523,6 +523,9 @@ static struct clk_regmap *gpu_cc_sa8775p_clocks[] = {
 
 static struct gdsc cx_gdsc = {
 	.gdscr = 0x9108,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.gds_hw_ctrl = 0x953c,
 	.pd = {
 		.name = "cx_gdsc",
@@ -533,6 +536,9 @@ static struct gdsc cx_gdsc = {
 
 static struct gdsc gx_gdsc = {
 	.gdscr = 0x905c,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "gx_gdsc",
 		.power_on = gdsc_gx_do_nothing_enable,
-- 
2.43.0



