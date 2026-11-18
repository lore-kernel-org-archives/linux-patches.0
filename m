Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059406;
	b=5oZ0ysi1ReqTFcoFjrW/YEdUWUHyFynXIQMneeZ/rxm24PpNvYWG9TONSVJhi4Wein+R
	 3VWWnu5K65rd5aM8u5RCZh8RTiGWOhnDiwktmKK31LDtW9VbIZfkwG0eh10y0/4UQ4No3
	 PMm1RgJr+mBLMjZ9zIATVtDXGP/8OdYd+iQ7rSy0bXWT95C+8JDb1tacdxrb2iQ8DmQll
	 6S6fTbI792DI0p1a5h5WjN57PMkD1RLf4DaPYGAbVasD/OvjoRpqBQS5gPExpGqEj5Ik3
	 zsvwddBModEAauQtRViXs7uQteTpIpfGO48UMSEn1AUMqHTYJtZarzCm2ili3SrP0XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KPx6gnZwEpin+SRvMN8YtDKZO4GbihXnFcDwsoMbTOg=;
	b=WFbwXiDYkUIjziZ4VhcIc8EoKTYRLerekMPVoepRrP1z/W/abIa+mQwCpq2M+EPZiXje
	 DI+mY4tHrzFJtxaV8sKsgmeHu1sm+Rr8UKj4RvZrJZNBSGLa4d5lTd0bueo4xYj+PELG1
	 gIPP66BhINfE1PS3YCutsbVnktBwtDRawgrEkRY/WJKv81sJnYuABioBG14jvUnDY7Oz+
	 cydfJStQ/xpVjLWLiEjkb4i7NaAfXkn6rm0gzGT1iC5v7vPeIslbkB/kIJyb0cN9aeVaL
	 SvWOHhPVnxbhjPd2so6alb+XYYOPr6fqwepBfcoM7oinSaj0un7lMWf9Q7SwIGC5Mwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MK2p57Ss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4147606A31C;
	Thu, 19 Nov 2026 03:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MK2p57Ss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC2F1F000C4;
	Thu, 19 Nov 2026 03:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059405;
	bh=KPx6gnZwEpin+SRvMN8YtDKZO4GbihXnFcDwsoMbTOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MK2p57Ss2I1tph/oM6ZGpeQFCNqQITZ00GKJBxBbc7OlXVeMOLBUVTgBucsocFS/f
	 Wc4AGj+7ZTIgbt9/AQEfAZizQip9jXoqURN/cZsPmHR7W7nHr1Z+cik5z1FNHZt54R
	 l0ypscOaVdhztzUxmNAP6tjV5IPCkmKarkPbIKGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0829/1848] Bluetooth: L2CAP: Reject signalling responses in invalid states
Date: Wed, 18 Nov 2026 15:47:47 +0100
Message-ID: <20261118145951.415248065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 6320736af7dcb90da6ee9fd651ecc11c564d45b7 upstream.

Adjusted context as stable does not have the lockdep_assert_held()
calls, and l2cap_get_chan_by_scid() still returns the channel locked,
so l2cap_config_rsp() does not lock it again.

A peer can send configuration messages while an
incoming channel is in BT_CONNECT2, before the
security or deferred accept gate has completed. A
configuration response can then promote the channel
to BT_CONNECTED. Configuration responses can also
act on channels that are closing, and a late connection
response can move a disconnecting channel back to
BT_CONFIG.

Accept connection responses only while waiting in
BT_CONNECT. Answer configuration requests in
BT_CONNECT2, but defer our own request until
BT_CONFIG so configuration cannot complete before
the gate. Ignore configuration responses outside
BT_CONFIG and BT_CONNECTED, and only complete
configuration in BT_CONFIG.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index de97a746bb38c..5a24d655b535a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4478,6 +4478,10 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
+	/* Ignore a late response after the channel has left BT_CONNECT. */
+	if (chan->state != BT_CONNECT)
+		goto done;
+
 	switch (result) {
 	case L2CAP_CR_SUCCESS:
 		if (__l2cap_get_chan_by_dcid(conn, dcid)) {
@@ -4507,6 +4511,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 		break;
 	}
 
+done:
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
@@ -4642,7 +4647,13 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 		goto unlock;
 	}
 
-	if (!test_and_set_bit(CONF_REQ_SENT, &chan->conf_state)) {
+	/* A channel in BT_CONNECT2 has not passed security or userspace
+	 * accept yet. Answer the peer's request, but hold our own until
+	 * the channel reaches BT_CONFIG: the CONNECT2 -> CONFIG sites send
+	 * it. Connected channels may also need to reconfigure.
+	 */
+	if ((chan->state == BT_CONFIG || chan->state == BT_CONNECTED) &&
+	    !test_and_set_bit(CONF_REQ_SENT, &chan->conf_state)) {
 		u8 buf[64];
 		l2cap_send_cmd(conn, l2cap_get_ident(conn), L2CAP_CONF_REQ,
 			       l2cap_build_conf_req(chan, buf, sizeof(buf)), buf);
@@ -4693,6 +4704,10 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return 0;
 
+	/* Connected channels may also receive reconfiguration responses. */
+	if (chan->state != BT_CONFIG && chan->state != BT_CONNECTED)
+		goto done;
+
 	switch (result) {
 	case L2CAP_CONF_SUCCESS:
 		l2cap_conf_rfc_get(chan, rsp->data, len);
@@ -4767,6 +4782,9 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 	if (test_bit(CONF_OUTPUT_DONE, &chan->conf_state)) {
 		set_default_fcs(chan);
 
+		if (chan->state != BT_CONFIG)
+			goto done;
+
 		if (chan->mode == L2CAP_MODE_ERTM ||
 		    chan->mode == L2CAP_MODE_STREAMING)
 			err = l2cap_ertm_init(chan);
-- 
2.53.0



