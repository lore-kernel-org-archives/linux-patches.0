Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915C214388D;
	Tue, 23 Apr 2024 21:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908498; cv=none; b=bwQ4EdIg1YFjfqgelFFGzQ4GDLCo7z3YE+1FuBgZSHVWYfkc+OcS+f/AdbwpQNqMGuRv0kixR5JOjRxiTzh9O6Mz4A7ggfyuFE/brGVl8tkBIiY9JxRjp/ToCYXtaaZ+dhitq81ZrgZFGPWzyKMqUk2la6HTW6V+iJi9b2LDXzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908498; c=relaxed/simple;
	bh=N3N2fMpPSEsJdVnDd4D8+XuslV0K2ed1TfFkUvfaQ0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrOznVmwofm36Km17aAe5rhRFtaCdvhzT6n+0o3WEXJ2qW/5U8//OEYuqDOXM68EA/Dkb5prULH0xTa9Yxf7ou9a0oMo154kdaCXpOehjvFaYhyXTUd7ZigtVtpm3zCZHWda71dCZkf/tuKxf3SA8hzVXLVfoa86nrxEneUwiss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q56Xhicr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q56Xhicr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC3C32786;
	Tue, 23 Apr 2024 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908498;
	bh=N3N2fMpPSEsJdVnDd4D8+XuslV0K2ed1TfFkUvfaQ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q56XhicrNcB33igZ/DaSWXUXveYUM98pSju5Q08ZA8BEl6N10u0LtYOFAMMjBeMFi
	 kVh1hCllgBNqdWNfE5Iqnf/ImDC4rn7fSQ8OsmwgCTF0mkuS/Uxh2y8ahdViBv5QWq
	 4hoy1vLHgumVqxZlt2r4x+0pvOY06ZloQyZFAsaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 076/158] interconnect: qcom: x1e80100: Remove inexistent ACV_PERF BCM
Date: Tue, 23 Apr 2024 14:38:18 -0700
Message-ID: <20240423213858.429386511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 59097a2a5ecadb0f025232c665fd11c8ae1e1f58 ]

Booting the kernel on X1E results in a message like:

[    2.561524] qnoc-x1e80100 interconnect-0: ACV_PERF could not find RPMh address

And indeed, taking a look at cmd-db, no such BCM exists. Remove it.

Fixes: 9f196772841e ("interconnect: qcom: Add X1E80100 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Mike Tipton <quic_mdtipton@quicinc.com>
Link: https://lore.kernel.org/r/20240302-topic-faux_bcm_x1e-v1-1-c40fab7c4bc5@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/x1e80100.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/interconnect/qcom/x1e80100.c b/drivers/interconnect/qcom/x1e80100.c
index cbaf4f9c41be6..06f0a6d6cbbc0 100644
--- a/drivers/interconnect/qcom/x1e80100.c
+++ b/drivers/interconnect/qcom/x1e80100.c
@@ -116,15 +116,6 @@ static struct qcom_icc_node xm_sdc2 = {
 	.links = { X1E80100_SLAVE_A2NOC_SNOC },
 };
 
-static struct qcom_icc_node ddr_perf_mode_master = {
-	.name = "ddr_perf_mode_master",
-	.id = X1E80100_MASTER_DDR_PERF_MODE,
-	.channels = 1,
-	.buswidth = 4,
-	.num_links = 1,
-	.links = { X1E80100_SLAVE_DDR_PERF_MODE },
-};
-
 static struct qcom_icc_node qup0_core_master = {
 	.name = "qup0_core_master",
 	.id = X1E80100_MASTER_QUP_CORE_0,
@@ -832,14 +823,6 @@ static struct qcom_icc_node qns_a2noc_snoc = {
 	.links = { X1E80100_MASTER_A2NOC_SNOC },
 };
 
-static struct qcom_icc_node ddr_perf_mode_slave = {
-	.name = "ddr_perf_mode_slave",
-	.id = X1E80100_SLAVE_DDR_PERF_MODE,
-	.channels = 1,
-	.buswidth = 4,
-	.num_links = 0,
-};
-
 static struct qcom_icc_node qup0_core_slave = {
 	.name = "qup0_core_slave",
 	.id = X1E80100_SLAVE_QUP_CORE_0,
@@ -1591,12 +1574,6 @@ static struct qcom_icc_bcm bcm_acv = {
 	.nodes = { &ebi },
 };
 
-static struct qcom_icc_bcm bcm_acv_perf = {
-	.name = "ACV_PERF",
-	.num_nodes = 1,
-	.nodes = { &ddr_perf_mode_slave },
-};
-
 static struct qcom_icc_bcm bcm_ce0 = {
 	.name = "CE0",
 	.num_nodes = 1,
@@ -1863,18 +1840,15 @@ static const struct qcom_icc_desc x1e80100_aggre2_noc = {
 };
 
 static struct qcom_icc_bcm * const clk_virt_bcms[] = {
-	&bcm_acv_perf,
 	&bcm_qup0,
 	&bcm_qup1,
 	&bcm_qup2,
 };
 
 static struct qcom_icc_node * const clk_virt_nodes[] = {
-	[MASTER_DDR_PERF_MODE] = &ddr_perf_mode_master,
 	[MASTER_QUP_CORE_0] = &qup0_core_master,
 	[MASTER_QUP_CORE_1] = &qup1_core_master,
 	[MASTER_QUP_CORE_2] = &qup2_core_master,
-	[SLAVE_DDR_PERF_MODE] = &ddr_perf_mode_slave,
 	[SLAVE_QUP_CORE_0] = &qup0_core_slave,
 	[SLAVE_QUP_CORE_1] = &qup1_core_slave,
 	[SLAVE_QUP_CORE_2] = &qup2_core_slave,
-- 
2.43.0



