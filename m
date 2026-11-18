Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025624;
	b=EhiOGj08nQVG57dxSPGf44T6HR4BQv0MtNW9ZRrn9fxMYmPplD/DHd+CPPxXUeWFHftw
	 6clhIUxQTM6/b/8ah6H1HGHQTfI8PBFhwnjqvgr2mXcr9E1Wdl/jq9X6R/36KJwiQZw3K
	 it69ZbeDjb3slZ+ZAgW9XtNxTYHn1v2o3BpPgZzlxxrmA4fmrTdj04GzF64J4qCwORGSq
	 XCIEqwSwPr8JYrvvnwmQAh2S2eE3xNV97Nr2SM132nySxsdRxlyb8rM2suGMdne9Sn8lQ
	 FYHBV7UlnJZcJWEBzmBotu/aMy0HmjIlTZ7LjQbzzHmAtby7e4YUw+HhGinpQUEvsEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdWdslIfM0TVSlwg3vFbC1hR+pD5SdMtyn1sk6x/YqA=;
	b=Pled7p4S+hmC7D5mGSbKQ1nhtThhyLWRbmx0BjVqg9iKsrB6BvxWIREirM0G/m5YFX8/
	 WGyqaqJtsQg2hLnOwOU9jILHP0cSVqV8SYjL+VrFyr47JHm54T6w2Y3zBILDsGbpYYFxi
	 sbkAxO5HHh+BvZd5gZQvCgidokdMGokM+2xhrG5njlXVaZFDY/xDR3wEfZAAJqz6n5de7
	 yzHmlOxpatVRzCr2mSbsciSlXWsCmVJ9MENhY2IFKky8nJvojZbPeq6QDV9wYkSE3CwbA
	 qcjRTfeSLMQMyGdgJzedazPAh5Ybn2u/7c2MtE+wtsF/PXLbpoEJl7xSitdPQnTJ94w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJXI5cgG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6099F606A331;
	Wed, 18 Nov 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJXI5cgG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B690F1F000C4;
	Wed, 18 Nov 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025624;
	bh=kdWdslIfM0TVSlwg3vFbC1hR+pD5SdMtyn1sk6x/YqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJXI5cgGCTc/yqAICSWvpJFgyIkhgFvsg1S7PnvyDkO0F6RzG5OKyk5E0vHEiJ9al
	 Hvi+i2z5Su8QMPuuqjQzMKAQYFEimaFApi+W5CPePTldd46+pFZInJ5zyl+F3CzBX6
	 lutFLirfD4nRhNE7vV7wxiZtzKQ3mKXnRFIfoqNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1144/2151] ipv6: add daddr/final storage in struct ipv6_pinfo
Date: Wed, 18 Nov 2026 15:47:59 +0100
Message-ID: <20261118150203.867752365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 03ff0cb1a9269a12c648e69e8b6ae6c2a723977c ]

After commit b409a7f7176b ("ipv6: colocate inet6_cork in
inet_cork_full") we have room in ipv6_pinfo to hold daddr/final
in case they need to be populated in fl6_update_dst() calls.

This will allow stack canary removal in IPv6 tx fast paths.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260206173426.1638518-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 86a19284425f ("net: psp: require an established connection for association setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c5541096a2867..3a58998bccfea 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -238,6 +238,10 @@ struct inet6_cork {
 struct ipv6_pinfo {
 	/* Used in tx path (inet6_csk_route_socket(), ip6_xmit()) */
 	struct in6_addr 	saddr;
+	union {
+		struct in6_addr daddr;
+		struct in6_addr final;
+	};
 	__be32			flow_label;
 	u32			dst_cookie;
 	struct ipv6_txoptions __rcu	*opt;
-- 
2.53.0



