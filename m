Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209074;
	b=SC+1XR0ioONVuWMkVKwQb75ljxsCm/8pkcMJ/Lffuo0myqBJVn+2oTRxnHG71dln0fp4
	 lDt+uqZJCkO3cAkDD4rvtWe7njbRgG7H+1T+nM0s6jDqvK7bjfZ00OvhP2PrCNJi3rm+a
	 CpNlWPCB732w/mKFwo6H556En+Ij8YdL4mrT1h6jiYHMOdmeyu/F1qLhEJycM5nRem25X
	 sSEuPA9DndqMr/SoEGRnh8CpkI9AaHeanCECDRyPY8y/k0C40BX/CZhsIi5t5eOIl9TS1
	 T6FFB58FmOzkhSLXQjpPLa33tvM9/rwYLKk/dGywiH11d552QNlDVa8B+a8sf519m3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6TzNM/+i2JvMBx0g7LB+OXbliGl/2j0SpRL70rw9MZE=;
	b=JyCN+UhgDfSjcPxQdhD+g3M6fw004i/4YYg2ZScTYyzM4GY1mHtsnujJiaqaR5nmHpT0
	 4zJXv/TsXLVXiBjt5MzMhKgH9VLNYtcfAHD2wjOgcedcHk22OhvbChNS2VDJX1Woqp6Uz
	 RNviukJi+YgbuRFCKu60J/Q9qxdpPbQcAtXsERG42KrObepDJm/SwH4Q0ypDHDjX6jkIA
	 thuAkpAuAM/edZ0c2w+/oNC/So+zGOQfbEXzbvnhRnldLLorDtiPcOW+9+1iMKM3NcaTg
	 MTSKQ7QF1Mr0UBW/gxNty4xSthHMIzDvcmIgk0N1KHxEwS6l0sCtvmq0W5qtOJrXIaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/fWrGHv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E0860A2635;
	Wed, 28 Oct 2026 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/fWrGHv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421CE1F01825;
	Wed, 28 Oct 2026 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209073;
	bh=6TzNM/+i2JvMBx0g7LB+OXbliGl/2j0SpRL70rw9MZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/fWrGHv74vvNFa9FYollyFhirqSVptTg/CiHMww5Ov+OoUv2r2/Wa28BuMhMBphF
	 Be8rDALEi3Z/D+yluwdOzqmz+Qlvuh/BZGqqiHj+r77h+X6BUdEZSPS/K/xNSdOViX
	 NUC89LFtEssenTsyB6UJKK1PmS0h0tfBUwGEdGTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 344/516] Bluetooth: RFCOMM: free the skb when the DLC has no owner
Date: Wed, 28 Oct 2026 17:58:16 +0100
Message-ID: <20261028170011.636687075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Skokov <skokovmaksimevg@gmail.com>

commit 9d1afbf60ed53c5b051cd124153e0ae3078c8b93 upstream.

rfcomm_recv_data() hands the skb to d->data_ready() and returns 0
without freeing it, so the callback owns the skb from that point on.
The tty implementation frees it when the DLC has been detached from its
device:

  static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc,
                                    struct sk_buff *skb)
  {
          struct rfcomm_dev *dev = dlc->owner;

          if (!dev) {
                  kfree_skb(skb);
                  return;
          }

The socket implementation returns without freeing it, and the skb is
leaked.

A connected DLC can have no owner: rfcomm_sock_destruct() clears
d->owner, while the DLC itself stays on the session until it is closed.
Data frames that arrive in that window still find d->state ==
BT_CONNECTED in rfcomm_recv_data() and are handed to the callback, one
leaked skb each.

The leak does not stop on its own either.  The remote runs out of
credits only once RFCOMM_RX_THROTTLED is set, and for a socket the only
place that sets it is rfcomm_sk_data_ready() itself, below the return.
rfcomm_process_dlcs() keeps granting credits, so the remote keeps
sending and the leak keeps growing.

Free the skb, as the tty side does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Closes: https://lore.kernel.org/linux-bluetooth/CABXGCsPe5wykd8Aj-hm+SJ7SGQyb8yoGNnx3XDpPmBathj+EGg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/sock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -50,8 +50,11 @@ static void rfcomm_sock_kill(struct sock
 static void rfcomm_sk_data_ready(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
 	struct sock *sk = d->owner;
-	if (!sk)
+
+	if (!sk) {
+		kfree_skb(skb);
 		return;
+	}
 
 	atomic_add(skb->len, &sk->sk_rmem_alloc);
 	skb_queue_tail(&sk->sk_receive_queue, skb);


