Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB02B1C5D77;
	Wed,  4 Feb 2026 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216318; cv=none; b=Z0cNwV4WZNjIOb/5+kTclKeQ8PTjZnuxs5UkLW+tq1P8MwIyO3gggyaK5quD2V+Uv8Q7Vwk3gfIeqF0iH/PEbV2QDyv/qDyyZimVP2sWoAGoWBCJakTDhl+q8OYUr0bzu7jAz3PD3UuRzazEAKUvYtaegVAfV0BwMv/eEWogkAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216318; c=relaxed/simple;
	bh=ty+5+Tbtmoq+6UWgJDSLK1U7/eGMR0XEGOV4A5DEEes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s510V3VqDAlbpX9Jk0ShU39KF4HoaCQnsz89OzhUWOexj2/Ub9SrHFamtJWrIzav44WM101m732qtyqkDdB3Itm486Em4/XYfJsmnea1Ok/XtJtKWGPbhAhTqSk/p7/HY1DHe+9AxeiYvTDi2OCzr8RPsx5HrJUySA/b7Dy+oXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWruGlno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWruGlno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8B0C4CEF7;
	Wed,  4 Feb 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216318;
	bh=ty+5+Tbtmoq+6UWgJDSLK1U7/eGMR0XEGOV4A5DEEes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWruGlnocApSrtaj3DzQvANLhrTBtSsDU5SJUrAKwhRKs3wJjsn2zvmKk1IyXHM7a
	 Lrl4TqKBN153QJuP3xQlMSneDWVXzjDCKvntpTj3gMV3+6s0KDfT7dgSowQaS7uhkh
	 r95y+m4MJ9mfHo3BaSEyJqah4k22iOTzNENOGdu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yongjun <zhengyongjun3@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/161] sctp: sm_statefuns: Fix spelling mistakes
Date: Wed,  4 Feb 2026 15:38:35 +0100
Message-ID: <20260204143853.634032070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 0c2c366e0ec55533decb00d0f1ea1cbc42247e7b ]

Fix some spelling mistakes in comments:
genereate ==> generate
correclty ==> correctly
boundries ==> boundaries
failes ==> fails
isses ==> issues
assocition ==> association
signe ==> sign
assocaition ==> association
managemement ==> management
restransmissions ==> retransmission
sideffect ==> sideeffect
bomming ==> booming
chukns ==> chunks
SHUDOWN ==> SHUTDOWN
violationg ==> violating
explcitly ==> explicitly
CHunk ==> Chunk

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20210601020801.3625358-1-zhengyongjun3@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a80c9d945aef ("sctp: move SCTP_CMD_ASSOC_SHKEY right after SCTP_CMD_PEER_INIT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 29b879bf86975..9a0ba3747711c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -361,7 +361,7 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 
 	/* If the INIT is coming toward a closing socket, we'll send back
 	 * and ABORT.  Essentially, this catches the race of INIT being
-	 * backloged to the socket at the same time as the user isses close().
+	 * backloged to the socket at the same time as the user issues close().
 	 * Since the socket and all its associations are going away, we
 	 * can treat this OOTB
 	 */
@@ -608,8 +608,8 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct net *net,
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
 			SCTP_STATE(SCTP_STATE_COOKIE_ECHOED));
 
-	/* SCTP-AUTH: genereate the assocition shared keys so that
-	 * we can potentially signe the COOKIE-ECHO.
+	/* SCTP-AUTH: generate the association shared keys so that
+	 * we can potentially sign the COOKIE-ECHO.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_SHKEY, SCTP_NULL());
 
@@ -791,7 +791,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		goto nomem_init;
 
 	/* SCTP-AUTH:  Now that we've populate required fields in
-	 * sctp_process_init, set up the assocaition shared keys as
+	 * sctp_process_init, set up the association shared keys as
 	 * necessary so that we can potentially authenticate the ACK
 	 */
 	error = sctp_auth_asoc_init_active_key(new_asoc, GFP_ATOMIC);
