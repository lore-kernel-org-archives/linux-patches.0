Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3867F27781E;
	Tue, 12 Aug 2025 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025610; cv=none; b=SgZyiNDHg7NeExGz5dE7TolX5QsecT3ycsiXjF51vB8TAgUBMP7w1pUYYE4FfHrZQYRe8T77vXZSVmAaJxAaiTUl7+eW5INvRCFB0mYWzifyUaf3xzL8zy14qBgoVhP4SRm4NykZq9941rlkvR57mxyxCBKOtjzmIuWovTDNse4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025610; c=relaxed/simple;
	bh=Kly1L6q6i2Eb5biGqWj+KrDJz+qb08391afCquRg30c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIF/f1jPqslmTGlLZ1lnazwXFNfUyuMSOd93kzWyHYFOs/E4kIP/QSYa48yCBhiOFUYqM8b5uka1DMiFTSp5Js7cAq2ZnAZ3Qylc9zQJ1FKjwq6xF1OliT1ysYYhArTS6xieN1KPswgN/D/9KNmpFj84kA+QD6q1cR2yFnFNk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAByjEae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAByjEae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D80C4CEF0;
	Tue, 12 Aug 2025 19:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025610;
	bh=Kly1L6q6i2Eb5biGqWj+KrDJz+qb08391afCquRg30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAByjEaeyRDmpd0O0eHCOqRSS7+HFU/PacA33VIq/qmVxaDl2zLmBMt9fxbcxi/y6
	 Q4Gm3h1/X3tFJaZrxoMQHLGiZHnHC/RFabclUCZIjSpGHfELm7Bq+TzHfRwpotRPm1
	 eSGry9FoZnkQd/B1nRjj85tzVudX+xbHtItSuRYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 093/480] interconnect: qcom: qcs615: Drop IP0 interconnects
Date: Tue, 12 Aug 2025 19:45:01 +0200
Message-ID: <20250812174401.294534062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit cbabc73e85be9e706a5051c9416de4a8d391cf57 ]

In the same spirit as e.g. Commit b136d257ee0b ("interconnect: qcom:
sc8280xp: Drop IP0 interconnects"), drop the resources that should be
taken care of through the clk-rpmh driver.

Fixes: 77d79677b04b ("interconnect: qcom: add QCS615 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250627-topic-qcs615_icc_ipa-v1-2-dc47596cde69@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcs615.c | 42 ------------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/interconnect/qcom/qcs615.c b/drivers/interconnect/qcom/qcs615.c
index 7e59e91ce886..0549cfcbac64 100644
--- a/drivers/interconnect/qcom/qcs615.c
+++ b/drivers/interconnect/qcom/qcs615.c
@@ -342,15 +342,6 @@ static struct qcom_icc_node qnm_snoc_sf = {
 	.links = { QCS615_SLAVE_LLCC },
 };
 
-static struct qcom_icc_node ipa_core_master = {
-	.name = "ipa_core_master",
-	.id = QCS615_MASTER_IPA_CORE,
-	.channels = 1,
-	.buswidth = 8,
-	.num_links = 1,
-	.links = { QCS615_SLAVE_IPA_CORE },
-};
-
 static struct qcom_icc_node llcc_mc = {
 	.name = "llcc_mc",
 	.id = QCS615_MASTER_LLCC,
@@ -942,14 +933,6 @@ static struct qcom_icc_node srvc_gemnoc = {
 	.num_links = 0,
 };
 
-static struct qcom_icc_node ipa_core_slave = {
-	.name = "ipa_core_slave",
-	.id = QCS615_SLAVE_IPA_CORE,
-	.channels = 1,
-	.buswidth = 8,
-	.num_links = 0,
-};
-
 static struct qcom_icc_node ebi = {
 	.name = "ebi",
 	.id = QCS615_SLAVE_EBI1,
@@ -1113,12 +1096,6 @@ static struct qcom_icc_bcm bcm_cn1 = {
 		   &qhs_sdc1, &qhs_sdc2 },
 };
 
-static struct qcom_icc_bcm bcm_ip0 = {
-	.name = "IP0",
-	.num_nodes = 1,
-	.nodes = { &ipa_core_slave },
-};
-
 static struct qcom_icc_bcm bcm_mc0 = {
 	.name = "MC0",
 	.keepalive = true,
@@ -1260,7 +1237,6 @@ static struct qcom_icc_bcm * const aggre1_noc_bcms[] = {
 	&bcm_qup0,
 	&bcm_sn3,
 	&bcm_sn14,
-	&bcm_ip0,
 };
 
 static struct qcom_icc_node * const aggre1_noc_nodes[] = {
@@ -1411,22 +1387,6 @@ static const struct qcom_icc_desc qcs615_gem_noc = {
 	.num_bcms = ARRAY_SIZE(gem_noc_bcms),
 };
 
-static struct qcom_icc_bcm * const ipa_virt_bcms[] = {
-	&bcm_ip0,
-};
-
-static struct qcom_icc_node * const ipa_virt_nodes[] = {
-	[MASTER_IPA_CORE] = &ipa_core_master,
-	[SLAVE_IPA_CORE] = &ipa_core_slave,
-};
-
-static const struct qcom_icc_desc qcs615_ipa_virt = {
-	.nodes = ipa_virt_nodes,
-	.num_nodes = ARRAY_SIZE(ipa_virt_nodes),
-	.bcms = ipa_virt_bcms,
-	.num_bcms = ARRAY_SIZE(ipa_virt_bcms),
-};
-
 static struct qcom_icc_bcm * const mc_virt_bcms[] = {
 	&bcm_acv,
 	&bcm_mc0,
@@ -1525,8 +1485,6 @@ static const struct of_device_id qnoc_of_match[] = {
 	  .data = &qcs615_dc_noc},
 	{ .compatible = "qcom,qcs615-gem-noc",
 	  .data = &qcs615_gem_noc},
-	{ .compatible = "qcom,qcs615-ipa-virt",
-	  .data = &qcs615_ipa_virt},
 	{ .compatible = "qcom,qcs615-mc-virt",
 	  .data = &qcs615_mc_virt},
 	{ .compatible = "qcom,qcs615-mmss-noc",
-- 
2.39.5



