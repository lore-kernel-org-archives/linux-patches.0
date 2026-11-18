Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023983;
	b=QKMvqZGknamBifdFFpE01OmaP517WyYjvg5fejFlTHBwycYX13Kb5hSfX5oucD8Hxeyk
	 mCDDb6LMpMWdz8TnQlg1hUmAuWuIbC7iGGLgx8oLlQ4ftHZhkiX8nHI38d2qX0A6FgY71
	 mABBVxaFZB6SLNXWLZ1atUlaZ4lelF78E2L0A3QiHSRpD4SJbNXZs63AXjvZAV1bfgDe/
	 HKpUq7mzpksdhQWKqkaGGhpOU8PRd4pnJwXPmNc9aIgMNrzv83YrlEN3rHoP9VarqC6HP
	 gFXlS/e8OxDQQQoOd+55xGrJeh0+SNvYO8gSEXy0JBH3dq+kIZxalPPywNur1LNd35g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7slAwvZ1IBYAqth1yXbaKkssxOhFPh4NV/5mOEqNSI=;
	b=Q0N1coO42RbGfNUmwi+XebL5X/1U7KKKONPe4qtH/Q8xf3+eFwABqSmsBjI16Y/u76Rg
	 6B6IiVZQMzoBVIPrH31bOMp77gtJ/mjYKG4Fq42caZwYbmLvd4wuGBLO37lkGpe87UhLM
	 pRxCcOAEbGesz3qFUzwsvvcTG0tPg7Ws9Qqgw6/21M5s06tD8hWsob2ddsE1mviLy1Fit
	 IeaCknFit85DXZ1Huj0RjAuJ2H67xwLAr0pAZWfH2QHIOag+qsQ7rvoClqkKvPO1gyxhu
	 UJkCVhpxB5qDrVC0ngOWQmp0B7h0yXK3QaWERyKSlScoc8AgE5xrjeThO0otBQiefmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tChbBd5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB39606A31C;
	Wed, 18 Nov 2026 17:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tChbBd5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A78C1F000C7;
	Wed, 18 Nov 2026 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023982;
	bh=y7slAwvZ1IBYAqth1yXbaKkssxOhFPh4NV/5mOEqNSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tChbBd5nO1/5evMmOhCx5m1UayytcIufJzWLiOQPlG8KgDkXIHgEvBXUsXWMyW2pC
	 ffY20Df19WF/5fcSuKNYjZtk+6hf5GNEd+ZxnYATu3zsPcWMZFzaabgDlFYVd88WkG
	 ivvj/q6azG77eLkf/uMP/DVRXHFyo3labBMERp08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0522/2151] interconnect: qcom: icc-rpm: Handle icc_link_create() failures
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150141.056640952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b2079a6b8e8b92c6c45a22930e5b68a9c5c34645 ]

icc_link_create() can return errors. Don't ignore them.

Assisted-by: LLM
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-3-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index ea1042d381287..37da715554eae 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -582,8 +582,15 @@ int qnoc_probe(struct platform_device *pdev)
 		node->data = qnodes[i];
 		icc_node_add(node, provider);
 
-		for (j = 0; j < qnodes[i]->num_links; j++)
-			icc_link_create(node, qnodes[i]->links[j]);
+		for (j = 0; j < qnodes[i]->num_links; j++) {
+			ret = icc_link_create(node, qnodes[i]->links[j]);
+			if (ret) {
+				icc_nodes_remove(provider);
+				clk_bulk_disable_unprepare(qp->num_intf_clks,
+							   qp->intf_clks);
+				goto err_disable_unprepare_clk;
+			}
+		}
 
 		/* Set QoS registers (we only need to do it once, generally) */
 		if (qnodes[i]->qos.ap_owned &&
-- 
2.53.0



