Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211442;
	b=np2cGg3CiGsmYHM8wWV1AfJc396LRS13QECIansj0k2r8jToztDC1wbIj2mt+rEKYABS
	 xPtXjMoKP/HBzOxcRCwLTW6EmSxvvvAN/0fsyTGWe7V4IIhynwV4BION25uNPO1QyopOi
	 j3PcGrl1hcII+zg2gf2JMJMe8f1bNDQYzA41omgcXw+NP9GDojZnm8wZ9CrDw3XHsD14j
	 eIL4AIN9+BJFww/YdHeW1pzkI0KGXSp0CWNZ01T+zsmaw9fQBdSLZpKyS6frSgqwfLF3S
	 HhoTtP2olU8HxrN1QzTrT2B0y1Qmh+P7r1EvJENDZgXYWp1IrvXD4FvzYbTp8aWoFRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bq3xuVoBaOnq2o1pZhVOolJE6Sfyd+yeP5n1Pxh5ib4=;
	b=bRiUxcxy1UPFDiMZ/0x4HOBdLUrHxoFIYa8fbuu2cVbD8HMgQ09gdA9eBn3dpGJQbWf4
	 TVkGQlLPV+fyhXxo35mdOk2EGVTCZzmITL8hlDFawC9K6m1D3ujizgS8Zqinb5ia1r0eH
	 KTV3G8m3Wi8vW5EKHP35SmhlMFbhdjA3vTivcnYbu2YEdDP8dZRhYvvSwIzcDSefWg6qB
	 NNJeQqYmOB5TeGrPKQguCNSAXCcc35Vehwpr9E5ey6FeFm1mnPOXm4tKOtr9DdVYGHOtb
	 flz24X/39zvX4v4u3Vbq6jcwZ+S7DPdqkuqaLZUxcB600oXpfd/jDvYsvjuRFm2KG6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zs/sdTs/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA95B606A325;
	Wed, 28 Oct 2026 18:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zs/sdTs/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A1E1F01828;
	Wed, 28 Oct 2026 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211441;
	bh=bq3xuVoBaOnq2o1pZhVOolJE6Sfyd+yeP5n1Pxh5ib4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zs/sdTs/rNVjxx1/3dPE5OQI5lWJVkfkFElJqlbJvQw91ZGxD2yQqIYCgnVUhFeU+
	 qZqKH0o6gvJL7W2wbZlgJB/xOHncZoIhJOIFGlVMY/Q3lPh72/fqWPWoAG9bXzWgFy
	 ZjMADYUCTPebnP3IZtMTpy8gqzOoxhI20Bw9H0Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 380/571] Bluetooth: RFCOMM: free the skb when the DLC has no owner
Date: Wed, 28 Oct 2026 17:58:47 +0100
Message-ID: <20261028170017.028434819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