@@ -842,7 +842,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 
 	/* Add all the state machine commands now since we've created
 	 * everything.  This way we don't introduce memory corruptions
-	 * during side-effect processing and correclty count established
+	 * during side-effect processing and correctly count established
 	 * associations.
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
@@ -928,7 +928,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 						  commands);
 
 	/* Reset init error count upon receipt of COOKIE-ACK,
-	 * to avoid problems with the managemement of this
+	 * to avoid problems with the management of this
 	 * counter in stale cookie situations when a transition back
 	 * from the COOKIE-ECHOED state to the COOKIE-WAIT
 	 * state is performed.
@@ -2935,7 +2935,7 @@ __sctp_sf_do_9_2_reshutack(struct net *net, const struct sctp_endpoint *ep,
 						  commands);
 
 	/* Since we are not going to really process this INIT, there
-	 * is no point in verifying chunk boundries.  Just generate
+	 * is no point in verifying chunk boundaries.  Just generate
 	 * the SHUTDOWN ACK.
 	 */
 	reply = sctp_make_shutdown_ack(asoc, chunk);
@@ -3526,7 +3526,7 @@ enum sctp_disposition sctp_sf_do_9_2_final(struct net *net,
 		goto nomem_chunk;
 
 	/* Do all the commands now (after allocation), so that we
-	 * have consistent state if memory allocation failes
+	 * have consistent state if memory allocation fails
 	 */
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 
@@ -3710,7 +3710,7 @@ static enum sctp_disposition sctp_sf_shut_8_4_5(
 	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
 
 	/* We need to discard the rest of the packet to prevent
-	 * potential bomming attacks from additional bundled chunks.
+	 * potential boomming attacks from additional bundled chunks.
 	 * This is documented in SCTP Threats ID.
 	 */
 	return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -4221,7 +4221,7 @@ enum sctp_disposition sctp_sf_eat_fwd_tsn_fast(
 }
 
 /*
- * SCTP-AUTH Section 6.3 Receiving authenticated chukns
+ * SCTP-AUTH Section 6.3 Receiving authenticated chunks
  *
  *    The receiver MUST use the HMAC algorithm indicated in the HMAC
  *    Identifier field.  If this algorithm was not specified by the
@@ -4782,7 +4782,7 @@ static enum sctp_disposition sctp_sf_violation_ctsn(
 
 /* Handle protocol violation of an invalid chunk bundling.  For example,
  * when we have an association and we receive bundled INIT-ACK, or
- * SHUDOWN-COMPLETE, our peer is clearly violationg the "MUST NOT bundle"
+ * SHUTDOWN-COMPLETE, our peer is clearly violating the "MUST NOT bundle"
  * statement from the specs.  Additionally, there might be an attacker
  * on the path and we may not want to continue this communication.
  */
@@ -5178,7 +5178,7 @@ enum sctp_disposition sctp_sf_cookie_wait_prm_shutdown(
  * Inputs
  * (endpoint, asoc)
  *
- * The RFC does not explcitly address this issue, but is the route through the
+ * The RFC does not explicitly address this issue, but is the route through the
  * state table when someone issues a shutdown while in COOKIE_ECHOED state.
  *
  * Outputs
@@ -5902,7 +5902,7 @@ enum sctp_disposition sctp_sf_t1_cookie_timer_expire(
 /* RFC2960 9.2 If the timer expires, the endpoint must re-send the SHUTDOWN
  * with the updated last sequential TSN received from its peer.
  *
- * An endpoint should limit the number of retransmissions of the
+ * An endpoint should limit the number of retransmission of the
  * SHUTDOWN chunk to the protocol parameter 'Association.Max.Retrans'.
  * If this threshold is exceeded the endpoint should destroy the TCB and
  * MUST report the peer endpoint unreachable to the upper layer (and
@@ -5980,7 +5980,7 @@ enum sctp_disposition sctp_sf_t2_timer_expire(
 }
 
 /*
- * ADDIP Section 4.1 ASCONF CHunk Procedures
+ * ADDIP Section 4.1 ASCONF Chunk Procedures
  * If the T4 RTO timer expires the endpoint should do B1 to B5
  */
 enum sctp_disposition sctp_sf_t4_timer_expire(
@@ -6410,7 +6410,7 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 		chunk->ecn_ce_done = 1;
 
 		if (af->is_ce(sctp_gso_headskb(chunk->skb))) {
-			/* Do real work as sideffect. */
+			/* Do real work as side effect. */
 			sctp_add_cmd_sf(commands, SCTP_CMD_ECN_CE,
 					SCTP_U32(tsn));
 		}
-- 
2.51.0



