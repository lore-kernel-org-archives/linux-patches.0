Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831766;
	b=hwMfguj6eGONc3OpGqylZovHqSBY1CDSbbTC2X3+Z5EVt0UphaxiU/pOTX+f+a92ZTnN
	 xBLiRjOruGX5Bb098KJ7D/pruL+hTzy3pC78YLXTf4KhSswUcicSTNLqGKN6ndPbrN/nV
	 jVa+kgtzNsbYrLodLUSBq2lAzoKyd/CidXtTf7J5FWR7rwDgXZv0QYVkCnDh/V5JGPrI3
	 kh6L3248IVefSY6IJTbHySVNDhWTvYQ/LKNpochPg1OlPduM8jutE+uOuPI9GOpIfKst3
	 VFCSITY+Va6Ph2AcoI7sKbkCHo0m3er2hScfSBSr+eXzaK22Rs5aUTttisJAZor9SJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y8c95Sl3d3yvS/R1a4NnowkzbaLt0jbfZT6lHkPqmv4=;
	b=FiFhND481/GipTVmnki4wx19SBApGyE8z0OJIVs4/UEvtG6wJLxkSD1NEIewyaMLI0ck
	 npJDIpj4J3kYtx+cjuQcd/1EPwk7I7nVkla9t4SaXka8156dv66m8YMdOsNUYlq1lq2ow
	 WASfqXKOXqn3B+/uLqfAePNW9882gRMavo+MuoVwILE2Mas4eqXW2FJH4b7ORPlRMFeUS
	 4h0O0HQd7HedUmVuXK29v7NshHW2JAoBqzc7lblTqH367nUbiBM7RdfdlZ78jMpck6/LW
	 jfv+Qgn/ZQ8KdG7Tj3rb8DtUFmGMqzMpzSbMHsxwDnEMSVuJqk7NEMh4u++h+PIKunw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnVk2vHK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03717606A31B;
	Wed,  4 Nov 2026 22:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hnVk2vHK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A191F000C1;
	Wed,  4 Nov 2026 22:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831765;
	bh=Y8c95Sl3d3yvS/R1a4NnowkzbaLt0jbfZT6lHkPqmv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnVk2vHK2IhAd28/ycWc7G8QrmB2n9WVeoQvP3IV19JMSJ8fgKMUZ+VxzF11mZlAa
	 UFfIC/qt8iS9gZLtvkwuZlHOqBg1Ag6OyUCd6Kt9J7VIJ377iliGdt5d3IVn2ba+N4
	 h2bK0lrRfvlGHYYg2mi8rsdBtx4EjYeO6MxDUwWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Mayank Jangid (OpenSec Intelligence)" <mayank.jangid.moon@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0899/1005] nfsd: preflight SEQUENCE replies before accepting a slot
Date: Wed,  4 Nov 2026 16:10:32 -0500
Message-ID: <20261104211108.382642355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 35ff1a7a7e3835c3e974bc5c45d335897564ceae upstream.

nfsd4_sequence() narrows the reply buffer to the session's cached
reply limit before it accepts the slot seqid. A client may negotiate
ca_maxresponsesize_cached down to NFSD_MIN_HDR_SEQ_SZ, and
nfsd4_alloc_slot() then gives every slot a zero-length sl_data[]. A
COMPOUND tag can fill that narrowed buffer until it holds the
SEQUENCE opcode but not the status word that follows.
nfsd4_encode_operation() returns without running
nfsd4_encode_sequence(), so cstate.data_offset stays zero. It leaves
op->status at nfs_ok as well, so the COMPOUND is treated as having
succeeded.

nfsd4_store_cache_entry() declines to cache a lone SEQUENCE that
returned an error. That test reads the status the operation
reported, so it passes here. The copy starts at offset zero and
takes the whole reply, RPC and COMPOUND headers included, into the
zero-length sl_data[]. The COMPOUND tag is copied along with it, so
the client picks most of the bytes written past the end of the slot:

  BUG: KASAN: slab-out-of-bounds in read_bytes_from_xdr_buf+0x1bc/0x390
  Write of size 80 at addr ffff888003a549cd by task kunit_try_catch/24
   __asan_memcpy+0x38/0x60
   read_bytes_from_xdr_buf+0x1bc/0x390
   nfsd4_sequence_done+0x5b0/0x810
   nfs4svc_encode_compoundres+0x1bf/0x240

Check that the fixed-size SEQUENCE result, plus room for a following
operation's error status, fits the negotiated limit before narrowing
the buffer and consuming the slot seqid. The slot and its reply
cache are left unchanged, as RFC 8881 Section 2.10.6.1.2 requires of
an error returned from SEQUENCE.

Fixes: 47ee52986472 ("nfsd4: adjust buflen to session channel limit")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Tested-by: Mayank Jangid (OpenSec Intelligence) <mayank.jangid.moon@gmail.com>
Link: https://patch.msgid.link/20260817-jean-v1-1-9e356596ab85@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4565,6 +4565,7 @@ __be32
 nfsd4_sequence(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
 {
+	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 	struct nfsd4_sequence *seq = &u->sequence;
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
 	struct xdr_stream *xdr = resp->xdr;
@@ -4574,6 +4575,7 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 	struct nfsd4_conn *conn;
 	__be32 status;
 	int buflen;
+	u32 maxlen, respsize;
 	struct net *net = SVC_NET(rqstp);
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
@@ -4651,7 +4653,22 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 			session->se_fchannel.maxresp_sz;
 	status = (seq->cachethis) ? nfserr_rep_too_big_to_cache :
 				    nfserr_rep_too_big;
-	if (xdr_restrict_buflen(xdr, buflen - rqstp->rq_auth_slack))
+	if (buflen < rqstp->rq_auth_slack)
+		goto out_put_session;
+	maxlen = buflen - rqstp->rq_auth_slack;
+
+	/*
+	 * A SEQUENCE result too large for maxlen never reaches
+	 * nfsd4_encode_sequence(), so cstate.data_offset stays zero and
+	 * the reply cache overruns the slot.
+	 */
+	respsize = nfsd4_max_reply(rqstp, &args->ops[0]);
+	if (!nfsd4_last_compound_op(rqstp))
+		respsize += COMPOUND_ERR_SLACK_SPACE;
+	if (xdr->buf->len + respsize > maxlen)
+		goto out_put_session;
+
+	if (xdr_restrict_buflen(xdr, maxlen))
 		goto out_put_session;
 	svc_reserve_auth(rqstp, buflen);
 


