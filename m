Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C147C
	for <patches@lists.linux.dev>; Mon, 28 Feb 2022 15:10:03 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 132so11705170pga.5
        for <patches@lists.linux.dev>; Mon, 28 Feb 2022 07:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=/IzYX9ekXXf7onTNDRhy0rzD0OI0XgiFY+K3R+MvA9A=;
        b=ZGIn/OXsY7QB0Sykq85jAfBBii7x+DAFUHBo7NHAudLxTsc/Unb8bKEFWoqST8WBpW
         bw94JTVLzK0mn8ztcZhov9MXKHyGOOwbI70uHhcBZOtpoU5oafVBEP+KOeLCU0ev9dGu
         QcEZM2EuIVFq9qVSGgzdj9jnqTBiv2dVZqWPReaWwHdGy1gdqmDn7oMTQOTUBYMrm4kH
         7eRTEmq2C6bq8/xae6yoaqQa45g73ts/DgJrKuxRIfD66i1hf1Xxzat3o81X9wY3erRa
         4cvJvMcJZLXK+ITjHuzNkMEZ9UtcL1Vq1LUMOxaiL6dvIxfvD0rgcprLUrOA57gpF60H
         /Xnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=/IzYX9ekXXf7onTNDRhy0rzD0OI0XgiFY+K3R+MvA9A=;
        b=epa8KD/MuPmkfMaWoYCoW7K2TIHNOMKlZ/DajdB0UhxQNe7eJR+nzsn/YRX1WJBYzU
         qKlJKUGXNeYhVyQrjleehHNv935AiYCMP2lUfZ/BM9SDLnyUkc//LRl91A3Tzo3BPouX
         b2UQsZA/Muc07JeK7GEYXCSpz1WefIUUSU/zYh8AEwouk0uyAYBUiyufsK7FIfI00Khy
         HMxsZ/JCBWlP5BpP80/seBy26fbtI/kkShT1IHb/ncXf27qNrVJQ+ntYvx55zzJlH43P
         YsHDExltoI0NX/HjpUvJ3XyLOmG0pYUccoJKfTefL4OsyEK/tqgG39LeXz+Xoh4X1SHl
         fH3w==
X-Gm-Message-State: AOAM531l8JcODj+3fgb/tJ/0WEi1+INTO5xuiekHv33UaCMxiiZ1bCV3
	0rKxzvfZlGE1F6vsTXGgjKs=
X-Google-Smtp-Source: ABdhPJwOXeWsUUvwtVxFSOTG/liBvry3WbgiNRSaXCk4O/6AoD9vAhicr3tugHtb0p7pOx8qnDjRWQ==
X-Received: by 2002:a63:d904:0:b0:372:9faf:5467 with SMTP id r4-20020a63d904000000b003729faf5467mr17491373pgg.196.1646061002852;
        Mon, 28 Feb 2022 07:10:02 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id q8-20020a056a00088800b004bca31c8e56sm14786206pfj.115.2022.02.28.07.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 07:10:02 -0800 (PST)
Date: Mon, 28 Feb 2022 15:09:55 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Yury Norov <yury.norov@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Matteo Croce <mcroce@microsoft.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Zqiang <qiang.zhang@windriver.com>
Subject: [PATCH] mm/slub: initialize stack depot in boot process
Message-ID: <Yhzlw0GGBeuCALJp@ip-172-31-19-208.ap-northeast-1.compute.internal>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOOhuoU7T4UqHbzkRAvM+b-gvt+Qtx41va=9ixGgUSWaQ@mail.gmail.com>

commit ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in
objects") initializes stack depot while creating cache if SLAB_STORE_USER
flag is set.

This can make kernel crash because a cache can be created in various
contexts. For example if user sets slub_debug=U, kernel crashes
because create_boot_cache() calls stack_depot_init(), which tries to
allocate hash table using memblock_alloc() if slab is not available.
But memblock is also not available at that time.

This patch solves the problem by initializing stack depot early
in boot process if SLAB_STORE_USER debug flag is set globally
or the flag is set to at least one cache.

[ elver@google.com: initialize stack depot depending on slub_debug
  parameter instead of allowing stack_depot_init() can be called
  in kmem_cache_init() for simplicity. ]

Link: https://lkml.org/lkml/2022/2/28/238
Fixes: ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in objects")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 include/linux/slab.h |  1 +
 init/main.c          |  1 +
 mm/slab.c            |  4 ++++
 mm/slob.c            |  4 ++++
 mm/slub.c            | 28 +++++++++++++++++++++++++---
 5 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 37bde99b74af..023f3f71ae35 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -139,6 +139,7 @@ struct mem_cgroup;
 /*
  * struct kmem_cache related prototypes
  */
+void __init kmem_cache_init_early(void);
 void __init kmem_cache_init(void);
 bool slab_is_available(void);
 
diff --git a/init/main.c b/init/main.c
index 65fa2e41a9c0..4fdb7975a085 100644
--- a/init/main.c
+++ b/init/main.c
@@ -835,6 +835,7 @@ static void __init mm_init(void)
 	kfence_alloc_pool();
 	report_meminit();
 	stack_depot_early_init();
+	kmem_cache_init_early();
 	mem_init();
 	mem_init_print_info();
 	kmem_cache_init();
diff --git a/mm/slab.c b/mm/slab.c
index ddf5737c63d9..80a6d01aab06 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1196,6 +1196,10 @@ static void __init set_up_node(struct kmem_cache *cachep, int index)
 	}
 }
 
+void __init kmem_cache_init_early(void)
+{
+}
+
 /*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
diff --git a/mm/slob.c b/mm/slob.c
index 60c5842215f1..00e323af8be4 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -715,6 +715,10 @@ struct kmem_cache kmem_cache_boot = {
 	.align = ARCH_KMALLOC_MINALIGN,
 };
 
+void __init kmem_cache_init_early(void)
+{
+}
+
 void __init kmem_cache_init(void)
 {
 	kmem_cache = &kmem_cache_boot;
diff --git a/mm/slub.c b/mm/slub.c
index a74afe59a403..40bcd18143b6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4221,9 +4221,6 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 	s->remote_node_defrag_ratio = 1000;
 #endif
 
-	if (s->flags & SLAB_STORE_USER && IS_ENABLED(CONFIG_STACKDEPOT))
-		stack_depot_init();
-
 	/* Initialize the pre-computed randomized freelist if slab is up */
 	if (slab_state >= UP) {
 		if (init_cache_random_seq(s))
@@ -4810,6 +4807,31 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 	return s;
 }
 
+/* Initialize stack depot if needed */
+void __init kmem_cache_init_early(void)
+{
+#ifdef CONFIG_STACKDEPOT
+	slab_flags_t block_flags;
+	char *next_block;
+	char *slab_list;
+
+	if (slub_debug & SLAB_STORE_USER)
+		goto init_stack_depot;
+
+	next_block = slub_debug_string;
+	while (next_block) {
+		next_block = parse_slub_debug_flags(next_block, &block_flags, &slab_list, false);
+		if (block_flags & SLAB_STORE_USER)
+			goto init_stack_depot;
+	}
+
+	return;
+
+init_stack_depot:
+	stack_depot_init();
+#endif
+}
+
 void __init kmem_cache_init(void)
 {
 	static __initdata struct kmem_cache boot_kmem_cache,
-- 
2.33.1
