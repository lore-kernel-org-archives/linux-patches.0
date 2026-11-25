Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619346;
	b=hXJqczQYC7td6RKxjP5lbXCVv7TzMuNAHPSzk2i/rbc5wOK3tcQf80GrfGMZu7ILxPVP
	 rKvG34iUbZScUUTr8zAu17VwR1rV1jbQBUqd9tMXlJq9FiAjatfHpMJmQtdX+Wra5TCVJ
	 dPO1M1Sl1b87kWBHbHLzDqRHpI+xvTVftCx2KWhwB9D9b6gNWs2Q5Zt6L8pKSQkmyUaiN
	 eSKOwQmN69yziGZkEKay7hRWUDC8w+bg75T7if02yV/m7AWsUhagXx5QYdt3tQkJbG1Ij
	 oKketD+bpTBtHScMXOEst/FcP1d0kamErsfNDoDB4UF1dKt2EtSEBruQ9ir8b4yeqOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M0xtMTeLh8tGXL99ml4RcoIlyBHsQfwJ2AZgx+czk6A=;
	b=WSXOa9YQTSJ/pTCwDgnbYgWX6nSv5/DrdRMSqZtwd8kx1kaG3V+J9zHYcqDKwdVrHnyU
	 MGL6KXuaoUELMSAYlnQsvmKxCYkL4YFmRUHAxgjYMRs76/25K2bDcozI/VTXLtfccbxty
	 zNqOegGsKXPGm0uqo0d8DTIgHKpChvlgmQ2bJ77Mzg/qAvgT7/g3VgpCeaCp4zJnRAgq7
	 izCpan/fLAc5/RFsExj0TZxPv4GOEN5ui8rqPONw4oUN6JQL03BfacqQ1z8m0ljzO2FZ8
	 Xk7aysZ7xi+Snhe8a6vdaso/q2CWg1NmEnx/Qwp1aBEaVkn/Fonntxw7hdeFPU1+Kkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rT3Xr3Ok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1D1606A333;
	Wed, 25 Nov 2026 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rT3Xr3Ok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B11F000EF;
	Wed, 25 Nov 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619345;
	bh=M0xtMTeLh8tGXL99ml4RcoIlyBHsQfwJ2AZgx+czk6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rT3Xr3OkTJXYY/oazl6Nw2ASQ1jpOCngVrjKQpQ/WItLkLCn/BaOph9QDgN7mTrUi
	 CBavCg+zkayBJEDI71YPs+CyCgDUQFzV+TAVzmQo+LOI/AUatgfqBzqArB30Caml1K
	 ZMx5nw42tl4TlmLOWEr9DYdBeDRqZ8c0Xxckplk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0550/1005] tls: Break the connection after a burst of empty data records
Date: Wed, 25 Nov 2026 15:31:28 +0100
Message-ID: <20261125143834.630115040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 201f0531e413d6cdd9673a77bea340839e1713ae ]

TLS permits zero-length application_data records, and RFC 8446
suggests them for generating cover traffic. Nothing bounds how many of
them a reader processes back to back, though. They advance neither
loop bound in tls_sw_recvmsg() and tls_sw_read_sock(), so a peer
streaming them faster than the reader decrypts them keeps it in the
kernel for as long as they arrive. recvmsg() does not check for signals
while records are ready, and its peek and async paths queue every empty
record on rx_list. read_sock consumers like nvme-tcp hold the socket
lock throughout and never get control back.

Break the connection once a reader decrypts more than 128 consecutive
empty data records without sleeping or returning to its caller in
between, treating the burst as a protocol violation like a malformed
record header. A stream of empty records which the reader keeps up with
costs no more than any other traffic, so the count starts over on every
read and whenever the reader waits for the next record. The strparser
is stopped before it parses the next record, so the reader gets the
error from tls_rx_rec_wait() and no later record is delivered.
Returning to the caller and keeping the connection alive would need a
way to wake read_sock consumers which installed their own sk_data_ready
after the handshake, a lot of code for a peer that is either broken or
malicious.

