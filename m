Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D58FC12
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6255C433D2;
	Mon, 15 May 2023 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171869;
	bh=tTBC6sVvWLoVf5jUOKKLJnEzWECkbAQjGx7mU7TbRqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwvL+2fKSfdXf89s50MtrpIYRD/c3TpYF3ZmygBk90i/0I9JTsppIN0cdvqj0bcHj
	 IiXGQC0kiMfozABi4Yd48/NSSGtZqj5dbbVZZfZL4oRm9DlUyEDiV700mgwE6cmeTo
	 HJS4kH7QOuE53SXBP43cl9L3h3RXHwgFL12pizxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/134] drm/i915/dg2: Add HDMI pixel clock frequencies 267.30 and 319.89 MHz
Date: Mon, 15 May 2023 18:29:41 +0200
Message-Id: <20230515161706.590365757@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit d46746b8b13cbd377ffc733e465d25800459a31b ]

Add snps phy table values for HDMI pixel clocks 267.30 MHz and
319.89 MHz. Values are based on the Bspec algorithm for
PLL programming for HDMI.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8008
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230223043619.3941382-1-ankit.k.nautiyal@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_snps_phy.c | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_snps_phy.c b/drivers/gpu/drm/i915/display/intel_snps_phy.c
index 2030ef0b599f0..170690fc735b5 100644
--- a/drivers/gpu/drm/i915/display/intel_snps_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_snps_phy.c
@@ -1483,6 +1483,36 @@ static const struct intel_mpllb_state dg2_hdmi_262750 = {
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_267300 = {
+	.clock = 267300,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 7) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 3),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 74) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 30146) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 36699),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_268500 = {
 	.clock = 268500,
 	.ref_control =
@@ -1573,6 +1603,36 @@ static const struct intel_mpllb_state dg2_hdmi_241500 = {
 		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
 };
 
+static const struct intel_mpllb_state dg2_hdmi_319890 = {
+	.clock = 319890,
+	.ref_control =
+		REG_FIELD_PREP(SNPS_PHY_REF_CONTROL_REF_RANGE, 3),
+	.mpllb_cp =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT, 6) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP, 14) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_INT_GS, 64) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_CP_PROP_GS, 124),
+	.mpllb_div =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_DIV5_CLK_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_TX_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_PMIX_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_V2I, 2) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FREQ_VCO, 2),
+	.mpllb_div2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_REF_CLK_DIV, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_MULTIPLIER, 94) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_HDMI_DIV, 1),
+	.mpllb_fracn1 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_CGG_UPDATE_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_EN, 1) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_DEN, 65535),
+	.mpllb_fracn2 =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_QUOT, 64094) |
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_FRACN_REM, 13631),
+	.mpllb_sscen =
+		REG_FIELD_PREP(SNPS_PHY_MPLLB_SSC_UP_SPREAD, 1),
+};
+
 static const struct intel_mpllb_state dg2_hdmi_497750 = {
 	.clock = 497750,
 	.ref_control =
@@ -1760,8 +1820,10 @@ static const struct intel_mpllb_state *dg2_hdmi_tables[] = {
 	&dg2_hdmi_209800,
 	&dg2_hdmi_241500,
 	&dg2_hdmi_262750,
+	&dg2_hdmi_267300,
 	&dg2_hdmi_268500,
 	&dg2_hdmi_296703,
+	&dg2_hdmi_319890,
 	&dg2_hdmi_497750,
 	&dg2_hdmi_592000,
 	&dg2_hdmi_593407,
-- 
2.39.2



