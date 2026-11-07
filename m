Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061577;
	b=XnoGcYAHe81DN8H6mYtjZu+Yk+NySAQv6YZsIjkILQHeCPKbzPwt0C/Nf0emU7+9dMGP
	 gQ7AUXqCy0+TzcsjfMffW9FCx97nvbs+0RmUOXrSO+sNH76AIkO0wHHM5S22B55YnpyMp
	 SlOkoYABvCnHRx60W7WeYQrbrlJeZQS1ddElnO2iCrnngoCUlFs4bgILDTb4W3LkGge77
	 UaLQus1lgxURAE/QFB+EIyBkn9Qt6pJQFGWPHunek7+0Isq4WrWncytc0ODaLT0RyE55C
	 PCqKl5vwMpSnizWBh0mYXfdZyf5uFbLEv4tTPhA9UpeGBywKudgD/Kvi7kmqsFb5PVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m7i/NDz2yNp57KFeupIbTFH2mCdJT9tx6evl57cVaW0=;
	b=rPUILVjkPhn6pcJLlj/ufhXASmAiubFMcY1tKdRRC+u2dk6c4iZEQzfz2903roKxtr8j
	 YQ3R6mPPbH4EaMaxa7ml3nlDrT7qsFNABXjwjl4g4eRHbP5GdJ9+5UX/7vM7/MWui048z
	 +FuTNWmJ46WOjDNL+fk1QyP0Q55nGk19MvLXJC06hNCqAvkL2o+2v+lOeGoiLokxHn02U
	 Eo8cC8xNHweua1zutb3gvzFtD1ixsn1sm1ARze3jRS/n/IJIYZ8imFnplQYhBiYOYTlBe
	 LzJqkCs73gnf8Q4ZkU9KCoS/k8ALKYEKBr4e9b21r4ma3Mw977/5z7f2oTLFj12IzWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lYwvP+xD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8488606A326;
	Sat,  7 Nov 2026 14:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lYwvP+xD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555E81F0089F;
	Sat,  7 Nov 2026 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061576;
	bh=m7i/NDz2yNp57KFeupIbTFH2mCdJT9tx6evl57cVaW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYwvP+xDfyRVosrSoQZJfQ5azaFhDenps2a2ULFra6DeZCUe9/NDLgFP+phCzX75/
	 BUA4sT9usYp0l++AbS7lGez7hqVZJL2gFMoqBmuWWJJ9XLqeVpS766oGjP7jI150VH
	 3IK2UXwxw7NN2B+8V6bYieb+sXGwd8ggIEfHPdO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.12 0653/1536] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Sat,  7 Nov 2026 08:44:29 -0500
Message-ID: <20261107135015.866742361@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

commit f3e27b7955727a4d7c0e9264a2a209fbba788bdc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1212,6 +1212,14 @@ static void blkif_free_ring(struct blkfr
 	int i, j, segs;
 
 	/*
+	 * Interrupt teardown must be done ahead of freeing queue-related
+	 * data, otherwise the interrupt handler can race with the cleanup.
+	 */
+	if (rinfo->irq)
+		unbind_from_irqhandler(rinfo->irq, rinfo);
+	rinfo->evtchn = rinfo->irq = 0;
+
+	/*
 	 * Remove indirect pages, this only happens when using indirect
 	 * descriptors but not persistent grants
 	 */
@@ -1293,10 +1301,6 @@ free_shadow:
 	/* Free resources associated with old device channel. */
 	xenbus_teardown_ring((void **)&rinfo->ring.sring, info->nr_ring_pages,
 			     rinfo->ring_ref);
-
-	if (rinfo->irq)
-		unbind_from_irqhandler(rinfo->irq, rinfo);
-	rinfo->evtchn = rinfo->irq = 0;
 }
 
 static void blkif_free(struct blkfront_info *info, int suspend)


