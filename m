Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035157;
	b=QBrmbsF/U+oC91EUNTcf+ka2qe1i+W9MPRHXchDK7l2dkK5sK6iVAXK4uRwoY48gfqXo
	 JQWZ5Ne0kKvu/101YwQyOZG3tA8yvJvtMMQbtQyll8B0jOgfxeW6cuyhzKLo8wl5uusv8
	 sTeLb8XCRI0koMEzDJLuUgPLarcHnckWkw5rVu0EPFupCD11t2kb1uzKq5wXyJHSduB8z
	 h22qHQX7VfwYaJRqLhDYE0GUUIibw+5Df3HIgU8cRR/RkvXA7m8PRMznUywj7Wv8cOvW2
	 9VB1V06Om1/NKKq/b7ZscsFgEzvl+xcLYtgCD+KiNvDBOZk+dZm5Ycnmck9h8/NhcMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lIyDAhgp6l3W1LxLX1Ul4sfAyTFoMxKyjgkQ2jSll54=;
	b=4Zh/3jzEEKgP8Kj1iDZ2W3xQU7jSyDQ+MpWZNN3aC+TeCaOcyz/JGm3kBXVQPoC/irdC
	 0/RhGTjHvTYi3aysue2eIzfT8Vc5EwsY+ZIzaR9VNelLHxtvgMOYxwCHtKpvqAdkJiiB8
	 VsRFBFmpNAnAK12wP+gkmy3iKmW3Zaj0s3FkgsaacJR+7iLULv7LeL7F4eTguM4AzzU83
	 gUsaS9WlO9IBjihWDjE77vvAA9Apf4vVpUNDzcXWjFT6sw1juhYAqjVM8j6bTebf2egCh
	 +zLL1EvDzo4tBaiYDJRQ8vVCFWtpTxS6OYadcR+WVhoxpzkJT/Fw7mcmMz5pr5NY8zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AUEv0V7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B44606A31C;
	Wed, 18 Nov 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUEv0V7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3651F000C4;
	Wed, 18 Nov 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035157;
	bh=lIyDAhgp6l3W1LxLX1Ul4sfAyTFoMxKyjgkQ2jSll54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUEv0V7/XyNmiu3VwiFmczk7GEyqNASA3NyItQ2XTTq6xw9380EKE3E6VyuPA+9YK
	 F3kYSEzVpvql/WoyHO48ocyjaLhsXqywaO15lXZp7fQ3MdqrCZx6YsOF27APBxok1K
	 Bmh6T+RGcb8yWGQwWSJypELoySgK7ZK71RWGsKbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 0625/3318] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Wed, 18 Nov 2026 15:20:47 +0100
Message-ID: <20261118150336.602908394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


