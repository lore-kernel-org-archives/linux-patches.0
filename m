Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016340;
	b=nbyFJzHNPZ0iLu15M2Ovs2Cjk0poWshXqVFyWR83gnQCHMbc6VmpvmYfii0f2d+gqpny
	 +p7sy59u1vMs4c8J3QZ/oHVcceNh3mJpNudXVenZTp4udbm6m6anNCWf3aoISNIyTzSen
	 EFzdE6fgSSNfbVmN6AlYdQ2N7pv4d/Cf5sDEYB4rZ85weoSKLjoIHv0H07PRcNhXU6Bqf
	 ANya6TiYLeB55t9Qwx+s3E+WZQk9XyF1sT/Ev3jrIT4gwbKhfQ2+kt7idi5sEBZGffI9y
	 OcdFbTTvexAbvKkrRPQzQxMvc13qD7JW5SI6LqGUP1QGxB/X9ikiNbhoIS8rYchcFWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oz7PLlgKPtsKmDkRKwprmV9TuH84IqANI23imSkB2dY=;
	b=NwL2IBck/dR6SZfQUi285NDiSPw35ExSoDDum8XcOKMZpBTMWQRlj1dKoheq9+yZJkN9
	 +BdOvsVVRv4WxIRfYsq8z4MJqKURCtmDGsg6VwqccQDU7Bp21R7njCFb0USfbmD62JEQS
	 eed3bszf86fS2C1QwNlnQUhulWQC4c4jKSsuf3jZKMmI4WOhNtZI0T3bpfN2VNMDUawtk
	 ElVaNWyA1SDkC+f9w8pTjL7P+OZAvakyyxPAgZoizQ2FsBcs4gI3PXgKBOpGmyvqV/23V
	 2LO571AUKWio5QUTL2ZU+nuBNASlpU/QiGQaAQ2Wjzq+pgiei/8eo1JGmleZBzvOA7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTjX5skE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A9D606A337;
	Wed, 18 Nov 2026 15:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTjX5skE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CC81F000C4;
	Wed, 18 Nov 2026 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016339;
	bh=Oz7PLlgKPtsKmDkRKwprmV9TuH84IqANI23imSkB2dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTjX5skE+lRfvthnBrvWLu2EV0F/b6xik9eWHEHLlEth4ByNDBpKjVbZx5VnhzaQS
	 xIQqRC1vzDHp+QN6Pp0sU2GcxEMReQzOst+FJGtBozmaV4gYKXW5/uUD+ZEc0GALS+
	 41SMJuNFYYiRs3xsoWmPcIaBxrEu6Owvh+nV64Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0494/2651] interconnect: qcom: Move bcm_div() to common code
Date: Wed, 18 Nov 2026 15:28:54 +0100
Message-ID: <20261118150305.559822131@linuxfoundation.org>
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

[ Upstream commit 51797517fab74cba616b4932cbc2348c0fc04192 ]

This helper is useful for both SMD_RPM and RPMH code, extract it.

Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-1-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Stable-dep-of: 40ea86fa389c ("interconnect: qcom: icc-rpm: Don't skip small votes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/bcm-voter.c  | 25 +++++++------------------
 drivers/interconnect/qcom/icc-common.h |  9 +++++++++
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/interconnect/qcom/bcm-voter.c b/drivers/interconnect/qcom/bcm-voter.c
index a2d437a05a11f..b05350af03207 100644
--- a/drivers/interconnect/qcom/bcm-voter.c
+++ b/drivers/interconnect/qcom/bcm-voter.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
  */
 
-#include <asm/div64.h>
 #include <linux/interconnect-provider.h>
 #include <linux/list_sort.h>
 #include <linux/module.h>
@@ -14,6 +13,7 @@
 #include <soc/qcom/tcs.h>
 
 #include "bcm-voter.h"
+#include "icc-common.h"
 #include "icc-rpmh.h"
 
 static LIST_HEAD(bcm_voters);
@@ -47,17 +47,6 @@ static int cmp_vcd(void *priv, const struct list_head *a, const struct list_head
 	return bcm_a->aux_data.vcd - bcm_b->aux_data.vcd;
 }
 
-static u64 bcm_div(u64 num, u32 base)
-{
-	/* Ensure that small votes aren't lost. */
-	if (num && num < base)
-		return 1;
-
-	do_div(num, base);
-
-	return num;
-}
-
 /* BCMs with enable_mask use one-hot-encoding for on/off signaling */
 static void bcm_aggregate_mask(struct qcom_icc_bcm *bcm)
 {
@@ -99,20 +88,20 @@ static void bcm_aggregate(struct qcom_icc_bcm *bcm)
 	for (bucket = 0; bucket < QCOM_ICC_NUM_BUCKETS; bucket++) {
 		for (i = 0; i < bcm->num_nodes; i++) {
 			node = bcm->nodes[i];
-			temp = bcm_div(node->sum_avg[bucket] * bcm->aux_data.width,
-				       node->buswidth * node->channels);
+			temp = qcom_bw_div(node->sum_avg[bucket] * bcm->aux_data.width,
+					   node->buswidth * node->channels);
 			agg_avg[bucket] = max(agg_avg[bucket], temp);
 
-			temp = bcm_div(node->max_peak[bucket] * bcm->aux_data.width,
-				       node->buswidth);
+			temp = qcom_bw_div(node->max_peak[bucket] * bcm->aux_data.width,
+					   node->buswidth);
 			agg_peak[bucket] = max(agg_peak[bucket], temp);
 		}
 
 		temp = agg_avg[bucket] * bcm->vote_scale;
-		bcm->vote_x[bucket] = bcm_div(temp, bcm->aux_data.unit);
+		bcm->vote_x[bucket] = qcom_bw_div(temp, bcm->aux_data.unit);
 
 		temp = agg_peak[bucket] * bcm->vote_scale;
-		bcm->vote_y[bucket] = bcm_div(temp, bcm->aux_data.unit);
+		bcm->vote_y[bucket] = qcom_bw_div(temp, bcm->aux_data.unit);
 	}
 
 	if (bcm->keepalive && bcm->vote_x[QCOM_ICC_BUCKET_AMC] == 0 &&
diff --git a/drivers/interconnect/qcom/icc-common.h b/drivers/interconnect/qcom/icc-common.h
index 21c39b1639486..af4b5a6f30b71 100644
--- a/drivers/interconnect/qcom/icc-common.h
+++ b/drivers/interconnect/qcom/icc-common.h
@@ -7,6 +7,15 @@
 #define __DRIVERS_INTERCONNECT_QCOM_ICC_COMMON_H__
 
 #include <linux/interconnect-provider.h>
+#include <linux/math64.h>
+
+static inline u64 qcom_bw_div(u64 num, u32 base)
+{
+	if (num && num < base)
+		return 1;
+
+	return div_u64(num, base);
+}
 
 struct icc_node_data *qcom_icc_xlate_extended(const struct of_phandle_args *spec,
 					      void *data);
-- 
2.53.0



