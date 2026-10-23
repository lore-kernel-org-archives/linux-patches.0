Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774567;
	b=iNA6o61CdThbFBYdcUon4meGjKrQSky7CQAcCpkiv3ZeHY8u3z1qF4YMGbIpB7AzoJ34
	 //c8eIOLOoiqw1og+eLfB2gESBuw3HCMLdPPfREu29rz5JeNpj+qHlFvj6FOhLtUmjyG2
	 Nd8peN+8BAdEgbcuO1Ou88kAX4Fzz9oge8JyhpuXVjwxVjXaAgtlBlNxaRcWpT9c5is4x
	 n18sAv7pIeZMiv5q5/jBXWo+Dfrlq36kcL9Ha3ULEkSsgoNBbYi8VzPgQ9pu/+1Q0GO+J
	 uiIJfDdLBshYxXQhECN56uClUsT7vVIIsFcDleaS1qLBGAojntqzHjyiv9F0qYNCIqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+FVLbHrp2pgJo7rsU65PwOW0ZL4kf/XkY6xET8xB2Gk=;
	b=o0szInkVrKG4R73X2Yf3RrsLzgk3kPAsmZNyozbVR8163kDajlPDN7KQMCIZxaC7SJiY
	 DhseKHo3OilfU8C/C/04yyDMe5DPrGUMrUvX3wuhhWIXah4nN0/JS0FZ2GZF8wt/8Ud7w
	 jMrckWC6nDHUTYS9WX2Jpjxb5cAjvBW+2InJwk60Ijw+M0WtLvLi9jcNnzYk1gPexJ4KW
	 MdQW5dH5Ad2x0ccFlR+DOQeDM5rEWEIT/AFWZ9HyWbJFoiMMJqIwQPVE978bNpcWoiikJ
	 OcHaNoJSzwt0MItaA+T0iluxalW4TC7KkUGYYQm70ms1qb5YmR8k8Fl6gzpjDJIQlxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5gCQbTh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8098E606A31A;
	Fri, 23 Oct 2026 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q5gCQbTh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBD61F01825;
	Fri, 23 Oct 2026 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774567;
	bh=+FVLbHrp2pgJo7rsU65PwOW0ZL4kf/XkY6xET8xB2Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5gCQbThDJzsFndI1Q2uvyKC+x81+x8+iRR3rH96VBE+doorPHAGy/A7BNgF2IkQO
	 /B60K9DKjuCTd0iJuVyHLhAX7OCYbElKbU2TxYrvSUcStDN2mJ2qVSegeiFkDMdPpE
	 WtrAUWTedNOSPBk1UXw8OFR5HoPR/o4pBZXeMHpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 083/242] net: bcmgenet: unshare the skb before writing the control block
Date: Fri, 23 Oct 2026 18:38:45 +0200
Message-ID: <20261023163715.741164665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e8908916558b1..f4cfbff49a1b8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2153,6 +2153,16 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
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



