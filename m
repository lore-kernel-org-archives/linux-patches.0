Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1183769FD;
	Thu, 30 Jul 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426885; cv=none; b=ioJ+uV7w9EyqQrJmoNNLXA5k4Y7XuMbt6vSulCJRgSjZMvSPHxPtvBTw/qzlkjQAa64n01INHkXL1HzCYigyzjKoFz4dpbPVTBEtQUDNFAS9mBsFG3WWUNP20YlSLBu0OoS+JXfLIf9dB5niSy5qBOrh/kfIrAjHx31L2TTg0wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426885; c=relaxed/simple;
	bh=PTvp98j15J8qHCd2eqB3N77yodiJfqf8BMbkxL9I35k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu0NWmgCZ1+4u/wVapd9V9+BDofxeyYh645lvNAnM8Ygye0zI/5WHv1bGRGumUhs+k2QekhHT7l1ZhsaNKXlz8p3sJbGO8tw8BrfjDdRX6okmRcvzICx905SMRrFQGUtsIeMPB3QEMxrFPd+Ar2TDdWUpqLTOWiQP9WnvbBrm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMxaoosd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMxaoosd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070291F000E9;
	Thu, 30 Jul 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426884;
	bh=twAoLBAbk1Y4bfgS6N6MRDN4d6Pgh1JjSPXJ0vhVq9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMxaoosdMhgxAHB4N9CUPLlq3uNFvi/AG306HLaaRpQlSEkrkOq/DMhcmEjl/mHya
	 Bp18Jljstwq3Uc+GyeZwQeKaVHMWu49SZgrkvPWbirLFlSwfcVKYo/ZZZokgQ7Ka3k
	 oavoMDjMRuk1W11zho8T+PQnx2TluM+qhupJLpo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/602] rxrpc: Allow the app to store private data on peer structs
Date: Thu, 30 Jul 2026 16:16:09 +0200
Message-ID: <20260730141448.176636193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit f3a123b25429dc03508e3bf598373005220b7203 ]

Provide a way for the application (e.g. the afs filesystem) to store
private data on the rxrpc_peer structs for later retrieval via the call
object.

This will allow afs to store a pointer to the afs_server object on the
rxrpc_peer struct, thereby obviating the need for afs to keep lookup tables
by which it can associate an incoming call with server that transmitted it.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20250224234154.2014840-13-dhowells@redhat.com/ # v1
Link: https://lore.kernel.org/r/20250310094206.801057-9-dhowells@redhat.com/ # v4
Stable-dep-of: 330e2c514823 ("afs: Fix dynamic lookup to fail on cell lookup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_rxrpc.h  |    2 ++
 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/peer_object.c |   26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -74,6 +74,8 @@ struct rxrpc_peer *rxrpc_kernel_get_peer
 struct rxrpc_peer *rxrpc_kernel_get_call_peer(struct socket *sock, struct rxrpc_call *call);
 const struct sockaddr_rxrpc *rxrpc_kernel_remote_srx(const struct rxrpc_peer *peer);
 const struct sockaddr *rxrpc_kernel_remote_addr(const struct rxrpc_peer *peer);
+unsigned long rxrpc_kernel_set_peer_data(struct rxrpc_peer *peer, unsigned long app_data);
+unsigned long rxrpc_kernel_get_peer_data(const struct rxrpc_peer *peer);
 unsigned int rxrpc_kernel_get_srtt(const struct rxrpc_peer *);
 int rxrpc_kernel_charge_accept(struct socket *sock, rxrpc_notify_rx_t notify_rx,
 			       unsigned long user_call_ID, gfp_t gfp,
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -333,6 +333,7 @@ struct rxrpc_peer {
 	struct hlist_head	error_targets;	/* targets for net error distribution */
 	struct rb_root		service_conns;	/* Service connections */
 	struct list_head	keepalive_link;	/* Link in net->peer_keepalive[] */
+	unsigned long		app_data;	/* Application data (e.g. afs_server) */
 	unsigned int		last_tx_at;	/* Last time packet sent here (time64_t LSW) */
 	seqlock_t		service_conn_lock;
 	spinlock_t		lock;		/* access lock */
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -510,3 +510,29 @@ const struct sockaddr *rxrpc_kernel_remo
 		(peer ? &peer->srx.transport : &rxrpc_null_addr.transport);
 }
 EXPORT_SYMBOL(rxrpc_kernel_remote_addr);
+
+/**
+ * rxrpc_kernel_set_peer_data - Set app-specific data on a peer.
+ * @peer: The peer to alter
+ * @app_data: The data to set
+ *
+ * Set the app-specific data on a peer.  AF_RXRPC makes no effort to retain
+ * anything the data might refer to.  The previous app_data is returned.
+ */
+unsigned long rxrpc_kernel_set_peer_data(struct rxrpc_peer *peer, unsigned long app_data)
+{
+	return xchg(&peer->app_data, app_data);
+}
+EXPORT_SYMBOL(rxrpc_kernel_set_peer_data);
+
+/**
+ * rxrpc_kernel_get_peer_data - Get app-specific data from a peer.
+ * @peer: The peer to query
+ *
+ * Retrieve the app-specific data from a peer.
+ */
+unsigned long rxrpc_kernel_get_peer_data(const struct rxrpc_peer *peer)
+{
+	return peer->app_data;
+}
+EXPORT_SYMBOL(rxrpc_kernel_get_peer_data);


