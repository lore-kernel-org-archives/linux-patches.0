Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040997;
	b=lnlAngsjv5ZF8iB8NbdBRF6qdPD9burfkECTiq54ELNfENSDwSwXQO1S2/HBxl8byrz9
	 sqBVRF3X4+OCSCRxM5Kuey/e35gcp4PBHal+eu/9m6wK8laizxC/kkS3lmZXiYAfKdClq
	 SMODGa/xKaFywENQkJUtB/MukNM/e5TAWhRpiiqIsHgsesnCpHwjkQrPonwpfxN+YoNvf
	 BMxVQ9S0T2gzzNTFfn5BubGB5xFYf6uJ4gNx7qpr5qjrTt6jggqMhz4JOPRicXIf4NT0m
	 Vs2o9euU5Iisr6I+2MnBxjq42YOJr7mqVBsgDnGooAf9e3EWyUFtqVE1JM1PfwprNow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOwbAiC5v3PnwqG5i++WTGoLuRKYQfU3om8N/c+2m/E=;
	b=HcUT74XXui+L3qPOneaBpWdOBIiWYZkP/VXaAbcP0OETJ14u40l8O6vJ4adI4FE/Y5ns
	 fda+zndR/U0jqI97+hYphCIPBjir3Y9ZI93q6x+43H/I0xJdsPXdOfKQnKfY9+LQzc2WG
	 ERGXISNvDq9POu1a5JwZDsTttCvIppW7EVsGSs4lJEkJwGIZzWBsCUwRcGBM//0Q6Ujoa
	 ZHcxSUPKReqJgFGt706HirqL/MAyVrYEWuJJ1xCeWkOfVbpeaHOBd2mAMjPJzIy4i6hlc
	 2RJTBp3Ac+PftaQCf7wq3KHdBUEeL+DRnS/Q+S+lqGjp/FtKLup+PAgpkgykDADnb6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZV0ULCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEDA606A31C;
	Wed, 18 Nov 2026 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VZV0ULCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E131F000C4;
	Wed, 18 Nov 2026 22:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040997;
	bh=HOwbAiC5v3PnwqG5i++WTGoLuRKYQfU3om8N/c+2m/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZV0ULCZYMieyig3MAIKaNNuF5vg2S5RlN6lFerG32UszGNiEIXf/Ma+yhmuRmble
	 xmGAkZN4m2wX8tpVtsn29vdrCzehNoYPmS/MxRKSBUG/F4I7dXR+RMwdDgTtZIQ7Uy
	 OhjbxhsIbWmaasJ6buRP0hB0aYpLMSXOz9fgvdrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2629/3318] ipv4: reserve one IP ID per segment for UDP GSO packets
Date: Wed, 18 Nov 2026 15:54:11 +0100
Message-ID: <20261118150439.965802680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 852c08d6a99149dc71c51cea125b5083f555237e ]

__ip_make_skb() reserves a single IP ID for UDP GSO packets, but GSO
assigns one IP ID per segment. Following packets then reuse these IDs,
either from inet->inet_id or from the shared generator.

Unless IP_PMTUDISC_DO/PROBE is used, DF is not set on UDP GSO packets,
so segments can be fragmented on the path and IP ID reuse can lead to
incorrect reassembly.

Reserve one IP ID per segment, using the same test as udp_send_skb().

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930144018.1174068-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index edf92678ba043..19a1bb3d8b555 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1411,6 +1411,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	struct iphdr *iph;
 	u8 pmtudisc, ttl;
 	__be16 df = 0;
+	int segs;
 
 	skb = __skb_dequeue(queue);
 	if (!skb)
@@ -1465,7 +1466,19 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(net, skb, sk);
+
+	/* UDP GSO packets are segmented later (see udp_send_skb()):
+	 * reserve one IP ID per segment.
+	 */
+	segs = 1;
+	if (cork->gso_size && sk_is_udp(sk)) {
+		int datalen = skb->len - skb_transport_offset(skb) -
+			      sizeof(struct udphdr);
+
+		if (datalen > cork->gso_size)
+			segs = DIV_ROUND_UP(datalen, cork->gso_size);
+	}
+	ip_select_ident_segs(net, skb, sk, segs);
 
 	if (opt) {
 		iph->ihl += opt->optlen >> 2;
-- 
2.53.0



