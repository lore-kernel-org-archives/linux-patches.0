Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F3B9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2DCC433C7;
	Sun, 13 Aug 2023 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962562;
	bh=Jri7Qm/d1DnfPstgCZ34GLipVi6UaNrs77sFxIHOf9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcIjnvaDU5xSphvaH9quEm+Qg8yxZiGcO6br8n3ZaOXubCogOSzfzZNPTuEBW1ttK
	 kFMaLQLTligZJjI8Xxc5o0Ad/Buu94BIfl7vMeZuzBtncaZJZ9ch3kHue8MREcj40B
	 ZxRV0+iTkZNpM7r76ulOWFH99tGrH56O/lUNLiWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 074/149] interconnect: qcom: sm8450: add enable_mask for bcm nodes
Date: Sun, 13 Aug 2023 23:18:39 +0200
Message-ID: <20230813211721.009845460@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

commit be02db24cf840bc0fdfbecc78ad803619dd143e6 upstream.

Set the proper enable_mask to nodes requiring such value
to be used instead of a bandwidth when voting.

The masks were copied from the downstream implementation at [1].

[1] https://git.codelinaro.org/clo/la/kernel/msm-5.10/-/blob/KERNEL.PLATFORM.1.0.r2-05600-WAIPIOLE.0/drivers/interconnect/qcom/waipio.c

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230619-topic-sm8550-upstream-interconnect-mask-vote-v2-2-709474b151cc@linaro.org
Fixes: fafc114a468e ("interconnect: qcom: Add SM8450 interconnect provider driver")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/sm8450.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/interconnect/qcom/sm8450.c b/drivers/interconnect/qcom/sm8450.c
index 2d7a8e7b85ec..e64c214b4020 100644
--- a/drivers/interconnect/qcom/sm8450.c
+++ b/drivers/interconnect/qcom/sm8450.c
@@ -1337,6 +1337,7 @@ static struct qcom_icc_node qns_mem_noc_sf_disp = {
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = 0x8,
 	.num_nodes = 1,
 	.nodes = { &ebi },
 };
@@ -1349,6 +1350,7 @@ static struct qcom_icc_bcm bcm_ce0 = {
 
 static struct qcom_icc_bcm bcm_cn0 = {
 	.name = "CN0",
+	.enable_mask = 0x1,
 	.keepalive = true,
 	.num_nodes = 55,
 	.nodes = { &qnm_gemnoc_cnoc, &qnm_gemnoc_pcie,
@@ -1383,6 +1385,7 @@ static struct qcom_icc_bcm bcm_cn0 = {
 
 static struct qcom_icc_bcm bcm_co0 = {
 	.name = "CO0",
+	.enable_mask = 0x1,
 	.num_nodes = 2,
 	.nodes = { &qxm_nsp, &qns_nsp_gemnoc },
 };
@@ -1403,6 +1406,7 @@ static struct qcom_icc_bcm bcm_mm0 = {
 
 static struct qcom_icc_bcm bcm_mm1 = {
 	.name = "MM1",
+	.enable_mask = 0x1,
 	.num_nodes = 12,
 	.nodes = { &qnm_camnoc_hf, &qnm_camnoc_icp,
 		   &qnm_camnoc_sf, &qnm_mdp,
@@ -1445,6 +1449,7 @@ static struct qcom_icc_bcm bcm_sh0 = {
 
 static struct qcom_icc_bcm bcm_sh1 = {
 	.name = "SH1",
+	.enable_mask = 0x1,
 	.num_nodes = 7,
 	.nodes = { &alm_gpu_tcu, &alm_sys_tcu,
 		   &qnm_nsp_gemnoc, &qnm_pcie,
@@ -1461,6 +1466,7 @@ static struct qcom_icc_bcm bcm_sn0 = {
 
 static struct qcom_icc_bcm bcm_sn1 = {
 	.name = "SN1",
+	.enable_mask = 0x1,
 	.num_nodes = 4,
 	.nodes = { &qhm_gic, &qxm_pimem,
 		   &xm_gic, &qns_gemnoc_gc },
@@ -1492,6 +1498,7 @@ static struct qcom_icc_bcm bcm_sn7 = {
 
 static struct qcom_icc_bcm bcm_acv_disp = {
 	.name = "ACV",
+	.enable_mask = 0x1,
 	.num_nodes = 1,
 	.nodes = { &ebi_disp },
 };
@@ -1510,6 +1517,7 @@ static struct qcom_icc_bcm bcm_mm0_disp = {
 
 static struct qcom_icc_bcm bcm_mm1_disp = {
 	.name = "MM1",
+	.enable_mask = 0x1,
 	.num_nodes = 3,
 	.nodes = { &qnm_mdp_disp, &qnm_rot_disp,
 		   &qns_mem_noc_sf_disp },
@@ -1523,6 +1531,7 @@ static struct qcom_icc_bcm bcm_sh0_disp = {
 
 static struct qcom_icc_bcm bcm_sh1_disp = {
 	.name = "SH1",
+	.enable_mask = 0x1,
 	.num_nodes = 1,
 	.nodes = { &qnm_pcie_disp },
 };
-- 
2.41.0



