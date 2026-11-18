Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052044;
	b=NiCCTHCT0kJjnMMf2p6LcSph1htKsSbCk52N5i9BEW2h0DE3wOmQYPMwR5RJg8J7xn63
	 guU8+KeaSKRz4AkZGyoQkrhwnD8ygegbWqji4In7tclCnQ1nREWtEqBGTVLdCo3o2J6rk
	 nWjfjd91Ib1EDkLrw8MtlfFeps2kU0oO9ADzwytedKZpFzHWKBaWBeyv2vLgPa5/OIj1I
	 rC+fyKfHx9+Bm9ErPUbVea3+tO8EUsHOfD7hcAvJiAF+iSGzK3XRL6YPd25ujuuqfK/ax
	 vQ5NslvQbhwbadB7mYcsflgfq1lpxE8mlZc+N7LFsGAWbXuftxkst9KnX0BDau8iNCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=45EZ6QjojjSz1QU7UM7G6F+nIqGyrTFe1lvVIzFKbqg=;
	b=fnJOHQqUttcOYgGZk/7M2kKrNPiPzjnIrKpJS377BIq56JeMEus1nHfIVfU5FwBplHUB
	 fA5c52R4v5Ztep7Qe5i8NZ2gwo3ASoPS2wWFb7AGqKLqPWvqhuLZ5webf7L0XLYvIlDmJ
	 MHnSEwlioFNBhoWRnyCIL2h0ov1mDMLldPS+1GtTWcSyoyNyMXj6XAxEuNovTvy2TXQyu
	 vsnMTNan4Q1efcbv14duqR2nCAghXlU5DDo3LVJHpCsBlIjnfaYME+NZP0dv53MipB7eQ
	 UtMqAreGITfGNMvGAmjWvZZ0BCaovh8xyeQp9QxbrYR9bYk7Titcxvmcwb7wJUzrkcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pfrgN/6i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AD5606A32A;
	Thu, 19 Nov 2026 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfrgN/6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1463F1F000C4;
	Thu, 19 Nov 2026 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052044;
	bh=45EZ6QjojjSz1QU7UM7G6F+nIqGyrTFe1lvVIzFKbqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfrgN/6iOrwRoohK11aezRm6V9sAoFifYA5zXyYq7wIKmYNnaEpCum2Cve6J6svv+
	 xlZxzHtyaXHX5rA5xg4m1k7g+Wg47velBRRRrBRHdGphq1wNX84yLKxQ6IMzS7VNC1
	 f6jmlu+qOwLh0J47AyrB06IXvrYqo0+zk/ixur6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0425/2214] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Wed, 18 Nov 2026 15:35:01 +0100
Message-ID: <20261118150027.892143608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit f3e27b7955727a4d7c0e9264a2a209fbba788bdc ]

In blkif_free_ring(), the driver tears down the ring's persistent grants,
shadow request arrays, and shared ring structure (xenbus_teardown_ring),
and only calls unbind_from_irqhandler() at the very end.

While blkif_free_ring() is freeing persistent grants and clearing the
shadow array, the event channel interrupt (blkif_interrupt) is still
registered and active.  If an interrupt arrives from the backend during
this teardown window, blkif_interrupt() reads rinfo->ring.sring and,
via blkif_completion(), accesses rinfo->shadow[id].grants_used and
rinfo->shadow[id].sg.  blkif_free_ring() tears these structures down
without holding rinfo->ring_lock, and the handler only checks
info->connected at entry, so this is a real race resulting in a
use-after-free or NULL pointer dereference.

Fix this by moving unbind_from_irqhandler() to the beginning of
blkif_free_ring().  Calling unbind_from_irqhandler() first frees the
IRQ and synchronizes with any in-flight interrupt handlers on other CPUs
before ring memory and shadow request structures are deallocated,
matching the teardown order in drivers/net/xen-netfront.c.

Fixes: 11659569f720 ("xen/blkfront: split per device io_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260922072155.34625-1-ndaugoing@gmail.com>
[ sashal: Adjusted context to preserve direct grant and memory cleanup where upstream uses xenbus_teardown_ring(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 831747ba8113c..02dc4a67ac82f 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1215,6 +1215,14 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 	struct blkfront_info *info = rinfo->dev_info;
 	int i, j, segs;
 
+	/*
+	 * Interrupt teardown must be done ahead of freeing queue-related
+	 * data, otherwise the interrupt handler can race with the cleanup.
+	 */
+	if (rinfo->irq)
+		unbind_from_irqhandler(rinfo->irq, rinfo);
+	rinfo->evtchn = rinfo->irq = 0;
+
 	/*
 	 * Remove indirect pages, this only happens when using indirect
 	 * descriptors but not persistent grants
@@ -1304,10 +1312,6 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 	free_pages_exact(rinfo->ring.sring,
 			 info->nr_ring_pages * XEN_PAGE_SIZE);
 	rinfo->ring.sring = NULL;
-
-	if (rinfo->irq)
-		unbind_from_irqhandler(rinfo->irq, rinfo);
-	rinfo->evtchn = rinfo->irq = 0;
 }
 
 static void blkif_free(struct blkfront_info *info, int suspend)
-- 
2.53.0



