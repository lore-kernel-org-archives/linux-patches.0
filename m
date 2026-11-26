Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704316;
	b=ZPvdAUZOv6q/YYUYkR20D8cEy4oep2q+DlRrdPxAHk7wKOiUV+5r4MEvymVzMxPS4g6Q
	 UqSycIhPubhCUSwzi68avYPUvVOKCDVVZv4SCeaoC/QnLWWeR4R+sthUPPKtYEtKpMA5i
	 eqe8J9x0RLlCetkrv6dVDLC4g9UGhN9Go0EzThrgZAqym0DBUPN3bs3JYPeIy+iLQksQF
	 U4/d+bH9RvzO8Vh97sp4OlmA3WxJNDTW+4kJB9TO5tjL0GIuDlHjPSPmVioEqtJpEjoS+
	 iei04DAzWCpVDlirL94rzHcxK3aZwbH+JtE+v5P63ePGn1r7cl1XwOzWtE8Wzvbm7iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hl/kcMX6znVEWrsomYX/xqeNpfu5gRm57jILd/1tB6w=;
	b=oflC3niXqMwyWPCb7vcp/fb7WuqG243CyL/SA80qKjSJRWvv3fqex9ZWDGvJioy/SZmd
	 Wn2/AfUrb2VljABERqLdvAu9qzp9btwSEdMAEMBsq53RnxLjFbR09isM1szWeIARkN0GN
	 4w0zbz/szB0dQOlZJiy004kBN571tFJfboTmGXMeEM4FW9RlRmcVfQ0uJqmF/kyu/ojiF
	 2PBEmOsXK7LrFo0h1j6+2EJMoZakSj4Os7slcu630jxpswH2MnSLboqraVTt/LyiXxQEV
	 soHrp1Pmt2gYKoNEpB86tUbNaQsbmuqnT7mcNCi6kLKmpSQ60nrFSKBiGR8/1n9zlsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2NIYa97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3F0606A330;
	Thu, 26 Nov 2026 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2NIYa97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B0A1F000C4;
	Thu, 26 Nov 2026 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704316;
	bh=hl/kcMX6znVEWrsomYX/xqeNpfu5gRm57jILd/1tB6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2NIYa97gk5TLblIByE29Fioxc0l2ONVwOXTtqZGQR/omsWZj10C22oY1iT0W53z7
	 wDV9VwAcpnBG5Ig3waVubfcMIpfbdjFFmcu8OSrBGEXLDfz329sjjVspqCspDI0ia7
	 ozkdg1Jyt948b8T1tZi5CWQhM4EnsAOl3xDx6aqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/265] Bluetooth: L2CAP: Clear request identifiers on incoming LE connections
Date: Thu, 26 Nov 2026 15:36:50 +0100
Message-ID: <20261126143610.637813834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 15809ca665ffa..2c7330d021875 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4080,6 +4080,7 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
 		       &rsp);
+	chan->ident = 0;
 }
 
 static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
@@ -6129,10 +6130,10 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+		chan->ident = cmd->ident;
 		l2cap_state_change(chan, BT_CONNECT2);
 		/* The following result value is actually not defined
 		 * for LE CoC but we use it to let the function know
@@ -6355,10 +6356,10 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
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



