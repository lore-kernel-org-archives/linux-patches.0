Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AF2583
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCF851F397
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1CF013A8E
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id fHIsMmVnE2LaIAAAMHmgww
	(envelope-from <vbabka@suse.cz>)
	for <patches@lists.linux.dev>; Mon, 21 Feb 2022 10:20:21 +0000
Resent-From: Vlastimil Babka <vbabka@suse.cz>
Resent-To: patches@lists.linux.dev
Resent-Date: Mon, 21 Feb 2022 11:20:20 +0100
Resent-Message-ID: <eb2d93e8-3885-85d7-3c3e-4f2ade5bbcfe@suse.cz>
Received: from dovecot-director2.suse.de ([192.168.254.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by imap2.suse-dmz.suse.de with LMTPS
	id EJ1JNt1yDWKKSgAAMHmgww
	(envelope-from <willy@infradead.org>)
	for <vbabka>; Wed, 16 Feb 2022 21:55:41 +0000
Received: from relay2.suse.de ([149.44.160.134])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	by dovecot-director2.suse.de with LMTPS
	id IK4pNd1yDWIFHwAApTUePA
	(envelope-from <willy@infradead.org>)
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:55:41 +0000
Received: from relay2.suse.de (localhost [127.0.0.1])
	by relay2.suse.de (Postfix) with ESMTP id D240EA3B81
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:55:41 +0000 (UTC)
X-Virus-Scanned: by amavisd-new at relay2.suse.de
X-Spam-Flag: NO
X-Spam-Score: 0.59
X-Spam-Level:
X-Spam-Status: No, score=0.59 tagged_above=-9999 required=5
	tests=[BAYES_50=0.8, DKIM_SIGNED=0.1, DKIM_VALID=-0.1,
	DKIM_VALID_AU=-0.1, DKIM_VALID_EF=-0.1, T_SCC_BODY_TEXT_LINE=-0.01]
	autolearn=no autolearn_force=no
Received: from relay2.suse.de ([127.0.0.1])
	by relay2.suse.de (relay2.suse.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fxxPiGI5-Wyt for <vbabka@imap.suse.de>;
	Wed, 16 Feb 2022 21:55:36 +0000 (UTC)
Received: from mx1.suse.de (unknown [149.44.161.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 5C53BA3B8B
	for <vbabka@imap.suse.de>; Wed, 16 Feb 2022 21:55:36 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTPS id 3A546AD35
	for <vbabka@suse.cz>; Wed, 16 Feb 2022 21:55:36 +0000 (UTC)
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nKSGn-00F4GM-WB; Wed, 16 Feb 2022 21:55:30 +0000
Date: Wed, 16 Feb 2022 21:55:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Roman Gushchin <guro@fb.com>
Cc: Vasily Averin <vvs@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: tools/cgroup/memcg_slabinfo.py is broken
Message-ID: <Yg1y0ax5bnjGLAqz@casper.infradead.org>
References: <327b9e92-88bb-d66f-e07c-526161db539b@virtuozzo.com>
 <Ygw3au+tPdg2MXYT@carbon.dhcp.thefacebook.com>
 <35486a00-791c-3b1b-14e0-476e6242709b@virtuozzo.com>
 <Yg1kFH3umdrvOhu1@carbon.dhcp.thefacebook.com>
 <Yg1ooYmX54j8l+Fz@casper.infradead.org>
 <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg1wKkIJxIdN43qU@carbon.dhcp.thefacebook.com>

On Wed, Feb 16, 2022 at 01:44:10PM -0800, Roman Gushchin wrote:
> On Wed, Feb 16, 2022 at 09:12:01PM +0000, Matthew Wilcox wrote:
> > On Wed, Feb 16, 2022 at 12:52:36PM -0800, Roman Gushchin wrote:
> > > The problem can be fixed by explicitly casting struct page * to struct
> > > slab * for slab pages. The tools works as expected with this fix, e.g.:
> > 
> > This feels like a quick fix, and not really correct.
> 
> Do you mind to provide a correct version?

I know nothing about python, nor how to even run this script.  But this
is the kind of thing I was thinking about.

I didn't do the 'skip over tail pages' because I have no idea how
you'd tell for_each_page() to do that.  I don't know where to get
drgn.helpers.linux from, so I can't look at the implementation.
Maybe it already does that.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/tools/cgroup/memcg_slabinfo.py b/tools/cgroup/memcg_slabinfo.py
index 1600b17dbb8a..6bb588946f50 100644
--- a/tools/cgroup/memcg_slabinfo.py
+++ b/tools/cgroup/memcg_slabinfo.py
@@ -11,7 +11,7 @@ from drgn.helpers.linux import list_for_each_entry, list_empty
 from drgn.helpers.linux import for_each_page
 from drgn.helpers.linux.cpumask import for_each_online_cpu
 from drgn.helpers.linux.percpu import per_cpu_ptr
-from drgn import container_of, FaultError, Object
+from drgn import container_of, FaultError, Object, cast
 
 
 DESC = """
@@ -69,15 +69,15 @@ def oo_objects(s):
 
 
 def count_partial(n, fn):
-    nr_pages = 0
-    for page in list_for_each_entry('struct page', n.partial.address_of_(),
-                                    'lru'):
-         nr_pages += fn(page)
-    return nr_pages
+    nr_objs = 0
+    for slab in list_for_each_entry('struct slab', n.partial.address_of_(),
+                                    'slab_list'):
+         nr_objs += fn(slab)
+    return nr_objs
 
 
-def count_free(page):
-    return page.objects - page.inuse
+def count_free(slab):
+    return slab.objects - slab.inuse
 
 
 def slub_get_slabinfo(s, cfg):
@@ -145,14 +145,14 @@ def detect_kernel_config():
     return cfg
 
 
-def for_each_slab_page(prog):
+def for_each_slab(prog):
     PGSlab = 1 << prog.constant('PG_slab')
     PGHead = 1 << prog.constant('PG_head')
 
     for page in for_each_page(prog):
         try:
             if page.flags.value_() & PGSlab:
-                yield page
+                yield cast('struct slab *', page)
         except FaultError:
             pass
 
@@ -190,13 +190,13 @@ def main():
                                        'list'):
             obj_cgroups.add(ptr.value_())
 
-        # look over all slab pages, belonging to non-root memcgs
+        # look over all slabs, belonging to non-root memcgs
         # and look for objects belonging to the given memory cgroup
-        for page in for_each_slab_page(prog):
-            objcg_vec_raw = page.memcg_data.value_()
+        for slab in for_each_slab(prog):
+            objcg_vec_raw = slab.memcg_data.value_()
             if objcg_vec_raw == 0:
                 continue
-            cache = page.slab_cache
+            cache = slab.slab_cache
             if not cache:
                 continue
             addr = cache.value_()
