Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041608;
	b=cuJPjp7i5Z01rssgBsGn1Hd62IAb7tEluwBK7lRO6ntVGQ3P1MpZfDLby3Zq+Sresb1Y
	 5e2St0yUQiN+rC3IWgtrRZmoc/z0NT9PdxcAITnzx/dfjs7XSJytVgTiogIyQx2FUx7wL
	 7VwRE3MzedJPR+XVs1v1GihzGvdd76P/ZJbHLbSKmQHKnzSPR8nqEuFDn8pg3MCJiIv1g
	 //uWGp6weFS1hQEvvIjUCGMBb3y8cnowsD4ChCsd9lH4a1Rbs6lwVbWudt5Pmcv6vOr8X
	 l7BZT76l6efS2DTApcfOHUwGnly7TEGEK+9SuyY/trkGIZ+gV1NSzObogYqKc1amyaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Z5SUIZ1K9WjbJ8MQ+BSoKZqe9paTdzqcxhdGeKFGkI=;
	b=yq2dqGcwCRrMR+XxY52M2SD6Uyk3W0bSe2efar7Hz4KsvdeKD8gLXdXeIA3NqWSFjh4y
	 fu4OrD3Au2Z7oZf201A6QOxkP5wEOGLYI7Lo8Joycixf7PM+/r3GVWx3dhv/zF9Q0li17
	 swxWkNMhDjA8w7H3shQtPqJJNYkFCwnzOCQ5b9/IrmH1TpgJmhEcAl616NmGV/LwAzGGL
	 ytgTIKtuLX0nq+h9rl4WsmRcqQgXLD4WUgNURFle0Bnxa6EeDBhbQaG75zMbU2nZDri9V
	 MXaiIC3dezMqO6yYXlP8cDnmNSMO9fHH4KdxSWi7RrfeHxt/ObZgwWdhswIYqmHVEUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RI6vJ6++;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4181606A336;
	Wed, 18 Nov 2026 22:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RI6vJ6++
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429A11F000C4;
	Wed, 18 Nov 2026 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041607;
	bh=3Z5SUIZ1K9WjbJ8MQ+BSoKZqe9paTdzqcxhdGeKFGkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RI6vJ6++EjYb4SJNqUaNWfv8B57sD1BH6E3uNUDEUARy0+XIpWLUWZT6qrruJ8xk6
	 dduAYIq7KODKshRrNVAY6om+0fNB9WsHw7xJckv5iBoguDPpdwQWt7m0+OYJo+qY3d
	 UK3efbRTwQkNWSbbncyEBlxWVMbSCoBz8qnbyAYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2874/3318] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 15:58:16 +0100
Message-ID: <20261118150446.771259664@linuxfoundation.org>
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
index 5409225b4abc0..c225557b8c4ed 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1061,7 +1061,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
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



