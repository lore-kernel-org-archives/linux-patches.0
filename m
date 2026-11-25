Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624485;
	b=YUDwedR3jCLAQkb55QTNDRNWMazW5AyOdDeZkuzCDxJR7eU+4PvI1GsOjai8W91yGiz2
	 3jm0IPwesyB80CiRly8Iv9WOYjLlTXTBQIJrS14w8lHWlvfqikjdoj1DpZu8+hc+5E4Qe
	 GC0FxkNv9ps/kxq1Q/pvL9bZp1WkpbbtBLLf0YTThU1sqqXjudGmvTDnuDGPkVP9WwCc7
	 U4eMmL3WtPjmQD8qJCQvtpAztcsv+of2HtsnP73brJ8+spXTPb0rGdPPT6cHRnzD/7o/H
	 ygP9HWCUGP8+wmb9lT4DtKnCcFgyO9y0XFgmsE/ywPS7F1zjkQy33p13eNzM0UbQgxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lZLSp4TDYz9KN47anS9mT2PpecH0sXrEk4H2rcrubUE=;
	b=g9IjWuFvG6greX40vW7zCI4OwsXoNUrqb1JGnSX8hfietVlkBLJDd1njlEuf6aQKgq7m
	 Y9Qc1kuvsASfugS93ig+B3stkJN1WNHu3N9N4BxBP7EhOuoojJHGYEHyrDpOGZyqUoAFm
	 GGPeioouKsq0LumCpnWFXodbY9+ckAoMv+u9gzFX8OlxkHxyJs82zol1mtqWmgXdap5cH
	 HTDM8jPvTXnNp6RUmB68oih5XlO9fapwutcZssJ4iZBShCQRLz5Y6iojy731XBi51XoZz
	 b/4NCZU2XeAl7VgBTbxckbyrbajhDB5ZoiG/XpUBunh0h/y8Ra6FqFIE6KWEfEaLZgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTcXEIJU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839B9606A33D;
	Wed, 25 Nov 2026 16:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hTcXEIJU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E781F000C6;
	Wed, 25 Nov 2026 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624485;
	bh=lZLSp4TDYz9KN47anS9mT2PpecH0sXrEk4H2rcrubUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTcXEIJUQNIPIFa/9zoWaFEvXUJnvqROHvQUiu6UzgBX2b8ZHLJnwgckc/AZ595qp
	 Km+6nbcMLGEv4/GPAcprijRQhhg8yKqF2a0m8VMGbL2O335CpxhrdGWM8+oZ8Cram+
	 W2KwcLg9XqUQoVkSEHnsJsqIOOGHVV7dvLTLpgaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/816] inet: reduce inet_csk_clone_lock() indent level
Date: Wed, 25 Nov 2026 15:29:15 +0100
Message-ID: <20261125143853.989068817@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55250b83b02aa5ffe602987adb2c05178c87ac63 ]

Return early from inet_csk_clone_lock() if the socket
allocation failed, to reduce the indentation level.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250212131328.1514243-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e069fd3fd39 ("tcp: ipv6: do not read ireq->pktopts from tcp_v6_send_synack()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 50 ++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 61fbcaa913b35..c78291ea4ff6f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1257,39 +1257,43 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 				 const gfp_t priority)
 {
 	struct sock *newsk = sk_clone_lock(sk, priority);
+	struct inet_connection_sock *newicsk;
 
-	if (newsk) {
-		struct inet_connection_sock *newicsk = inet_csk(newsk);
+	if (!newsk)
+		return NULL;
 
-		inet_sk_set_state(newsk, TCP_SYN_RECV);
-		newicsk->icsk_bind_hash = NULL;
-		newicsk->icsk_bind2_hash = NULL;
+	newicsk = inet_csk(newsk);
 
-		inet_sk(newsk)->inet_dport = inet_rsk(req)->ir_rmt_port;
-		inet_sk(newsk)->inet_num = inet_rsk(req)->ir_num;
-		inet_sk(newsk)->inet_sport = htons(inet_rsk(req)->ir_num);
+	inet_sk_set_state(newsk, TCP_SYN_RECV);
+	newicsk->icsk_bind_hash = NULL;
+	newicsk->icsk_bind2_hash = NULL;
 
-		/* listeners have SOCK_RCU_FREE, not the children */
-		sock_reset_flag(newsk, SOCK_RCU_FREE);
+	inet_sk(newsk)->inet_dport = inet_rsk(req)->ir_rmt_port;
+	inet_sk(newsk)->inet_num = inet_rsk(req)->ir_num;
+	inet_sk(newsk)->inet_sport = htons(inet_rsk(req)->ir_num);
 
-		inet_sk(newsk)->mc_list = NULL;
+	/* listeners have SOCK_RCU_FREE, not the children */
+	sock_reset_flag(newsk, SOCK_RCU_FREE);
 
-		newsk->sk_mark = inet_rsk(req)->ir_mark;
-		atomic64_set(&newsk->sk_cookie,
-			     atomic64_read(&inet_rsk(req)->ir_cookie));
+	inet_sk(newsk)->mc_list = NULL;
 
-		newicsk->icsk_retransmits = 0;
-		newicsk->icsk_backoff	  = 0;
-		newicsk->icsk_probes_out  = 0;
-		newicsk->icsk_probes_tstamp = 0;
+	newsk->sk_mark = inet_rsk(req)->ir_mark;
+	atomic64_set(&newsk->sk_cookie,
+		     atomic64_read(&inet_rsk(req)->ir_cookie));
 
-		/* Deinitialize accept_queue to trap illegal accesses. */
-		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
+	newicsk->icsk_retransmits = 0;
+	newicsk->icsk_backoff	  = 0;
+	newicsk->icsk_probes_out  = 0;
+	newicsk->icsk_probes_tstamp = 0;
 
-		inet_clone_ulp(req, newsk, priority);
+	/* Deinitialize accept_queue to trap illegal accesses. */
+	memset(&newicsk->icsk_accept_queue, 0,
+	       sizeof(newicsk->icsk_accept_queue));
+
+	inet_clone_ulp(req, newsk, priority);
+
+	security_inet_csk_clone(newsk, req);
 
-		security_inet_csk_clone(newsk, req);
-	}
 	return newsk;
 }
 EXPORT_SYMBOL_GPL(inet_csk_clone_lock);
-- 
2.53.0



