Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039893;
	b=i0823pPwN+01xh65UIGMnXdifqxtNoA6R2mPc/qg5wd1MWECYaYWWmUM79lii64MpMO7
	 8PHqgYALLeOpxWXPojXToHSfnL4hB/9WcR4SJtw9QCfQBa3edbn4cenme4v32kwfLr95M
	 zoCWQsgnXWh7mGG/R2wfKG+uo9En2GHq4npJ28C83YUfNabqA3G0wvhvGLolVonX8UO3e
	 5Fte4qsM8MW8EPZVAkTAfgyaoZJXUJ/ALfyYKLc3F+fXEMmKfrbAGFdaYCXp38vLKXwpz
	 l2sFK+MJweMJ24ZDUv0EWqVHSNtR24VZPpzXnWKi0latOaR9Zc+TaTnjshhIm0f38PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aDxjjmGPs9LPXEtNsgmcB0R+ndHWvZPpvLMpGtQp+KI=;
	b=1NP3C+UisQlHJKOSl7fTRtxGeJisEttypZEpkRfrB71ZYQN5vcQ4vf2HU6aj+CxAeuU/
	 r7/9S7cJwAyh575mhcRsO+f0C6nO976eCckA6/GFA/KZY84aMtky+veHrgcEmPFtS3Clq
	 SirU+VRTLgPVP4oDUlVVlllxSi6XeCMygGqGbrREfhs/Sskz6M5b+khFWiF4tY2NYWKcL
	 F/DGYpwQj2dpI8z7H3sywiP8BiYSWJLuDFibgIlefumILgXEJoBoqFN+7VDFgwSg66ha3
	 jGjp2WsIOaNvcv/hKw+/FxZF7bH102hS8jgz6U9zfa+sT8mwfeMw5Ffwz0FcECHX2ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tudbtqCd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C1606A31C;
	Wed, 18 Nov 2026 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tudbtqCd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED001F000C5;
	Wed, 18 Nov 2026 22:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039893;
	bh=aDxjjmGPs9LPXEtNsgmcB0R+ndHWvZPpvLMpGtQp+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tudbtqCdG5IH+G4shtl0DrJqtBebM3VBJFK+jzb2Fnu+0hSac6ZHcqMs6lP/lv5AX
	 FO3sbEW1RotbrAqibJcuzJbS5ROBg6k+cBDW45zu3ZF0Eh1i4Yqi4sGUDdPhcy/9Ts
	 pY45yk+Fk+s75ydG+wUhQD3coi59zUTocdxwc034=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2262/3318] interconnect: qcom: use 64-bit SMD RPM bus votes
Date: Wed, 18 Nov 2026 15:48:04 +0100
Message-ID: <20261118150429.675469275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eed3451af3e6e..4545e9d50ff5f 100644
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
@@ -149,7 +149,7 @@ int qnoc_probe(struct platform_device *pdev);
 int qnoc_remove(struct platform_device *pdev);
 
 bool qcom_icc_rpm_smd_available(void);
-int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u32 val);
+int qcom_icc_rpm_smd_send(int ctx, int rsc_type, int id, u64 val);
 int qcom_icc_rpm_set_bus_rate(const struct rpm_clk_resource *clk, int ctx, u32 rate);
 
 #endif
diff --git a/drivers/interconnect/qcom/smd-rpm.c b/drivers/interconnect/qcom/smd-rpm.c
index 16a145a3c9144..92916c5f1db0e 100644
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



