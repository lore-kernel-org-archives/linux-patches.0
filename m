Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207534;
	b=3Jc0MrVllO9MeqRh5rAZQSpaVFGWyWBWojp+GNWQ+Qf2NT8K/2oW+FvutLyHeXo/3May
	 1dWiE6rlCVgeV8jzEbU/7NANWlyZ27t8pLyB53hFafg7a1UUN9POOgd7StXfosxoYxv4X
	 gtAI5WPHswrCnnueDks6FdXXyLaFy9ZZMl7l0H1gy5Rfn8Wn01+c8/kC5cdhvu/0ayN/x
	 OV0FIlBDSpBvELKznCySNogahdJnaB2vFzu3OTQePpBQbN4CuWFxZxPa66TVH1rfjZDww
	 /RrMxBAxQ89hUQmsM4FfpdsOJOsE0rfUyhnojWWeapTQzFPvW4Iv45RXRSRwZseT/9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q/7M6A9CErZwHbeKJEQfN5kmZ5rVFYeT9zu/iHi7RLo=;
	b=UotMI5D9bRQu5Z1PukHucKQpsiNvvi/9lV7Z+4oeN30B3VAiSw9XDzYgMaQZsmDvvRNV
	 Bf358gkewK82/17UBy6da4FPgSQ7i85t2NnIhDgM9YJzU2GdP/YDdxijbKJAWYRu3YXKV
	 cymXy05NoPTt0TLF0eV5xFlz+Tho9M5Ebnz9EUGr6X/WCkyoRGJHgLhtO5I2nzOz+32iM
	 bLbWxNcSF2HTqn04cz45vhdLxH1/ESryV94qt/mJDxsTSHjQOmUjh1GQ0EWcfsR+jKc4R
	 /iKLa1JWCP+157sVbPm5jFjqA3xsSazBIgAldoCcrVRxlCB5IFUgXD4B5o7u/n888nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dg6ZbK9/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00653606A31A;
	Wed, 28 Oct 2026 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dg6ZbK9/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51ED11F01828;
	Wed, 28 Oct 2026 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207533;
	bh=q/7M6A9CErZwHbeKJEQfN5kmZ5rVFYeT9zu/iHi7RLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg6ZbK9/g4MaRGuSVcHiFJTuk54UrILvnxa/xJ6VHv9P2807yGDzvKrOz4EMwC1/Z
	 1V5ZdbNam81EkzuRzySTZZ8vUR6hjAiKGE5q6PGEheJcpwmNxQvKNDitaZ8cfcLgW4
	 v2QMkMTzNVFem+1Wi0jtKtNIHmRqhM05l/24Fz3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/247] net: bcmgenet: unshare the skb before writing the control block
Date: Wed, 28 Oct 2026 17:57:34 +0100
Message-ID: <20261028165948.585831787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 89771ce4f8f67dcffae561b2ccac95c0f6e3aa01 ]

bcmgenet stores first_cb, last_cb and bytes_sent in the skb control
block and reads them back on completion to free the skb and credit BQL.
ether_setup() leaves IFF_TX_SKB_SHARING set, so the stack can resubmit
a shared skb that is still in the ring. The next transmit overwrites
last_cb, so the earlier slots complete without crediting their bytes
and BQL stalls the queue until the watchdog resets it.

Unshare the skb before writing the control block.

Reproduce with pktgen in clone_skb mode, which hands the driver the same
skb while earlier copies are still in the ring:

  modprobe pktgen
  pg=/proc/net/pktgen
  echo "add_device eth0" > $pg/kpktgend_0
  echo "dst_mac AA:BB:CC:DD:EE:FF" > $pg/eth0
  echo "dst 192.0.2.1" > $pg/eth0
  echo "clone_skb 8" > $pg/eth0
  echo "count 0" > $pg/eth0
  echo start > $pg/pgctrl &
  sleep 5
  echo stop > $pg/pgctrl
  wait
  cat /sys/class/net/eth0/queues/tx-0/byte_queue_limits/inflight

inflight stays nonzero on the now idle queue. clone_skb 0 leaves it at
zero.

Fixes: f48bed16a756 ("net: bcmgenet: Free skb after last Tx frag")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261009-nb-genet-shared-skb-net-v1-1-c6d0a841977d@tipi-net.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 7da4a2114a771..0402e8f69c6fa 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2095,6 +2095,16 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
+	/* We store Tx state in the control block, so the skb must not be
+	 * shared, but ether_setup() leaves IFF_TX_SKB_SHARING set.
+	 */
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
+		BCMGENET_STATS64_INC((&ring->stats64), dropped);
+		ret = NETDEV_TX_OK;
+		goto out;
+	}
+
 	/* Retain how many bytes will be sent on the wire, without TSB inserted
 	 * by transmit checksum offload
 	 */
-- 
2.53.0



