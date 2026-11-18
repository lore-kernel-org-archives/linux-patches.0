Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033976;
	b=zPdAHE1eyahJduoMVz3S6AsGVJnvTRN/NJsL4IPuKJJOYVpufhwUe18YpMtLEDo/hQE6
	 hWJBKymtHdllS6ICkM+R5MxKqrrA2X96X8tNgzFtZux28Q4TNuQUE7tEgrkaj790U6JL4
	 rtwNgRJMP1wR4mbAUBLZHtF4U6ypR5zSiPJnor3p3FX9eQiifGPlTw0qlYtbOA9Ln+7tY
	 G5kO+bdZ0DFEqd9glxueC2etoqva3njsu+0t7IglwgiZe3e9Zp7JaCc53WEhlksbbL125
	 8RZqCzxo7T3OKT7f+ud1aCZzt6wxoN8h+8T0/r07BT6FOutZ4OQ5a8qL5w4OCppAc1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTEpRDYZD2EIosGevGw4xp7LpienjBhPtJ/TEsA7A4Y=;
	b=OBPRE2JwFFbzcS//nNWAtcIaPT6yykWlSkqLP39VClzBoSTerDEeCb0pvEhXzl0+2GTA
	 RQj6iPmcvUgJoCb/4JikNuQqMSRLmU2QjcZv8b+iDnC7orgkQzsQNWOFgaRs14gnQiYta
	 hG57Ba8kA3j+20pmhFCNEGiU/+dPO3cwHh/FyTh9M3NP0FCgNnxTFak7KAQCnHwdsy2F1
	 FqtXXPTFeLF5CssVrltC+CdoYotnGcPJxGSPCWAaNJz6JASPGb3xh4IlyDHS/ayuz6M+e
	 lHWe38hLnHPhggd2yAQQauR1DIjCIRXX0SDaRxoT/4qNQ2lJZWBWZMEvAzCSlEcxNsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QceRa9kO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DFC606A336;
	Wed, 18 Nov 2026 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QceRa9kO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D801F000D3;
	Wed, 18 Nov 2026 20:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033976;
	bh=NTEpRDYZD2EIosGevGw4xp7LpienjBhPtJ/TEsA7A4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QceRa9kORd6G2a4K721UOF6U5HnuWAuQVs+t8owSjJlR77GmlVPzz/59AjInllcqT
	 +r11fm7C3ygwbaLk5LyXeDNoRuznolyMq2y97NMuaDqx21p7z3OKlp9IwQZSCUtEHa
	 jnVIxBGBGrlDAZ4bxEXNlZMNGkNUJ9/b7toOIG9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0165/3318] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Wed, 18 Nov 2026 15:13:07 +0100
Message-ID: <20261118150319.553794221@linuxfoundation.org>
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

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit a05b67cd45ad09a19f41b2d37255da714512e0ca ]

qcom_domain->pgtbl_ops was assigned after mutex_unlock(). Another thread
calling qcom_iommu_init_domain() would see qcom_domain->iommu already set
(domain fully initialized) and skip re-initialization under the mutex.
If it then called qcom_iommu_map() before the first thread set pgtbl_ops,
it would observe a NULL ops pointer and return -ENODEV for valid mappings.

Move the assignment to before mutex_unlock() so that once the mutex is
released the domain is fully visible to concurrent operations.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 3de5a7847978d..65a1529bdcf26 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -318,13 +318,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
 		ctx->domain = domain;
 	}
 
-	mutex_unlock(&qcom_domain->init_mutex);
-
 	/* Publish page table ops for map/unmap */
 	qcom_domain->pgtbl_ops = pgtbl_ops;
 
-	return 0;
+	mutex_unlock(&qcom_domain->init_mutex);
 
+	return 0;
 out_clear_iommu:
 	qcom_domain->iommu = NULL;
 out_unlock:
-- 
2.53.0



