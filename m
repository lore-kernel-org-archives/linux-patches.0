Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618480;
	b=0N+x8RYQ339GIu8AswLlYGEHRDaUKgtSd6Ybe3ki2fyzm9DqJl4lwojCQzKBB+vu89Ct
	 cAdn90SUZPloYKTb33QLGHWyqjNwI6ZJR6wbNCcTy4w5CBhB7dJMM7p+v459K/B7mpzTz
	 FFDGt3N1LwCzsHpnxIm0S14QEvAPkNNUSnCSp5gEsl0vPzjNZdZviQkSKnJm4ge0TebnW
	 KuV/jfvwKvxc4z8OcpkZf7aM58oY81RBPY7muhgIkmpHxLHpS8ApurqEYab9h1lUxtBbd
	 S40FZeCba6WzxdQ+OzgH/wD16rMisVyG+gDzBhvuxjSCeiO2K9tCT9uKeccj/c0+gzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6UkWdwPpJlFtA0j1XZDt0ffnZSLyxh0bb718g8uU5fw=;
	b=eB1ryWdG16noHaWvRaiCtMAk1Qrr1EIhkPfUI0wO6GrPYoffeAomZrKe2FGyWoNGe4dX
	 +GTrGjX3jc0tSVVDdDCImk2vIM02cEDRmd9fTiwfiy4/xl6C9VjMTKJpV3NotpuogepkG
	 Jx4mExnBbpcUJdLIsSAx/5JsxcrNRKeqiq+YME6whwRmuYWQSiGSXX9g8A7ix6GQkyRQJ
	 YhIIUTUMrpMW+9Y700ODsUg7mIJj1bNQzAynVSTs7Km1PfcI0WgpdQeX2i7jnWvDwavYx
	 r42i2avIUSWRY2u/+iWtYfEd7OHx4ZF06EkRVQ8jXW4BWiAWywivFNyL5iZvmRXiYUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqnBqNAH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB1B606A321;
	Wed, 25 Nov 2026 14:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqnBqNAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056EB1F000D3;
	Wed, 25 Nov 2026 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618479;
	bh=6UkWdwPpJlFtA0j1XZDt0ffnZSLyxh0bb718g8uU5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqnBqNAHZMp1jCwIQu0ixXowqhvYCM9QOQLE9dXwJE1f9hctDmU/L9410gqf/1C96
	 fuk+C7Ww/PYEHMVYNlDju4q8RRQ9PJ1B8Bf7n0VnRqPMQSkPZA175iWMkqLy9dmF4n
	 HbG0QSEHmjK8Plrp4lauE5anSNP2V/M3KK1jJVl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0292/1005] Bluetooth: L2CAP: Clear request identifiers on incoming LE connections
Date: Wed, 25 Nov 2026 15:27:10 +0100
Message-ID: <20261125143828.578426783@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 15a80cc8263abd50132a05d1b06824de8e28abcb ]

Incoming LE and ECRED channels retain the peer's request identifier
after an immediate response. The deferred LE response also leaves the
identifier set, unlike the deferred ECRED response.

A later ECRED request can reuse that identifier and include an unrelated
channel in its shared-response handling. That walk matches on the
identifier alone, so an LE channel is selected too. If the old channel is
closing, the checks can refuse the new connection. The check at request
receipt rejects it with L2CAP_CR_LE_INVALID_PARAMS; the check before a
deferred response returns L2CAP_CR_LE_AUTHORIZATION.

Store the identifier only when deferring the response, and clear it
after sending the deferred LE response. Keep deferred ECRED identifiers
until the shared response is sent, since a partially accepted group
still needs them.

AI assistance was used.

Fixes: 27e2d4c8d28b ("Bluetooth: Add basic LE L2CAP connect request receiving support")
Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 01d3fa02c7502..fdf92a3d57455 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3958,6 +3958,7 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
 		       &rsp);
+	chan->ident = 0;
 }
 
 static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
@@ -5207,10 +5208,10 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+		chan->ident = cmd->ident;
 		l2cap_state_change(chan, BT_CONNECT2);
 		/* The following result value is actually not defined
 		 * for LE CoC but we use it to let the function know
@@ -5442,10 +5443,10 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
 		__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-		chan->ident = cmd->ident;
 		chan->mode = L2CAP_MODE_EXT_FLOWCTL;
 
 		if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+			chan->ident = cmd->ident;
 			l2cap_state_change(chan, BT_CONNECT2);
 			defer = true;
 			chan->ops->defer(chan);
-- 
2.53.0



