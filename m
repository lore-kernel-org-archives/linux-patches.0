Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044431;
	b=U40xpHaMD52I/zF84bYVJCybgcO9B9rQvTnaXIREAqxoJRPdsiLDSpggjkhmq+bLMKpa
	 8E0ZRKv6QVHndVrTpDza9IukQI2C0ljZ6NfxPjhqctrvWD9YOM5TfjkMHpvGjcyEmMiDE
	 4YEp4J5Xy7QzlCW8cy8NQaM+XCLr90TAr+uORE9hvAgMRILriTgTmFLnFgjUavfJ8ZKXe
	 zQzxknyN47jYF8YJyl1w6Sd18y5sLssEYeq9+jQDVEar5FZSqyC/3b3pGcqvmQY51nJcb
	 nTaOQq1fqUNhvCRig7uPX/eLIv5zzEHnNrEFkXlaymyLjx55cEBYHOTTpby12+DUe5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mPcI5s9gmp3W6Jw9g/6739y/IMX1bjaN3J0WY9tRA94=;
	b=Ur5n09kUfInUAMXd/+V49euM6t3PAP3n8SGiGqgTcM+qjIJRNVe1MZxGjV7cog/RXhGT
	 AJuj2IRVC61eN7TApmaGNNJCvWk4DyFGoCLKJVSPKnR2uZWB/AZGAb0aDiSybZd2HZuiW
	 V87MvgkeZoRyVK0BYp7F0SZGJVVvhy+gSe5alGWVwHqDw6ltUjiz+X0JHOBW2fE0Xr5xG
	 Y8TsqFCpXB9FTRNWiYy379vYwd4RVGd0gwT+aCMZlnEdlt/I3h/O6CNh7WUSv1J/OcSkI
	 ZmdURUzH5SqwedhpqNuZM7cNtt7/S/vXbm2jTOkzFALFn69ttcDo32uBJELBIrQwYag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvb9XP7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B409B606A320;
	Wed, 18 Nov 2026 23:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tvb9XP7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188F91F000C4;
	Wed, 18 Nov 2026 23:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044431;
	bh=mPcI5s9gmp3W6Jw9g/6739y/IMX1bjaN3J0WY9tRA94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tvb9XP7jQ6slIh8FA3yMvc801L5DD/or9QvlZxos3N138/QCQ53AH8zHy+PGW7hPE
	 dcbFHbBhSjMgmJzkmpVYWrorwAA4ucxY5B6wgAqPAbFVaQjWccMNy7p6mk6E/5LKbj
	 FhOjhyvaOCki2unX2u0FsJ/dJqAwzdJHJdAS5wcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 0563/2857] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Wed, 18 Nov 2026 15:26:37 +0100
Message-ID: <20261118150221.761736242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1211,6 +1211,14 @@ static void blkif_free_ring(struct blkfr
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
@@ -1292,10 +1300,6 @@ free_shadow:
 	/* Free resources associated with old device channel. */
 	xenbus_teardown_ring((void **)&rinfo->ring.sring, info->nr_ring_pages,
 			     rinfo->ring_ref);
-
-	if (rinfo->irq)
-		unbind_from_irqhandler(rinfo->irq, rinfo);
-	rinfo->evtchn = rinfo->irq = 0;
 }
 
 static void blkif_free(struct blkfront_info *info, int suspend)


