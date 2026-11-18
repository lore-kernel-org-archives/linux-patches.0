Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023653;
	b=3d/EC3UFGvYY63EhTEL7p7TP3MU+jJCyHvS+BZNYNhs/DxELxlnf5q9HWJaPhX8awDx1
	 qayWg1/5dD2L/aLAMeTwNkbrAhDVqVxduvRum+lusLkVVA/5Ns8aTrsZ+gVgTm8fAi9/e
	 1xeV/+MgieYWhhRR1GwBXIBl6uCD7EkPUYNS9Mbz12CS3htyLTayk/uuEoiUMv5IGB/fI
	 CY7IQBbRciWFVp60657I02U6D8HBbV05ijPuFM7LhIwcWmgXkCpNQRjzZT2sZenq3DEDk
	 xq4JAbRJlzIXXCYs2Iyi1Q2koZwByDdA5CNkJEfr83MM5vIgGpVQ9jxdyMmi/ouLC0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWJJfas5FkHkZ56T5AM9h2OyJO1JE2ZHjKlpAEqLl+4=;
	b=dBDT+Xnbpk5+zCN1FND2WeWAcsLh/gH8kUXLy2WUrmyYC0gWWGMGiRUu6PUtbESFqP/p
	 sMq6NxdsG9uwNY8kVo94c5eG2XJ3GJll25rZHhi1Zkf2dv0xaDPtXE3hoHiVlyLzTNJ7I
	 Tho4AiUsE5nG1+VjmyDduuDHTrlJgQ3XgLIFU/Rm6f92FxYdpjo0g8hXplq9SWXbG7oX2
	 t+KrzjKobNKeswLM2r+tu66I6Xxcu7Mqelzdl0Gs+GxMfkAaAuQtDZ1dSiEQtnBQXNIrH
	 JQueo8vUckZotT6su4MdFAfZMsM20zvD+fXF1BltJwm1ur0xxOncIh2wBWYOKcnls+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhuK5cRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDF3606A31C;
	Wed, 18 Nov 2026 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhuK5cRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280791F000C4;
	Wed, 18 Nov 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023653;
	bh=qWJJfas5FkHkZ56T5AM9h2OyJO1JE2ZHjKlpAEqLl+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhuK5cRFjk8tb5PrSFmntUajLe95Ob9hh5nTx0bVmTFGd+W3P8Sz6fElNNgza4rJD
	 1GNLVJMA0weoN3ZRWrDaKPF6VSFAtALSWFkiEWQb4hfUyhPPvwRVE7jvK52i3isVDK
	 dto7Ix5+hydbtK1y6c95eROs1hvpC1ov/76pTRaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0446/2151] memblock: reject non-page-aligned reserve_mem regions
Date: Wed, 18 Nov 2026 15:36:21 +0100
Message-ID: <20261118150138.281980165@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 5728d3523f12826a2b180c1c5738f74e33197e14 ]

When map->start or map->size is not page aligned,
reserved_mem_preserve() does not preserve the last one or two pages of
the region from map->start to map->start + map->size.

After kexec the new kernel reserves only the preserved pages, so those
pages are released to the buddy allocator. But
reserve_mem_find_by_name() still returns the whole region including
them, so they can be allocated while the subsystem is still using them.

So reject a reserve_mem= size or alignment that is not a multiple of
PAGE_SIZE to keep both map->start and map->size page aligned.

Fixes: 8375b76517cb ("kho: replace kho_preserve_phys() with kho_preserve_pages()")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Link: https://patch.msgid.link/20260905141526.1546478-1-ekffu200098@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 mm/memblock.c                                   | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e9ffe9c877b1a..1746b47d45368 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6473,6 +6473,9 @@ Kernel parameters
 
 			reserve_mem=12M:4096:oops ramoops.mem_name=oops
 
+			Both the size and the alignment must be multiples of
+			the page size.
+
 	reservetop=	[X86-32,EARLY]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
diff --git a/mm/memblock.c b/mm/memblock.c
index e2f15bbc274b5..c0612f48b2e91 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2655,12 +2655,17 @@ static int __init reserve_mem(char *p)
 	if (*p != ':')
 		return -EINVAL;
 
+	if (!IS_ALIGNED(size, PAGE_SIZE) || !IS_ALIGNED(align, PAGE_SIZE)) {
+		pr_err("reserve_mem: size and align must be multiples of the page size\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
 	 * but it is OK for this command to have it.
 	 */
-	if (align < SMP_CACHE_BYTES)
-		align = SMP_CACHE_BYTES;
+	if (!align)
+		align = PAGE_SIZE;
 
 	name = p + 1;
 	len = strlen(name);
-- 
2.53.0



