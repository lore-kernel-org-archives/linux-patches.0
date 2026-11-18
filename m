Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016564;
	b=E9o4oOar9FStKsB+yMnkQe2icTy3g9FnTyAXKg6bA0moUrP0tDn79Ac86wMQBmmgDY3v
	 mGugWK1vOVnDBb+P5Eq2I/vXerFlEcmckNc+WjtXl4C9S03heMATW13QK5Gj9uR1PATu6
	 QBTmtULn7VJWrx76GVMqI2pxG0La3oyZ7YSXv9hJO+qc+kkg2a/INHWlwtOwK/9k/IlY7
	 hhLJF0cuZ+Hjb77GlNIOEQK2b/wV22etRKWR45RDG6Hm58yFIoKk5DnTZCWBZqi3fe0Gy
	 TXAyOQoPzXhSf11R76d4RBR7vjpBiA1PKzCAuH2+7Gxd8M409SrOTKkExwD4sHbaT1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtrvVXAmEUATRW83KL7KSa1jrZRxsRZ0Qn/YQCUJR9I=;
	b=DrROQNuaIjqOUOVpJHGCleCHXs/qyGae1WzQjjGFPr0Us8Suh58DJIRoiHkAM/GDDPc9
	 TWBtTGO07OMbonL1WIX5jWP+6Ebx0J3LJfwgDG6QKv/aRJ0JdzxVmgqbPuZ7BdDIP/txa
	 ojzrKBTFMzw5hUafgNxEGkMLLHf48P6mYVVr2tpB3vKz9EMxdOFxzpjPkjZC+f/WQb39U
	 vrnPy8td+eQOnj5AaMGP/e/rH3HwH6WUMmDaKVrVp2WG6DVSdk99YvDo0uKDCtfzV0YCQ
	 76c0N6/7Uh2YQ8Ll7k2NuZoHIX4N6jzKGoZeEkoCgVch9wNgZq282Sek6yLhhssB72A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW4ANTw6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9B60A2604;
	Wed, 18 Nov 2026 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW4ANTw6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0761F000C5;
	Wed, 18 Nov 2026 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016564;
	bh=dtrvVXAmEUATRW83KL7KSa1jrZRxsRZ0Qn/YQCUJR9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LW4ANTw6Uk19N1XKIs7gMufUhwbfH3d83vAlfS/6au2YDXx9V2gOmiukQ3kP1a6rH
	 VvIfkilrm/jHhjk/SDGy+tFG0rm1Cmz7+pgvT7ixA6IcTFCMpFM1E+mzahAd5suFSG
	 c24yupomTOXyytKhEo4WJvqUerjCsSenL9X367rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0574/2651] interconnect: qcom: icc-rpm: Program SMD RPM auxiliary QoS ports
Date: Wed, 18 Nov 2026 15:30:14 +0100
Message-ID: <20261118150308.401045508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit ddbacca26d1db5bd9c477253b0af83b028136a24 ]

Some SMD RPM interconnect nodes own two QoS ports. Currently, the code
only takes care of one, leaving some endpoints partially unconfigured.

Keep qos_port as the primary port and describe the optional second port
with aux_qos_port.

Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-4-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Stable-dep-of: aa4c405d47c5 ("interconnect: qcom: msm8996: Configure auxiliary Venus QoS port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 82 +++++++++++++++++++++++++----
 drivers/interconnect/qcom/icc-rpm.h |  2 +
 2 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index fa69418818d64..407233f2d1218 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -58,15 +58,32 @@ static int qcom_icc_set_qnoc_qos(struct icc_node *src)
 	struct qcom_icc_qos *qos = &qn->qos;
 	int rc;
 
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + QNOC_QOS_MCTL_LOWn_ADDR(qos->qos_port),
+				QNOC_QOS_MCTL_DFLT_PRIO_MASK,
+				qos->areq_prio << QNOC_QOS_MCTL_DFLT_PRIO_SHIFT);
+	if (rc)
+		return rc;
+
 	rc = regmap_update_bits(qp->regmap,
 			qp->qos_offset + QNOC_QOS_MCTL_LOWn_ADDR(qos->qos_port),
-			QNOC_QOS_MCTL_DFLT_PRIO_MASK,
-			qos->areq_prio << QNOC_QOS_MCTL_DFLT_PRIO_SHIFT);
+			QNOC_QOS_MCTL_URGFWD_EN_MASK,
+			!!qos->urg_fwd_en << QNOC_QOS_MCTL_URGFWD_EN_SHIFT);
+	if (rc)
+		return rc;
+
+	if (!qos->aux_qos_port)
+		return 0;
+
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + QNOC_QOS_MCTL_LOWn_ADDR(qos->aux_qos_port),
+				QNOC_QOS_MCTL_DFLT_PRIO_MASK,
+				qos->areq_prio << QNOC_QOS_MCTL_DFLT_PRIO_SHIFT);
 	if (rc)
 		return rc;
 
 	return regmap_update_bits(qp->regmap,
-			qp->qos_offset + QNOC_QOS_MCTL_LOWn_ADDR(qos->qos_port),
+			qp->qos_offset + QNOC_QOS_MCTL_LOWn_ADDR(qos->aux_qos_port),
 			QNOC_QOS_MCTL_URGFWD_EN_MASK,
 			!!qos->urg_fwd_en << QNOC_QOS_MCTL_URGFWD_EN_SHIFT);
 }
