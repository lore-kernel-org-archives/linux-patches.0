Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C55BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EAFC4339B;
	Tue,  7 Mar 2023 17:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211484;
	bh=B9SXSPHOZ8dmNNiuXWw1/8WcmeIEgRI7oLH4wukwo9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeONtwLpQDrMeg4ZG8cTbMFnx+tXLsfpXTFwmC+7/Z0SC4FxV1dGKePCwrvZCjJD2
	 zV5XqDaqpSwIeKrOm8IUvnu42LBbjyb99uI6e0M7/cPNuqAc9y/RfxZzbJXfnyJzUo
	 ifSq7kpjTFDaaKPWsRoTlZHIfQaRJJyhG+6BENvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0877/1001] selftests: dmabuf-heaps: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:00:49 +0100
Message-Id: <20230307170059.963859139@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit f80f09b59fdd45753dd80ac623981ad00ece4c2d upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>  # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/dmabuf-heaps/Makefile      |    2 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/dmabuf-heaps/Makefile
+++ b/tools/testing/selftests/dmabuf-heaps/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -static -O3 -Wl,-no-as-needed -Wall
+CFLAGS += -static -O3 -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS = dmabuf-heap
 
--- a/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
+++ b/tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c
@@ -13,10 +13,9 @@
 #include <sys/types.h>
 
 #include <linux/dma-buf.h>
+#include <linux/dma-heap.h>
 #include <drm/drm.h>
 
-#include "../../../../include/uapi/linux/dma-heap.h"
-
 #define DEVPATH "/dev/dma_heap"
 
 static int check_vgem(int fd)


