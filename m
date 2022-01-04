Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472DE2C9C
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9770A1F3AA;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srk+YmvDK1AuCYYo/jZO5WMS/0PQaBF+cZ2HDYoq77U=;
	b=0rjdvRHZWPC11gp7fMFamTuF4JWMC1gmG2K+qqefzyirFpSheeZs/JUc/qwl+eG5Af+A1C
	fGxV5wmGnwxdI8NBbYVjKYrJfPHGwG5wqevPjiIZEYjZW67V0NdRTSTCGQnfjwk7s2r6A9
	Up8Es6sOaFPNNuiZjd0HuDi2qmLrXCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Srk+YmvDK1AuCYYo/jZO5WMS/0PQaBF+cZ2HDYoq77U=;
	b=vtUkRrMGsPgOvBs73G1cvG3NGzsbjFKkLxaSq9U5ELsvmys9oQiXfB8NrI1DkUusmVM9bR
	koCCJKOKTXgkHdAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D287139D1;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id COsGGpKQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:58 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <guro@fb.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 28/32] mm/slub: Simplify struct slab slabs field definition
Date: Tue,  4 Jan 2022 01:10:42 +0100
Message-Id: <20220104001046.12263-29-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=849; h=from:subject; bh=39zndzYmCUGEzzVWaAohrHd5JlCLUGXNcqIoBc86Vgc=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CBhxwEhilFdlkJnZQP2IOQ8lU+5xIHU/8+7TPd /1AjGrCJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQgQAKCRDgIcpz8YmpEFwhB/ 9BNPSUzDVieBL+ELuX+1Wap2q5bwfzbue/MHPkyqncEUG+CAyJSu6wChepgmOte3j/0RHUWYy6tebz RRk2cu5BWRHciux2YfwVha7gyvNO//6YSU80ia3CtRiSKuh2pm7zBza2Krsp++mRsgxUK3kIGk0Jx4 jWHSPzdB+3Er0zHiOdHREB/5K0gMO1GmxS0AqFClV48tD1aCrTRYxFEhSCTX716+zrcfGHR+yCE5S/ xMzXoJ7zzF7rasrcrhaIGU/2Pqf0C4KCZERPqJUZOPIoxFVDs6YGXObT2hzFIsZ4K7SVwBMyUS0quA 3RGAAi3v1avCtzUjTgkqMvi0Dib4o2
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Before commit b47291ef02b0 ("mm, slub: change percpu partial accounting
from objects to pages") we had to fit two integer fields into a native
word size, so we used short int on 32-bit and int on 64-bit via #ifdef.
After that commit there is only one integer field, so we can simply
define it as int everywhere.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/slab.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index b8da249f44f9..362832f465e6 100644
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
2.34.1

