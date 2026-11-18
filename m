Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051350;
	b=4awX3mjVeUb00gMNpg82K1584ZoLU4GXWP6VbUfjPRUVlXWjtYMMd0V8fMJHLMahp/op
	 tAAzF55EwhIxzYxGpyHZ+tItWk1Q2Ss4ZY6Ga7n/yqfwh5ENO3t9V4ZFWGA0cvfLnv9kB
	 o4o6t2fANkHELEtRm+9O87vTkaPhcw46r9PonivPXNYDXW1RqmhGJ7oBAbtF3gNCh95oq
	 KLOZT1hHk2MCPmuwCrJgWdZIiBN4ls92a5NerD0xjFZU3HfRh5IIRgvciQQ8KvTepQq/I
	 iiJNJ9DO4lKlh+zKUN8SM47PThwx/nVKg5YLQ7R+5EuRo5ZA+mUSMnv6qdtDkMbOnxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E4Sm5f10Fkl6xg7E58h9CVeyk24eu4FH+mobroFwDnc=;
	b=L6nmrDcDtj7R3cq9BL4fLtfRskbZSj0QsSbw2mpl0weZV+kQ89Ayq8DUFQgg16YOvAGq
	 6/KPJTuZKSnkj8z1Lg9jibQ4z/6PV8iY/GfiBUSymwddDo6FfX+/54cU6/OVc+GatgF+F
	 EAPzesBXJu2DBhFnvX6+h0eSnoVmpuQyCd6QnqOEgKrY34ID4EQ3QNmrW6+uMwhDSPJdy
	 hcCFF9X8FiWyxFjxz7tWdotDE8QspQjHyONp62QY9nauNucdKOLrbkKTyDR91UmupqvRB
	 j9N5H5sPLQ50aKhpZbSpk3uCOZ6lYs16wNSRMz2poWLiR5ln7XTlpYDui5LMzDUntJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Psi/ntMg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E6E606A31C;
	Thu, 19 Nov 2026 01:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Psi/ntMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4B21F000C4;
	Thu, 19 Nov 2026 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051350;
	bh=E4Sm5f10Fkl6xg7E58h9CVeyk24eu4FH+mobroFwDnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Psi/ntMg7RSpMvxTRgqVXB9jpbHF0k0V+6oS3oQI/bG4PaSS+vgz1nKygSgYwLB/3
	 rAh6h1WEztm10us5HTYQojbELwnV4VuXMekWXB0b91ed4MiMRDfsV9cQDpmz/F4R9i
	 MTheVvlZJBfsP02SywmCIiVsWnurufMbA3oQyhF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0126/2214] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Wed, 18 Nov 2026 15:30:02 +0100
Message-ID: <20261118150015.270756135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67844abcff027..7eae750491192 100644
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



