Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619619;
	b=cP0hZOHqmhSXtahU0nLQ/VYTp5C2Ji4ZrpjQL6DvQhYqAyjTkWBCAzI/FZlIrpkZdkos
	 Mtas6m2K3ohpvRaXQuPv+axVm0I2KqfRKX9lavH4ov1DjEw7AFu8V1QLA4Xxk7C3694mm
	 /LczLZABQaTRKpVIeEAlNXJM8Uil+KXRAUd4irVx+r3IXKJoLKAJ7eXfUYUq18jKInbuu
	 ttV1uX2s7RBInlZ3d9USX8k+hXld53/f9G2EUku+glCNQkKKcx9K6CqvnDxAk3mL/0n2W
	 W7At2Dt9qaGoL9w5hHdfjj5MF3sViAjUrrmeAaLXokT6vTBxAFWeWMOxeE1+AlUMzmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRGMWAmw0wV7bKQ9Y1asP4cNqppwdX25g6B9PwQbAYc=;
	b=Q0Gfkk0/4L4iafvcSnFUOe+pweaDUnCIQKOIXtne+OugC1k/ChtaJi9097+rULsyZ+n9
	 5ncZ5y8ANtTvhUOItgcpW4+cv6lwAXCCBbVhY3Aw5h1KJZGpl9Bl54djAw/azCQVT0rQ5
	 FeULXQe9IP5FHAXj7p4nxD2dagxUtdbvYoKmB6DyfunnSVWZCQ1YTR/tgLMn+IatOvKaD
	 R6IkmB9KGG2po09C/lYUW956XrR3h7RHJoeIB8M9u2hZHSAVTYJsWMqc48SV47J61g2Pc
	 dUR68jGHrQTS6GT8HcntKpgGBqVMgJwDBAAaWVY+pQCbJEWNLf4FTTjYZZoEZU6k+Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N59L2aOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B600B606A326;
	Wed, 25 Nov 2026 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N59L2aOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC131F000C0;
	Wed, 25 Nov 2026 15:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619619;
	bh=tRGMWAmw0wV7bKQ9Y1asP4cNqppwdX25g6B9PwQbAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N59L2aOqWliEnSpuWBPtfhWEbsP6eMWMjgf9keNCqId8k8MiF3GjjqaMDcv7RljrM
	 ddLKtP9BIRg739FTq/01oiRaOpWBGk4R0kJppB+p3gGadeHy5UvpZ967gkXXZQX/it
	 w+MPJCugiuoVbU0TC4gI9sXLyXpubjNk3QZUmpiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0656/1005] net: gro: avoid parsing headers from shared fragments
Date: Wed, 25 Nov 2026 15:33:14 +0100
Message-ID: <20261125143837.115684431@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit 44818c9a826d766dc0e21179dc76f229334f1dda upstream.

When an skb has an empty linear head, skb_gro_reset_offset() can expose
the first page fragment directly to GRO header parsers. For an
SKBFL_SHARED_FRAG skb, those bytes may still be writable through a file
mapping. Headers validated during receive can therefore differ from the
headers later copied into the linear head and used during completion.

For example, changing an IPv6 destination-options length between the
short and full header fetches in ipv6_gro_pull_exthdrs() can make
ipv6_gro_complete() pass an out-of-bounds offset to udp6_gro_complete().
A userspace reproducer triggered a KASAN slab-out-of-bounds read there
on an unmodified kernel as UID 1000. The same completion path can write
the UDP checksum and length through the invalid offset. The packet has
trusted TCP GSO metadata and spliced file data, so it reaches completion
without an skb zerocopy destructor or a second GRO packet.

Disable the direct-fragment fast path for skbs with externally writable
fragments. With an empty linear head, frag0_len remains zero, so
skb_gro_header_slow() pulls each required header into the linear head
before it is inspected. Subsequent pulls preserve the validated prefix.
This covers both gro_receive_skb() and napi_gro_frags(), including other
protocols using the same helpers. Linear headers and private fragments
retain their existing fast paths.

Codex assisted with review of the supplied report, reproducer and draft
fix, related-path analysis, and this changelog. The patched
net/core/gro.o builds with W=1 using the supplied x86-64 configuration,
allyesconfig and allmodconfig. The fix was checked by code-path analysis;
the reproducer and kernel selftests have not been run on a booted
patched kernel.

The issue was found by an LLM.

Fixes: dff0b0161ad5 ("net: gro: parse ipv6 ext headers without frag0 invalidation")
Cc: stable@kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261031050752.31869-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gro.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -414,7 +414,8 @@ static inline void skb_gro_reset_offset(
 	headlen = skb_headlen(skb);
 	NAPI_GRO_CB(skb)->frag0 = skb->data;
 	NAPI_GRO_CB(skb)->frag0_len = headlen;
-	if (headlen)
+	/* Shared fragments must be pulled into the linear head before parsing. */
+	if (headlen || skb_has_shared_frag(skb))
 		return;
 
 	pinfo = skb_shinfo(skb);


