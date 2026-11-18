Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016573;
	b=e3744h0dYRzFw2XndOBgblxlM9zrrO1h54DIUbvZIm4tr2WKYRYPEhLX/oXaYdEnW0vD
	 U/Xvp8iB52ArkAKX1pkAM5ESb4xHA+TxO/WjXE6oNu+DBmz21GS5bu0Gk6px28rZy8blu
	 3T4+w5u7NToZqoGTLLKXsrNSzpDoq07i2JcBDnLpli72n8wEi2ijKAiIdkQlqnr/Ckmqy
	 Drka4GIA4K34t4p0ZBRKrEYCmPg01z70GCWsnUPpkoNSR7LSxFp4QktY9tRzVSTq81uRX
	 O4OnDkjXzhOWTHlMZIv20b0v9FVZU+8IG6l+vjHBxG+2Rmm9Nk6yYjuUS/zJy0NgH2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvltyz/DnkUZeFKurbLW87qWQg2CihZHVulrtUhq8MI=;
	b=YIiWsw4fNA81MvWvjwXnAkZo/+5iHrEgGzCWeuyXoJaybL7LVsSeLI2xNSnINqrYCqWr
	 /yhKJ62JcloEsWgBxVaBVBso9hamLqEOE9R84/P95p1ot8x4a95lwKL6hWTUfLcjLgcw1
	 laZUWBhUl2dHVY7jSzsyCQhKYivro9b8clbwxtbSazKDsX2oGWIB6E3TQURMH4KoZF4s8
	 SuWtvGAiP2UQCOEReE2Lo28XhPOz3R6XQ1Jy/l+2tCijZszULBveXbGOIngc2jrkDEKZ6
	 c7lQPUkGPuyQddnhBsqNltNlrrJMjBiHYrSiwZqwO9mjzw3M2wmIgj17sPaBFAjIpKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdNoCFaE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2486260A2613;
	Wed, 18 Nov 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bdNoCFaE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3238A1F000C8;
	Wed, 18 Nov 2026 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016572;
	bh=rvltyz/DnkUZeFKurbLW87qWQg2CihZHVulrtUhq8MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdNoCFaEl79yw6lC72IXTqZ1dTdcK75W07XbCJftYWX4gA1xWBkBmxBRpJ7NimIG+
	 7TU/0d7ktw2IJv4RvNlfOd/2qXGO3P9IX/oa2DbCpMVeoygFAFrrCvKvua9FbNg/tr
	 BA2VtoH+cUmOTfQxeUZL2dgn+lwCAJcNzrXe8TZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0577/2651] interconnect: qcom: use 64-bit SMD RPM bus votes
Date: Wed, 18 Nov 2026 15:30:17 +0100
Message-ID: <20261118150308.504323965@linuxfoundation.org>
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
index e36c378a80a32..d2c5f45eeedf4 100644
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
@@ -169,7 +169,7 @@ int qnoc_probe(struct platform_device *pdev);
 void qnoc_remove(struct platform_device *pdev);
 
 bool qcom_icc_rpm_smd_available(void);
-int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u32 val);
+int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u64 val);
 int qcom_icc_rpm_set_bus_rate(const struct rpm_clk_resource *clk, int ctx, u32 rate);
 
 #endif
diff --git a/drivers/interconnect/qcom/smd-rpm.c b/drivers/interconnect/qcom/smd-rpm.c
index dbc7ae50b02b7..6ac9aef942ad2 100644
--- a/drivers/interconnect/qcom/smd-rpm.c
+++ b/drivers/interconnect/qcom/smd-rpm.c
@@ -20,7 +20,7 @@ static struct qcom_smd_rpm *icc_smd_rpm;
 struct icc_rpm_smd_req {
 	__le32 key;
 	__le32 nbytes;
-	__le32 value;
+	__le64 value;
 };
 
 bool qcom_icc_rpm_smd_available(void)
@@ -29,12 +29,12 @@ bool qcom_icc_rpm_smd_available(void)
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



