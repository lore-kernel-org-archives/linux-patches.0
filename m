Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061819;
	b=CRAqyXM9VXcVFx5DXxZT5cQv8E8asMoHL/Z9NIlDrq6KA/3Sl5rRI/9yvBU+IVqRMXPy
	 /FxmZ0cfjNt/lQZ/qN/okKjoG82Wex2OEH0f1MxLzKlDQp4HmsPcqkLf/C31XfLfTHJCg
	 COlsMJ+HI4EDbay/rTttiZpnQoKQc8QP9Es1X22OSE3lc0/9JT28iEaEQAHRgjMoscVAc
	 nxP+tGTxU96ua6qa3/ywm8w21jGf7QVZR69VWVENwQWeV4xdhP2YPDLwANPyijz7ndf8j
	 kjIDVoYv8wim5IrK1CDsHYkMnfE+U+LZG5yBr7ekBNn9qJLpzilFuu8cjLKYkQRtHAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkEJnTso9gsB8Uqa5kQVrwKegB2/pWxTMBHrS9Lkfpk=;
	b=Q5t7An8NvO7jKTMqeDeDS5AbTRSiyWVDz6LucQ6G0xL0LdchEovpilzswcGf8zocSPMQ
	 lOf6ULoAc+GPydwkIDtZG3/jSZhWfyJSvzOcIjH2ybJ0AhTgnKun615JTxfpVzU6dMAUV
	 LbzcjPilnWiWbcuvLH325UotQNXPkl624vfdwuBKsYYW0yWSWGo06rX82AMV3VSa3RcFA
	 BEbmNU8lOB5gD1zlMhKSN3ofYE/JP/rNoV49RYa3iB3uI3xUorvDQgI5U57ZquNZPns24
	 ua1kgqaKjIH37E7o75f8i+3Ppui6Gd2pW4/J9TRm8eaz6P+IaMNp26kbqJeaIiaEcsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZcZ+4bs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF2606A325;
	Thu, 19 Nov 2026 04:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZcZ+4bs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992161F000C4;
	Thu, 19 Nov 2026 04:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061819;
	bh=LkEJnTso9gsB8Uqa5kQVrwKegB2/pWxTMBHrS9Lkfpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZcZ+4bsYtabsi5vtgnwYIA6Fny5qu4A+tTK/BKHvUh72HHF0QfWNemIfBFHfeEd4
	 n6udI0LH+M69ahZ3z90UR16PzYwLHhYGDhk5+lYj3EvcHOE+geJTCTYElEKR5zX3fO
	 o5uvmaFb2IwXfloVLlQipNt3fYxa3RGGEEhZW9t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1647/1848] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 16:01:25 +0100
Message-ID: <20261118150028.691015417@linuxfoundation.org>
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
index c4b8df2ad3285..d83fbfcd0fdfd 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1405,7 +1405,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
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



