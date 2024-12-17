Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20D51F758F;
	Tue, 17 Dec 2024 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455664; cv=none; b=HM3sZq8Q+vTvesENiAUE9G2mwRzYcmUlxT3FYabAHRJVU0ZubL6OfYiyZg8xoNTA8vqdoxJbQq/IVhSZjG4/7U+n3ztKI19vhQE4ns+Ptqu5md3YH+iKnIKjXXyMKkQh6zvcV0LaQFym2+noYn3vgZGMcrEA4SZCuTK+n+9KlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455664; c=relaxed/simple;
	bh=/Qv02c7o02ijGudfL8p0i2GrWzwcBJDR5Jjgoh5Zoec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9yn5pfkUKORVQOi/+3gGFWWKAmsV6Z7IX/0kqo3upSOZ3XxQPJb4eqLRUus+IWZQXkc+GeucB8t5N61TuN1ztjb8UsSmEnzGyYBzpaK04xBXuf2/dGc14cNb5CIQwv7Lt2Lqe2NFSywDeowls905r1m/+bc3TI9H3TJeR/INgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7F3YWa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7F3YWa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CDDC4CEDD;
	Tue, 17 Dec 2024 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455664;
	bh=/Qv02c7o02ijGudfL8p0i2GrWzwcBJDR5Jjgoh5Zoec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7F3YWa0afKsDaiTWrfc5ufuwWV7xLY5o+kumxhnQyx2Cnb3rd8hOjIz5scZGZNcC
	 Y7sjnfD3JmCVMrDbBamOySPdovztcjTXzFrnaDFS/XaNCVtTJjJZ6124F/C9LFpEIF
	 1QKVJCSkACweO7XHB58zQAV0doRp4C7Bowx0uL30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Mingli Yu <mingli.yu@windriver.com>
Subject: [PATCH 5.15 42/51] Revert "parisc: fix a possible DMA corruption"
Date: Tue, 17 Dec 2024 18:07:35 +0100
Message-ID: <20241217170522.202198961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit dadac97f066a67334268132c1e2d0fd599fbcbec which is
commit 7ae04ba36b381bffe2471eff3a93edced843240f upstream.

It is reported to cause build failures.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/436a575b-4ec0-43a2-b4e9-7eb00d9bbbeb@roeck-us.net
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Mingli Yu <mingli.yu@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig             |    1 -
 arch/parisc/include/asm/cache.h |   11 +----------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -15,7 +15,6 @@ config PARISC
 	select ARCH_SPLIT_ARG64 if !64BIT
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
-	select ARCH_HAS_CACHE_LINE_SIZE
 	select DMA_OPS
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -20,16 +20,7 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#ifdef CONFIG_PA20
-#define ARCH_DMA_MINALIGN	128
-#else
-#define ARCH_DMA_MINALIGN	32
-#endif
-#define ARCH_KMALLOC_MINALIGN	16	/* ldcw requires 16-byte alignment */
-
-#define arch_slab_minalign()	((unsigned)dcache_stride)
-#define cache_line_size()	dcache_stride
-#define dma_get_cache_alignment cache_line_size
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 
 #define __read_mostly __section(".data..read_mostly")
 


