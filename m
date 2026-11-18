Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016567;
	b=QY6G0rFrB4qoKmaJ/LE/bts9SaWtn4rX0UqFmFbrEqwT15CWlqrhe/Mu5Ypz67nZe5o5
	 Wue/2E6hzwt3kZPTGFf4iTNSSSa8WXJNdP2uaMwAR97tAjRehta47WOsENP3ScvEsl7b0
	 10mr6KMJPUe+jmcNCaoa/Mc3PXlVc8DA8IykBCNLSmENetlyMRQ3ckr5wWg2E2foQJo6O
	 eGusTY6jAjuRfg6Dt86YGDYgv4Gzjxrx9mLY82cg1hcVby7XDBzvvDyp4ywlyeGT6/rmh
	 JBjY9n4dPFmQKqZaawywJM9ukmua++ktHAgOHsKV6tt4UZ4VSOmynfIbHLA3cTyIDSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAbMw/spZj5wqyOWvYbNANUuuIfK6R856U0qi8R0EaE=;
	b=WjnQxqcLRnUjkrHu8lLlVbG6Yq2hqhdktWNXGpe9W01apO4Aw50gM4dy2i1T6ggZ0+TV
	 qmZ/C0BH2Y0VG63GI6Khtl2qS6WU1Xa/lZYwxmB7CHQZi9OFar+FlkwaicZO6Fn2f5pZD
	 HDrsqzItnjLpl2dIBXUM9995pYGxzP4p4qztFv4JWTMTH80tC+O54pIavVrMN3HFDM68w
	 vWQlLKs03L2UKw/54SFgLf7YefEc2Z7p/mF0WkAfyZDSV4baUt/m+X8PJjBGnkDWN6zVS
	 GEsTakfR9LS9ctFi4Nr26OXAn5KdmghP+XuuVVe2XTuakfw+aEq1zRZwvz5xTKf17jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onZ07rZ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528BA606A332;
	Wed, 18 Nov 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onZ07rZ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43491F000C5;
	Wed, 18 Nov 2026 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016567;
	bh=iAbMw/spZj5wqyOWvYbNANUuuIfK6R856U0qi8R0EaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onZ07rZ0RrnfBnzBcDKnFhoBeFzpUuYQa8DU5KlkYQ5VQ2bAya/f/8Tow46fhBOpb
	 x4R1yucUl8vpjh2NGmpNAryfGwrK7BstmKP5Te00qimwDUVDxjLQ2REoW9SLYIPvFO
	 +8A+l27+riEtsn1zXbHlO3Hqvj3AQyq/Z1zmNv+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0575/2651] interconnect: qcom: msm8996: Configure auxiliary Venus QoS port
Date: Wed, 18 Nov 2026 15:30:15 +0100
Message-ID: <20261118150308.435818643@linuxfoundation.org>
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

[ Upstream commit aa4c405d47c54bcf6d62d0f6596aeb555e52ebf7 ]

Enable the secondary QoS port used by the MSM8996 Venus node.

Assisted-by: LLM
Fixes: 7add937f5222 ("interconnect: qcom: Add MSM8996 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909-topic-icc_rpm_smd_qol-v1-5-6dc5b5e97626@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8996.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index 882f9d2b6d4e1..7fc808cc59757 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -501,6 +501,7 @@ static struct qcom_icc_node mas_venus = {
 	.qos.areq_prio = 0,
 	.qos.prio_level = 0,
 	.qos.qos_port = 3,
+	.qos.aux_qos_port = 4,
 	.num_links = ARRAY_SIZE(mas_mnoc_bimc_common_links),
 	.links = mas_mnoc_bimc_common_links
 };
-- 
2.53.0



