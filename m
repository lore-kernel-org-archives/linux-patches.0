Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211955;
	b=q/YZvAaQkAffTcKo7E+N8btiwky9OGixHHb9rIFLa27rKF2Wvf5xBV/4CllqG0X13LCZ
	 c7n5p3vewM5HVIm4YkZ3nFj8QHPRQF8epuN4/i5AvlrSLRziDbAznhzlQkWrkev+uWGIf
	 40hcPW7RKkgLwptA+4wtgJw27WvNf5sSTCsc5aD/g/2PZrYSMQZn8YlCOLUf7AiClFntl
	 /5WqviGWokzPka5YD1kezF+GCP78NWYWgIOpQc0LtaC37d/3sUT48Yp0rmQRdq1iOeyqZ
	 zFjWTLMSr5yxcVf7VLC3UBYcEHLOf0MeyISrttI3PYsYlrxSTjTsc+zqyLLbHjXDWUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7gEh8Rg/pmlAqV55AkGWcuq6uJ8pgDBzAfI2vjs84C0=;
	b=X9IupbP+2si19wqlqONccF2TupkAgcTkvawh34HFYrY7WfwLZrCFY7s9UXg3eEhMMVl/
	 /KAVIm+7Ojt3i1itmHmMaZx33KhmKdiCOharcTUpgS6MXVbDYzAAtIUA2PPlmfiZKzcoq
	 a0dqUKshI4P2JrQI+XAcYgn0gLPk5yBqTYuGp3CKNWUNPHQhPp/v+wrABp1td/IowwTO1
	 JU19tKXGE10ahLFgwcLJdfEYFp0MxOlAJYEd9Frpg449BthkN06hC4HZY04WycD0hCTMw
	 qT8iLpd3+kqqnt/n8MMusLxPD/Pjqmhrl2LnoxWwfxbiFvjFiS4rjBFBK+aYknR57xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YVZFR/ib";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2138606A31A;
	Wed, 28 Oct 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVZFR/ib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D52C1F01825;
	Wed, 28 Oct 2026 18:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211954;
	bh=7gEh8Rg/pmlAqV55AkGWcuq6uJ8pgDBzAfI2vjs84C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVZFR/ibN3pnFUu3y6vpDG9WfTWalwh8zEzBGtcBJCZW4q7WtPvLwX71VbVS7OgSH
	 2Xe7pz8uKB/ezomVmS5kDQVStHtYLBg32ndR5To/YmYThkUWPXvVHQ4Y55bUBkfvEt
	 D4ZcjnmvlU+4x3DcweAxBJKtclpFiLbIiNH0dBNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/571] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
Date: Wed, 28 Oct 2026 18:01:44 +0100
Message-ID: <20261028170021.252966912@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 86b55991d3cd690e73c5ef8d20b75ae4905b357a ]

l2cap_chan may be linked to l2cap_conn at most once. This is assumed in
several places, eg l2cap_chan_del cleanup.

There is a TOCTOU race where the invariant is violated:

    [Task 1]                          [Task 2]
    l2cap_chan_connect                l2cap_sock_bind
      l2cap_chan_lock                   lock_sock
      l2cap_state_change                if (sk->sk_state != BT_OPEN)
        chan->state = BT_CONNECT
        l2cap_sock_state_change_cb      chan->state = BT_BOUND
                                        sk->sk_state = BT_BOUND
          lock_sock <------------------ release_sock
          sk->sk_state = BT_CONNECT

l2cap_sock_connect() does not check sk->sk_state, so since chan->state
is now BT_BOUND, subsequent connect() ends up with second
__l2cap_chan_add.

Explicitly document and check the invariant in __l2cap_chan_add with
WARN_ON_ONCE. The only callsite where it could be hit is
l2cap_chan_connect, so add pre-check there to avoid relying on
chan->state. chan->state read/write is not properly guarded currently so
there can be other TOCTOUC problems.

Add l2cap_lock_chan in l2cap_sock_bind() to guard chan->state write.

Fixes: b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref")
Assisted-by: deepseek-4-flash # finding the race condition
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[Lee: Resolve context conflict around mutex_lock(&conn->chan_lock) prior to commit 56c2b5831d39 ("Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect")]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 7 ++++++-
 net/bluetooth/l2cap_sock.c | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 435c03d20ac1e..b127882cc02f3 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -598,6 +598,10 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
 	       __le16_to_cpu(chan->psm), chan->dcid);
 
+	/* Caller must ensure l2cap_chan is linked to l2cap_conn only once */
+	if (WARN_ON_ONCE(chan->conn || test_bit(FLAG_DEL, &chan->flags)))
+		return;
+
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
 	chan->conn = l2cap_conn_get(conn);
@@ -8355,7 +8359,8 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 	mutex_lock(&conn->chan_lock);
 	l2cap_chan_lock(chan);
 
-	if (cid && __l2cap_get_chan_by_dcid(conn, cid)) {
+	if ((cid && __l2cap_get_chan_by_dcid(conn, cid)) || chan->conn ||
+	    test_bit(FLAG_DEL, &chan->flags)) {
 		hci_conn_drop(hcon);
 		err = -EBUSY;
 		goto chan_unlock;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 046f3e6555f00..0cc0508298b96 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -109,6 +109,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 			return -EINVAL;
 	}
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN) {
@@ -174,6 +175,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



