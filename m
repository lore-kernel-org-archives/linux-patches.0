Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023986;
	b=QAubIy3mefqeH47VGko9x1Q0FfORtyN25Z5FtIN4BL4VrEKX0xaUS/fRbYKBCloWS1qG
	 BWP4aEPstxeCV3SlRx/H6M5IT7HbnOu+gJkL5uEO703omUc+1mN4m5+Bqs34iMMJd2cc+
	 GrK7lsnz8Mvb7iqnG23HQy3R8yqmQVAfg0AxP5d6L/eFZYzbCCC1uBGqVm+1QKu2C8ag1
	 3gh6m+VIFNhy3D5GmgSpqwulXsjbHrrdoqmM0wDLjHzRk4ZKMcVxeM/tV+q1+Dd7p501p
	 tkQaMwyWoP4u7y6/EZTbkiZ/XDnZV1jyKXc+IKT/gpmNQeV3jA0KqevtnKkPpRxOEDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/Qi0oIMeewMVfmtZXjxjB3xgDFabMwxPwBo+EFAM3s=;
	b=q1G31H5B6X0nOQFd07SnLi2S/S3Q/t8bjNiqcivre+RWv3189jng1EIOQX4p/aNNoQyk
	 7VAZJaG5KFxyd6DKZFtmZrQsJDjdx+FFsvN+6n3pDDSK8Xtl6eXMlNKKbCjcI6lEmB2mZ
	 cCsfWD7r3Byf1LfRgLO7m76QsizJQtyBS6CI0bociOX+TJ3X3lix5SCtpcVwOtGk8S9P/
	 3U6Mb4I4NYUkwNr3OyrMRNONmJOZvL6yKUTIfdSpX3mVFsr2D1nrNZzZSWCQBaMBROaAB
	 Fi/jC3bP1sUgqQiWprCGfOtje+pXwFaGD1Q9saE54fTkhawI/+j/od3qBcaMy31vKag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brMCV5oG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F0606A320;
	Wed, 18 Nov 2026 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brMCV5oG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2101F000C5;
	Wed, 18 Nov 2026 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023985;
	bh=Y/Qi0oIMeewMVfmtZXjxjB3xgDFabMwxPwBo+EFAM3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brMCV5oGQ3eADJAUnT+bW9k3NUuwLZ2S3z3P9R/7vJjLMxPUIMGLeyq0e04D8Ndq9
	 NQQSYVE3jBUpHSkWKcsvZui/emFzuQwKVQrMO58hLTjhHv64E8KVNqTj1GfS9PoYZ+
	 hxMpqV8IiZwqSK62D8TNS+yi2NpLOkn+3SGTcv48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0523/2151] interconnect: qcom: use 64-bit SMD RPM bus votes
Date: Wed, 18 Nov 2026 15:37:38 +0100
Message-ID: <20261118150141.090977257@linuxfoundation.org>
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
index 8316c87a2c60f..39831fcf191b3 100644
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



