Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207199;
	b=W6A1v10kGNeaq6PwarE93voFKxn++g4DFAv4Rt5FSesILHFacBHsJViuQqhl+T8tkr7C
	 3AvHljC8dTQT/SOkOdDj0bU7DzH9QouieCOB8wjoHtwhMjfiHwBRzq57qHEoUNoduMYLa
	 7fuY/8Vem3ntFHPzcgCENy7W1zn5IU+lb8KiNwexQf6S5N9shUxAkON6mml6zbOexgpv0
	 X4LAyEbduWyMfKunMxYoDKXMIBVya4Ojay7Tse7RPabVGxtSSdPnRghndv8Qjwwkfzd8k
	 Z+oNrn2OoT+ynglYmAPaJuYD48kTPXHqRzW9tYLsu19DvHWSLfesa+o6xlNpnIZ/fYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YoFMiO4sExGrCZMqChe4hnY7E50ED43KmIxYswUYOiI=;
	b=yIHarHAl7S63ExEdPpKgdqClkHT87QldCJq5CKuFQhcg7E9xWlYI1LUezsQnGVvP1g7v
	 h6zXwSJpHAkeG16jJZkjIVkZZauN5Ijbu0W/81KPyuNJAk92rN/BKeW5GaDiPQMMTljXZ
	 00SnCQA6IaOv481b8sXksvlvXfVl/ZB16DAGgqv9Ngbm1iOOpt7Vq8R/wT4GHn5Mh7CgL
	 0J3eU+52NXyPpxH++hg1jWpTYPUwDfcmyl10BtyjDBux2DaAwy1gxCViAlvRusOFhQT/6
	 U5CFZBobYX1umMsMX788PhLW5lEeamLkGd5UaTqiRvz3Gry2zKosff+hnXCbyvdDWzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Owd/d+aV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9910606A31D;
	Wed, 28 Oct 2026 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Owd/d+aV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068911F01825;
	Wed, 28 Oct 2026 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207198;
	bh=YoFMiO4sExGrCZMqChe4hnY7E50ED43KmIxYswUYOiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Owd/d+aVMpbvdbz+Brb0EDgfLbB58TcK7GIyOYwK8QIkVARYfyIymkqYWj7GxU1/v
	 xRcB+x8Ueomg0yQqYdbO/XtE4Z0LXDRocxPYkkNucDt5IekfdZMAhhx74RfacFPf0u
	 axs1BfeRzJlB18md5KWNTqJ8wvISGIZXa1nl3TzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 06/88] Bluetooth: L2CAP: refuse __l2cap_chan_add if chan already has conn
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028165942.262922950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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
index 9a1b0ae07679e..fa17f235d5e40 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -622,6 +622,10 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan)
 	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
 	       __le16_to_cpu(chan->psm), chan->dcid);
 
+	/* Caller must ensure l2cap_chan is linked to l2cap_conn only once */
+	if (WARN_ON_ONCE(chan->conn || test_bit(FLAG_DEL, &chan->flags)))
+		return;
+
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
 	chan->conn = l2cap_conn_get(conn);
@@ -7412,7 +7416,8 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		}
 	}
 
-	if (cid && __l2cap_get_chan_by_dcid(conn, cid)) {
+	if ((cid && __l2cap_get_chan_by_dcid(conn, cid)) || chan->conn ||
+	    test_bit(FLAG_DEL, &chan->flags)) {
 		hci_conn_drop(hcon);
 		err = -EBUSY;
 		goto chan_unlock;
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 143654a47989d..7eefb46f06927 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -109,6 +109,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr_unsized *addr, i
 			return -EINVAL;
 	}
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	if (sk->sk_state != BT_OPEN) {
@@ -174,6 +175,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr_unsized *addr, i
 
 done:
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



