Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215629;
	b=xG/zjGyUGYvfwMP89355hfbL7/oFrs4OEnP5q5tqYWB6bDYyqL9+ovsupLUMxq0hITV3
	 7RQTKZKULFhvLpUcAsdnqU9V3jdtG3BDiA/qokmubHjuWQnJ5esxpgXIWdyr+AaBnuwhO
	 01y4KLMJ1BVi9Ci00o9ek7GNbzibnurawjQb5Ek9v3ZrAEaBHPwvkG0TI9xAdbd4r7Tv3
	 4qzmA7mVPhmZ/QzflyMFzH6Kgb8nWwEMi6MNG+XstKdXtTMLHcguKhz8mdVgxr8qwmTd6
	 FMzCzhoVEFNjvmJ8CKDF2XaMlbb/V4ot9vDgPQanucUJrvRj4n/oNHAGrxGllkxaWWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F13ujxXSI2BOrKTJNfAzCrMnTzERSyYDu9Ga5myMuWU=;
	b=j9gPq2Z4k1PUAUAYdSOQxW6uBJ1/DABZG3WFBdsaLAGyorBQ4FFLamBg9z3lWBwgaYGR
	 myHQbueCH7RQhJnzMB8PKIKBtH/olR4jputPaOVxdvSusf1g3bExjrE/hhH6W8NyE8dGJ
	 7lspa5QtGuoJRv4C2qL8rZN5zUzEjJh9mr3bpN7o95uO2RJtHpzSSyj+U4AO7v0cwNpJ3
	 XmUtA8FreikT3rGCeeLzYeHl5vAtBqOD+wfKDsytZk/raYSrOUy3vQoN2+7L7bWlGQ7dY
	 EnM6NF4vadh5fXArtse9fEwzy9hs3Tw/cmFRHZXN7dy35Ts9QSSRGB1ZbhFI7iPCDjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYfMFXaG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5695F606A31D;
	Wed, 28 Oct 2026 19:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYfMFXaG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE1C1F01825;
	Wed, 28 Oct 2026 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215629;
	bh=F13ujxXSI2BOrKTJNfAzCrMnTzERSyYDu9Ga5myMuWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYfMFXaGrec23MfhktoHpDlQWKTXH3IIXdZlqibG/FrQup86e/iOTT01ZxAGPNOAD
	 dcgZRtmYZwlSMBI+sUqGYHwTz7YN8Z1Gk6bOlUQ1fa+Qo8/KxMTFdC2lTIl6ZdkpDb
	 9TjyDssKZvqkMRg/dsuM3SSXNdSdAucwA3sQmRR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1234/1887] sctp: add INIT verification after cookie unpacking
Date: Wed, 28 Oct 2026 17:55:30 +0100
Message-ID: <20261028170527.504278158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 414c5447fe6a200613dd46d7fdc8454622076cb1 ]

In SCTP handshake, the INIT chunk is initially processed by the server
and embedded into the cookie carried in INIT-ACK. The client then
returns this cookie via COOKIE-ECHO, where the server unpacks it and
reconstructs the original INIT chunk.

When cookie authentication is enabled, the cookie contents are protected
against tampering, so reusing the unpacked INIT without re-verification
is safe.

However, when cookie authentication is disabled, the reconstructed INIT
can no longer be trusted. In this case, the INIT must be explicitly
validated after unpacking to avoid processing potentially tampered data.

Add sctp_verify_init() checks after cookie unpacking in COOKIE-ECHO
processing paths (sctp_sf_do_5_1D_ce() and sctp_sf_do_5_2_4_dupcook())
when cookie_auth_enable is disabled. On failure, the new association is
freed and the packet is discarded.

Also tighten cookie validation in sctp_unpack_cookie() by verifying the
embedded chunk type is SCTP_CID_INIT before treating it as an INIT
chunk.

