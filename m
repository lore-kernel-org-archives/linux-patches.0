Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020230;
	b=n1CvfjAYC2cTk1Ev53N8HF0tAzv1quBsxuAW5PbsrswGq2MaFNTekqZkYGopFF5yfM9B
	 iVFpYbvA6CsO8ABj3yBV3j8vCWu88j0v3tR4QdZxgpbR8S7ateoAD1Hz5zR8NeL2vuGPl
	 SzAR63V0odz3aDf5OsMSGzR1JmaHr9vLQdCUHJ2NPk1b18a7ac5vEy6w3wuaZO/vXiolA
	 tq6jOCCCVylmFu+iTyFA5xO4VkXAu4u1kDbKzEt8Vn9dbCduIi7UzBHXWDsFBH7GaNR7n
	 Lz2aHdXVh7DCfXnjnJ5UFmSgy+ls6vpyMyBbEviTrTEVgQCIdMVbrflH3IMi6uJ9m5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/yc9+3hb3ofuzOvtKEr5sq0fl9JRfWKTuJ7It8RwAUk=;
	b=xowZNqXnIn3IQ0JAFZMjXcfqoP8kEAy/9bzhyhWcwaGYtjhA9EC4LqvU//Dwd+c3g0Jm
	 CX6xzUj1W8CfeTZn2xLyCnCwW0PbZtIB4WaukuaF7wCUTGfqB8tPKXwLZxdFxjNhhPoO1
	 2NSti4+FXJS0ywQzC4YTSiPbBtMQxNK+YnzkBohKvJ7MxA8TjUF+M3lR9DtbHB6MpKGvN
	 EECGG7wlXcbiT5TVtz7yTry+OE228hoOdbr0EKLOsAygbDNW6nQRgcjDHa0y8oR+t6bcf
	 dt8T6gf/ijpd0MJDCjVDioJiLswUOL1WUMNnnM9Z7O9Uptj77Hr4+m0E70hXAnP5aTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3NmgP4D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D7A606A320;
	Wed, 18 Nov 2026 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3NmgP4D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3061F000C6;
	Wed, 18 Nov 2026 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020230;
	bh=/yc9+3hb3ofuzOvtKEr5sq0fl9JRfWKTuJ7It8RwAUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3NmgP4DvC3cYFJuzw5OGw30Blrn/jElnlxalJTt1H1G0XfkfvUUO+Z3sb8qgrIeD
	 +Wk8g0vqk3WjhIrVdwF7JqaWFXfS8Kd9ftvp575mgO1wJOZQeickoZx+cSRjDs+pbc
	 qQbUahsAOxDAjxrBloaYvdi+8jy7t1eUgu1b5SbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1875/2651] Bluetooth: L2CAP: hold conn->lock for __l2cap_ecred_conn_rsp_defer
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150354.450290630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 32d86e048d8efedb7aa6cbbd3c36c3c435401c92 ]

__l2cap_ecred_conn_rsp_defer() > __l2cap_chan_list_id() accesses
conn->chan_l which is guarded by conn->lock. The lock fails to be held
when calling from l2cap_sock.c.

Fix by using l2cap_chan_conn_lock(), and taking the locks in required
order l2cap_conn::lock > l2cap_chan::lock > sk.  Leave fast path with
sk->sk_state precheck.  Move the L2CAP defer handling to
l2cap_sock_defer().

The code should also take l2cap_chan_lock() for sibling channels, but
that needs separate fix due to lock nesting.

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 68 +++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index fed7c0967da28..d8bb987deb3d7 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1249,40 +1249,68 @@ static void l2cap_publish_rx_avail(struct l2cap_chan *chan)
 		l2cap_chan_rx_avail(chan, -1);
 }
 
-static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
-			      size_t len, int flags)
+static int l2cap_sock_defer(struct sock *sk)
 {
-	struct sock *sk = sock->sk;
-	struct l2cap_pinfo *pi = l2cap_pi(sk);
-	int err;
+	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	bool have_conn;
+	int err = 0;
 
-	if (unlikely(flags & MSG_ERRQUEUE))
-		return sock_recv_errqueue(sk, msg, len, SOL_BLUETOOTH,
-					  BT_SCM_ERROR);
+	/* Fast path check */
+	lock_sock(sk);
+	if (sk->sk_state != BT_CONNECT2) {
+		release_sock(sk);
+		return 0;
+	}
+	release_sock(sk);
 
+	have_conn = l2cap_chan_lock_conn(chan);
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECT2 && test_bit(BT_SK_DEFER_SETUP,
 						    &bt_sk(sk)->flags)) {
-		if (pi->chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
+		err = 1;
+
+		if (!have_conn) {
+			release_sock(sk);
+			err = -ENOTCONN;
+		} else if (chan->mode == L2CAP_MODE_EXT_FLOWCTL) {
 			sk->sk_state = BT_CONNECTED;
-			pi->chan->state = BT_CONNECTED;
-			__l2cap_ecred_conn_rsp_defer(pi->chan);
-		} else if (bdaddr_type_is_le(pi->chan->src_type)) {
+			chan->state = BT_CONNECTED;
+			release_sock(sk);
+			__l2cap_ecred_conn_rsp_defer(chan);
+		} else if (bdaddr_type_is_le(chan->src_type)) {
 			sk->sk_state = BT_CONNECTED;
-			pi->chan->state = BT_CONNECTED;
-			__l2cap_le_connect_rsp_defer(pi->chan);
+			chan->state = BT_CONNECTED;
+			release_sock(sk);
+			__l2cap_le_connect_rsp_defer(chan);
 		} else {
 			sk->sk_state = BT_CONFIG;
-			pi->chan->state = BT_CONFIG;
-			__l2cap_connect_rsp_defer(pi->chan);
+			chan->state = BT_CONFIG;
+			release_sock(sk);
+			__l2cap_connect_rsp_defer(chan);
 		}
-
-		err = 0;
-		goto done;
+	} else {
+		release_sock(sk);
 	}
 
-	release_sock(sk);
+	l2cap_chan_unlock_conn(chan, have_conn);
+	return err;
+}
+
+static int l2cap_sock_recvmsg(struct socket *sock, struct msghdr *msg,
+			      size_t len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct l2cap_pinfo *pi = l2cap_pi(sk);
+	int err;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return sock_recv_errqueue(sk, msg, len, SOL_BLUETOOTH,
+					  BT_SCM_ERROR);
+
+	err = l2cap_sock_defer(sk);
+	if (err)
+		return err < 0 ? err : 0;
 
 	if (sock->type == SOCK_STREAM)
 		err = bt_sock_stream_recvmsg(sock, msg, len, flags);
-- 
2.53.0



