Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C92CAC
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E5C01FE01;
	Wed,  1 Dec 2021 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlUv2OtrC7eRXASO71bKR3Wlk76iz2Ou0YyjK0XRGig=;
	b=DnSf2A6NCH10S73TLXwAJYUNL+xOvhQ3GN559e72v4YhgY2y7Atyff01DHcJYt6qCx9Ojt
	p2tM5QV+M80dELSnLNYeyfdgFnFeGjBIlkXm5jbxdh8vDRBy4DRbSG1PJvgc8S1LUS61XP
	orgANGZ5HfnNazPWlL1XY1ZgbxSxkKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382521;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlUv2OtrC7eRXASO71bKR3Wlk76iz2Ou0YyjK0XRGig=;
	b=QZYELxLu0RZtD+MkfYvbOD6sgO25lHF1P5GawuNdwVSS8IH5gntYr0pH56KTl7FsgheJBl
	mjPciRkLb19n/8BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4E2E13D9D;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id gJZIN7i7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:20 +0000
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
Subject: [PATCH v2 32/33] mm/slub: Simplify struct slab slabs field definition
Date: Wed,  1 Dec 2021 19:15:09 +0100
Message-Id: <20211201181510.18784-33-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=800; h=from:subject; bh=Bs7CnNqvzouQkyTUczu6bOXcjfNRkUUfsin8TCcV3Ow=; b=owGbwMvMwMH4QPFU8cfOlQKMp9WSGBKX7155/pJ1SuhvdR3vS332BuLpl4t8n9VPOtge/FnXearW Hh+1TkZjFgZGDgZZMUWWXu/JjCtNH0vs84g7AzOIlQlkCgMXpwBM5HEu+z+D8vwW5k1+RuLy+Q4eM4 TerfGf7bhhx626jrB3Eefc6x8vnSX+wPrv/zaf29piV1JZFH4KnjDuOy3bE7nAM//WuTQxvfY9Ex7n Kjy16Zmh1ely4XlD8ev+bLEdi9ezGHoxz17eztteEnUpud9gfXMgV67e6vUvNtqfd9LdYbRLcbbzcq uvx1varV3/c/d5us/mC63RWTzBQlys55Nv1Hep9c1aB6dODv+XdFXkkIK+dFzjFccnmzcuW/3I9bno R7v9HyqOZgtdjWPRL9u2eUKzvshB7dXr3h6/XbW6W4gtMKr9qHmIUcgrngP2+kz5JvqaMVN91No65p xztplrk28oJeaQGZDbcf2Zz+kFAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Before commit b47291ef02b0 ("mm, slub: change percpu partial accounting from
objects to pages") we had to fit two integer fields into a native word size, so
we used short int on 32-bit and int on 64-bit via #ifdef. After that commit
there is only one integer field, so we can simply define it as int everywhere.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8c5a8c005896..ee4344a44987 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -27,11 +27,7 @@ struct slab {
 		struct rcu_head rcu_head;
 		struct {
 			struct slab *next;
-#ifdef CONFIG_64BIT
 			int slabs;	/* Nr of slabs left */
-#else
-			short int slabs;
-#endif
 		};
 	};
 	struct kmem_cache *slab_cache;
-- 
2.33.1

