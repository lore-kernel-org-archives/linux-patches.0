Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585747;
	b=FkhLdspVFryZxlznUTSw1UgmuBy+2LD0872G4+UT/FmR9crvq0ucgk3y3Co6ll1DdPbY
	 +ICUM5i+mDpy/U5rbfkoHHrU5+yD0wBgGJYVbKBtkntTAINUI7ZVEP8SozyniZvRfURfI
	 tRTcMUjXDQ0/1JPMMY/PzeUJ3QBz8mIQtWv9tfvYycKjMucBKfP90Z4juj3/tUA+nzVcT
	 1kEx0hm4+BSNPBs+x5UQKLZbBKwP7DEf8+/5JQjhLA9aGasqCWNBrC07UnJr0/9Bb706k
	 g3vBHpbJ5ckYeM28HuHvbKLyrv5LrPdcYxYcQK1/Ebnna4OZuUV6J9L1T+1mbnfHHMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ieLH5tObU1GUFiWXVfZBNYzhWnEQ2ohxewa/QmoXQnw=;
	b=T6OmiX14f35takSE2PRVyUD9G7okOKq9Aopt8/ADtb8+fKi2+HFLWT2gVZk83+g8DW8c
	 edf9Dp50jryTA13NhYZZMEPRPAx6V9g6TtkOALyufM9mQYpaTzt46FOgmbf627JMGv8kL
	 kpw3JiM4vXPWtRsvYQjODJ0Q89LExn9wLZpIlS5S/9VM4p9llWUVCSRaSENxz1lo5KQ8H
	 q7I9oDvtWjlNQ87WrWM14A4hB4tXTFMWBCYY309kmmWAmJU5+o+/Qnxtz8C6AMeKv9l4D
	 xYf+ImXpT1NQZRZOIXdSoNAuq3EfHAZwYdcZQUNbvTFJZrk4IE9O8rkuaemZ4GhJlRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juxDTar3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9537C606A336;
	Fri, 13 Nov 2026 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juxDTar3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478F61F000C4;
	Fri, 13 Nov 2026 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585747;
	bh=ieLH5tObU1GUFiWXVfZBNYzhWnEQ2ohxewa/QmoXQnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juxDTar3BXTkY3ygSQnF8pQY2BfMyCFM+B0J9pngxTYCzMxGPY67qmY4zqALlK1tW
	 phX2oHdHsDUVkf2cXSl2TKTdFxPQZ8PE9TCDi0jlYYzSRMO+F4e2usqb17TRNCEz3n
	 lNeiS7ZKkMxP9DQHG/RHG+9D/GQNqQVQGXENeLRU=
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
Subject: [PATCH 7.3 344/507] mptcp: do not use Fast Open on MP_JOIN subflows
Date: Fri, 13 Nov 2026 10:50:48 -0500
Message-ID: <20261113153807.054701353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 2c72cb50fbf36..0b67b46ef872e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -379,6 +379,10 @@ static void subflow_prep_synack(const struct sock *sk, struct request_sock *req,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_request_sock *ireq = inet_rsk(req);
 
+	/* MP_JOIN cannot use TFO, do not send a cookie in the SYN/ACK */
+	if (foc && mptcp_subflow_rsk(req)->mp_join)
+		foc->len = -1;
+
 	/* clear tstamp_ok, as needed depending on cookie */
 	if (foc && foc->len > -1)
 		ireq->tstamp_ok = 0;
@@ -887,6 +891,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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



