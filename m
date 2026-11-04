Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829602;
	b=k5RXO+C0pVodEjWB5NzQ1lwARURsnxlIavf0KLIIazWLuwwKkOgCFbvKVHYTd23dHzqP
	 THEXBgJoFfs7g7clXQ2moZ0/C2iwUk2iPiOV3sPZyj9MyAPX7R9soIF7GC0IMv8vwKc+S
	 8q8ZsrmWL7kb0awjGXjfBIiUOFcSZJ1YEON0Bx30h2+f4zgAk3feAXqoAzNW6Na1Fa11O
	 w4zWJJeotqiygd6dOzVUhxnEXqkxBU69S+F3v7uk/hHQ19/I5rrI2SVhxzuMKi+4CCeqN
	 AifWca9/OURwEiHEC5inZM2IcwboZMVBuXM7tNIaWakxk7LzvT98lg8FTTl+y1hgI/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLfLzRL6lzSlcmAts+gEO7noaQidaOpX75+AVMpUywU=;
	b=wdIlXc8GmlEBnVKoggtJwzw8uEQXdHrFRTZn/9xxfBsUHMaFiip2owVNL9JEhMTdJGdJ
	 1wwgUYvp+lsqJdEZNsKBbkhFAfujJ4RqnUy2wmmVbXo30h9CyCoO6eIk0TpyVaD8+DEhH
	 koQm4AjSpGowTglM0Jx7mOKY2jHnkwlPbBO9FzipflJ/Qyr52xxvS6Nho/soyMJCW+ud5
	 /NSqOkWgJ35cxdi4zqatt20kfgVbavZmVBb9mVNotcDNiKTH2pD6rsWTtIgcOxqFrHfCb
	 08ALnh3w09s2n/NMR2WlHR/vRyIqUPZu8arEUud36fm22acEpxhNt6s7jAu9k0z54rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNN6x34W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86312606B2FD;
	Wed,  4 Nov 2026 22:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNN6x34W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB911F0093A;
	Wed,  4 Nov 2026 22:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829602;
	bh=KLfLzRL6lzSlcmAts+gEO7noaQidaOpX75+AVMpUywU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNN6x34W4PoULT/0I4PgN+yE2gwuPmWmAxpHCDbZndExbeKvXlqyOCYYTiJx/TIZ9
	 DhEI3anbLTOxqLE6ewg074+M06z47u9To43kfMGiMCuBNpcNZ1DSJ8kSbfeDqhoSoT
	 PF6d8U7CU4QzG5Nq0IjzhgGlnwSSjHYMVZirJrNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0229/1005] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Wed,  4 Nov 2026 15:59:22 -0500
Message-ID: <20261104211050.255090921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 792585321bd11..1a046122fca0d 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -306,13 +306,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
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