Consume empty records in recvmsg() rather than queuing them on rx_list,
so that repeated MSG_PEEK cannot pile them up past the per-read count.
Decrypt them synchronously, too. Once a recvmsg() call has decrypted a
record asynchronously, recv_end replaces the error with the result of
process_rx_list(), so a call that saw only empty records returns 0, a
false EOF, instead of the error or -EAGAIN.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260720-tcp-read-sock-v2-0-29545d034f3c@kernel.org?part=1
Closes: https://sashiko.dev/#/patchset/20260630191551.875664-1-cel@kernel.org?part=1
Link: https://lore.kernel.org/all/20261019-tls-follow-on-v6-0-ab01c4ecca0c@kernel.org/
Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Fixes: 3be28e2c9cd0 ("net/tls: Consume empty data records in tls_sw_read_sock()")
Reviewed-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261111185522.2859004-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h |  1 +
 net/tls/tls_sw.c  | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index e57bef58851ea..0b001b8ab1c3b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -139,6 +139,7 @@ struct tls_sw_context_rx {
 	u8 zc_capable:1;
 	u8 reader_contended:1;
 	bool key_update_pending;
+	u8 empty_run;
 
 	struct tls_strparser strp;
 
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 47e46547108e9..3dc0d9db3e882 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1153,6 +1153,7 @@ tls_rx_rec_wait(struct sock *sk, bool nonblock, bool released, bool has_copied)
 		if (!timeo)
 			return -EAGAIN;
 
+		ctx->empty_run = 0;
 		released = true;
 		add_wait_queue(sk_sleep(sk), &wait);
 		sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
@@ -1572,6 +1573,7 @@ static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
 			     struct tls_decrypt_arg *darg)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm;
 	int err;
@@ -1589,6 +1591,19 @@ static int tls_rx_one_record(struct sock *sk, struct msghdr *msg,
 	rxm->full_len -= prot->overhead_size;
 	tls_advance_record_sn(sk, prot, &tls_ctx->rx);
 
+	/* A peer may send empty data records, e.g. as cover traffic, but
+	 * a burst of them traps the reader in the kernel. Treat more than
+	 * 128 in a row, without the reader sleeping or returning to the
+	 * caller in between, as a protocol violation. Stop the strparser
+	 * before the next record gets parsed, so the reader finds the
+	 * error in tls_rx_rec_wait().
+	 */
+	if (rxm->full_len ||
+	    tls_msg(darg->skb)->control != TLS_RECORD_TYPE_DATA)
+		ctx->empty_run = 0;
+	else if (unlikely(++ctx->empty_run > 128))
+		tls_strp_abort_strp(&ctx->strp, -EBADMSG);
+
 	return tls_check_pending_rekey(sk, tls_ctx, darg->skb);
 }
 
@@ -1768,6 +1783,7 @@ static int tls_rx_reader_acquire(struct sock *sk, struct tls_sw_context_rx *ctx,
 	}
 
 	WRITE_ONCE(ctx->reader_present, 1);
+	ctx->empty_run = 0;
 
 	return 0;
 }
@@ -1881,9 +1897,11 @@ int tls_sw_recvmsg(struct sock *sk,
 		    tlm->control == TLS_RECORD_TYPE_DATA)
 			darg.zc = true;
 
-		/* Do not use async mode if record is non-data */
+		/* Do not use async mode if record is non-data or empty,
+		 * recv_end would report an error after empty records as EOF.
+		 */
 		if (tlm->control == TLS_RECORD_TYPE_DATA)
-			darg.async = ctx->async_capable;
+			darg.async = ctx->async_capable && to_decrypt;
 		else
 			darg.async = false;
 
@@ -1925,7 +1943,10 @@ int tls_sw_recvmsg(struct sock *sk,
 
 			DEBUG_NET_WARN_ON_ONCE(darg.skb == ctx->strp.anchor);
 
-			if (async) {
+			/* Consume empty records, even when peeking, so that
+			 * they cannot pile up on rx_list.
+			 */
+			if (async && chunk) {
 				/* TLS 1.2-only, to_decrypt must be text len */
 				chunk = min_t(int, to_decrypt, len);
 				async_copy_bytes += chunk;
@@ -1946,7 +1967,7 @@ int tls_sw_recvmsg(struct sock *sk,
 			if (err < 0)
 				goto put_on_rx_list_err;
 
-			if (is_peek) {
+			if (is_peek && chunk) {
 				peeked += chunk;
 				goto put_on_rx_list;
 			}
-- 
2.53.0



