Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3C617E
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 08:52:05 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id z15so13583918pfe.7
        for <patches@lists.linux.dev>; Tue, 01 Mar 2022 00:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=X+CELJ7rEgmBMwuKX3QnxNunnNgyBQv4GScNFZ71SB0=;
        b=KwqZjC+TAY7yWZaiJPe0/5cQbVUsJm4BVqQGXKKDx26ptfR4w5H4zNTfiTpyaFtkmB
         +W5TytA2dylB07CeWLQuxbQWEPAGeLV89hEFLJ/MIamYquQ8KQO4III05jixVjhu545v
         jkL0Ua1N11cP7USZt+IU/3AjYRNKUmNtbl/8jCbTTRQ3nMDP2CYgbaPTxfhBQMLb94UT
         nfFyYee1BRqI/zDHFOrMZFP2d2oWxLhg89c0MP7tioNASOMIcpkiz9W298B0bRLKcr+W
         SoHvrpjQuJshP4oRvo0+79s/eau8VJxniJaG8VdfzBRaCXgiCC1BSS7pQZShTczThqVD
         lGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=X+CELJ7rEgmBMwuKX3QnxNunnNgyBQv4GScNFZ71SB0=;
        b=vcUfK5MEsNRaqP0PnsmLpdP0BNJJ6+4+pxCpy9FFFxlvE5JjTmTsIy/+O8d14LLQUE
         EqJ9n3weFUY2JSQzwlvslbEUGHwT2DYiQfrZEFQAl2X+O/toEyHcnLROSIUMt+IJkCdQ
         k12LA/2Rs9Gww47R5w7fStDGGdor6sfwARd1dXK2nvniHdN7UZ6aQYzvuc1lvlJ0QF8l
         9afyFjnXVusVGeeLwdqHSUZ7pGCAWeWrbua635nLcy4Anzd5ZmRHnmKeoqaOXZ+g7MZR
         pzzUATuA42FJpb6xkrubrtZI2dSLPmN/vXrDUdF0tZmCXCk6W3STyQxUPtKg0UkJKzMR
         VrYw==
X-Gm-Message-State: AOAM530fAn6QWjf7M/naCI6gM9HPHYDiINHl2Y6yQTad5ybG1UoWOclA
	kqzoRZEzzd4k4yHmxT0+HC0=
X-Google-Smtp-Source: ABdhPJz+fO4CUS/yMIGn/QrRS/NMKXCeSG9j218AJLbx2wIEG3bt8mJAh6hrbPF00rlmtIW3daVe0g==
X-Received: by 2002:a62:7e06:0:b0:4e0:f0f8:9b86 with SMTP id z6-20020a627e06000000b004e0f0f89b86mr26732203pfc.26.1646124724549;
        Tue, 01 Mar 2022 00:52:04 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id o3-20020a056a0015c300b004e17afd9af9sm16979963pfu.92.2022.03.01.00.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 00:52:04 -0800 (PST)
Date: Tue, 1 Mar 2022 08:51:56 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, kbuild-all@lists.01.org,
	David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Oliver Glitta <glittao@gmail.com>,
	Faiyaz Mohammed <faiyazm@codeaurora.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Yury Norov <yury.norov@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Matteo Croce <mcroce@microsoft.com>, Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Zqiang <qiang.zhang@windriver.com>
Subject: [PATCH v3] mm/slub: initialize stack depot in boot process
Message-ID: <Yh3erDM9anwFXkD8@ip-172-31-19-208.ap-northeast-1.compute.internal>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203011512.U0o5cAx4-lkp@intel.com>

commit ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in
objects") initializes stack depot in cache creation if SLAB_STORE_USER
flag is set.

This can make kernel crash because a cache can be crashed in various
contexts. For example if user sets slub_debug=U, kernel crashes
because create_boot_cache() calls stack_depot_init(), which tries to
allocate hash table using memblock_alloc() if slab is not available.
But memblock is also not available at that time.

This patch solves the problem by initializing stack depot early
in boot process if SLAB_STORE_USER debug flag is set globally
or the flag is set for at least one cache.

[ elver@google.com: initialize stack depot depending on slub_debug
  parameter instead of allowing stack_depot_init() to be called
  during kmem_cache_init() for simplicity. ]

