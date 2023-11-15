Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23A041223
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exmIXWD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540FAC433C7;
	Wed, 15 Nov 2023 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076763;
	bh=7i0XakDkawUIe1CBLOG0Rfk84ufVkav4lPxrY2l4Mnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exmIXWD820RxyNrMzlwn4EcLaZCRhtGC+5wbe0WIFdHAdcPi6/SRlwy7uSk0Mynt3
	 zSycGevOuAv9yNb/5MyEsD8CI3MAgELfq3UDpmxF8Eh3mOs57NUzNnjPac2ZMdhqsR
	 1alqRS9CDLsIX0aZlOjXCmpD5x1z9Klu8kM8MBs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 414/550] interconnect: qcom: sdm845: Retire DEFINE_QBCM
Date: Wed, 15 Nov 2023 14:16:38 -0500
Message-ID: <20231115191629.458663133@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 35f490c5e4e833e81be464d89404b26ee20740ef ]

The struct definition macros are hard to read and compare, expand them.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20230811-topic-icc_retire_macrosd-v1-13-c03aaeffc769@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Stable-dep-of: f8fe97a9fd20 ("interconnect: qcom: sdm845: Set ACV enable_mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sdm845.c | 277 ++++++++++++++++++++++++++---
 1 file changed, 249 insertions(+), 28 deletions(-)

diff --git a/drivers/interconnect/qcom/sdm845.c b/drivers/interconnect/qcom/sdm845.c
index 954e7bd13fc41..39ee54ffdb7ba 100644
--- a/drivers/interconnect/qcom/sdm845.c
+++ b/drivers/interconnect/qcom/sdm845.c
@@ -146,34 +146,255 @@ DEFINE_QNODE(srvc_snoc, SDM845_SLAVE_SERVICE_SNOC, 1, 4);
 DEFINE_QNODE(xs_qdss_stm, SDM845_SLAVE_QDSS_STM, 1, 4);
 DEFINE_QNODE(xs_sys_tcu_cfg, SDM845_SLAVE_TCU, 1, 8);
 
-DEFINE_QBCM(bcm_acv, "ACV", false, &ebi);
-DEFINE_QBCM(bcm_mc0, "MC0", true, &ebi);
-DEFINE_QBCM(bcm_sh0, "SH0", true, &qns_llcc);
-DEFINE_QBCM(bcm_mm0, "MM0", false, &qns_mem_noc_hf);
-DEFINE_QBCM(bcm_sh1, "SH1", false, &qns_apps_io);
-DEFINE_QBCM(bcm_mm1, "MM1", true, &qxm_camnoc_hf0_uncomp, &qxm_camnoc_hf1_uncomp, &qxm_camnoc_sf_uncomp, &qxm_camnoc_hf0, &qxm_camnoc_hf1, &qxm_mdp0, &qxm_mdp1);
-DEFINE_QBCM(bcm_sh2, "SH2", false, &qns_memnoc_snoc);
-DEFINE_QBCM(bcm_mm2, "MM2", false, &qns2_mem_noc);
-DEFINE_QBCM(bcm_sh3, "SH3", false, &acm_tcu);
-DEFINE_QBCM(bcm_mm3, "MM3", false, &qxm_camnoc_sf, &qxm_rot, &qxm_venus0, &qxm_venus1, &qxm_venus_arm9);
-DEFINE_QBCM(bcm_sh5, "SH5", false, &qnm_apps);
-DEFINE_QBCM(bcm_sn0, "SN0", true, &qns_memnoc_sf);
-DEFINE_QBCM(bcm_ce0, "CE0", false, &qxm_crypto);
-DEFINE_QBCM(bcm_cn0, "CN0", false, &qhm_spdm, &qhm_tic, &qnm_snoc, &xm_qdss_dap, &qhs_a1_noc_cfg, &qhs_a2_noc_cfg, &qhs_aop, &qhs_aoss, &qhs_camera_cfg, &qhs_clk_ctl, &qhs_compute_dsp_cfg, &qhs_cpr_cx, &qhs_crypto0_cfg, &qhs_dcc_cfg, &qhs_ddrss_cfg, &qhs_display_cfg, &qhs_glm, &qhs_gpuss_cfg, &qhs_imem_cfg, &qhs_ipa, &qhs_mnoc_cfg, &qhs_pcie0_cfg, &qhs_pcie_gen3_cfg, &qhs_pdm, &qhs_phy_refgen_south, &qhs_pimem_cfg, &qhs_prng, &qhs_qdss_cfg, &qhs_qupv3_north, &qhs_qupv3_south, &qhs_sdc2, &qhs_sdc4, &qhs_snoc_cfg, &qhs_spdm, &qhs_spss_cfg, &qhs_tcsr, &qhs_tlmm_north, &qhs_tlmm_south, &qhs_tsif, &qhs_ufs_card_cfg, &qhs_ufs_mem_cfg, &qhs_usb3_0, &qhs_usb3_1, &qhs_venus_cfg, &qhs_vsense_ctrl_cfg, &qns_cnoc_a2noc, &srvc_cnoc);
-DEFINE_QBCM(bcm_qup0, "QUP0", false, &qhm_qup1, &qhm_qup2);
-DEFINE_QBCM(bcm_sn1, "SN1", false, &qxs_imem);
-DEFINE_QBCM(bcm_sn2, "SN2", false, &qns_memnoc_gc);
-DEFINE_QBCM(bcm_sn3, "SN3", false, &qns_cnoc);
-DEFINE_QBCM(bcm_sn4, "SN4", false, &qxm_pimem);
-DEFINE_QBCM(bcm_sn5, "SN5", false, &xs_qdss_stm);
-DEFINE_QBCM(bcm_sn6, "SN6", false, &qhs_apss, &srvc_snoc, &xs_sys_tcu_cfg);
-DEFINE_QBCM(bcm_sn7, "SN7", false, &qxs_pcie);
-DEFINE_QBCM(bcm_sn8, "SN8", false, &qxs_pcie_gen3);
-DEFINE_QBCM(bcm_sn9, "SN9", false, &srvc_aggre1_noc, &qnm_aggre1_noc);
-DEFINE_QBCM(bcm_sn11, "SN11", false, &srvc_aggre2_noc, &qnm_aggre2_noc);
-DEFINE_QBCM(bcm_sn12, "SN12", false, &qnm_gladiator_sodv, &xm_gic);
-DEFINE_QBCM(bcm_sn14, "SN14", false, &qnm_pcie_anoc);
-DEFINE_QBCM(bcm_sn15, "SN15", false, &qnm_memnoc);
+static struct qcom_icc_bcm bcm_acv = {
+	.name = "ACV",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &ebi },
+};
+
+static struct qcom_icc_bcm bcm_mc0 = {
+	.name = "MC0",
+	.keepalive = true,
+	.num_nodes = 1,
+	.nodes = { &ebi },
+};
+
+static struct qcom_icc_bcm bcm_sh0 = {
+	.name = "SH0",
+	.keepalive = true,
+	.num_nodes = 1,
+	.nodes = { &qns_llcc },
+};
+
+static struct qcom_icc_bcm bcm_mm0 = {
+	.name = "MM0",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns_mem_noc_hf },
+};
+
+static struct qcom_icc_bcm bcm_sh1 = {
+	.name = "SH1",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns_apps_io },
+};
+
+static struct qcom_icc_bcm bcm_mm1 = {
+	.name = "MM1",
+	.keepalive = true,
+	.num_nodes = 7,
+	.nodes = { &qxm_camnoc_hf0_uncomp,
+		   &qxm_camnoc_hf1_uncomp,
+		   &qxm_camnoc_sf_uncomp,
+		   &qxm_camnoc_hf0,
+		   &qxm_camnoc_hf1,
+		   &qxm_mdp0,
+		   &qxm_mdp1
+	},
+};
+
+static struct qcom_icc_bcm bcm_sh2 = {
+	.name = "SH2",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns_memnoc_snoc },
+};
+
+static struct qcom_icc_bcm bcm_mm2 = {
+	.name = "MM2",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns2_mem_noc },
+};
+
+static struct qcom_icc_bcm bcm_sh3 = {
+	.name = "SH3",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &acm_tcu },
+};
+
+static struct qcom_icc_bcm bcm_mm3 = {
+	.name = "MM3",
+	.keepalive = false,
+	.num_nodes = 5,
+	.nodes = { &qxm_camnoc_sf, &qxm_rot, &qxm_venus0, &qxm_venus1, &qxm_venus_arm9 },
+};
+
+static struct qcom_icc_bcm bcm_sh5 = {
+	.name = "SH5",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qnm_apps },
+};
+
+static struct qcom_icc_bcm bcm_sn0 = {
+	.name = "SN0",
+	.keepalive = true,
+	.num_nodes = 1,
+	.nodes = { &qns_memnoc_sf },
+};
+
+static struct qcom_icc_bcm bcm_ce0 = {
+	.name = "CE0",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qxm_crypto },
+};
+
+static struct qcom_icc_bcm bcm_cn0 = {
+	.name = "CN0",
+	.keepalive = false,
+	.num_nodes = 47,
+	.nodes = { &qhm_spdm,
+		   &qhm_tic,
+		   &qnm_snoc,
+		   &xm_qdss_dap,
+		   &qhs_a1_noc_cfg,
+		   &qhs_a2_noc_cfg,
+		   &qhs_aop,
+		   &qhs_aoss,
+		   &qhs_camera_cfg,
+		   &qhs_clk_ctl,
+		   &qhs_compute_dsp_cfg,
+		   &qhs_cpr_cx,
+		   &qhs_crypto0_cfg,
+		   &qhs_dcc_cfg,
+		   &qhs_ddrss_cfg,
+		   &qhs_display_cfg,
+		   &qhs_glm,
+		   &qhs_gpuss_cfg,
+		   &qhs_imem_cfg,
+		   &qhs_ipa,
+		   &qhs_mnoc_cfg,
+		   &qhs_pcie0_cfg,
+		   &qhs_pcie_gen3_cfg,
+		   &qhs_pdm,
+		   &qhs_phy_refgen_south,
+		   &qhs_pimem_cfg,
+		   &qhs_prng,
+		   &qhs_qdss_cfg,
+		   &qhs_qupv3_north,
+		   &qhs_qupv3_south,
+		   &qhs_sdc2,
+		   &qhs_sdc4,
+		   &qhs_snoc_cfg,
+		   &qhs_spdm,
+		   &qhs_spss_cfg,
+		   &qhs_tcsr,
+		   &qhs_tlmm_north,
+		   &qhs_tlmm_south,
+		   &qhs_tsif,
+		   &qhs_ufs_card_cfg,
+		   &qhs_ufs_mem_cfg,
+		   &qhs_usb3_0,
+		   &qhs_usb3_1,
+		   &qhs_venus_cfg,
+		   &qhs_vsense_ctrl_cfg,
+		   &qns_cnoc_a2noc,
+		   &srvc_cnoc
+	},
+};
+
+static struct qcom_icc_bcm bcm_qup0 = {
+	.name = "QUP0",
+	.keepalive = false,
+	.num_nodes = 2,
+	.nodes = { &qhm_qup1, &qhm_qup2 },
+};
+
+static struct qcom_icc_bcm bcm_sn1 = {
+	.name = "SN1",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qxs_imem },
+};
+
+static struct qcom_icc_bcm bcm_sn2 = {
+	.name = "SN2",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns_memnoc_gc },
+};
+
+static struct qcom_icc_bcm bcm_sn3 = {
+	.name = "SN3",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qns_cnoc },
+};
+
+static struct qcom_icc_bcm bcm_sn4 = {
+	.name = "SN4",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qxm_pimem },
+};
+
+static struct qcom_icc_bcm bcm_sn5 = {
+	.name = "SN5",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &xs_qdss_stm },
+};
+
+static struct qcom_icc_bcm bcm_sn6 = {
+	.name = "SN6",
+	.keepalive = false,
+	.num_nodes = 3,
+	.nodes = { &qhs_apss, &srvc_snoc, &xs_sys_tcu_cfg },
+};
+
+static struct qcom_icc_bcm bcm_sn7 = {
+	.name = "SN7",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qxs_pcie },
+};
+
+static struct qcom_icc_bcm bcm_sn8 = {
+	.name = "SN8",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qxs_pcie_gen3 },
+};
+
+static struct qcom_icc_bcm bcm_sn9 = {
+	.name = "SN9",
+	.keepalive = false,
+	.num_nodes = 2,
+	.nodes = { &srvc_aggre1_noc, &qnm_aggre1_noc },
+};
+
+static struct qcom_icc_bcm bcm_sn11 = {
+	.name = "SN11",
+	.keepalive = false,
+	.num_nodes = 2,
+	.nodes = { &srvc_aggre2_noc, &qnm_aggre2_noc },
+};
+
+static struct qcom_icc_bcm bcm_sn12 = {
+	.name = "SN12",
+	.keepalive = false,
+	.num_nodes = 2,
+	.nodes = { &qnm_gladiator_sodv, &xm_gic },
+};
+
+static struct qcom_icc_bcm bcm_sn14 = {
+	.name = "SN14",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qnm_pcie_anoc },
+};
+
+static struct qcom_icc_bcm bcm_sn15 = {
+	.name = "SN15",
+	.keepalive = false,
+	.num_nodes = 1,
+	.nodes = { &qnm_memnoc },
+};
 
 static struct qcom_icc_bcm * const aggre1_noc_bcms[] = {
 	&bcm_sn9,
-- 
2.42.0



