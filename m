Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618691;
	b=0ztpZ7NLjHrwu5FhmySjvlLVWiVUmlRB5AscNwlbzWb1lvFEU6gjxhCEFyvfj+XExCUY
	 OQwxGxWaIIbBwXYFECrik1r+B1dDHx5Hh7KDKWYnr7ZGETyVFF6+OWlZY1IoNnx6hTpYj
	 Wn1syFeP/8iWt7iZbVyekx7BWmWp2JIuPGGhmfwhp1TMnDA5cNfM9jlThxAaaJUyxhBP+
	 aOdfRwvMqGHCWMD3KQc/CQKLdmAmMWnsDxgs08BrrCGSBevY+vw35d2FX9hZH+cfx3l8z
	 GX+rrZupWaJW3SDPBWupSVCyuv3qi4nu7rSwb7AlAB2j8tsxZNxcvbEorWoSwpqtpSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yr1ZUBHenrMxABxz4Q20n1trovnFBd8lkarv34UiC0c=;
	b=PCoV+cuHWuOmqXTRdRcUVT0hyufLIYJQp5BBzrwuoueD/h2hk7/ZyDehi3DRvR4l48y1
	 bkWpPzKIQK7yOx4udIIzOKJeViiPBefirEali9f3A3+8PLWS83b0gZlPoojL7Sy9deamM
	 cXpkAlNE2/qkVlYLSj6ZolT6cGvmSfyAyagqpy8KaYbJGjRHW62YOtw+16ozjhwNSqGup
	 3R91rnZGTac7nw9PbYLsIw4oPZdCDohadPG1oVMB36lukVQeOOjsYuFdHhdZwCDRVKiSo
	 aZlRpSMed3gS8fkPQKGxpuuIlURmPNIydpttwjR7Z18QcaB4ctKJVr1go5/Adrb4kFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/Q/ayZA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0A606A330;
	Wed, 25 Nov 2026 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/Q/ayZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB9D1F000CA;
	Wed, 25 Nov 2026 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618691;
	bh=Yr1ZUBHenrMxABxz4Q20n1trovnFBd8lkarv34UiC0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/Q/ayZAoq/Mbt9gAVAwofGPIUZZYgfx0qBOos/a78DQmu+Vs2D+btZXsc/zyZFLW
	 AlE+GwmudxpFhVJ7vxHKylyX7bHtVqnVZ3mUPpHt4FHgYdYvPd8nvcb8/wNosxosD3
	 27oczTdxPfe0sC7om/1nkZRPXItL2LpS42mELGwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0313/1005] tcp: initialize send sequence numbers before deferring TFO
Date: Wed, 25 Nov 2026 15:27:31 +0100
Message-ID: <20261125143829.070155173@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 57889a8f6d49fc153aa0017d13086ab736567f8a ]

TCP_FASTOPEN_CONNECT can return from connect() before tcp_connect_init()
when a cached cookie or cookieless Fast Open allows deferring the SYN.
At this point write_seq contains the initial sequence number, while
snd_una and snd_nxt have not been initialized to that sequence number.

Consequently, inet_diag and /proc/net/tcp{,6} report the initial
sequence number as the send queue length despite no SYN or payload being
queued.

Initialize snd_una and snd_nxt to write_seq before marking the
connection as deferred. Both sequence-based queue lengths then remain
zero until the first write starts the connection and runs
tcp_connect_init().

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20261102035943.9700-1-qingfang.deng@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index e40477b6b5549..b621c48a52314 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -543,6 +543,8 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err)
 
 	if (tp->fastopen_connect && !tp->fastopen_req) {
 		if (tcp_fastopen_cookie_check(sk, &mss, &cookie)) {
+			WRITE_ONCE(tp->snd_una, tp->write_seq);
+			WRITE_ONCE(tp->snd_nxt, tp->write_seq);
 			inet_set_bit(DEFER_CONNECT, sk);
 			return true;
 		}
-- 
2.53.0



