Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047361;
	b=wNE3XH9SU6MCKK2dwds2OBtkvjuFbQlk2uK1hAYa8qGtqIcvsgnumRn+O1mwhne1aQnq
	 MIKbvCsipyC3iR3zzMdAf8GbUGCJiTjJu2X9oL6W36HYzGZupzWkU1Yp5Gopi86heES86
	 cM4Pw+m/MOTjmKmXSvtXruv6N7Her4jCwZmqpqkKvyARbgjNiD5O5x8OGX3KUIhsNC+fx
	 uOz3q33UEdGb2ug6g3cxh74hs3iV2rpqcSkRNAt+WJHFMdoMZCWbV0gAnlFB13TZInTfd
	 gDGHFxTuG/LA9jVnWgPfbbwTpdLyLE2i77Ci8+Gfh66+AqvQLbCVQSpGH8HkAxfbu4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfLheiXLtO3XdG9tXy2FYyUO13jjXFI3uspl6LLkmRY=;
	b=EOuGdq/CKBnhcQCGNhN1Bh5tFGlIDG2Smbp443PS/80OKpDzMngDR/k5hURXlA4pSoQP
	 hGSumH36B1r9Xc4SsUxisO5seY4/IZJfuAN86Q18ZJSvGvmH4+vxBevE0/0t5KS0B1+F5
	 9jtSytRstvYpd5SECovACA0wM5KYyehjh5KL26KF2b/p0g+dc5NT3QuiY2r3sdbBliTfn
	 YC7SEOJ+lm5/hVhy/dowIRr34TnR0aSN/hHvCAzOa+1rjgbTbIYf7OVawn+BW2Q6a8UQi
	 wbETh6xACvfvxZkSqailGODs/m9ormuxvU5N3fXNG/KhpMUOovQ6lJGLCcZEjoGpdrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRvAf80H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15D4606A333;
	Thu, 19 Nov 2026 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DRvAf80H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AB21F000C6;
	Thu, 19 Nov 2026 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047360;
	bh=IfLheiXLtO3XdG9tXy2FYyUO13jjXFI3uspl6LLkmRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRvAf80H03FJDocZAkewtARabLhSewRB2jIfqAPCFxMdpi3KcmqzWccG2tSgBZLbU
	 06qbwD9f4/OsjYd2+Xj1ZNtkT87q3qkT6Up7UJoajxizChZ3cgNKDib/d+UpTONWvA
	 FwMR7zP7RMundF6Cp3/l/D7OKrnNl4aeDvDkdtkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1612/2857] net/packet: check TX_RING fragments before memory accounting
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118150259.397305114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit dc4dd12f80e499dc034710cd8195489abcf0b059 ]

tpacket_fill_skb() adds the full non-linear payload length to
skb->truesize and sk_wmem_alloc before checking MAX_SKB_FRAGS. With
PACKET_VNET_HDR, userspace can submit a ring-sized frame even when it
greatly exceeds the device MTU.

A near-INT_MAX frame can saturate sk_wmem_alloc before the fragment
loop rejects it. A subsequent refcount_add(0x40000001) can temporarily
turn REFCOUNT_SATURATED into 1. A concurrent TX completion can then
drop that apparent last reference and free the still-live packet
socket before refcount_warn_saturate() restores the counter.

Check that the remaining payload fits in MAX_SKB_FRAGS pages before
accounting it. Include the initial page offset in the calculation,
and move the existing -EFAULT handling out of the fragment loop.
This preserves the accepted packet sizes and error code while
preventing an invalid frame from injecting an oversized byte charge.

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Cc: stable@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: use net_warn_ratelimited() instead of pr_err(), add a Fixes: tag]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028181450.2221013-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ 6.1: adjust for context in kernels lacking 3948b05950fd ("net:
  introduce a config option to tweak MAX_SKB_FRAGS") ]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cc5bb8765f52e..779e316c68d08 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2694,6 +2694,12 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	}
 
 	offset = offset_in_page(data);
+	if (unlikely(to_write > MAX_SKB_FRAGS * PAGE_SIZE - offset)) {
+		net_warn_ratelimited("Packet exceed the number of skb frags(%u)\n",
+				     (unsigned int)MAX_SKB_FRAGS);
+		return -EFAULT;
+	}
+
 	len_max = PAGE_SIZE - offset;
 	len = ((to_write > len_max) ? len_max : to_write);
 
@@ -2705,12 +2711,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	while (likely(to_write)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
 
-		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
-			pr_err("Packet exceed the number of skb frags(%lu)\n",
-			       MAX_SKB_FRAGS);
-			return -EFAULT;
-		}
-
 		page = pgv_to_page(data);
 		data += len;
 		flush_dcache_page(page);
-- 
2.53.0



