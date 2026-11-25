Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619556;
	b=JTy6ub8XrsCO2ihqu88auL3aQKgB78ohhcxtobg3pXi2KKoxqMV7vRFNA+7wWF1X6Gta
	 eLf8dE/EijnMEc7TLkPTAmOl/Z0J8SbyWbusHjrp8QnZgF4NAYr9OF6ReNx6hEsWIpKdQ
	 4McbfKQwgOc6M+StLm9Q15nSumk4zHLbYUHgJgozt+DlpzgtfbnT/W21xHuBH9xdJjhVl
	 d8+4jmJmIKXklj4BNRwlPQSudUVH9/2ejqrj1HOxlpUpzcFc44Z6gEuFjALULu75T9Mgb
	 homIlwDyRj7v2e0xF3sWvAajvegq0GP0uRV7NNXFdUVNNWOfybQ3CLL8uu2/a41Pjng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1L6WQEFGWB4LfqBUMRkoCPsmKJ8nant+SxVwdlDNEM=;
	b=TBw8KVL5BsCNBT7J+OAOB2G4kytOnInIaBmB69tZaVi3tTAfz35Akooi4KOeNneX8M/2
	 KoDmCdkzaxDRaOEpg6Lek0RIuSQvP2sh2TfdzgGdi9Fjxy0AEi6bxjhb0EUeMih+r0Mjd
	 utGRE+TEpBz6ezgXxnn+oYWFlF1m5/to7wASG0mPHz6e4MMwWJzdWEy/FmBzp8Wpz0czu
	 EvS+b89rLU8U/whrzjQ4hj6J6d75l/hMsq2TOveTzwXETskM9j+r6Q1Jx04bSCH5uGQi5
	 QbO8VueGw6YnscgHAzDZtn64/pdOp+fWufrFTWsJb0M+n+1xeMakbY+aWeu/cKBiDDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wrtvvcj+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F93606A682;
	Wed, 25 Nov 2026 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wrtvvcj+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEE31F0093C;
	Wed, 25 Nov 2026 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619556;
	bh=v1L6WQEFGWB4LfqBUMRkoCPsmKJ8nant+SxVwdlDNEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wrtvvcj+rkpmYXOD3tmATha/5NJ/NUcz62Gm8LEMyozESXjIHGfb34LH7Qpe0teXS
	 PUaE8fmBme9KwEzuUTcw0/fGcxRpqgoeNshNaaqYwRTwmBlMQ71KN/F31rvo313uCO
	 hG54ZnPnSAq+HjWUUOuz/U2FUSoJOx0J0nlgehN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 0634/1005] xsk: defer software checksum until the skb is complete
Date: Wed, 25 Nov 2026 15:32:52 +0100
Message-ID: <20261125143836.604547959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rongzheng Wang <testwrzwrz@gmail.com>

commit f2eddafbfcc004098425fee7c5664adbe29152d7 upstream.

When XDP_UMEM_TX_SW_CSUM is used with multi-buffer TX, xsk_skb_metadata()
calls skb_checksum_help() while only the first descriptor has been added to
the skb. The checksum therefore covers just the first fragment, and
skb_checksum_help() sets ip_summed to CHECKSUM_NONE, so the remaining
fragments are never included in the checksum.

Move the software checksum calculation to the point where the last
descriptor has been added to the skb.

On a checksum failure the packet is now dropped instead of being returned
to the application for a retry. This path is not reachable with the
existing metadata validation, but the behavior change is intentional.

Fixes: 11614723af26 ("xsk: Add option to calculate TX checksum in SW")
Cc: stable@vger.kernel.org
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Signed-off-by: Rongzheng Wang <testwrzwrz@gmail.com>
Link: https://patch.msgid.link/20261104034809.24545-2-testwrzwrz@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1011,14 +1011,6 @@ static int xsk_skb_metadata(struct sk_bu
 		skb->csum_start = hr + csum_start;
 		skb->csum_offset = csum_offset;
 		skb->ip_summed = CHECKSUM_PARTIAL;
-
-		if (unlikely(pool->tx_sw_csum)) {
-			int err;
-
-			err = skb_checksum_help(skb);
-			if (err)
-				return err;
-		}
 	}
 
 	if (flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
@@ -1030,6 +1022,15 @@ static int xsk_skb_metadata(struct sk_bu
 	return 0;
 }
 
+static int xsk_skb_sw_csum(struct sk_buff *skb, struct xsk_buff_pool *pool)
+{
+	if (unlikely(pool->tx_sw_csum &&
+		     skb->ip_summed == CHECKSUM_PARTIAL))
+		return skb_checksum_help(skb);
+
+	return 0;
+}
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
@@ -1277,6 +1278,12 @@ static int __xsk_generic_xmit(struct soc
 			continue;
 		}
 
+		err = xsk_skb_sw_csum(skb, xs->pool);
+		if (unlikely(err)) {
+			xsk_drop_skb(skb);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */


