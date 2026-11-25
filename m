Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624516;
	b=FGWlj89ioiZF4dE+v2IbXWzwgBNc7QOMKKhQmV7HEPc+8oQlpIKNpBhfmZnVstC+ZEYa
	 C/Ygowns2EWgFk2Gb0Na80DC/Nbdrc31OEiFo2nMCLv95czAjCyflz7pxXDdxalNs9lN6
	 Qph8tpcfCML/Aor8IHCv2PZyJYlsxqmTk24dRcRMzz3/zdQfhrb7d7mHZQWRK9oNWgCuq
	 AncD2slfV4uhkpKNZUEwFStTStEeKYnlTYeBLxbovRjhNosP0aMOMM/ufEB5bUxFek6KY
	 c2L0GHLJDj4WjzLAXaVb5yngE6CJN1L1kNKSaQRn6vrHc6caBZxb0ZqIiUqbK6p8UFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZEFVFSUkJvSchcw2gwMUNyFuVXc6JXm9cgf9d2VL5FA=;
	b=Dhl/X9TuIDoKS4Ch78NI4mAiczVXbWs/IKt0ds2AmKentMvfLaA/OfyIUEPR4REr/mc8
	 kwGa3IPi1JYg7WofE1HDLv738ThlKb+IDg4o50C+5zaAVD6NGUtdsUlDiliGuZWtKLk8S
	 Grxlx4OCz0IlFTQN6cSA1xtjB19EXYOeBJB5gTA+d3rVl9HkE3nctADcpCfjK9AVNP8ke
	 0N2jlNqGl9lbl+S6QTl/R28SwEyYUdLsvTpEsub15d0E9Z8K6CpIwipsEUFe1DsnLsBrx
	 3SPK/tDvNYQVMNhwyUZQKr3hitOa47HVOVOC39YAk9HyuOGTtymCOKasqmQPpTOL0vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhpbXl5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3B4606A33F;
	Wed, 25 Nov 2026 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhpbXl5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC01F1F000C6;
	Wed, 25 Nov 2026 16:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624515;
	bh=ZEFVFSUkJvSchcw2gwMUNyFuVXc6JXm9cgf9d2VL5FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhpbXl5kHK5PcJ6F9jW6Vh7GxobJ1p8MFcXB3rDYgUDf2AHppCS2DjBaHhTlGcKsz
	 6DKt3uOnraNPvedLI7ZJHLL/Okmg/ueQf+ngaSJ8lleZL4cbzqsqQYocEJe5X1dPXR
	 pNL14T9po0J/aJ3IjcJwzSmeCr5jYGXbKGOTi9nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/816] Bluetooth: L2CAP: Clear request identifiers on incoming LE connections
Date: Wed, 25 Nov 2026 15:29:24 +0100
Message-ID: <20261125143854.202947329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index bab8caf18f204..275454b34366e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3882,6 +3882,7 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 
 	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
 		       &rsp);
+	chan->ident = 0;
 }
 
 static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
@@ -5137,10 +5138,10 @@ static int l2cap_le_connect_req(struct l2cap_conn *conn,
 
 	__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
-	chan->ident = cmd->ident;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
 	if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
+		chan->ident = cmd->ident;
 		l2cap_state_change(chan, BT_CONNECT2);
 		/* The following result value is actually not defined
 		 * for LE CoC but we use it to let the function know
@@ -5370,10 +5371,10 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 
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



