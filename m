Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293882CAD
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 453521FE02;
	Wed,  1 Dec 2021 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EbhpLd+Q4B2M+R0uCA9t2TiAJGnc3XWbqibvAWCPhjU=;
	b=DOoG0xpGWK48kuGkzPBns42ZWeB3Zlc7D2dZ/FWk1HdmydKs8DNEUzMNPS5i0OylFS/1yp
	nV0TH2Qn4QqnQKtYBIBP3tyKgGzsSIgZ/7pJOl2ME8CGSz8PWD+iJwT2WfmF3Gawv5zdjS
	N7i5keQJJiQmRIhPo7lYJAvLe/vW0AM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EbhpLd+Q4B2M+R0uCA9t2TiAJGnc3XWbqibvAWCPhjU=;
	b=1Gfb1nKWeKO3ojRYR2YpP9Bv9c/lBSC0fqB37339FT7b7lOLXH91CuDk7H8rLCz3TAwPgS
	1elJGn+jdSitHmCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1136614050;
	Wed,  1 Dec 2021 18:15:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id IDOuA7m7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:21 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 33/33] mm/slub: Define struct slab fields for CONFIG_SLUB_CPU_PARTIAL only when enabled
Date: Wed,  1 Dec 2021 19:15:10 +0100
Message-Id: <20211201181510.18784-34-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2322; h=from:subject; bh=m/z7+hlXnV3bCVCWVrLaMyJvvbYxX/z2IC4fNzb2k5U=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7usdZf4xHNwKrqZ8Vb+Rdj6YUM2kPeGgg+UWq+m r4/yMLWJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7rAAKCRDgIcpz8YmpEDgTCA ChfJZ4KJYE2UVojqmdcj+hW1R2bJrjwyO/TAsOIC2e5gHglGppN2zz67dqWCfkw4RUGwc/UIr5mzuD RAkXpcIiLaduq5/rqhs4qGEBjl3hSIQdjqV226o5wgw4bJBmQjQcwUO80SLj4tN3uQxXRpI+DF2wlO jS0BlZJHZcIkx5reEAhMrnJYnZeKosd0bcwwLoyoTQQ/jw+bFsSnwMYAQ5Sgldh1YLBZtqlGK79hrP FQQnWWTcWIWtsS3BrGx4SyE+Fs3cxz1u35QdrxFFg35LzLAcKAGRn7G0bTlUkifzewfX6zxJ7997gN zJxAhU62qKaFzoSITVVE/o11wZG+m8
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The fields 'next' and 'slabs' are only used when CONFIG_SLUB_CPU_PARTIAL is
enabled. We can put their definition to #ifdef to prevent accidental use when
disabled.

Currenlty show_slab_objects() and slabs_cpu_partial_show() contain code
accessing the slabs field that's effectively dead with
CONFIG_SLUB_CPU_PARTIAL=n through the wrappers slub_percpu_partial() and
slub_percpu_partial_read_once(), but to prevent a compile error, we need to
hide all this code behind #ifdef.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 2 ++
 mm/slub.c | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index ee4344a44987..46ea468b29aa 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -25,10 +25,12 @@ struct slab {
 	union {
 		struct list_head slab_list;
 		struct rcu_head rcu_head;
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 		struct {
 			struct slab *next;
 			int slabs;	/* Nr of slabs left */
 		};
+#endif
 	};
 	struct kmem_cache *slab_cache;
 	/* Double-word boundary */
diff --git a/mm/slub.c b/mm/slub.c
index 58f0d499a293..978d754d0ada 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5256,6 +5256,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			total += x;
 			nodes[node] += x;
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 			slab = slub_percpu_partial_read_once(c);
 			if (slab) {
 				node = slab_nid(slab);
@@ -5268,6 +5269,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 				total += x;
 				nodes[node] += x;
 			}
+#endif
 		}
 	}
 
@@ -5467,9 +5469,10 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 {
 	int objects = 0;
 	int slabs = 0;
-	int cpu;
+	int cpu __maybe_unused;
 	int len = 0;
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	for_each_online_cpu(cpu) {
 		struct slab *slab;
 
@@ -5478,12 +5481,13 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 		if (slab)
 			slabs += slab->slabs;
 	}
+#endif
 
 	/* Approximate half-full slabs, see slub_set_cpu_partial() */
 	objects = (slabs * oo_objects(s->oo)) / 2;
 	len += sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SLUB_CPU_PARTIAL) && defined(CONFIG_SMP)
 	for_each_online_cpu(cpu) {
 		struct slab *slab;
 
-- 
2.33.1

