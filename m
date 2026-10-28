Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215669;
	b=oQp2tOVk92Oxcov5/wXjYiI8MmR8q7jKdWBsJGTvUtPwQol4Mm9oeNGbjWY5bME4lvfc
	 SBuNT6oHBTVgRAYe9nvvenkT2RxQyI4fCCMG0tMw5LA1t8GdYDdHHcuxPvJ7oxOpDw58v
	 fSThEFD8yHRStKWkVlTPyKJc09Np/9IOsybu3oPSfbJ/ME1VDsVv8Uj7+uV1TmLzxPcP9
	 E8YcJ+W3rCEG1VlA6j49GhAFNWRNIx6JpwBJclnkcpyRpeDsrjYkbAm/NE9yHDaYkRjjg
	 HJBFIbIU1l5xHoxZv4GhNdHywKyNF71XgJ+T2MgLvmS4WhudzEBZRjE1dHr9zF+pcZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62e1ulYSatL0o+XkN9zxySl5F3vQgu+CDI6xtpPzeGY=;
	b=QwWbThtF/sZ3Khb6y76a9Ei9zgUYSL/Xfp7SyYk3xFbx6DM8pmz8GIhMo0/Dqv/c62fk
	 IkOpJGs8MNcUg3ZdWqEEbLhazIMycYinfulMRI8QkAB98KkZO2/rO+c8tJDSzrjLXNv+y
	 SbTBq8Lwp0RDAjergWDWpIHv5DG+1b2pqs9QGDbFI6FThpk185mH7C2B4xg6LGlx0aYUb
	 si4HWu89QUxlhTqCR/BBpl2Cs3XNnQjXwvKgnVJT4TlZ/guNuP75cR3bhBR1yQKM7E0JB
	 dY77S8LGp7dOGxmqmLVprwJ+RFQLmlxTxtGjB+lhlj96ylDWYCl0hOEfdCtRssTGfCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxkKH6Ru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CAF606A31A;
	Wed, 28 Oct 2026 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxkKH6Ru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1BF1F01825;
	Wed, 28 Oct 2026 19:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215668;
	bh=62e1ulYSatL0o+XkN9zxySl5F3vQgu+CDI6xtpPzeGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxkKH6Ruv7bcxJs8CafTmuS/E29zx6Je9I1LXdCUrg0GTJKqIrquKrw8COvJqSpHr
	 wunp+HI3IxUbwtLNi4ew7r0k5AOurCGqTKHHwBCgffsqiJYBYAprsKYMghBb66JfTY
	 dsgMb+N7K+aUwV57P+NKXGq3Roml5RJM5hhlQcOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1291/1887] net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()
Date: Wed, 28 Oct 2026 17:56:27 +0100
Message-ID: <20261028170528.805655115@linuxfoundation.org>
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

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit 3874892dd27d5387aa9a06f58d9060f18f351d24 ]

The commit 4f61f133f354 ("net: tap: NULL pointer derefence in
dev_parse_header_protocol when skb->dev is null") fixed a crash in
tap_get_user() by assigning skb->dev before calling tun_vnet_hdr_to_skb().
This is required because virtio_net_hdr_to_skb() may invoke
dev_parse_header_protocol(), which dereferences skb->dev. Without the
assignment, a NULL pointer dereference can occur.

However, tap_get_user_xdp() still parses the virtio-net header before
assigning skb->dev. When the vhost TX path passes an XDP buffer containing
a GSO virtio-net header but the protocol is set to zero on purpose,
tun_vnet_hdr_to_skb() can reach dev_parse_header_protocol() while skb->dev
is still NULL, resulting in a crash.

Fix this by looking up the tap device and assigning skb->dev before calling
tun_vnet_hdr_to_skb(), matching the ordering already used in
tap_get_user(). Preserve the existing RCU read-side critical section across
dev_queue_xmit().

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Cc: stable@vger.kernel.org
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260802224612.264563-1-dongli.zhang@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9124601d658b4..5b4b07e669cd1 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1179,10 +1179,21 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (!tap) {
+		kfree_skb(skb);
+		rcu_read_unlock();
+		return 0;
+	}
+	skb->dev = tap->dev;
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			rcu_read_unlock();
 			goto err_kfree;
+		}
 	}
 
 	/* Move network header to the right position for VLAN tagged packets */
@@ -1190,15 +1201,8 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
-	if (tap) {
-		skb->dev = tap->dev;
-		skb_probe_transport_header(skb);
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	skb_probe_transport_header(skb);
+	dev_queue_xmit(skb);
 	rcu_read_unlock();
 
 	return 0;
-- 
2.53.0



