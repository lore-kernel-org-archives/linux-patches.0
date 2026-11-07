Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061427;
	b=MMDmp43XZvyAG85UidKCLZFNm5KvTt80k8x0URjykmlUzYD7o2+3VA9ZC81r/R8nUChm
	 r+BbElVa2kt6QGAAsFmjAqulAgMQZzPIcx8m6EQK+YN8gcr7X4mYgvA2dqbUn8vUuru1U
	 M/JzR+BOamknMZSZWmtZR7G1YIYqjsfeDt6LSla/iPntKntHZENWmUMUIFdGfa0/5yRhl
	 g0a0lIvJJHSjsG+aEME3a3leoSiNJfnP32vTWMfrme8P0eMMMCJgajO0jcahl99nNRoXU
	 LG6xgiZTmiZC92i+9+R6cmKHYs+V+k1Ll1U1Ry5Shrsai/Eg3dheDdyFF65nLrrBCLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7JwmaAHZ9/F1COml6MseBs+R6qGgTfcWsgQypaUqzs=;
	b=qbUOR50yVANgGeblvcm7ryaEeBGYQV1XFrLFcm0fZxQHOA5ypgx7B7ZMfY/wHbLKHNAQ
	 8LL/VtIVGDP7CN2ozW3ipXhpqU9wrTI408KchXbd+PdmYeSG1YVAM/8zjSJfpe/KwCAUd
	 oa2GXHMEkAO24KrSNMdMVK1GEyCHyZbTrbIIRAfHgPiFSpcT5Kes654iWrxz26TIEEUwj
	 idCit+EIds2zGGvNnE6CSdrhTDY3glghJtJVFPz51om6Dq02fWihCCzt5xOOIB3GrL6ir
	 T+I+jwLIq1aAxq6rBspZGNl7gTeTMiMAt0UdbqxhdRCfrqPvNNqn1zyk5bDEWiehuhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGkAFP2b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF81606A326;
	Sat,  7 Nov 2026 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGkAFP2b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D611F0089F;
	Sat,  7 Nov 2026 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061426;
	bh=u7JwmaAHZ9/F1COml6MseBs+R6qGgTfcWsgQypaUqzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGkAFP2bU76b7aYDYcV0GRkGBdgkRaDGltIh80CnHKWVrHpNFLAjX21yh7JA87Akd
	 VGK2TAk/PcC39OSxN7RhGfTgPMRdEDz01n6oUVRx7zUQaXYeZ5v2qPbZMrmhQgr4XR
	 wpHP3+mj+Rn0LbqXzcMIRSkbQ+wDf+XkOFGF5F0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0535/1536] netfs: Fix missing alloc tagging of direct mempool allocations
Date: Sat,  7 Nov 2026 08:42:31 -0500
Message-ID: <20261107135012.630934735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

[ Upstream commit b78b728e21c32ec4c330b299f657fb1eb02dffc2 ]

Commit 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by
adding a mempool") added a mempool for the folio_queues and made the
request, subrequest and folio_queue allocations distinguish between
writeback and everything else.  Writeback is part of memory reclaim
and must not fail due to ENOMEM, so it allocates under GFP_NOFS
through mempool_alloc(), which may dip into the pool's reserve and,
if that runs empty, wait for elements to be returned.  The
GFP_KERNEL paths, which can return -ENOMEM to their callers, invoke
the pool's ->alloc() callback directly instead.

The direct call, however, skips the alloc_hooks() wrapper that the
mempool_alloc() macro provides.  The pool callbacks, mempool_alloc_slab()
and mempool_kmalloc(), call kmem_cache_alloc_noprof() and kmalloc_noprof()
and rely on current->alloc_tag having been set by the caller.  With
CONFIG_MEM_ALLOC_PROFILING_DEBUG=y this leads to

    current->alloc_tag not set
    WARNING: ./include/linux/alloc_tag.h:161 at __alloc_tagging_slab_alloc_hook
    alloc_tag was not set
    WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook

at allocation and free time respectively, as reported when reading
files on a CIFS mount.  The allocations are also missing from
/proc/allocinfo.

Wrap the direct ->alloc() invocations in alloc_hooks() with a new
mempool_alloc_noreserve() helper in include/linux/mempool.h, next to
the other alloc_hooks()-wrapped macros such as mempool_alloc().  The
GFP_KERNEL paths keep their failable allocation semantics, they just
get tagged now.

Fixes: 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by adding a mempool")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org/
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Link: https://patch.msgid.link/20260923063759.34667-1-hao.ge@linux.dev
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Adjusted context for older mempool_t/extern prototypes without the bulk API, and kept the branch's extra rreq->origin condition in netfs_alloc_subrequest() while swapping in mempool_alloc_noreserve(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/objects.c        | 4 ++--
 fs/netfs/rolling_buffer.c | 2 +-
 include/linux/mempool.h   | 7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 788bdaf7332f9..f417e70951442 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -32,7 +32,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 
 		rreq = mempool_alloc(mempool, gfp);
 	} else {
-		rreq = mempool->alloc(gfp, mempool->pool_data);
+		rreq = mempool_alloc_noreserve(mempool, gfp);
 		if (!rreq)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -189,7 +189,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 
 	/* The write-side callers don't handle failure, so only reads may fail. */
 	if (rreq->gfp == GFP_KERNEL && rreq->origin <= NETFS_DIO_READ)
-		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
+		subreq = mempool_alloc_noreserve(mempool, rreq->gfp);
 	else
 		subreq = mempool_alloc(mempool, rreq->gfp);
 	if (!subreq)
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index 7c768ca5ff592..ed150cd0ea0b0 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
 	struct folio_queue *fq;
 
 	if (gfp == GFP_KERNEL)
-		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
+		fq = mempool_alloc_noreserve(&netfs_folioq_pool, gfp);
 	else
 		fq = mempool_alloc(&netfs_folioq_pool, gfp);
 	if (fq) {
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 7b151441341b4..5f551883dfcb2 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -67,6 +67,13 @@ extern void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask) __malloc;
 #define mempool_alloc(...)						\
 	alloc_hooks(mempool_alloc_noprof(__VA_ARGS__))
 
+/*
+ * Allocate a new element without dipping into the pool's reserves or
+ * waiting.  Returns NULL on failure.
+ */
+#define mempool_alloc_noreserve(_pool, _gfp)				\
+	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
+
 extern void *mempool_alloc_preallocated(mempool_t *pool) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
-- 
2.53.0



