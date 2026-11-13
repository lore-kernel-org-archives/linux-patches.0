Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586012;
	b=bUm141kIOJd/YNuqOJYpV0feSJQ8sSCz3DCLS0jC2xMA4IdhjDvHPBOmKtGgSVRyathZ
	 khb7T5uI+hTYPgwFAR92sBitTqRcNOhlygVqlNrk1jRbrZ6YWV6fJBEOu7zaYv85oXsy2
	 /CSWoPFawuuJj4jCHKwuZXJADWNgiG89ekScxLaFaCWM2MODyY4x8pxom8XVmT8re+326
	 j6KvjrMOvaqC4eBrKbic267OlhqtkGe401AuFHaLWDBSSN3YLA7Ex+YrOxELWIwizc4p6
	 CtHl1vv/edgGV2CNaDRjA6g/V+CQb8SZdnDoK52PS3xfj2FVOYz5G853S0FVPzo/Zew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7eXB2oCVMdeTtYqTKxmuE86xyYT/9/1os9Tnsbt5O9k=;
	b=AH13LDLXWx3h9hQZaJAxvUiBksaBNn6U7FwTvW06HK31TD3HBfl+sb6oRG122t4sfWJT
	 MX7uawJ2MnrE2HY0aPmctvd9JJb09youPt6rtBm/So412XAvlNxc9AuuWO89GE5rq2saP
	 No/TRkvMxT+O1Cnv3xnG21wkuO7H6Q38OODMXAaegS63l86KfUTT3HTLTxogCb8/kbeMa
	 clD4RczzQcndyp5MAkCkXu7mDCc7KdIuqQsnXYjNelm9q11ayHkk7lRExZ2p6KoO1k56Y
	 IgTcDryI/QFx/IJuOFi3H2UEhq1Le2J4AmV8xo7va9YVElAlXWrNaJjGN6XxUVK3M/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeSEdMoh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58045606B2C2;
	Fri, 13 Nov 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeSEdMoh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044151F000C4;
	Fri, 13 Nov 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794586012;
	bh=7eXB2oCVMdeTtYqTKxmuE86xyYT/9/1os9Tnsbt5O9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeSEdMohndDXffS9oLnwPZxVy8PtO+x7DLFAKT0rKCihDuuhSeAQ0ZMXoXTP29Bti
	 2pbJ7FzmNUhA3Xp5Wm3/A2v1bPBCL7U80ucp2KLs4o/7npl6pl+QEDTOL5nniiq6gC
	 u+c3+9lRjQWoAfGivLHHv0RYbKr2ITvoE9/R7Wnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/686] Bluetooth: L2CAP: Reject signalling responses in invalid states
Date: Fri, 13 Nov 2026 10:42:21 -0500
Message-ID: <20261113153821.211466217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 0ba7b1ea435cc..52ff1b8785d77 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4310,6 +4310,10 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
+	/* Ignore a late response after the channel has left BT_CONNECT. */
+	if (chan->state != BT_CONNECT)
+		goto done;
+
 	switch (result) {
 	case L2CAP_CR_SUCCESS:
 		if (__l2cap_get_chan_by_dcid(conn, dcid)) {
@@ -4339,6 +4343,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 		break;
 	}
 
+done:
 	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 
@@ -4471,7 +4476,13 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
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
@@ -4519,6 +4530,10 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return 0;
 
+	/* Connected channels may also receive reconfiguration responses. */
+	if (chan->state != BT_CONFIG && chan->state != BT_CONNECTED)
+		goto done;
+
 	switch (result) {
 	case L2CAP_CONF_SUCCESS:
 		l2cap_conf_rfc_get(chan, rsp->data, len);
@@ -4586,6 +4601,9 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
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



