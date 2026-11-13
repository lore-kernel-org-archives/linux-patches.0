Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590435;
	b=SYzVEbzyAGNHNfncZcngZYnGht/MdhRmclIlek6rlZxink5EfXlvJgq83o64LHxxrhfO
	 5pEiuxolPu/ShXdbZhW4Dwk+FSz1rqYsqhsWqXBsOzWxD+AerdcHlzumIGF1160Sp1d6z
	 fe+mpZL1sB1zFKhBqFIRar+wjYz9tP8Vc1LFV42lJwhi65R82PcYq1K+PPUO8d3oaplHC
	 pagpA0p9nuktVHM2y1/U0sWqxaPCXsrCo+Bl79++6Ly7oZwrHyXWGwrjTF/JQCKjHoljN
	 gx/7GX7SQ4J5zB38rERY0u6QSBxmbLZv+r3fEq2oWkEu/dq4RSWQG4PKGoYtmUrpCOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quWE9FASjkdsAR825fBObtXJyUJZTsMRiRxE5fxjpJM=;
	b=KYWafP9z9vDGZ51b19DsTI9A7lAs0VCtOq7P9jBRgac2D9J1jhIp9aFTTPIirT4rihy7
	 oKMCmNKD9vhoolKhWiSlY5VqWLIqX03c6r3MSf+Bzei+Hs+I9/wMBJHwiqZwDkZFsGWuu
	 PRJdlP0PU7oHkgsr9uJPWPCXsWtH1psQ7s0XRPCfORkwACnJ0RPS3ZzvR4GqA+4b4sjK+
	 yM0qYjEWoarWGnruDkvHWGN7v9JUKLYax5e4ZyC/6M11VPghSCrDgBDtRWIKareP61Zfa
	 fL4b/gBmjftL0GENFPZvgATshNnrednA93RRknLcy7sXsl5mXJN7LzchY1mHsV2HTqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVfNvAZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6859360703C3;
	Fri, 13 Nov 2026 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVfNvAZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197731F000C6;
	Fri, 13 Nov 2026 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590435;
	bh=quWE9FASjkdsAR825fBObtXJyUJZTsMRiRxE5fxjpJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVfNvAZOn7EoSst70vc/1mABDL96zOWzUQxW5X4lLTShRopnnwWQnumkzi3pd+YAJ
	 c9akM7jykXaTevokZ+1mEpaQUCdpQ60pxXF0XcqqTSBKunySvCCgmuF8BB7YNkzBaF
	 0NsYJI5d1AsLR+vspkiP46/LeAJEzO3LDpwREFc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/686] mptcp: do not use Fast Open on MP_JOIN subflows
Date: Fri, 13 Nov 2026 10:48:48 -0500
Message-ID: <20261113153834.386585598@linuxfoundation.org>
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

From: Yilin Zhang <yilinzhang@moonshot.ai>

[ Upstream commit 6d2cf411aba2aa0bd641b49be5b1964ac5097a50 ]

tcp_fastopen_create_child() hands the SYN packet itself to
subflow_syn_recv_sock(). For an MP_JOIN request this takes the
fatal fallback: the cloned child is destroyed and handed back with
drop_req flagged, but tcp_fastopen_create_child() does not check
the flag and queues it, so accept() can expose the freed child.

MP_JOIN cannot use Fast Open: data on a subflow requires the
completed HMAC exchange (RFC 8684, sec. 3.2). Refuse it (only the
TFO path passes a SYN skb here) and let tcp_conn_request() fall
back to the regular MP_JOIN handshake; also strip the Fast Open
cookie from MP_JOIN SYN/ACKs.

Fixes: 90bf45134d55 ("mptcp: add new sock flag to deal with join subflows")
Cc: stable@vger.kernel.org
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Suggested-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
[ Moving code to avoid clearing TS and consolidating checks. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261030-mptcp-tfo-mpj-v4-1-e6eff2027342@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e020960f093e0..c2d6a7adca6b2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -380,6 +380,10 @@ static void subflow_prep_synack(const struct sock *sk, struct request_sock *req,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_request_sock *ireq = inet_rsk(req);
 
+	/* MP_JOIN cannot use TFO, do not send a cookie in the SYN/ACK */
+	if (foc && mptcp_subflow_rsk(req)->mp_join)
+		foc->len = -1;
+
 	/* clear tstamp_ok, as needed depending on cookie */
 	if (foc && foc->len > -1)
 		ireq->tstamp_ok = 0;
@@ -889,6 +893,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			fallback = true;
 
 	} else if (subflow_req->mp_join) {
+		/* a SYN skb here comes from TFO, which MP_JOIN cannot use: just
+		 * fall back to the regular path.
+		 */
+		if ((TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_ACK)) ==
+		    TCPHDR_SYN)
+			return NULL;
+
 		mptcp_get_options(skb, &mp_opt);
 		if (!(mp_opt.suboptions & OPTION_MPTCP_MPJ_ACK))
 			fallback = true;
-- 
2.53.0