[ vbabka@suse.cz: parse slub_debug parameter in setup_slub_debug()
  and initialize stack depot in stack_depot_early_init(). ]

[ lkp@intel.com: Fix build error. ]

Link: https://lore.kernel.org/all/YhyeaP8lrzKgKm5A@ip-172-31-19-208.ap-northeast-1.compute.internal/
Fixes: ba10d4b46655 ("mm/slub: use stackdepot to save stack trace in objects")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 include/linux/slab.h       |  1 +
 include/linux/stackdepot.h |  3 ++-
 mm/slab.c                  |  5 +++++
 mm/slob.c                  |  5 +++++
 mm/slub.c                  | 19 ++++++++++++++++---
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 37bde99b74af..d2b0f8f9e5e6 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -762,6 +762,7 @@ extern void kvfree_sensitive(const void *addr, size_t len);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
 void __init kmem_cache_init_late(void);
+int __init slab_stack_depot_init(void);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
 int slab_prepare_cpu(unsigned int cpu);
diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 17f992fe6355..a813a2673c48 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -12,6 +12,7 @@
 #define _LINUX_STACKDEPOT_H
 
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 typedef u32 depot_stack_handle_t;
 
@@ -32,7 +33,7 @@ int stack_depot_init(void);
 #ifdef CONFIG_STACKDEPOT_ALWAYS_INIT
 static inline int stack_depot_early_init(void)	{ return stack_depot_init(); }
 #else
-static inline int stack_depot_early_init(void)	{ return 0; }
+static inline int stack_depot_early_init(void)	{ return slab_stack_depot_init(); }
 #endif
 
 depot_stack_handle_t stack_depot_save(unsigned long *entries,
diff --git a/mm/slab.c b/mm/slab.c
index ddf5737c63d9..c7f929665fbe 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1196,6 +1196,11 @@ static void __init set_up_node(struct kmem_cache *cachep, int index)
 	}
 }
 
+int __init slab_stack_depot_init(void)
+{
+	return 0;
+}
+
 /*
  * Initialisation.  Called after the page allocator have been initialised and
  * before smp_init().
diff --git a/mm/slob.c b/mm/slob.c
index 60c5842215f1..7597c219f061 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -725,3 +725,8 @@ void __init kmem_cache_init_late(void)
 {
 	slab_state = FULL;
 }
+
+int __init slab_stack_depot_init(void)
+{
+	return 0;
+}
diff --git a/mm/slub.c b/mm/slub.c
index a74afe59a403..8f130f917977 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -646,6 +646,16 @@ static slab_flags_t slub_debug;
 
 static char *slub_debug_string;
 static int disable_higher_order_debug;
+static bool __initdata init_stack_depot;
+
+int __init slab_stack_depot_init(void)
+{
+#ifdef CONFIG_STACKDEPOT
+	if (init_stack_depot)
+		stack_depot_init();
+#endif
+	return 0;
+}
 
 /*
  * slub is about to manipulate internal object metadata.  This memory lies
@@ -1531,6 +1541,8 @@ static int __init setup_slub_debug(char *str)
 			global_slub_debug_changed = true;
 		} else {
 			slab_list_specified = true;
+			if (flags & SLAB_STORE_USER)
+				init_stack_depot = true;
 		}
 	}
 
@@ -1546,6 +1558,10 @@ static int __init setup_slub_debug(char *str)
 			global_flags = slub_debug;
 		slub_debug_string = saved_str;
 	}
+
+	if (global_flags & SLAB_STORE_USER)
+		init_stack_depot = true;
+
 out:
 	slub_debug = global_flags;
 	if (slub_debug != 0 || slub_debug_string)
@@ -4221,9 +4237,6 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 	s->remote_node_defrag_ratio = 1000;
 #endif
 
-	if (s->flags & SLAB_STORE_USER && IS_ENABLED(CONFIG_STACKDEPOT))
-		stack_depot_init();
-
 	/* Initialize the pre-computed randomized freelist if slab is up */
 	if (slab_state >= UP) {
 		if (init_cache_random_seq(s))
-- 
2.33.1
