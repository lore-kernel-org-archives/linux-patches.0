Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396D1269AFB;
	Tue,  8 Apr 2025 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115330; cv=none; b=F57fSXwLa/RHWxeGlBzvknW47PVXt+lp+1u//jpE6kAcCdNr5Gc/OG39RnCKQpcmjieGjMLxRlBe1KQpNsGX7YO9A8rBXTqI0gap7728K+rvHn+aLzJEzfKppg+Irqe5bDLzv3Si5sigGoUiVqkiUVRZfsNFDTenCdftJhuH0Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115330; c=relaxed/simple;
	bh=hBkJdVMGwJJZJzl2eSD+KHygyoUyuX5rFEZ5ibNTBMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoN8XU4W64xAKfzXqbMTfBpGQX0040WuZafJBuArbLa77MkTYqYS0sObiL7gQHDeo3qeKu1xEtmImo6/ellLxilC/GUWrdDnBug3K7KgcXHg3xRblMXtLr/abVNWTxMqTl3y/pXv7aO61dX6g5b3WkH414fkkjeZMauMLN24ay4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsiTE8Ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsiTE8Ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABB2C4CEE5;
	Tue,  8 Apr 2025 12:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115330;
	bh=hBkJdVMGwJJZJzl2eSD+KHygyoUyuX5rFEZ5ibNTBMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsiTE8RakLOgogbb13V4tey5l6ixYeJAye9syR2MlIEPR49DiWMq8H9wBFI/YT/Yc
	 MCSBBpEf7yF7EsKMFGiTZhjaByKe8wF5qJDE02a4DVRcrKmcOFHj/9JYbKzzO8+ZRx
	 wgcVqP+4GY4ZbapIBmlEZObFszOsFny9qmPCLQYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 435/499] LoongArch: Increase ARCH_DMA_MINALIGN up to 16
Date: Tue,  8 Apr 2025 12:50:47 +0200
Message-ID: <20250408104902.078755845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4103cfe9dcb88010ae4911d3ff417457d1b6a720 upstream.

ARCH_DMA_MINALIGN is 1 by default, but some LoongArch-specific devices
(such as APBDMA) require 16 bytes alignment. When the data buffer length
is too small, the hardware may make an error writing cacheline. Thus, it
is dangerous to allocate a small memory buffer for DMA. It's always safe
to define ARCH_DMA_MINALIGN as L1_CACHE_BYTES but unnecessary (kmalloc()
need small memory objects). Therefore, just increase it to 16.

Cc: stable@vger.kernel.org
Tested-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/include/asm/cache.h
+++ b/arch/loongarch/include/asm/cache.h
@@ -8,6 +8,8 @@
 #define L1_CACHE_SHIFT		CONFIG_L1_CACHE_SHIFT
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define ARCH_DMA_MINALIGN	(16)
+
 #define __read_mostly __section(".data..read_mostly")
 
 #endif /* _ASM_CACHE_H */


