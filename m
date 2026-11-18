Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031012;
	b=IJwwRtQPDWailgp+BV5g0xSjFTm2Q7v0VZRbe3Ysx8FfDJyiLh/QOthCu4YXQd9iEQOW
	 Yq5iIm4lDKAo1TPZgNV7pp6c1jvroxY2elWa4JCUNYTq1BQz8kSoVTzdQN5Ge2CsZsVx7
	 I+nlT42DWgKZ4frw3Eb7trp+cACa5xebukYIzCuMCZqxxvPcKtAlOqqBFFWpYfUKZ6efl
	 rntZ80yKvPTUfPVKSXCpe3eCrFsQd4x13uKDWi04DyeOVO23/E/+MH/fnK5fJLLjWkslT
	 NhjC1K1xG6Yue9aeoJonnhMwmtTZzF8mVEGLmPxLF01yrBhFdh1g0+hsJaLMBEvnIHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P+YyRJ9PuZPF++2fn9sWX/CsWs7ExOjMr7cBIPUUAb4=;
	b=ARa4bNzEezYqdIIszEVd2oMODq63ByoMeLxkcrNMRrwGl/ofdjuQOVcrwY9qimaNSV3l
	 9MytjsfMOHS7KtkN+zHK3iPIkLY6Iv8sfqUokdS+KVIxeRDHM4JqU6Un217RWyv7tiqMd
	 XXlKZ48whinrVxSB3SyhQzqJlxWSDL8rmg9saJeFIXybCEuE5m4O0NIhgCZ/fOp+gLt+9
	 tzDN+EV3C82q6hR04p4LDkJGsNq0D8ZMu5pC+3RRPAyHOCXeA656bFsBx7R1VqkUHpiQ/
	 io5YHte4WS+SvARseJ1QBbPnToJ9z+obudRmRQaWNYByOift7BNUolI5Ctxr+vYwyGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stRwTPk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68DA606A32F;
	Wed, 18 Nov 2026 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stRwTPk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4907B1F000C4;
	Wed, 18 Nov 2026 19:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031011;
	bh=P+YyRJ9PuZPF++2fn9sWX/CsWs7ExOjMr7cBIPUUAb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stRwTPk4XdZ2Fvo5iG7rXu0BNjkWCurTPVK78QqypGl3fEA6PSEhNXH0P8e4oG2DF
	 iUV6X4cOkeVctbsN8FGDl9B+i59jbBBPf1Wf7BGA0VsHVpnzsJJRrBktFnmzR4018v
	 ZIPQfm8VcSWoeO3LSCsQfBnXVFOtliSG6l/LUbwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0906/1756] ipv4: fix IP ID reuse in ip_select_ident_segs()
Date: Wed, 18 Nov 2026 15:50:33 +0100
Message-ID: <20261118150046.052349428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit fe7ca0c13f7d477d6f461114815c57fde3f930ca ]

ip_select_ident_segs() must put the first of the @segs reserved IP IDs
in iph->id, as GSO assigns id, id + 1, ..., id + segs - 1 to segments.

Commit f866fbc842de ("ipv4: fix data-races around inet->inet_id")
used atomic_add_return() for non-TCP sockets, which returns the first
ID of the next packet instead. Consecutive GSO packets can then reuse
IP IDs.

SCTP GSO is affected. Other callers use segs == 1, and only see
a harmless off-by-one (UDP GSO has a separate, older issue).

Use atomic_fetch_add() instead, like the TCP path.

Fixes: f866fbc842de ("ipv4: fix data-races around inet->inet_id")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index f00719e1863f7..8a81a177862a3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -582,7 +582,7 @@ static inline void ip_select_ident_segs(struct net *net, struct sk_buff *skb,
 			val = atomic_read(&inet_sk(sk)->inet_id);
 			atomic_set(&inet_sk(sk)->inet_id, val + segs);
 		} else {
-			val = atomic_add_return(segs, &inet_sk(sk)->inet_id);
+			val = atomic_fetch_add(segs, &inet_sk(sk)->inet_id);
 		}
 		iph->id = htons(val);
 		return;
-- 
2.53.0



