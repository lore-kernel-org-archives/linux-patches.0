Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590967;
	b=sI661nlnJz5X0ClPzscEyHRajd/JycBd33eWZhjHZEWa/UWmG/FoA9/yFMZf3WFosxGh
	 IErYYXMxFeoF3C9xZFHSxs9dgJcng0ztvuRPyaFrGKPDyVfsxUITvUjMXuFkORWNcz1US
	 pCXxeoIsh4mD5H1wD99rCL2Wq93uEFqja9UnjR2/kRl8X1XGdzwV+B1dF8pUsnmhaupqF
	 wO6HdIfzha6BsEt4I3iyeTKdRJXt1Vy7gvOFVTCL8ZJUurwr1ReWW5g+jGTwG3Q4CUz7z
	 EX0g4mKY8L4Z9dk6fEf9mf1TBrjkItLiLTFq0n1lFUv3O7sP4AwP1yBokO3M4u3iW/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnOQg0+VouutGCi/K0fX0YYgvuCxJRdU1E4SdmwLANU=;
	b=SuPeWrVwhdNrdpISEKMv6T7GxnNaqK3O6iJftQjckIPbzuQTZwCQnViw8i25CF68YJzt
	 lmVo+K+z3KQRvKyu8esm9anGeOErqllXAcH4GSrMpVZKfZm2VNgMKDLzpJJWDAaKW8jTx
	 owpCF4i0BPb1MHK1CKYFox2IKqkho0OwvSgtjxlTm6TJIy/qNXfbW6u/L5f9nVlZNZz7W
	 8NaXPl067NfrrQ1z8bCINnhjrL5ikOtDNXONntcgz6pFgPWOYX4lzF5E62L1RapFm88hd
	 V5C+tpocpZFNOzgi2N4V8AwBAZG+GTJUEoLltMXyqLP6QBB8Nvs5REzg2mZFRNoINZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OlaCn3Dt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1D5606E653;
	Fri, 13 Nov 2026 17:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OlaCn3Dt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A511F000C4;
	Fri, 13 Nov 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590967;
	bh=cnOQg0+VouutGCi/K0fX0YYgvuCxJRdU1E4SdmwLANU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlaCn3DtPScR9VGznxXTJ9FIVQsbORNXR4r6mQVMjl1PcQ5/zvA+JG6X0G2b7yL2r
	 69qZedjK2lRm39hjJDXwabpsoatQFfndtdvlvpWrRrrzXR4TQfNz23JDX83wyGA3RQ
	 3zKdXGGQS1i3Wf1wLzsDI+y0fOYDdEUb0cZxBNAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/670] bpqether: leave the Ethernet devices queue and counters alone
Date: Fri, 13 Nov 2026 10:44:27 -0500
Message-ID: <20261113153815.373861255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

bpq_xmit() replaces its "dev" argument with the underlying Ethernet
device before it builds the Ethernet header. The three statements that
follow were written for the bpq device but now act on the Ethernet one:

 - tx_packets and tx_bytes are added to the Ethernet device's
   statistics, so the bpq device never counts a transmitted frame;

 - netif_wake_queue() restarts the transmit queue of the Ethernet
   device. If its driver had stopped that queue because its transmit
   ring is full, bpqether overrides the driver's flow control.

Count the frame on the bpq device, which is still at hand in orig_dev,
and drop the netif_wake_queue() call. The bpq device does not stop its
own queue outside of ndo_stop, so there is nothing to wake.

Tested in a QEMU guest (6.12.94, KASAN and lockdep) with two e1000
ports on the same hub, bpq0 on the first and bpq1 on the second. After
40 UI frames bpq0 reported tx_packets=0 before the change and 40 after.
With the transmit queue of eth0 stopped by a small helper module, a
frame sent on bpq0 restarted that queue before the change and leaves it
stopped after; the frame goes out once the queue is woken. In both
cases the 40 frames are received unchanged on bpq1.

Fixes: f57505fd7ce5 ("bpqether: convert to internal net_device_stats")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 568cfa4507c2ef88099acd6cf88fdf76f7cef8d4)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index bac1bb69d63a1..c896b778b77b1 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -287,11 +287,10 @@ static netdev_tx_t bpq_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->protocol = ax25_type_trans(skb, dev);
 	skb_reset_network_header(skb);
 	dev_hard_header(skb, dev, ETH_P_BPQ, bpq->dest_addr, NULL, 0);
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes+=skb->len;
-  
+	orig_dev->stats.tx_packets++;
+	orig_dev->stats.tx_bytes += skb->len;
+
 	dev_queue_xmit(skb);
-	netif_wake_queue(dev);
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



