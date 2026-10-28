Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213277;
	b=OVMs9nXIafIBxYgS1WMfABP5EUHpV5d8u/fKtlpstpvZ6lFaHaTT2/hnoeeMyZ/omV8m
	 0Dyyky5AFgk4t600yLzmbnPsgJONdlSxonNKx9gD7oLfKDIp66pcUHzJfj03ZeZR1Ls2i
	 tBjJUtLZOAo7ID4PLtN/UHZxEt7I8qhBUu7/5h3AQonh2fCyCWICcKCO8O/5X8MKQSFxn
	 wjVDjmEhkraikbpPxeWvLAs9rwOaTeyK21MFS8/jqQTbDTfFPy7hXFdnH/E2+mOBKZzYL
	 w8LxZMrTW8TeGyztuMrflT0PGIKYSJLyeBpMI0yTx52LfLev6YO5/D1ESrCASNWab9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iI8AhUzeeUoPwPSsDgbep4qu4YWvIGyLdEJoCP9nmsw=;
	b=srKMmEKcvaFOJeYiVJ3peMnskTxnP+TezIrfxDOzV3ggTp6FzbVrMvXtEpn6OFjuk53p
	 dPyURE5m+kEJ6d4ui1BWqv9jo0Yr5zVDsW/6r2eahzqHoCK3F4MgOmxJ5Gf75PUJWgxI2
	 Jtwbdz9CRydI49MAbZGlUy4XMO6BCNGTxa/HBF4NxS18PNAGZIGiFLItrcA6n1T2+D+Sz
	 eY3soyggISTmNDGAGePQDNhwHeciKPZgQS+cH9RN3ltO7s4tipN7yU9PFGKgPhocgENcP
	 5ATsujBj2BIRHyVAI3sFIE+vJqYJBoYw9OIkooBsk0HkaYSBAX0tSHGg0F8zCj1Te3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+sgKxzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CD1606A31C;
	Wed, 28 Oct 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+sgKxzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04761F01825;
	Wed, 28 Oct 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213277;
	bh=iI8AhUzeeUoPwPSsDgbep4qu4YWvIGyLdEJoCP9nmsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+sgKxzUG9gU/oXq+Gjs5fvW7dgb5z79VT95lnL7vUFfyqAp+J/Rdo9Q3GOQMX8Uu
	 d4hrKPUoGE3j937kb2evuNCUrCbWMg2d/oxNEzvz4IES/GwBKmxn8jeAj4F7Upp76C
	 M8KneirYX7gQLbdLAgVQtYPRsZZDkDuNmkxW/sgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Dave Marquardt <davemarq@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0450/1887] ibmveth: fix TX LTB and filter unwind on open-fail
Date: Wed, 28 Oct 2026 17:42:26 +0100
Message-ID: <20261028170509.470380621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingming Cao <mmc@linux.ibm.com>

commit 84bec0bf035258a1073ffd6f6dc8ea61806aa7d4 upstream.

out_free_buffer_pools reuses open()'s loop index for the TX LTB
walk. After the pool unwind i is -1, so the TX buffers allocated
earlier are leaked. request_irq() failure has the same leak.

The TX-fail goto on that walk also skips dma_unmap of the filter
list (pre-existing since the LTB was added). Rewrite the TX walk
to real_num_tx_queues with a pointer check, and unmap the filter
list before those frees.

Fixes: d926793c1de9 ("ibmveth: Implement multi queue on xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Reviewed-by: Dave Marquardt <davemarq@linux.ibm.com>
Link: https://patch.msgid.link/d14314c2b10f125f5e578782484ba3cc50564d53.1790357373.git.mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -465,10 +465,15 @@ static void ibmveth_rxq_harvest_buffer(s
 
 static void ibmveth_free_tx_ltb(struct ibmveth_adapter *adapter, int idx)
 {
+	void *ptr = adapter->tx_ltb_ptr[idx];
+
+	if (!ptr)
+		return;
+
+	adapter->tx_ltb_ptr[idx] = NULL;
 	dma_unmap_single(&adapter->vdev->dev, adapter->tx_ltb_dma[idx],
 			 adapter->tx_ltb_size, DMA_TO_DEVICE);
-	kfree(adapter->tx_ltb_ptr[idx]);
-	adapter->tx_ltb_ptr[idx] = NULL;
+	kfree(ptr);
 }
 
 static int ibmveth_allocate_tx_ltb(struct ibmveth_adapter *adapter, int idx)
@@ -579,7 +584,7 @@ static int ibmveth_open(struct net_devic
 
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		if (ibmveth_allocate_tx_ltb(adapter, i))
-			goto out_free_tx_ltb;
+			goto out_unmap_filter_list;
 	}
 
 	adapter->rx_queue.index = 0;
@@ -657,10 +662,8 @@ out_unmap_filter_list:
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
 
-out_free_tx_ltb:
-	while (--i >= 0) {
+	for (i = netdev->real_num_tx_queues - 1; i >= 0; i--)
 		ibmveth_free_tx_ltb(adapter, i);
-	}
 
 out_unmap_buffer_list:
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,


