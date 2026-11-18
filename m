Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058031;
	b=lKp1O3TbNaWgpS8iuMpgAXTjgpaUjSlFJdPDG/3ZUXYWV7YNpwREbuOXtOwocuvUxSQE
	 VllQxRYd64WXoNTezdEmanNCghQf7qitpeWKD8960IcMi9rVmH+oxVkfcCwvEo+801G+z
	 WKomQyv2zVBySjSRvlsDjgh7HPFu3ZowOa4aLWw7BmSd1EAW6x95simaf/kXj8OTKZrEQ
	 1tgn4BGXUJdE5e6+naNN/HoPqN9wVBwLzgdjrCigFcTYAs80LgdBp7fLWD29DEpR70Rch
	 Bw4BKf9lO4klmGYDyMtFR26RWODqyX11uXJIWbPElW0YGRBePDRpp8oc/l5KmYc3jWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Msv8yDPddLef1jxFe4SmbMPlNMMy/6MkcrW96w4FN68=;
	b=vbR6H9LuIAC/nCDGZg1bg1UwgLFUmPxlgApHv685YKqG2kdDXrYaP5FU77dtUZoap0+E
	 C4FHwz5NX146Nzs0E8ufMivpTzqZ2oc9fiu8vCpnZOur7Ap+hxoUJ34xVZVs0F51L//K8
	 wcCs5wYVA+Oi7Ps3Oxdaxd6vU4TLRG/OmEe3EtXDaCxLbTcRuzh2r07uu1eLv9Tkys6/Z
	 YbdCjMH1BPKceGNccwRLXrL39BCh2aXiy7kDKQKY+EEbAtMBdNFwLs0Kp6PXXj5yIYiHl
	 WlH52doIfJd82WGThnpuw3f8RNXBvhPUZHi0BCheBoHsIPzFUTnpH+D4hmAPchdnWSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGuvuKcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C710C606A31C;
	Thu, 19 Nov 2026 03:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGuvuKcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD5C1F000C4;
	Thu, 19 Nov 2026 03:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058031;
	bh=Msv8yDPddLef1jxFe4SmbMPlNMMy/6MkcrW96w4FN68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGuvuKcS5NnI7X6zJZLXQx92UZMXfD6XH6YVZNzb4jXkRP7SyAs3jBGO2QVWC/dn9
	 gxkPj+6VAGlmfwNhbwa3n1ErM3nYJB/UMiz+PpdG6pRi92ETgLQaSRqw/zO0+3pqBj
	 tAeZVC5KW+ozXYajzk3ldo0JHuPiRFOU4nsitVR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0340/1848] xen-blkfront: unbind irq before tearing down ring and shadow requests
Date: Wed, 18 Nov 2026 15:39:38 +0100
Message-ID: <20261118145926.686528979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for ring cleanup using free_pages_exact() instead of xenbus_teardown_ring() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 19ddbf977d28f..44c82088a611c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1276,6 +1276,14 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
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
@@ -1365,10 +1373,6 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
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



