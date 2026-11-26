Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705138;
	b=mq+2rvlNIdwXnDo3JHVXlrw8H2MgpgTTs0kCyW+NgD5rcQUEfLjIs4Ej/hjtv8E27ona
	 ZYt+6k5hMalc/C1dWbX7k4UlfeiX4Q7NqKz5M1uPyb9tfj3zEcDDFVRg4oGQUFtBa+yeC
	 owVWb14R0vjRLkLB3z9BvdfaowTXPx9aGMgJKm2HXnHhpqBK+r1Vn8hriLbxkChfJVAb+
	 X1BJPWu5ozQbM7Pf+MGRgktE9vMGxYUjvVE8hrE3acl/8F8HZaAP80oBK1vNa/UUCww3E
	 I0n/kBj9Wk1G3GWMqi4Cz47eI77+Y1CcaBKsovQomIWV8TvvNUgh8oNDFYq8OyJjQJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kIpHihdOi7E0sFvnXXBaFLSjj/NqMmAYnIsY3YsGyIc=;
	b=GHZT4c3SKIp6p5uPbSGyBQSDwvDQArriY4OMnf4U2KFu3yYoHdlDW9QSI7op0h3acTc8
	 SAFinxsOMCW/WfFhAmTk4SHhfikiGEDaCv4Q8zm4WU4und3+wuQhKbESP9DyBCK1BJsDx
	 EpKnt6DCEw1do8523J+Y03rPtIDTXBYykCO5OtRzTOnR0hlMBokacbDjsRGObGLUHwQoN
	 9muQ+u+FwBSVrAwHDT548ysuu7zNpQyaITXlhflStUy9aE0VsaEtBJzBGrvjBaLAU2NaQ
	 lzyHxWL5WJ2BKVF7F4efq4FbMelrMljR3yA40ee/hnN1kTjr1IjH3UlRJXQ7oOG12AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXtjYzG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEF5606A31C;
	Thu, 26 Nov 2026 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXtjYzG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62B81F000C0;
	Thu, 26 Nov 2026 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705138;
	bh=kIpHihdOi7E0sFvnXXBaFLSjj/NqMmAYnIsY3YsGyIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXtjYzG5mjFbQ0IwhpLjOdf9L75DfiFG0H68KvJ/s2aibKDszXDjb7ORsXE5x4Zr4
	 emjOoqLPi+SneRGnhqcLmQ+cFl/cjgDCz8K8FFk9RnDJ1A62RWoi+8WDEcdi6znmWH
	 +fK36A9exwEeqahX4uqwHUcNXQn2IE0LJOi6EjS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/319] Bluetooth: L2CAP: Clear request identifiers on incoming LE connections
Date: Thu, 26 Nov 2026 15:37:44 +0100
Message-ID: <20261126144008.911651610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 3d6bfe6c000e9..8aaa30e65b5b6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4054,6 +4054,7 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
 		       &rsp);
+	chan->ident = 0;
 }
 
 static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
@@ -6095,10 +6096,10 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+		chan->ident = cmd->ident;
 		l2cap_state_change(chan, BT_CONNECT2);
 		/* The following result value is actually not defined
 		 * for LE CoC but we use it to let the function know
@@ -6321,10 +6322,10 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
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



