Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215815;
	b=T6aAOMst/Utve3J+fqCC7noNtjtTWs8+jKNXOauZwcvlLnPgOo9cNf7cAHgEO5skxwZh
	 Qq2eHnJt+MhYs1xfJrmivp8fxqsFBrjH3GJwPeWEN+FvO/By8HQY7UXjXrPaVLt1fuHdb
	 rueP2gvRWRtdBBUtJEDLdrgyhQ06Vo7WeWmkPbw3lR85U1+p0b4TBlsnXKegpd/WBLwWO
	 UXNLeMqUCf29mqlsMG1DB1S2hpabJCYi2TCeeov7oekWeQJqH9zLwuDM/rCHdRPx8FIiV
	 OYM9067kdfhfGVuQ+NCKWaFO8sC+CyjqeZaPtJfJ7VHvivKwwH9oAsD8waJ5vrz3KXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UIbw5oEWbpWm1S1wapRGUX+3FIRelgX1vAPJc6UVYEs=;
	b=BGae78eAF4pNv6NZ/vOrMwz+RmWQ/3wm2k+sXeBsg1pozIK/+2UzkBiK0dCz76gKpNb5
	 HWeWyFhbNtQBnfOBoVPbq+dqim6erwpxY+GjZPIruv9SLHv4qAFqsSMQZR575WxSnd1yR
	 vaMd7+IVd3toykFK8alpCVMsknM9nY9KXJp6cnZqQj/qeWbHeVU9LQuHkFq8p/e8M2XHh
	 4SIVRxWk79o6HX0L9NZ9RcXZ4Y5dZMV1gTOYgbzyNnJ2ZDzh4HXsVBcoxTLR+LDyT/JEj
	 Vrl9uBGVvFqoO4iz+lPGNFVLKZOBoHUJwzdIFslj/ZuwyD81RBpP8SxqGPElQF6x++w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5TVtSq4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF9B606A31F;
	Wed, 28 Oct 2026 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5TVtSq4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C21F01825;
	Wed, 28 Oct 2026 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215815;
	bh=UIbw5oEWbpWm1S1wapRGUX+3FIRelgX1vAPJc6UVYEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5TVtSq4ahO1xePwE6IEyYXY4OcoiJXtFkgK1qWBkhjQ8KhZgj4RFgTa6ScKtTXSk
	 biIoa4CyBoLnbSCTT0R6FGVUwhLBq7tjHBqr2xR4+M9DCoC7jLm6J29J1nbwh2gnVM
	 eJLTLQDJQGH30lzfWTPanRnBvaGGpY4cqWF7FBeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1342/1887] bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie
Date: Wed, 28 Oct 2026 17:57:18 +0100
Message-ID: <20261028170529.979800647@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit 31a420a822ff92e2090bd5d65efe8e34e2d6d9b8 ]

bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie accept a socket pointer
'sk' with argument type ARG_PTR_TO_BTF_ID_SOCK_COMMON. However, they access
sk->sk_protocol without validating whether 'sk' represents a full socket.

Fix this issue by checking sk->sk_state != TCP_LISTEN before inspecting
sk->sk_protocol in both bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie.
Since mini-sockets are never in the TCP_LISTEN state, the condition
short-circuits and prevents dereferencing fullsock-specific fields.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/bpf/6218aa3534d0d2d3f448fde70a8dc2769d7a8201.1785823138.git.rakukuip@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 678fd0c108c84..cb62f24cb4a18 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7333,7 +7333,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 		return -EINVAL;
 
 	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
@@ -7408,7 +7408,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (unlikely(!sk || th_len < sizeof(*th) || th_len != th->doff * 4))
 		return -EINVAL;
 
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
-- 
2.53.0



