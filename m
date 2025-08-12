Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CA2221FAC;
	Tue, 12 Aug 2025 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020976; cv=none; b=bYK3zA4BO9c5uzuqinls5Wwn9R4LCOaJ+JRy/Rpu+x/hVZiKFZYf2yJv872bfmzzpN8xYxa4rOwmT9tKT6TDy84A6UbrjbWzdxkJUtAIN2niJtZvmeuuYu/XpbIjQupFGQ5/CQuDsDqRdONMJJqkIfOQz/JsfpCbEv4JZfDfZaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020976; c=relaxed/simple;
	bh=S9JmgrnmhaipQmEThAJXhtnZc2OSoAzyBQUqSry40YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBkGaw6JTek3sXZRt6raryzSsr9l7ZH3uwYHzyOmDwwAk9kyv0Lr0lzqBTdBuVEEPnTAnfVo2wt8Wq0sGmPK9clk6pnCqyJSo4OsubsN5CAc3hyLHtamF9orJjtP+jgsK+FoAUrPQDmqAVj6xbMAo/3wz9hUWeusXsib8xnOHhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJLIp/s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJLIp/s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1474C4CEF0;
	Tue, 12 Aug 2025 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020976;
	bh=S9JmgrnmhaipQmEThAJXhtnZc2OSoAzyBQUqSry40YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJLIp/s3pw6zTbcUSCRCfA59WYWuksA7TlkwKVrLbVtazqQteOpyS2nO3FkGc2x10
	 bhhk3nPxvpuNqOuoRF1+TbziPBiDxmwNXK9LvhaAi795tVrOKiRnKO6Akb7KLrLTol
	 BkK9qXpgN0SuwWU0DWX1gjo/0l5GI4Hcvhx1m0K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/262] interconnect: qcom: sc8180x: specify num_nodes
Date: Tue, 12 Aug 2025 19:27:13 +0200
Message-ID: <20250812172954.885053288@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7e0b59496a02d25828612721e846ea4b717a97b9 ]

Specify .num_nodes for several BCMs which missed this declaration.

Fixes: 04548d4e2798 ("interconnect: qcom: sc8180x: Reformat node and bcm definitions")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-2-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8180x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/interconnect/qcom/sc8180x.c b/drivers/interconnect/qcom/sc8180x.c
index a741badaa966..4dd1d2f2e821 100644
--- a/drivers/interconnect/qcom/sc8180x.c
+++ b/drivers/interconnect/qcom/sc8180x.c
@@ -1492,34 +1492,40 @@ static struct qcom_icc_bcm bcm_sh3 = {
 
 static struct qcom_icc_bcm bcm_sn0 = {
 	.name = "SN0",
+	.num_nodes = 1,
 	.nodes = { &slv_qns_gemnoc_sf }
 };
 
 static struct qcom_icc_bcm bcm_sn1 = {
 	.name = "SN1",
+	.num_nodes = 1,
 	.nodes = { &slv_qxs_imem }
 };
 
 static struct qcom_icc_bcm bcm_sn2 = {
 	.name = "SN2",
 	.keepalive = true,
+	.num_nodes = 1,
 	.nodes = { &slv_qns_gemnoc_gc }
 };
 
 static struct qcom_icc_bcm bcm_co2 = {
 	.name = "CO2",
+	.num_nodes = 1,
 	.nodes = { &mas_qnm_npu }
 };
 
 static struct qcom_icc_bcm bcm_sn3 = {
 	.name = "SN3",
 	.keepalive = true,
+	.num_nodes = 2,
 	.nodes = { &slv_srvc_aggre1_noc,
 		  &slv_qns_cnoc }
 };
 
 static struct qcom_icc_bcm bcm_sn4 = {
 	.name = "SN4",
+	.num_nodes = 1,
 	.nodes = { &slv_qxs_pimem }
 };
 
-- 
2.39.5



