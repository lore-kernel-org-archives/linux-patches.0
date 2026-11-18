Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057377;
	b=09+XpqYd+i0bTItetqfY/cOpyBoR6McmD8/G7stabJs/EFVrfkqXLpUeiSbRudI1gyuA
	 LkWcv9W/P0+mkPdhXywGSevOyvcqwVsc6cwJ4o1Z5y9qCIcUKOglOBKWLNnelsHpfg4Hb
	 AIuMxQ4EBEoR6eNcgbHlP6FrckSamYx7wgu11b0ftqh2DzPLCrF/6TxrMB4O3g/G2SXhz
	 oBMUkyck3yxRL71HydqYefT40fEwQrmkfMvLtXsSJscrRd5+fRq7qagynl/AVOy1PNwSN
	 Zgm+ccLVHpc3inzoQgSqM0b8IBS+cP5cdBuztZjKcbK/H8vnDwDQTjZIHj55GObzhig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oKzVVxQB7AwyHW6vccLxPwQjNbKtrtRZ90FrHYl2sK4=;
	b=mkGxnqSTCw/fvLaSMykRy/5QfJwkjnPn9I/2hbHxj2ZOywghF3XWW81PJAubND+uXA4j
	 Mr+E9+IUd0DoChnF4vsfA+dBjRaPI1Rh7Fhas5LUgiROXlWC6B5ExDEjgsSbvEXvfnSTK
	 TjrS9s0Wh9PXBlVZXrWyT/FP7Zp77svivyc097F+UB3dcjiInc2cfGfbiOBJ9qYutWazu
	 EHLQbz2hOZUYehhhnmD3CZKusKtCRQSmFUikWh+40XuWKnbRg1bI3WCZo5marguaZyCT8
	 ref3jpijWNRd+f0F+yQ3Mj0rK4KtL7fSi0p67Ta8c4+8iP5vsTLDQPjWU7bPnqsT2Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnsFqyG8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1F60A260B;
	Thu, 19 Nov 2026 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnsFqyG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E041F000C4;
	Thu, 19 Nov 2026 03:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057377;
	bh=oKzVVxQB7AwyHW6vccLxPwQjNbKtrtRZ90FrHYl2sK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnsFqyG8V/Eyrx2p7Hl1YHDygnb23xhM3YbIbArBtzTnCxmy/JHrJ5w2C684egB4y
	 6KfT+t2BUNvws/4i0u1hSxACAZ2zXa8+cKR4huYj/9b86ULzoj9eSm0dto9Xci9FZY
	 cRSZe4oOaY9NIv/voQLcCxfOQf1NDebdZbX/4Bns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0110/1848] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118145915.629335065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cfcebc87a978e..01152fc75c632 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -322,13 +322,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
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



