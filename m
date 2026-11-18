Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037805;
	b=msk0YvSP7dYfwPSCH+vlrnZgJGPT7c3BZh7WAQi0CFZVJPUhGsF0DP3OaGzRR1shRidE
	 6sqys2ZVDGXFx03x7EkipRovAK3S+t/yymO5ksgdod2Dcky/5BwH4B6mO07/fcxaqJM5C
	 7aXbPAf2fZTZk+Ls3QUo6NajPqVDFJCYnqQ9GE5FlfbT04Mi7/2UqqZg8uHgnYKGu26AS
	 +bQg1lWWcI2kAahmpKBXk8a07FpzE6SIHhMtduAjYrMAG7wuXxjLSLZaVehVZZKgtqOt8
	 aSprA5oubVS/CF4RtwJZrKpKXt7ssVeLA824ppcJgs1AM6A+QtFWsKwB5au5gMblwuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSBC+7ZkX2NqVPi1b8v09BgTgd6xAGkzair6whXSeMA=;
	b=HKiMVWMCSq9VuR6La+QVwbE95KDI1SV3AbKImxSTI623gBsQxnxa+kL1V8aBnPvAY1Ne
	 rqxdnviAViL+eXch1oTpCH2FtVfL4YQPyoRagmJvBRJovWxyxtocb9JFwvFGz9M5x8wn1
	 TPwrmApI3t1jlarVwfMihYPkP7YPTo/YKDa+K4uT/x5Z/M9EWeBl+M0F8qt/d5m29GGl4
	 jkAp9ATNfIi1LP18tiDa/dGfGzXq1kJaGlrSPnglYtx2Cr8ObTV/b2q0m1fMVn38sJ5Tp
	 1nrsONRF2423xDfCpCi/ChbKhgz6YlJcLRrxsTd11Oul5AAHox6ehq8M33JzxPQ0COg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3kQShoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93626606A332;
	Wed, 18 Nov 2026 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j3kQShoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7B81F000C8;
	Wed, 18 Nov 2026 21:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037805;
	bh=dSBC+7ZkX2NqVPi1b8v09BgTgd6xAGkzair6whXSeMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3kQShoSki0nXu4xED+nVO5ZxpaSd/H7FpwM2AU4GPNX9ej7uFlYs0FAOmaZOZVg+
	 /6MgzniyFIBdIU2aNsxgnp7n1NpW/hKQ5wD9JfC7Qf+uI6EKIa+NKatDjdf1HplB2w
	 51t7TOiK1ZYANl95gq18Tw6sCnxyQYk0W9dOHerY=
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
Subject: [PATCH 6.6 1525/3318] mptcp: do not use Fast Open on MP_JOIN subflows
Date: Wed, 18 Nov 2026 15:35:47 +0100
Message-ID: <20261118150406.713092301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac278fca2f9a2..9c4b83cd2c1aa 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -365,6 +365,10 @@ static void subflow_prep_synack(const struct sock *sk, struct request_sock *req,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_request_sock *ireq = inet_rsk(req);
 
+	/* MP_JOIN cannot use TFO, do not send a cookie in the SYN/ACK */
+	if (foc && mptcp_subflow_rsk(req)->mp_join)
+		foc->len = -1;
+
 	/* clear tstamp_ok, as needed depending on cookie */
 	if (foc && foc->len > -1)
 		ireq->tstamp_ok = 0;
@@ -869,6 +873,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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



