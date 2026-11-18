Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029760;
	b=ZPzmA1eDajg4e3e3EyxwzlMTwzNZ1mHwPoFaeuWSBWgyjwm+fouCUSVky07OCzVRwdPU
	 PLpp7oCm4th5bEkVB9ilWwZv2TtJLrM58PEhWMm0ZQYEVInFTiY5MroDZlIVxTBm22SQE
	 KmnE20mt5H7n0upsbA4YM4D5lhH1ww3BfJ7S9qn7TWYCAJFvvyq/3UgkM2KDwzTuNdhkF
	 YhXZQHO0B5OXKRxslb+a8mx6gll5B3+vEy6SgVvom7zP21zYG5ArLYdRKdt8v4j5fdGEn
	 2lYIOA2LK27pfVUlTq7scWYtsG/ieLbEK9wwCUvxb+tJCEZ/XgUyp4EhefNPpvmi8/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8LcoZKham6AS+2uaV+r6nLIs8mu2VJIy8PmhKr5aj8=;
	b=rUe4n89L44s7oHPTxIWQlBSZOczRiZRAckaEMwZoTKI3R4al7YUL0XUeJ7yJZdEXaqLE
	 3ZycjRX3l1N70nh/AxuyxY2FtRVizR8AdYK8C9o1SF1pk3qSMu7iO3UQ28Va5DLGhyEl7
	 nb3fPRjNC5Z1Spod+KKGUzI4nPdZv+BIB0gGhYPOLtcUv2o6oEuRB1Qp+Y6hneGVcW6+Z
	 Tn1J9EAnwXa8xuL/k0dus2Baa3xTlfaIINb0S+jF7Dg3R+jBMmVPf1db98qyhXA/YTgb6
	 BmehQnLxn6XtlN1fhOos89BkH0iKJl9vqtYHWQa26AE1J+Pcx3GwHvyF1DZwqMiqNqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxU7TZvk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD20606A339;
	Wed, 18 Nov 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxU7TZvk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7664A1F000D3;
	Wed, 18 Nov 2026 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029760;
	bh=N8LcoZKham6AS+2uaV+r6nLIs8mu2VJIy8PmhKr5aj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxU7TZvkBCCnaC4AL3WhdiQ8K4U6wy6CynmUXvkQlcJ/lGuP1fK7LtPloYlX4VBEt
	 ACYxTx2cFWaRHfMQHmz85TPyZnz2isPT1RRuJB9/1RMYY397I9JR64kJ1ZZLohbVUk
	 YAnzCm0dcpSYT9urOfX0D4t07ttONC/x48Ok4h+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0462/1756] interconnect: qcom: use 64-bit SMD RPM bus votes
Date: Wed, 18 Nov 2026 15:43:09 +0100
Message-ID: <20261118150027.164989265@linuxfoundation.org>
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

[ Upstream commit 24e7422ce31189502d07279c083646aaca513311 ]

SMD RPM bus bandwidth requests carry a 64-bit bandwidth value.
The interconnect proxy declared the KVP payload as u32, truncating
votes above 4 GiB/s and advertising the wrong payload size to RPM.

Use a little-endian 64-bit payload and accept a u64 value in the proxy
API. This has always been the right behavior, even on msm-3.10 and
32-bit SoCs.

Fixes: be06f8e7425d ("interconnect: qcom: Add interconnect RPM over SMD driver")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260904-topic-icc_rpm_64b_req-v1-1-37e24f1991a3@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.h | 4 ++--
 drivers/interconnect/qcom/smd-rpm.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.h b/drivers/interconnect/qcom/icc-rpm.h
index f4883d43eae4d..9b1602b2d5c59 100644
--- a/drivers/interconnect/qcom/icc-rpm.h
+++ b/drivers/interconnect/qcom/icc-rpm.h
@@ -30,7 +30,7 @@ enum qcom_icc_type {
  * @resource_type: RPM resource type of the clock resource
  * @clock_id: index of the clock resource of a specific resource type
  * @branch: whether the resource represents a branch clock
-*/
+ */
 struct rpm_clk_resource {
 	u32 resource_type;
 	u32 clock_id;
@@ -164,7 +164,7 @@ int qnoc_probe(struct platform_device *pdev);
 void qnoc_remove(struct platform_device *pdev);
 
 bool qcom_icc_rpm_smd_available(void);
-int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u32 val);
+int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u64 val);
 int qcom_icc_rpm_set_bus_rate(const struct rpm_clk_resource *clk, int ctx, u32 rate);
 
 #endif
diff --git a/drivers/interconnect/qcom/smd-rpm.c b/drivers/interconnect/qcom/smd-rpm.c
index 3816bfb4e2f39..f48d904dde195 100644
--- a/drivers/interconnect/qcom/smd-rpm.c
+++ b/drivers/interconnect/qcom/smd-rpm.c
@@ -21,7 +21,7 @@ static struct qcom_smd_rpm *icc_smd_rpm;
 struct icc_rpm_smd_req {
 	__le32 key;
 	__le32 nbytes;
-	__le32 value;
+	__le64 value;
 };
 
 bool qcom_icc_rpm_smd_available(void)
@@ -30,12 +30,12 @@ bool qcom_icc_rpm_smd_available(void)
 }
 EXPORT_SYMBOL_GPL(qcom_icc_rpm_smd_available);
 
-int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u32 val)
+int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u64 val)
 {
 	struct icc_rpm_smd_req req = {
 		.key = cpu_to_le32(RPM_KEY_BW),
-		.nbytes = cpu_to_le32(sizeof(u32)),
-		.value = cpu_to_le32(val),
+		.nbytes = cpu_to_le32(sizeof(u64)),
+		.value = cpu_to_le64(val),
 	};
 
 	return qcom_rpm_smd_write(icc_smd_rpm, ctx, rsc_type, id, &req,
-- 
2.53.0



