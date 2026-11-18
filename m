Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029757;
	b=3qFvSKDtwl9Sk9ALgkfnuqmTdmcXnmbkJyBa6KpT30ngk1X/CsX2qOFjypJNPdIJZmHq
	 9+6RVyLPoerhr/69gIxqtHW/9EvghWL8lsNml/oVDuFzScNqhGvlaNWYKjVXJfpyPkmB6
	 v70XSqGxAP0gbMqj192CxDuJVDoznkhlQ5FQm7D9yhwywortKP9i9v6QbbOUwk2RA+L0h
	 pKJ7xN8qC1DIi5w4qgqRuoHKI6o8cWXIISUBzhlUxF6MNag3ZCgZ5DiF8g3Zr/ue4BSY3
	 ZZj1TPhstfTK6CGtWtkZul8C7vfwxyQQRMhz+w2Z9TQ0ummE6J3YDY9dmnO9V893TcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0eZap0U0ZkaUwYAuCjL72W4h5+Ti6adX1Y9HcT0eq80=;
	b=CXWdA2R1DDpjspt8sQAg1tYZQK/Ry0hP+dNUjxyh08dJCPLSxzFx48BLV8DGHn4p7Nvm
	 fI/e5gv1qC3MqqjCxbSZqeKUDz8YM7YdVcQe18pkZb2voprDiox5XM8AbHL98rYifyfO8
	 l0W9naUFkqD0rqWjjzy9UnEaKyWTTxzjLt1rTR19c1/W/ajTdnG3lywYVeFemhyWP1c0g
	 DJ3m+dSR+7py5lNcuBPw34psl7bcX4XYN3IV8tcAy+jDEx3X4EMSCPqjL84AxIeGEmNid
	 /hJlK/jw+PT+JHfmAyZ+8F1DK+yg8mHnRxXykUlNaNE0iSgpgzOTHYgNPeo5ndTZWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNo6WmVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136CE606A32F;
	Wed, 18 Nov 2026 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNo6WmVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670C31F000C6;
	Wed, 18 Nov 2026 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029756;
	bh=0eZap0U0ZkaUwYAuCjL72W4h5+Ti6adX1Y9HcT0eq80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNo6WmVStdHZffLb15B/4Y4BCif4SPn48qa9SBRni/+DhiDlhE0rnhJifXi/Cs2Wd
	 cKoKUDpSni8qtTAHEu0j6lAjiMZNCs+nlRZ9VQTQc6HmsOfaH5/NbzqxEaslP8GRxH
	 oDIPdfe4iOXRhNUrfvGS4SvPJXPce5jNw6r+7O2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0461/1756] interconnect: qcom: icc-rpm: Handle icc_link_create() failures
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118150027.129638994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a8ed435f696c6..ce21a1a04cd50 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -581,8 +581,15 @@ int qnoc_probe(struct platform_device *pdev)
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



