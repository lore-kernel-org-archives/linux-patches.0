Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214791;
	b=iTTNZG6VE+or3qwNWJlJoVSvpvJBvgxZvKtH3XHB9yuCghq6450x0FdtdLWWO4Nwl8ye
	 dAHwQyHd874LxufoAQFmM8nsoLxp3u2rQzCib/1/sfEBlfRzwr8tI/lOObf/TiV5doFMC
	 7Txqzg8Adup/oAd1Yntx1IfAKwmskvpxxchy7297B+GMn9aHJnuCcE4BtRA9FJ9/cL+zO
	 8onOoKNDzhCNwPu8CKIL5pYrORQgPM8yyeOK912lJdMFrhbh4N+Kk9iwSQfCyZ+Onze2q
	 zNaGxYtw7+4Ojc+G75fCrF+KOB0TsW6vP6eiAPn2M1eCOTjzcq4AOUBK3MN+pvdu8Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/V7thOG9tN7Ax/1sA8/KakwLOeCZfC2AP6ySxawEo3U=;
	b=vyIgG0b3ZkUgijrzkrAFRQcG2IiabMPpyF4tRMi4Av4Rawth4VserWLTUqLxv1TXCa+6
	 x2QEQ8r8vxebLcpvUhvbDBHmdgp9PyFVG5OmMsFeGn8doLrqNzKqhXDDlOXkiPTb/DB/h
	 8ikIsOXOZEq0SuRT0TftQfJGa9orhY4yncc2/S2YUWCadGGiqJtLrWQSBa1le5kvL4ccE
	 2A4jy7PMb2lHAZBQeX97I8HVBPcWsCChKGv2JI7B9BFj1J8F9aXv/yrMtHHKA160edZdu
	 97Wgcyj+6lSb2Zo9ifH0Gxq2n410ELOkDNOAgQ+BXvhMHMtAKCZiUMk0CqXbq4aZN0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJlhDhjd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F160C606B7E4;
	Wed, 28 Oct 2026 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJlhDhjd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C271F01825;
	Wed, 28 Oct 2026 19:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214790;
	bh=/V7thOG9tN7Ax/1sA8/KakwLOeCZfC2AP6ySxawEo3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJlhDhjdNUZkCni8osbN56qN0lfH+vwD5cIQ6dgF8FDzBQIkNGje8Elw8Huoumtik
	 essQd4qfs0AwP1kK2rtH/W7jzonzopXhkyYXvhoW3tSMxfrow0vX3HMQshQxlX6CRj
	 ib0QvXsT4sHv2NVNXstiF00sPEkL3ekgxc8hHRgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0982/1887] ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()
Date: Wed, 28 Oct 2026 17:51:18 +0100
Message-ID: <20261028170521.757809828@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4e65a8b8daa18d63255ec58964dd192c7fdd9f8b ]

We need to check __in6_dev_get() for possible NULL value, as
suggested by Yiming Qian.

Also add skb_dst_dev_rcu() instead of skb_dst_dev(),
and two missing READ_ONCE().

Note that @dev can't be NULL.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260402101732.1188059-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 8db53f4da6604..05d8d9a5b3537 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -650,6 +650,9 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_schema *sc,
 				    unsigned int sclen, bool is_input)
 {
+	/* Note: skb_dst_dev_rcu() can't be NULL at this point. */
+	struct net_device *dev = skb_dst_dev_rcu(skb);
+	struct inet6_dev *i_skb_dev, *idev;
 	struct timespec64 ts;
 	ktime_t tstamp;
 	u64 raw64;
@@ -660,13 +663,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;
 
+	i_skb_dev = skb->dev ? __in6_dev_get(skb->dev) : NULL;
+	idev = __in6_dev_get(dev);
+
 	/* hop_lim and node_id */
 	if (trace->type.bit0) {
 		byte = ipv6_hdr(skb)->hop_limit;
 		if (is_input)
 			byte--;
 
-		raw32 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
+		raw32 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id);
 
 		*(__be32 *)data = cpu_to_be32((byte << 24) | raw32);
 		data += sizeof(__be32);
@@ -674,18 +680,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* ingress_if_id and egress_if_id */
 	if (trace->type.bit1) {
-		if (!skb->dev)
+		if (!i_skb_dev)
 			raw16 = IOAM6_U16_UNAVAILABLE;
 		else
-			raw16 = (__force u16)__in6_dev_get(skb->dev)->cnf.ioam6_id;
+			raw16 = (__force u16)READ_ONCE(i_skb_dev->cnf.ioam6_id);
 
 		*(__be16 *)data = cpu_to_be16(raw16);
 		data += sizeof(__be16);
 
-		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw16 = IOAM6_U16_UNAVAILABLE;
 		else
-			raw16 = (__force u16)__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id;
+			raw16 = (__force u16)READ_ONCE(idev->cnf.ioam6_id);
 
 		*(__be16 *)data = cpu_to_be16(raw16);
 		data += sizeof(__be16);
@@ -765,7 +771,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		if (is_input)
 			byte--;
 
-		raw64 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id_wide;
+		raw64 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id_wide);
 
 		*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw64);
 		data += sizeof(__be64);
@@ -773,18 +779,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* ingress_if_id and egress_if_id (wide) */
 	if (trace->type.bit9) {
-		if (!skb->dev)
+		if (!i_skb_dev)
 			raw32 = IOAM6_U32_UNAVAILABLE;
 		else
-			raw32 = __in6_dev_get(skb->dev)->cnf.ioam6_id_wide;
+			raw32 = READ_ONCE(i_skb_dev->cnf.ioam6_id_wide);
 
 		*(__be32 *)data = cpu_to_be32(raw32);
 		data += sizeof(__be32);
 
-		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw32 = IOAM6_U32_UNAVAILABLE;
 		else
-			raw32 = __in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id_wide;
+			raw32 = READ_ONCE(idev->cnf.ioam6_id_wide);
 
 		*(__be32 *)data = cpu_to_be32(raw32);
 		data += sizeof(__be32);
-- 
2.53.0