@@ -75,8 +92,9 @@ static int qcom_icc_bimc_set_qos_health(struct qcom_icc_provider *qp,
 					struct qcom_icc_qos *qos,
 					int regnum)
 {
-	u32 val;
 	u32 mask;
+	u32 val;
+	int ret;
 
 	val = qos->prio_level;
 	mask = M_BKE_HEALTH_CFG_PRIOLVL_MASK;
@@ -90,8 +108,17 @@ static int qcom_icc_bimc_set_qos_health(struct qcom_icc_provider *qp,
 		mask |= M_BKE_HEALTH_CFG_LIMITCMDS_MASK;
 	}
 
+	ret = regmap_update_bits(qp->regmap,
+				 qp->qos_offset + M_BKE_HEALTH_CFG_ADDR(regnum, qos->qos_port),
+				 mask, val);
+	if (ret)
+		return ret;
+
+	if (!qos->aux_qos_port)
+		return 0;
+
 	return regmap_update_bits(qp->regmap,
-				  qp->qos_offset + M_BKE_HEALTH_CFG_ADDR(regnum, qos->qos_port),
+				  qp->qos_offset + M_BKE_HEALTH_CFG_ADDR(regnum, qos->aux_qos_port),
 				  mask, val);
 }
 
@@ -102,7 +129,7 @@ static int qcom_icc_set_bimc_qos(struct icc_node *src)
 	struct icc_provider *provider;
 	u32 mode = NOC_QOS_MODE_BYPASS;
 	u32 val = 0;
-	int i, rc = 0;
+	int i, rc;
 
 	qn = src->data;
 	provider = src->provider;
@@ -116,8 +143,7 @@ static int qcom_icc_set_bimc_qos(struct icc_node *src)
 	 */
 	if (mode != NOC_QOS_MODE_BYPASS) {
 		for (i = 3; i >= 0; i--) {
-			rc = qcom_icc_bimc_set_qos_health(qp,
-							  &qn->qos, i);
+			rc = qcom_icc_bimc_set_qos_health(qp, &qn->qos, i);
 			if (rc)
 				return rc;
 		}
@@ -126,8 +152,17 @@ static int qcom_icc_set_bimc_qos(struct icc_node *src)
 		val = 1;
 	}
 
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + M_BKE_EN_ADDR(qn->qos.qos_port),
+				M_BKE_EN_EN_BMASK, val);
+	if (rc)
+		return rc;
+
+	if (!qn->qos.aux_qos_port)
+		return 0;
+
 	return regmap_update_bits(qp->regmap,
-				  qp->qos_offset + M_BKE_EN_ADDR(qn->qos.qos_port),
+				  qp->qos_offset + M_BKE_EN_ADDR(qn->qos.aux_qos_port),
 				  M_BKE_EN_EN_BMASK, val);
 }
 
@@ -145,8 +180,24 @@ static int qcom_icc_noc_set_qos_priority(struct qcom_icc_provider *qp,
 	if (rc)
 		return rc;
 
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + NOC_QOS_PRIORITYn_ADDR(qos->qos_port),
+				NOC_QOS_PRIORITY_P0_MASK, qos->prio_level);
+	if (rc)
+		return rc;
+
+	if (!qos->aux_qos_port)
+		return 0;
+
+	val = qos->areq_prio << NOC_QOS_PRIORITY_P1_SHIFT;
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + NOC_QOS_PRIORITYn_ADDR(qos->aux_qos_port),
+				NOC_QOS_PRIORITY_P1_MASK, val);
+	if (rc)
+		return rc;
+
 	return regmap_update_bits(qp->regmap,
-				  qp->qos_offset + NOC_QOS_PRIORITYn_ADDR(qos->qos_port),
+				  qp->qos_offset + NOC_QOS_PRIORITYn_ADDR(qos->aux_qos_port),
 				  NOC_QOS_PRIORITY_P0_MASK, qos->prio_level);
 }
 
@@ -182,8 +233,17 @@ static int qcom_icc_set_noc_qos(struct icc_node *src)
 		/* How did we get here? */
 	}
 
+	rc = regmap_update_bits(qp->regmap,
+				qp->qos_offset + NOC_QOS_MODEn_ADDR(qn->qos.qos_port),
+				NOC_QOS_MODEn_MASK, mode);
+	if (rc)
+		return rc;
+
+	if (!qn->qos.aux_qos_port)
+		return 0;
+
 	return regmap_update_bits(qp->regmap,
-				  qp->qos_offset + NOC_QOS_MODEn_ADDR(qn->qos.qos_port),
+				  qp->qos_offset + NOC_QOS_MODEn_ADDR(qn->qos.aux_qos_port),
 				  NOC_QOS_MODEn_MASK, mode);
 }
 
diff --git a/drivers/interconnect/qcom/icc-rpm.h b/drivers/interconnect/qcom/icc-rpm.h
index cdd5f444b1520..e36c378a80a32 100644
--- a/drivers/interconnect/qcom/icc-rpm.h
+++ b/drivers/interconnect/qcom/icc-rpm.h
@@ -77,6 +77,7 @@ struct qcom_icc_provider {
  * @ap_owned: indicates if the node is owned by the AP or by the RPM
  * @qos_mode: default qos mode for this node
  * @qos_port: qos port number for finding qos registers of this node
+ * @aux_qos_port: optional QoS port in addition to @qos_port. Zero means "none".
  * @urg_fwd_en: enable urgent forwarding
  */
 struct qcom_icc_qos {
@@ -86,6 +87,7 @@ struct qcom_icc_qos {
 	bool ap_owned;
 	int qos_mode;
 	int qos_port;
+	u16 aux_qos_port;
 	bool urg_fwd_en;
 };
 
-- 
2.53.0



