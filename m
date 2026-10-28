Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207917;
	b=d2QEDNC82NZPyaqr/4T25Kkc9iRHfC9ypH1TSkapAN40i0UiuDqN3z2rKJb5En40BNf1
	 XlGL2USieEncfWhp2mcuc2ongbLtBn4ELDRpsrD4ycEYQZ1l2KOBO1HvPjPBjy+XHVxqK
	 dg4UvZaT1qkeu7Ybdt+rsKIxPB53C8h4Kat7bA7SVPC2WGuQoLLnoBVvLzqmtD4j5SJQ/
	 goZDjtCfLHLnkuVlX6U1WjxljBVSnWS5s4Urs1VcLZNW8mMAYzd3/aSVsgSc9JTO/wni1
	 JTnP3hCa1XRYGvtF1kFXgDOBs7GFAlCWphLUzdk7nwGsyknfVd2lvzTmzfshX4q6BLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0rf2aL3pmWscdi0Rse5D7Zlia4RaFkdPZgekJjDQjE=;
	b=tkxxBUaDJzClzsVakdSELrwbQCTj7dT7niHkNuCJSms99VD6Lh7yRC8gzNDf8KUAWfvO
	 s7oNMocSwQZLQ9FoRe2N7tcj1L6qfbbu0XsVhg6xLgQCQNgFqUGJ6zGfifwIbCqGQUDx9
	 GIwTuymRl1YuejUV1QRfVESp87kibxvP7LrmQ93/VLu+qu7ZJzGoPdk3Oze1nySuIQjte
	 ehJ5218BmDUX/CV0+2f/xFLSvdexmugnLV6ZXeawfx1P2sbnIVrDSbYemFL4T+GUinNeG
	 0u9p3NMU8cekMCpvrg5s5XQEc6jkvLiItKiP8Ik1o/azb7/8St2SSF1S6KPacYcxMVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oy4fT3ml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC31606A31A;
	Wed, 28 Oct 2026 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oy4fT3ml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CF01F01825;
	Wed, 28 Oct 2026 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207917;
	bh=G0rf2aL3pmWscdi0Rse5D7Zlia4RaFkdPZgekJjDQjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy4fT3mlBR6v7Mwa0f5JV6MG8FKk4+/6OH+EcC9UYn3tss8lE+l8QkOo5x9yIKmS4
	 9S8kdyG1lNvk5qXRZVIJQ9c5r9r0w1JHWysmkKtfHtF/laYP+tnATuhBhkdcnItXOr
	 7KNT2OjW/rv+n3JYdlyeQUqW/EVYsIdC0kxnduYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/247] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028165951.825767626@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 7 ++++++-
 net/bluetooth/l2cap_sock.c | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 61914f280d6fa..894fcd779bd03 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -625,6 +625,10 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
 	       __le16_to_cpu(chan->psm), chan->dcid);
 
+	/* Caller must ensure l2cap_chan is linked to l2cap_conn only once */
+	if (WARN_ON_ONCE(chan->conn || test_bit(FLAG_DEL, &chan->flags)))
+		return;
+
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
 	chan->conn = l2cap_conn_get(conn);
@@ -7388,7 +7392,8 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		}
 	}
 
-	if (cid && __l2cap_get_chan_by_dcid(conn, cid)) {
+	if ((cid && __l2cap_get_chan_by_dcid(conn, cid)) || chan->conn ||
+	    test_bit(FLAG_DEL, &chan->flags)) {
 		hci_conn_drop(hcon);
 		err = -EBUSY;
 		goto chan_unlock;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ef3af57e4637f..f08512a57ab58 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -112,6 +112,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 			return -EINVAL;
 	}
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN) {
@@ -177,6 +178,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



