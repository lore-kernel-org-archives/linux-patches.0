Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591237;
	b=H7Z/UqRx7SyMCMyt6g9jK78+cQ5H7NtIQj+7EIwoejcczdq5SAoCR0dv1uVqRN5okLFh
	 yaDeTYiTKbgwbdk7SW3/DswgyBqZKGcxONlxZodglcUwvdunY3KHnnaInL1XbQbvitP88
	 6nGX6tXhRcYEBbnhPQwBYYOK4OkGFzXzqyxzgT2URktExGRim3sFhilJNnZxnJP2RZXZM
	 YtiKVC4IJGp9VHRuiKXtykjChcib4QD/i0TQo3XMgKl9gYKmte0cJiDIYVIsgFRVKj5y8
	 wI+2iYBGpULj/x68MKU+VpL0dBMeyI5qd5wwb8wXc9N5xqlhwMXGSPkSsz2+jS1SneA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtVjnYLmxygGTanf/b6PC/9LLJKQFbcWjmSFuDvp3BI=;
	b=0dJf4zubeHbEf+E3veP8HwWtQQa2SVM1m9F8VmP/6A6X81x2jX61R3LhSHWDWDq66LWF
	 n6PwooWnAb7Y2SWnt8eZH8YTo3SZ41fhhsF8qYQqdjq7tTgywHmW7aF8ZbEcGbRLhiIyU
	 zCaAEKyeFA45PrNoZXEqSt3FY1l+JzIZ+nYCQFdV9v2E/oSc+0xbxeNrKfqojLa00Lv7C
	 R77Yj+tlUxmEnIefXGCeBJv+KEpRPj5fcQIn5JpO60nNHflquCvmubhGZK1RXKvd2G5pf
	 UzvPLp17OoqPwYm1lrJqgXk+tlbgs86WZ9XuOomNNZjRCCUHil6EuSbykIF6AzZDGvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oloE7CZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2E960A2627;
	Fri, 13 Nov 2026 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oloE7CZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E041F000C4;
	Fri, 13 Nov 2026 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591237;
	bh=NtVjnYLmxygGTanf/b6PC/9LLJKQFbcWjmSFuDvp3BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oloE7CZGlVGYfl5nilIsZgml8ojaGppxS24pFdePfWGAVD+36bXdo2FNqcx/FyNwA
	 9smHmEOoMmlNo4+R3ga7MrYhvRD8PDVnXTSNz2fnhblQkmihnqlzmp4r9t45ZUN6Bo
	 ptlFRh+la7tpJe/N1FCcoE0KTvWAEsr5LsiPzHI0=
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
Subject: [PATCH 6.12 338/670] mptcp: do not use Fast Open on MP_JOIN subflows
Date: Fri, 13 Nov 2026 10:48:22 -0500
Message-ID: <20261113153823.309123107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index c4994b3b7b3ec..8f8ffc88214b8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -381,6 +381,10 @@ static void subflow_prep_synack(const struct sock *sk, struct request_sock *req,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_request_sock *ireq = inet_rsk(req);
 
+	/* MP_JOIN cannot use TFO, do not send a cookie in the SYN/ACK */
+	if (foc && mptcp_subflow_rsk(req)->mp_join)
+		foc->len = -1;
+
 	/* clear tstamp_ok, as needed depending on cookie */
 	if (foc && foc->len > -1)
 		ireq->tstamp_ok = 0;
@@ -895,6 +899,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
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



