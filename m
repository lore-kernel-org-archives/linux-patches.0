Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016270;
	b=W8STiKfNiy+OTgtjm34SSGAYTAgGzC13MyiHMoNR65r6W6tuYEhB9xhdh9uSX52G31ta
	 o08aKgzU+bPXUyPZo2eeN3no+FbKbJv8Z1EijcFXbHwWTrmJK5dLKrp48xwyjB+jkhl2F
	 L54RlTAdSou1dBCsBDOchHKJ+chAv5zBJKz0b9JIWB0SDZLLSIU626ZFQPyM95ABMwxJm
	 vNzJDRU9C1Vd+mBNEnl59tXmp2nnHmjcGzVjOxKZCkUnaeMORF8g9UtP7CpHQlepa2DZ9
	 /VYQ/Uw3IF7jjNMKr31GW4gvh3ZU+kz5hxkjEcn12NNxCKtCR8Q92A+j6D8ATyWv9ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYEg/J9WbFepC0JetY7hMP7j1NnGtjujrWP4YDd73xM=;
	b=g0KxWCaqkQwhpJR8vVBLCQk2fBITem2fKpGtc4X8EzOmir/XiF+vClDppes8rXVz0K9I
	 ucBDXF/XNJ/9Vczty2tbIi5an4wFCAlrtj+4ErVLunZHDa0NRhn+e31U99UUB1ICAwtJU
	 rC73l/jukLjyIp5ln/9hg/dbgCV7Md8VnWk4jQH2oFyO3CtkbSE7h+3o/4UxCzp13BXrd
	 xy/QT7LnJvpaJRkzEJAn+5Ne/W/OZY4/mI8btz8ChUlz1+iwEtF+0ibK1M3Vg79aS++ZB
	 TH4LkHLDnRiP1Rxmolo8oDik41XXBPmwknxZ9SxPSlG20PQKkLjvuGCeHJDzHwhJTlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trNxvGmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491B260A261C;
	Wed, 18 Nov 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trNxvGmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEB51F000C6;
	Wed, 18 Nov 2026 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016270;
	bh=AYEg/J9WbFepC0JetY7hMP7j1NnGtjujrWP4YDd73xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trNxvGmNzIjPnihdD0VG34GAqeejAIFuLZNvu9QNgixDonHDK+NsujUJL+Mi79D0a
	 7U63YGRDcNsncHSPhVRiQqD8taKN3tfEtTunaBA7cKDbeCrI0H+RGmvpUtNBj+UCIh
	 9PXh852la6OboB+zohFqh6kGLUFGJ4A8JF2gcKJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0467/2651] memblock: reject non-page-aligned reserve_mem regions
Date: Wed, 18 Nov 2026 15:28:27 +0100
Message-ID: <20261118150304.608500782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3c2523dd6a8d7..b92d84e33b551 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6615,6 +6615,9 @@ Kernel parameters
 
 			reserve_mem=12M:4096:oops ramoops.mem_name=oops
 
+			Both the size and the alignment must be multiples of
+			the page size.
+
 	reservetop=	[X86-32,EARLY]
 			Format: nn[KMG]
 			Reserves a hole at the top of the kernel virtual
diff --git a/mm/memblock.c b/mm/memblock.c
index e6fdf95a0534d..37e6abfcf4e30 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2828,12 +2828,17 @@ static int __init reserve_mem(char *p)
 	if (*p != ':')
 		goto err_param;
 
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



