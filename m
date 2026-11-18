Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026678;
	b=gD18YU2Wd9Aq13g0inyXL4114AC9nyaTl1sZpoKKFCBie0h85EbPBVrqMrRvpjdpYR/z
	 i3WTd+t+LyNNoysjJ9cQRU2gJ2q9W/k5dRZj37IGXmUYuOV4820qCY+nDs7KeTVMoJI1c
	 ofLjtTJ50zfUXSZ3OkFf/omFkCcrpJ02zv9qnIU2D1ydK2z150bJPvE97qDnKDSbGAEuR
	 EDBai0NM+Pt8nrNz3dma63bFReX8RHmJRVyu5h0I1X3MfyXwYI8eZwQUjLfwJEJWB/L3X
	 kzoy0pUFfv2bnyLxdTBN0DUipAdAZe9Gws7SfR5ThRVcIdw5QwpIZqK0FP+AV56BYtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JO30tWJYuyr2JYqSlb0MjKreTGdEYdmRf6IOhUOu3eQ=;
	b=003TW+a6aVHKMLdoWRW0tPbtYRb5mv59fv8MXH2pdP1FSYRBThD6rmSTENh+xR2o3WP1
	 /GPPAZLeW6pLEpg2ePtUnZwF2B6N4U3eo5KY1S60hUZVpOOw7Rj68PpFI58SRws24NB2o
	 v+cuJPRML7e9gR0EPE0m+l8QbCHCWTrFR4irMvcm1TKmlkglFjwbZ/Cqno8dGBU3OZQdo
	 rB2VxKN/emq8M4MWx7yYFstILfPgOAXUFX7puMChqbyYDGViDUONuOT1FpTp+2ZJYQk4z
	 8seEGlg7kSjGrBHOwl2kcOUuaD9NgHG6ZxfE45Vc29LLro3VZ+vHD0F3c8DlzenWmQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5NX99dv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E4606A320;
	Wed, 18 Nov 2026 18:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5NX99dv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C731F000C4;
	Wed, 18 Nov 2026 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026678;
	bh=JO30tWJYuyr2JYqSlb0MjKreTGdEYdmRf6IOhUOu3eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5NX99dv0h1esjYACaK5P6enELdeMYvNAI8eTmpnr/kpPk8h2O6cIaj5JDhGOlvC2
	 YWoKca3+ryqZLKQDveadYy0T0DTZMbIzG+FC58bwJCJHosu0yS3sycEl1On/KzwHi0
	 k8RdmYzIPWJVHNjbbmOqBXs92uYnqPA+buVIEMng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1521/2151] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 15:54:16 +0100
Message-ID: <20261118150217.247265112@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 74f79365839720bdb0c6bb4fe85c5b2a929ff5d1 ]

In __iommu_alloc_simple(), when IOMMU mapping creation fails, the error
path unconditionally called __free_from_pool() regardless of the
allocation path taken.

For the COHERENT case, memory is allocated via __alloc_simple_buffer(),
which does not use the atomic pool. Calling __free_from_pool() on such
memory silently returns without freeing, causing a page memory leak.

Fix this by matching the free function to the allocation path:
- COHERENT: use __dma_free_buffer(virt_to_page(addr), size)
- non-COHERENT: use __free_from_pool(addr, size)

Fixes: 565068221b905 ("ARM: 8561/4: dma-mapping: Fix the coherent case when iommu is used")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/dma-mapping.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 08641a936394c..00615a1528914 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1058,7 +1058,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
 	return addr;
 
 err_mapping:
-	__free_from_pool(addr, size);
+	if (coherent_flag == COHERENT)
+		__dma_free_buffer(virt_to_page(addr), size);
+	else
+		__free_from_pool(addr, size);
 	return NULL;
 }
 
-- 
2.53.0



