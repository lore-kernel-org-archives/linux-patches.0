Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043248;
	b=Do5Djy+q7RTv1TmhKsAwRoIPLZWjDxCoKtRd/4oITLwIXxOlob4LY25zC+itqgryNXqy
	 SfBCE9bI8e9Cp83yNG/YaEGph98jxFsPh6tE+1+kX5y0o5pKhoyZdDIwRrz6wgL5tB+eI
	 ySGWDr+4YqkXTCdNiNLwkVC6YmB+TfxOsiw9/UqXrZmt70IRntmkStvX1IJkzmoSi5fzi
	 iN4qoF/GSzl/yucpYHucoe/9a8xExDZTqrBonys9hsGxMOHuDg/WKDPGIZ7ER29KwHSzy
	 rmyB+CszQz+4cp4IdRVVIcYCaCIKbjzEnX6AwlwIZlPRDv9zyHD9hIz7W+mbIy8YBjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qZRanQRzBUzecnaEzOIu0C1TZAu/wD4Hb5MCzQ8IcPQ=;
	b=mMSe2w8bYniT0SBJ8fbQzhbiBtXSrc5e4Pf1/naBAO6ztcMU2PvB2vCtbIhd81dF385J
	 2Kxz63Td8mVL6Z/skKjdUcbEXnGDyYo4Z1sTl4TXjciHhS8CZRWvVH5Y65lkDCV6FFwcV
	 jAkMcXKHVXFRc73v6WlOQ8x4Id/b2U9tCvadvLZ6yZoPNprRkqveX+jNMzWFSyLbIlsrn
	 16f0HAKiUgs0mixL/rkc/QCqYfHyKCVvCAEHkHjfF4qr69gu4cu3cZmrphvHzNrT5BdEs
	 igkvRenO/ffd7Bc+xJCzfsZBg/SeNEAY7JHWuwaX0YA/Ux4KUiv1B7knJwSS73IL2OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLoWbvCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215A0606A32A;
	Wed, 18 Nov 2026 23:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLoWbvCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768D61F000C6;
	Wed, 18 Nov 2026 23:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043248;
	bh=qZRanQRzBUzecnaEzOIu0C1TZAu/wD4Hb5MCzQ8IcPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLoWbvCpJeJR1Cn0SFj0pK+0270R8MHvOVpHldJ6LGnDVleuvyFosJUNRfwAIZl6N
	 nOoUG09d/Xmm6cKFhq4gvOBIh7GcFFQq8C9CI/4Rnjb+4JqBk6/5rHKYSkWfp5gpO5
	 sFJkhf8rH9xorAU08UJftymExGqqvjfd+L8RmK3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0142/2857] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Wed, 18 Nov 2026 15:19:36 +0100
Message-ID: <20261118150206.462580211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8fd68d7e9b361..0b9a73f7d377c 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -312,13 +312,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
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



