Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A83B23742
	for <patches@lists.linux.dev>; Mon, 13 Nov 2023 19:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0Zk71Af4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vAhtZGcq"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE5771F86B;
	Mon, 13 Nov 2023 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1699902851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpvt5s4LImzllAEMKC9yyjTODPwLX4+6Y45s6lDAdck=;
	b=0Zk71Af4/ksZViufYFLz4W466HBY9hZ6yjSoaHX3v3J6SOrEeTFMUha4Tk6TWp6ktjmlTY
	tyWmx5ZTjAXIQL0It+uib+nO4jvjmUvBVn98fw84px5FDHOZc3q/N2qZVErz8XjjyZ8Rv3
	nya3pgfa+YY7tev+CjDyBZ95Zxr+uDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1699902851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpvt5s4LImzllAEMKC9yyjTODPwLX4+6Y45s6lDAdck=;
	b=vAhtZGcql9qIWxRJqKiLelqePVQm52ugRXQ7AXX20vnAKjBALODitlzRltKZ2qlT1HLVp2
	tD2r1WHZoMl+fJAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6270F13907;
	Mon, 13 Nov 2023 19:14:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id +BNfF4N1UmVFOgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 13 Nov 2023 19:14:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kees Cook <keescook@chromium.org>,
	kasan-dev@googlegroups.com,
	cgroups@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 07/20] mm/mempool/dmapool: remove CONFIG_DEBUG_SLAB ifdefs
Date: Mon, 13 Nov 2023 20:13:48 +0100
Message-ID: <20231113191340.17482-29-vbabka@suse.cz>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231113191340.17482-22-vbabka@suse.cz>
References: <20231113191340.17482-22-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_DEBUG_SLAB is going away with CONFIG_SLAB, so remove dead ifdefs
in mempool and dmapool code.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/dmapool.c | 2 +-
 mm/mempool.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index a151a21e571b..f0bfc6c490f4 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -36,7 +36,7 @@
 #include <linux/types.h>
 #include <linux/wait.h>
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
+#ifdef CONFIG_SLUB_DEBUG_ON
 #define DMAPOOL_DEBUG 1
 #endif
 
diff --git a/mm/mempool.c b/mm/mempool.c
index 734bcf5afbb7..62dcbeb4c2a9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -20,7 +20,7 @@
 #include <linux/writeback.h>
 #include "slab.h"
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
+#ifdef CONFIG_SLUB_DEBUG_ON
 static void poison_error(mempool_t *pool, void *element, size_t size,
 			 size_t byte)
 {
@@ -95,14 +95,14 @@ static void poison_element(mempool_t *pool, void *element)
 		kunmap_atomic(addr);
 	}
 }
-#else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
+#else /* CONFIG_SLUB_DEBUG_ON */
 static inline void check_element(mempool_t *pool, void *element)
 {
 }
 static inline void poison_element(mempool_t *pool, void *element)
 {
 }
-#endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
+#endif /*CONFIG_SLUB_DEBUG_ON */
 
 static __always_inline void kasan_poison_element(mempool_t *pool, void *element)
 {
-- 
2.42.1

