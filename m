Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704300;
	b=THaV1a/dDvJN8UR1FMKbVdTNtXfLM6+AjpVQ8dNz+yJSP6WoXjk3pEvCYCPGcoHjcWgx
	 iVL/n7LFjdrYbOXNf5bKps4UiRz19m7yuAyj6+S0dve99Iw9OFDhbaHhMIABVZEIvBOGr
	 hpTdNwNrzL90B6eGnNe0Ws4HcWEul1bIdSxMA0ntSSWYnhmEMoW71jiFG1BYHXRHDQA/D
	 4ZwrqdpdZp0R0c56ht3/179PFqNvBbLCUpKX6FHm4v2C9fNHTHN6pZqZvJ75O0mzmInBO
	 s3M7nB5XwsV0aYI6fzatwTuqZm/QC/az0FFJTYQA98I/qlVJmxBavPodOGfH17bhGMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gRCXrA2L3z912yGvzJVV+6P0oa2zE1427VWjWtZRkZw=;
	b=w12VFLIJCLPkkvHya5E4pBRSZ+84WrDqtmje3+5pgLXQmcpnNgbXLbGJiWIvQYcdbQkP
	 r619VHxgitpoeE1nNg9w3O9i7VbDNvJrQtbnsU8RhA0hNfGN4EcaKdk575vFGsRapVK+/
	 QMQ4YERLA8WyuFRE3xA71+lRsX3JunbIew2jHUAzF+B8EIExjufPdKcusIIkoIjsXtEWs
	 1+diA9OLZUTJ48JOmveWHymkigFtjLdj2/YZK4dv8TUD6TiiiLGA0aeDjHHnUThVfY8+V
	 IBpBMBGel6MZg1Lqf9LA6oHi5QE6ssp6SM0CsjHmF28AZhTj8ooB3S/RSDK490Ojcig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSOJyDBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52990606A321;
	Thu, 26 Nov 2026 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSOJyDBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E9B1F000C6;
	Thu, 26 Nov 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704299;
	bh=gRCXrA2L3z912yGvzJVV+6P0oa2zE1427VWjWtZRkZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSOJyDBEd03AwhhLZrvibxuzZnC8lPqFAdFVuuF9g7BeWrvpMdkOi6Bodbu6oo7ye
	 SgTYkQKUw5vWoNb/hubWoLeOjUAESXxnUjmF7Zcq/mJ+l2rd6zYASyRlk5rQaW5Mgb
	 18/tE0QmDdpv8q8ct70KV4Hu8wpkO0UBKCVGTv3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/265] net: skbuff: reject zero MPLS TTL before decrementing
Date: Thu, 26 Nov 2026 15:36:44 +0100
Message-ID: <20261126143610.233431731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 24614e72df484ad50ecba98aaa88c7df2448c122 ]

skb_mpls_dec_ttl() decrements the u8 TTL before checking whether it
expired. An incoming TTL of zero wraps to 255, causing the TC MPLS
dec_ttl action to pass an expired packet instead of dropping it.

Reject a zero TTL before the decrement while preserving the existing
behavior for TTL one and valid TTL values.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261031114135.3784868-2-thnkslprpt@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 207c4d85fad78..408e4b9935a10 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6026,7 +6026,7 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
-	if (!--ttl)
+	if (!ttl || !--ttl)
 		return -EINVAL;
 
 	lse &= ~MPLS_LS_TTL_MASK;
-- 
2.53.0



