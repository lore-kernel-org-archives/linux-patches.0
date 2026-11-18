Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053673;
	b=K8fevhZKEtsdHK6pMeK8/iHyAv2C/81rRtyxdIqIgLz+CUC6D04CBLKl03E/I5wuGijU
	 mMu+IndKhLlmmCXGX00MaVDk9lv+HsD54TH/18XApudScwSEj5Lq0UHsRkOSV6P1Bg1JL
	 lWwH4cJW5/Hutv/bMVvwJHzFQpY/U+pGHu/8jTmN2XL2sWieTslwLO8GLGTlUMny3dIDb
	 atXd1ISgo0hjeZtBo9/1fWrn82muD9vyjVCzeXMrIneGumZ6vK719QgynWbYAHwbjz6Uu
	 Da/tZ4vu9PfUQgCQAxwGBYXC38rYmkULKd45MsXWTk8UDEmsrmH8zMPcKXXUv7F5W5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3klxqnJqtDkvnPdAohsYaL1u5uc/jY9ScG6ERTa9CBA=;
	b=CWuQ7+x/74vLDFUSqSWb2gQ+ymo73dwMSH2G99kpIx4GpuVb/AV8If9188ZZpoBPsfgi
	 UcsDGWomN3hFMNjuXdezvcyTb7mP+TLUdv1g25hzhS/XwtFXBK8ghghTm7iGZxwocYC6y
	 7gbdQG64C7qHeHZWtGWShbygRn3MsZxblS9efR1Nv83OaNe6maifLdE+cZBylTBhV8qul
	 aQ3dgNMjZZLH5kidCRoPbk2mN1POeedco6ZRQQa1F/0e4UYfl3UAn8KykDlapGWEp2hdk
	 wO9PA5Df1ua0goxAkzKSYR4kHYPX0hHYdLyNq3iHPQ8kdKPVO5F9dh6E1Ftp5mJ+32A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V88Fs+Le;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005E606A31C;
	Thu, 19 Nov 2026 02:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V88Fs+Le
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB3D1F000C4;
	Thu, 19 Nov 2026 02:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053673;
	bh=3klxqnJqtDkvnPdAohsYaL1u5uc/jY9ScG6ERTa9CBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V88Fs+LeZWYdBp9b5CVgcBvZ1T0UYxLHioAdoRL/4Ukbv2dUGsR4NLu3XTquimVkc
	 qnE9sJocASyzbx6rzjQers9hr9zuVZStz4BYCW4WZFTvlHqZ2e7AtmVTi6P1A6hGrN
	 lp2WJSjnwEBC1NkCTW5sLhK4erAD6cUCg0o206/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1002/2214] Bluetooth: L2CAP: Only accept connection responses to outstanding requests
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150052.490261026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit a518b9a9ef6ee3b18ecdf6ba5360c608aaf969e9 upstream.

Adjusted context as stable does not have the lockdep_assert_held()
call and the __must_hold() context analysis annotations, and
l2cap_connect_create_rsp() still holds conn->chan_lock and returns
through the unlock label when the channel lookup fails.

Stable still has AMP support, which upstream removed in
commit e7b02296fb40 ("Bluetooth: Remove BT_HS"). The response to an
L2CAP_CREATE_CHAN_REQ is also handled by l2cap_connect_create_rsp(),
so set CONF_CONNECT_PEND in l2cap_send_create_chan_req() as
l2cap_send_conn_req() does. Otherwise that response is dropped and an
outgoing AMP channel hangs in BT_CONNECT. This also makes
__l2cap_no_conn_pending() see the request as outstanding, so
l2cap_do_start(), l2cap_conn_start() and l2cap_security_cfm() leave
the channel alone until it is answered, as they already do for a
pending connection request.

An outgoing channel waits in BT_CONNECT until security
and the feature mask exchange complete, and only then
sends its connection request. A peer can answer it
before that with a connection response matching our
source CID. The channel then moves to BT_CONFIG,
completes configuration and becomes connected before
security has completed. If security then fails,
l2cap_security_cfm() leaves the connected channel
alone, so it stays up on a link that did not reach
the required security level.

A connection response with a zero source CID is
matched by identifier. Another channel can hold the
same identifier for a response it still has to send,
so the lookup can pick the wrong channel.

Only accept a connection response while our request
is outstanding, and only look at such channels when
matching by identifier.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9a883e476684b..75c2ab39be167 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -185,6 +185,28 @@ static struct l2cap_chan *l2cap_get_chan_by_ident(struct l2cap_conn *conn,
 	return c;
 }
 
+/* Our connection request has been sent and is still outstanding */
+static bool l2cap_chan_connect_pending(struct l2cap_chan *chan)
+{
+	return chan->state == BT_CONNECT &&
+	       test_bit(CONF_CONNECT_PEND, &chan->conf_state);
+}
+
+/* Other channels may hold the same ident for a response they still have
+ * to send, so only look at channels waiting for a connection response.
+ */
+static struct l2cap_chan *__l2cap_get_connect_chan_by_ident(struct l2cap_conn *conn,
+							    u8 ident)
+{
+	struct l2cap_chan *c;
+
+	list_for_each_entry(c, &conn->chan_l, list) {
+		if (c->ident == ident && l2cap_chan_connect_pending(c))
+			return c;
+	}
+	return NULL;
+}
+
 static struct l2cap_chan *__l2cap_global_chan_by_addr(__le16 psm, bdaddr_t *src,
 						      u8 src_type)
 {
@@ -1329,6 +1351,8 @@ static void l2cap_send_create_chan_req(struct l2cap_chan *chan, u8 amp_id)
 
 	chan->ident = l2cap_get_ident(chan->conn);
 
+	set_bit(CONF_CONNECT_PEND, &chan->conf_state);
+
 	l2cap_send_cmd(chan->conn, chan->ident, L2CAP_CREATE_CHAN_REQ,
 		       sizeof(req), &req);
 }
@@ -4426,7 +4450,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 			goto unlock;
 		}
 	} else {
-		chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
+		chan = __l2cap_get_connect_chan_by_ident(conn, cmd->ident);
 		if (!chan) {
 			err = -EBADSLT;
 			goto unlock;
@@ -4443,8 +4467,11 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 
 	l2cap_chan_lock(chan);
 
-	/* Ignore a late response after the channel has left BT_CONNECT. */
-	if (chan->state != BT_CONNECT)
+	/* Only accept a response to a connection request we sent and that
+	 * is still outstanding. A channel waiting in BT_CONNECT for security
+	 * or the feature mask has not sent one yet.
+	 */
+	if (!l2cap_chan_connect_pending(chan))
 		goto done;
 
 	switch (result) {
-- 
2.53.0



