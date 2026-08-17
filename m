Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AC3FA5CC;
	Mon, 17 Aug 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977273; cv=none; b=nEdxo6CbFjxOIZ30BYyvhqL8Lzf9eOd0rBkQa8SNVHWOY8uztCrjfkG9j+223Y50rcnp8h1XsAA2wWVb6w2d2VabJknH9rwtTSQaXqV2T/ykd4uZdtFtaKhZ3dH2F7H1ccQkCuECCEgIdSNh3Pfh8luSmDG9xiCOZ0nQnJI/ZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977273; c=relaxed/simple;
	bh=VUBAwWbmdDOYY4Hpjy3hqZd5u5NrDcqOvAXBCxlYCKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDFH3hZ4w7iJctdO2Ia7YhGxwc+afwZCrUBzaeWMiQ3ClGye2bBz2qfQCcG/wIH14FVogNJhNHdzHSEcrrEYMuoxNmAn4bhOyiiMu9VXmrzlfNKIKP1+lT2VXfixm9G1JHXQxkVLCx7TgV1JzoHi3LIsplGF5+RsA7ZgwpHCa7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKrufES1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKrufES1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5067F1F000E9;
	Mon, 17 Aug 2026 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977271;
	bh=N9MbHR7BN1CFlZw82mXO9fN5YiB9FP0ricmcqycbgvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKrufES1fqcmOEeFxmGiZbE9qF5gF/ZEuWzl4Xyglbolvzo8KtK8VQfQN4Pg9CIhO
	 KXritPadv2/km3ZRmk7FwiZZEPb03Adb9BUOwnGdj6gStQUqsKRGHDO5HONDdi7jtZ
	 yvL2q2L/fNUL1VXQiuimgUHQOWlMVCDwD0RvZTUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 234/456] raw: remove unused variables from raw6_icmp_error()
Date: Mon, 17 Aug 2026 15:30:24 +0200
Message-ID: <20260817132549.252893825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit c4fceb46add65481ef0dfb79cad24c3c269b4cad upstream.

saddr and daddr are set but not used.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Link: https://lore.kernel.org/r/20220622032303.159394-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/raw.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -335,7 +335,6 @@ static void rawv6_err(struct sock *sk, s
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32 info)
 {
-	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct hlist_head *head;
 	struct sock *sk;
@@ -347,8 +346,6 @@ void raw6_icmp_error(struct sk_buff *skb
 	sk_for_each(sk, head) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
-		saddr = &ip6h->saddr;
-		daddr = &ip6h->daddr;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
 				  inet6_iif(skb), inet6_sdif(skb)))


