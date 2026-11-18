Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019282;
	b=Xpa+OXt1Frtj6R6MLZEmf8NSDmOg/uPgiAZhT6GKeQ5F/BhbgrbYbWSLXSfdMDMDIpt6
	 0XQC0JTh6Docx+zaJuAMgfSmqQSTTfBmF1gd2GFq16p3Yawz7nEb8qC19c3vJfiu8fSgZ
	 4cT4+tTicOB4O7v3xb7YIVMXEtZ7XsxLpbi8q6p60Jod5sFxdaTaezXdIiW/H27zptsSY
	 i+9rwrbp7kkGSa6LHlyJYQ9+Bsnjfu8vbT8GpJQLUeAvcF8XbZHtxdT45otqqAV8sta1c
	 6UWI7cwCBwRsmebULe9CuW8EjeId2jfCV6FLaL307mR2hpVXmVZ4g121Lth8uoCMHNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FAzBKWkESUsH8cNV1vVGIQW9DIg3FwjQOsU5xALSb30=;
	b=J8M+XJsZRXnbVttH9WZXfzR02D5Il3YDgE3YkR+8afYxPhoaWZ7NFUroFE+hdb+PG5vm
	 PImKE7Ov2CUpVa/GOMjznPUbYHTuEj4q/ppOBWjkwyinC4sIo3EdTTsEN+rZi2nT5sN1d
	 Ks4SoJn1bOnoGBS1BarzJYpg4SvuBmuVibPENSX2zLTq5U/UBA7sPmaPgUrS8mYjgZHZ4
	 9JcJfVm5+7Alu+hoz2e34LRQ4TDpZzWZGV4pS37dM0ibe6KGxdKAtu+8V6Tn3XqG3R3q6
	 ukjh5qTpiYHDQ2oz1W7dsczFu7dFhfb757uLaTcUorE2j3zfiidvUv0XRZIDawXiDsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGapvQ1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1C1606A332;
	Wed, 18 Nov 2026 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGapvQ1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8C71F000C4;
	Wed, 18 Nov 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019282;
	bh=FAzBKWkESUsH8cNV1vVGIQW9DIg3FwjQOsU5xALSb30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGapvQ1bWlGPXffNFTCwrNXY7ttgrx48iJS+9M+ZwlV/wCBz5ccA5jkehGn7T+CJH
	 re2AgIwx7koifeLyfFOXtO+EekfIXDN3FSkYsiDQT08H+CcYYk4BWn697N8GEany9T
	 1AQ4CK4qtgX6a4lWxRCAyjRAaNztUCWGNa2Yf0ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1541/2651] lib: fix lock initialization in region allocation benchmark
Date: Wed, 18 Nov 2026 15:46:21 +0100
Message-ID: <20261118150343.448402553@linuxfoundation.org>
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

From: Yury Norov <ynorov@nvidia.com>

[ Upstream commit 718de76e2d3dc38a30026f23909842ad26010b6e ]

The Maple Tree benchmark uses MTREE_INIT() for a stack-allocated tree.
Its static spinlock initializer leaves lockdep to use the lock address as
the class key.  Since the address is on the stack, the first allocation
triggers "INFO: trying to register non-static key" and disables lockdep.

The IDA benchmark has the same problem through IDA_INIT(), but runs after
Maple Tree and therefore encounters an already disabled lockdep.

Use mt_init_flags() and ida_init() to initialize the locks with persistent
lock-class keys.  Keep initialization outside the timed allocation paths.

Link: https://lore.kernel.org/20260911155244.1406122-1-ynorov@nvidia.com
Fixes: f4806cc63cc6 ("lib: test bitmap vs IDA vs Maple Tree performance for region allocations")
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com
Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/region_alloc_benchmark.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
index e88b4cf55c629..a644f3d5431a0 100644
--- a/lib/region_alloc_benchmark.c
+++ b/lib/region_alloc_benchmark.c
@@ -78,11 +78,13 @@ static size_t __init ida_size(unsigned long nr_ids)
 
 static unsigned long __init benchmark_ida(unsigned long cap)
 {
-	struct ida ida = IDA_INIT(ida);
+	struct ida ida;
 	unsigned long cnt, idx, off, nr_ids = 0;
 	ktime_t alloc_time, free_time;
 	int id = -ENOSPC;
 
+	ida_init(&ida);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		for (off = 0; off < reg_sz[cnt]; off++) {
@@ -125,12 +127,14 @@ static unsigned long __init benchmark_ida(unsigned long cap)
 
 static unsigned long __init benchmark_maple_tree(unsigned long cap)
 {
-	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
+	struct maple_tree mt;
 	unsigned long cnt, idx;
 	ktime_t alloc_time, free_time;
 	size_t sz;
 	int ret;
 
+	mt_init_flags(&mt, MT_FLAGS_ALLOC_RANGE);
+
 	alloc_time = ktime_get();
 	for (cnt = 0; cnt <= cap; cnt++) {
 		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
-- 
2.53.0



