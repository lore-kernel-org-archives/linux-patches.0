Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217125;
	b=FUIG0fZ91IzYFrPKP8McqZnQVmyG/ITFPrjU6ax0kAedCPWHbKSfRXv1JxuzrHb4XVNN
	 Ax8KAN/iEVfw2jJsrZkkaIlg/WzL1b5ClixW5n3kAwYI1G63TmLRdMJZByZ+5LQtilNs4
	 57KU64r4k3Rd1FT9QuNAx/Ha94IxDmeIK+o2jmQTI11sX+HRGynldaKfazYR2ofNlasRF
	 OccjFIAG5MW+zRjhEqziptS8z8ODxSgZZzRPD4mlPJVzNvj4mckVKEaBZ8GlpwRxI2drv
	 AciQNFdh57V8EiVc9cogDFr2HNTnx0W3XJOX3TZ9jNyh+HBCEVvkBGLBdBJ1OHtwe6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I+u30XajTKXgMz70Ufgv+KDlIBvXvH1PplvAW2tWru0=;
	b=WtX1C+8rF2Ndwv08Y2GU2q9LCJ/ug0CNGiTXVoYLetBX07OeWQErmIAGWf15LmxOHYRD
	 BiAognlN0w5EmONjDpPGH7zmO7b8HRlq85Hu9+qJSHoCK1BkO72s0gnoiFwGWvL1NBAl7
	 JmpnQFYyjjtlshoH3PGOLhgD1g68+SoRDqrIpC/WCYR3C/DkOZ8oHxfNdU6ob22rK4KYz
	 sUARv7pCye7pFr7K4/Vjg4B9FNMDzs9aNx87tsnVhsPE+JFtwHLDM9yQz0XCgh5k8ck5i
	 4NYaaTvQNGuQznlLI/W1VeUyD1Q4QwYZrT6EvVNNwpb4uwpICDB8NVjk1OsQu6HoHgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZel5rQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FB0606A31A;
	Wed, 28 Oct 2026 19:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZel5rQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937A51F01825;
	Wed, 28 Oct 2026 19:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217125;
	bh=I+u30XajTKXgMz70Ufgv+KDlIBvXvH1PplvAW2tWru0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZel5rQW2Dxi77uo91nGPn7aPpmaBQFj5tTy7loT/iqzRtzCPX39bBgkqXSMifk7i
	 LNlmZY578gah4z3/5vyM7ZZiYFR9Ks5yr5k2CI8VHA1wlFrxtNALVCBXXk43f5ngFD
	 OaKia4CPp1LMWXhhZpeVDfexMJBQt0CF/C/9NSVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1798/1887] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
Date: Wed, 28 Oct 2026 18:04:54 +0100
Message-ID: <20261028170540.362709987@linuxfoundation.org>
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
index 15bb4ca915134..ea41bf1efc6da 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -630,6 +630,10 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
 	       __le16_to_cpu(chan->psm), chan->dcid);
 
+	/* Caller must ensure l2cap_chan is linked to l2cap_conn only once */
+	if (WARN_ON_ONCE(chan->conn || test_bit(FLAG_DEL, &chan->flags)))
+		return;
+
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
 	chan->conn = l2cap_conn_get(conn);
@@ -7428,7 +7432,8 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 	mutex_lock(&conn->chan_lock);
 	l2cap_chan_lock(chan);
 
-	if (cid && __l2cap_get_chan_by_dcid(conn, cid)) {
+	if ((cid && __l2cap_get_chan_by_dcid(conn, cid)) || chan->conn ||
+	    test_bit(FLAG_DEL, &chan->flags)) {
 		hci_conn_drop(hcon);
 		err = -EBUSY;
 		goto chan_unlock;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index b11558b0dfec5..655922aa82f1f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -111,6 +111,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 			return -EINVAL;
 	}
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN) {
@@ -176,6 +177,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



