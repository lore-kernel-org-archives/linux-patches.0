Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060787;
	b=F4OSjOlko+i72AWAITAa80J0ZRKAgeuen2cJbZUlXbxvJJbRBe9oYRLRtI5su2sHKSbc
	 dpHlzmUcdtO8l8LwLO5aRtmk6OSaPj7VVk0Rqls4fV7nTiwXmE77j2nQMUhHpRfST1eGP
	 CQzaFH3kuYyc3jmlsTHDpFqCGEc4ctndCZa7TrlnHwCpUS8MW8Rx7FOI4vqyNQg79an2e
	 4bfY3n3FEeY8iftQFtJcPYnQDQrFZLX1nkyP5kJZF2OJiWS6k34rOnOxvRESs6/17XEYk
	 kun29fTTqs4h7FEKnIdTz01XboPBTK7Q2PJWtxaiSQ/HWmoMre0agZZGGuGE6+jyLyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QAVOY4mPhJR1mbC0o8Ln4+T6LYUMg/y4zTwNhKcLEHQ=;
	b=qwi+AxnM+VwOH/8rTFE3k7+J03KK/T1BS/lCfiuuxJl2fOaF537kB5xAsPBCMwgVaHYQ
	 5RQMe9YLbrbyXtp8sgJskr0jB+TXce89PwkLchRO7vKEbcCpEL6y9eloU9XsRI+fsvJa/
	 vBW9deg3FVsMv+5eXqrwiJLoABCv3eXfU2yzywQlNB5EiRAHFVjGkxhE73oL29daLbr+g
	 re7U0WVpyOort9oHNxd92aW2vc7pYS47lUHclHGDB4FtEOXL+q6xmrRdn3fZ/QmqG9GcO
	 mhnm9/L2Z24Epy1Qkw3RI73yfCw+9XR54dAl436d6euIEVhD8UlagXBccfoRPtPdyFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i9/fdxKe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3137606A326;
	Sat,  7 Nov 2026 14:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9/fdxKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD141F0089F;
	Sat,  7 Nov 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060787;
	bh=QAVOY4mPhJR1mbC0o8Ln4+T6LYUMg/y4zTwNhKcLEHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9/fdxKeIc6HqZsSAe7e1DOMVc/K5g1408QefzZKQGk5B6BCmMXfxywJrJMeDyvlG
	 REJN1mfcB2h1A/4G1xrimW/BkRBc51ynWbwIFil1du+2ei4aCI4fIsnixVMMVBjMcc
	 IUHwXwhSvdX9EGLaO3PVcBIf3FsrTz2kP75ajC/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0192/1536] iommu/qcom: Publish pgtbl_ops before releasing init_mutex
Date: Sat,  7 Nov 2026 08:36:48 -0500
Message-ID: <20261107135003.055034083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index fff2771958363..3c1d2303f1b8e 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -308,13 +308,12 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
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



