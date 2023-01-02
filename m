Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B60328EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F0AC433EF;
	Mon,  2 Jan 2023 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658799;
	bh=SH2JM2HfsbN7V2AIGSsRJPfyb+iaTDTginw9Agsv6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6h4k4NvTP4nsd+wpqPlpMSi+4Eyi+EvRSzNGCpLyb11JQBtdSt+jK1hDhs5vIQw+
	 lhg8rsCQ58Qwwmp8kqmWPDffEjs+vPfmuE2gUD6pr7aHtDHnpoPZmwLL3i1A5W/U/L
	 nzBQS7r5ZLEMv9RNoqTde3j6s6L6G8jMd8YT0yhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 47/71] kmsan: include linux/vmalloc.h
Date: Mon,  2 Jan 2023 12:22:12 +0100
Message-Id: <20230102110553.466330745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit aaa746ad8b30f38ef89a301faf339ef1c19cf33a upstream.

This is needed for the vmap/vunmap declarations:

mm/kmsan/kmsan_test.c:316:9: error: implicit declaration of function 'vmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
               ^
mm/kmsan/kmsan_test.c:316:29: error: use of undeclared identifier 'VM_MAP'
        vbuf = vmap(pages, npages, VM_MAP, PAGE_KERNEL);
                                   ^
mm/kmsan/kmsan_test.c:322:3: error: implicit declaration of function 'vunmap' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
                vunmap(vbuf);
                ^

Link: https://lkml.kernel.org/r/20221215163046.4079767-1-arnd@kernel.org
Fixes: 8ed691b02ade ("kmsan: add tests for KMSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/kmsan_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index eb44ef3c5f29..088e21a48dc4 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/tracepoint.h>
+#include <linux/vmalloc.h>
 #include <trace/events/printk.h>
 
 static DEFINE_PER_CPU(int, per_cpu_var);
-- 
2.39.0