Finally, update sctp_verify_init() to validate parameter bounds using
the actual embedded INIT length instead of chunk->chunk_end, since the
INIT stored in COOKIE-ECHO may not span the entire chunk buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/ebcbbac574815b0850f371b4bdb02f2e602b94d3.1782341592.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c |  7 +++++--
 net/sctp/sm_statefuns.c  | 36 ++++++++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 742ba54755e8b..b5ade45d6c66f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1780,7 +1780,9 @@ struct sctp_association *sctp_unpack_cookie(
 	cookie = chunk->subh.cookie_hdr;
 	bear_cookie = &cookie->c;
 
-	ch = (struct sctp_chunkhdr *)(bear_cookie + 1);
+	ch = (struct sctp_chunkhdr *)&bear_cookie->peer_init[0];
+	if (ch->type != SCTP_CID_INIT)
+		goto malformed;
 	chlen = ntohs(ch->length);
 	if (chlen < sizeof(struct sctp_init_chunk))
 		goto malformed;
@@ -2338,7 +2340,8 @@ int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 	 * VIOLATION error.  We build the ERROR chunk here and let the normal
 	 * error handling code build and send the packet.
 	 */
-	if (param.v != (void *)chunk->chunk_end)
+	if (param.v != (void *)peer_init +
+		       SCTP_PAD4(ntohs(peer_init->chunk_hdr.length)))
 		return sctp_process_inv_paramlength(asoc, param.p, chunk, errp);
 
 	/* The only missing mandatory param possible today is
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 052a9f74354ce..57d81cc01f724 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -707,11 +707,12 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 					 struct sctp_cmd_seq *commands)
 {
 	struct sctp_ulpevent *ev, *ai_ev = NULL, *auth_ev = NULL;
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_association *new_asoc;
 	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
-	struct sctp_chunk *err_chk_p;
 	struct sctp_chunk *repl;
+	enum sctp_cid cid;
 	struct sock *sk;
 	int error = 0;
 
@@ -785,6 +786,19 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
+	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+	cid = peer_init->chunk_hdr.type;
+	if (!sctp_sk(sk)->hmac &&
+	    !sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+			      &err_chk_p)) {
+		sctp_association_free(new_asoc);
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+	if (err_chk_p)
+		sctp_chunk_free(err_chk_p);
+
 	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -798,8 +812,6 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	/* This is a brand-new association, so these are not yet side
 	 * effects--it is safe to run them here.
 	 */
-	peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
-
 	if (!sctp_process_init(new_asoc, chunk,
 			       &chunk->subh.cookie_hdr->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
@@ -2217,10 +2229,12 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 					void *arg,
 					struct sctp_cmd_seq *commands)
 {
+	struct sctp_chunk *err_chk_p = NULL;
 	struct sctp_association *new_asoc;
+	struct sctp_init_chunk *peer_init;
 	struct sctp_chunk *chunk = arg;
 	enum sctp_disposition retval;
-	struct sctp_chunk *err_chk_p;
+	enum sctp_cid cid;
 	int error = 0;
 	char action;
 
@@ -2289,6 +2303,20 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	switch (action) {
 	case 'A': /* Association restart. */
 	case 'B': /* Collision case B. */
+		peer_init = &chunk->subh.cookie_hdr->c.peer_init[0];
+		cid = peer_init->chunk_hdr.type;
+		if (!sctp_sk(ep->base.sk)->hmac &&
+		    !sctp_verify_init(net, ep, asoc, cid, peer_init, chunk,
+				      &err_chk_p)) {
+			sctp_association_free(new_asoc);
+			if (err_chk_p)
+				sctp_chunk_free(err_chk_p);
+			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
+						commands);
+		}
+		if (err_chk_p)
+			sctp_chunk_free(err_chk_p);
+		fallthrough;
 	case 'D': /* Collision case D. */
 		/* Update socket peer label if first association. */
 		if (security_sctp_assoc_request((struct sctp_association *)asoc,
-- 
2.53.0



