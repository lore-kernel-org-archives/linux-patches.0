Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621562;
	b=aikZaQyYCK5IDoCQOiLCsRQIbgWb4e5fdpcN/Denr1jRp1bd2delpV4ysyjCQ3RGlXNH
	 Ol44ag+SjBR8LwwhTL26pLJmVRgbx+uKNgLO8itgv4u/wowHYfZl5qi5kxWIcXNGjE1mB
	 iNzuz+MvWdLSV7lPDRV6B0DVznqrRC5VmxLgMUjpAbLwJU17Y8uLam+Hch4cZh9jO7MMW
	 0VNcOgWga5G9iQdH85yLLFAiIOlJLjQm3nevX5e1XBIUtrRiJFwkLswqbux2xX8ieSL1V
	 Ul3PW8JjXI1ACo3RE9mE2pdGWC/dqdY2+/zuEgWO3Wd1XqkgIgvn0IpBU/VUPp3LhAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QD84HrnFEQvj+iYYC6SQ1AGpL7bPD2/RqmJ3Vwjqlzc=;
	b=0976kG3TJVHY0x+GG63of/sb0V56UJtGfp1ZVmo8zbQl7s3rHZizdkODAUhSQjeK7eCV
	 uXiO0PQdcazlsJxkiiRqy34yns04y0NzDPx+XJEl/9VJL/2zjmjS6/b7nS1sNZTF2Lfzy
	 L3J65HNQcQL0s9tD6CqrRQK0yp5tKspxk4zwceCCmSMYQNCSp+9Z+frCFM4Td1sjxgEMo
	 RZRNYUxSR14gM0ltY6Rhn3H9pzh8/oouRxD5FDBqWDRav4vKQuWRsvYD9dixNAVK2lj5e
	 8J98t6l0nBX8nTnk9zBj+bb+9Z1iqj9XRF9TaEsjb5jphuEuGU098MyP3aHnJBfvMJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bI5/SLVZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49025606A31E;
	Wed, 25 Nov 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bI5/SLVZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D9B1F000C4;
	Wed, 25 Nov 2026 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621562;
	bh=QD84HrnFEQvj+iYYC6SQ1AGpL7bPD2/RqmJ3Vwjqlzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI5/SLVZL71hmQlFXlud5t2GE8PMdUAF7IHw3lsY0mr3LzCg0zdw1uagiuJ/+JP4n
	 iFb7PzeTgegjepozrYeoSsf5I5cvxVRQamVPCI58q7paewmeZHSvM4UeCCUZYinksh
	 /DphOezVTyMRVnnmuGgLIgsJTj25WuUNxWiHCvg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/990] Bluetooth: L2CAP: Clear request identifiers on incoming LE connections
Date: Wed, 25 Nov 2026 15:27:13 +0100
Message-ID: <20261125143828.325678436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2df5d25bfee60..eef49a65084b4 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3914,6 +3914,7 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
 		       &rsp);
+	chan->ident = 0;
 }
 
 static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
@@ -5162,10 +5163,10 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+		chan->ident = cmd->ident;
 		l2cap_state_change(chan, BT_CONNECT2);
 		/* The following result value is actually not defined
 		 * for LE CoC but we use it to let the function know
@@ -5395,10 +5396,10 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
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



