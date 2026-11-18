Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031014;
	b=QJJFr1ARyJUTLL6a5Gw2dP0PxHWVUu9LCcZXRPuzKF0Ii6MCr7lv0K/Go6gbcSU0inKG
	 L9bGRMP+gF4ndR0By27xsrxAU4Mn9XTN0sPc+urKngPKe4kvMTPGb23Ww38orE3X+IUMq
	 PpAQKPIZ+zYfEITdkWl3pNXU/xxlQ/ALbhzPWzimULeMjuwCSZZoJKbEUgiaaln3RN50G
	 RNCJtbKHVVxonYqZi7Peh5d11XpY5emA+jlCQgm56Jh67qsGo0dyHgRZgGvcXP9BezKHL
	 f/b3f+9yu/KSbIE/dxFAfx3FwYvf39hDBGJ9cxYmeRMtoFcim83Y4T7jY3RndZpY45g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7e5Yh3ZEN/UPcwsxZy5G6eRszdkVd6zy7ikshAygs0=;
	b=mrUgh5sGMau0vVV04KYJVNxcIvoE3W1jq5LmjDJNxxqN2Ch/ci3LBhled06negbvHzjI
	 HvArE1Ihocm1jFIm7pp60r99Gr0CYgrZLVWMVDV9FMI6j5v3ygw6NUKaVl0yDsdaTfCw6
	 aqQP9KfogkFlX3Ha7VNuASn85EDjFnm8zXvGcGEDMdsFlH13g3V32CmuQw7Uc6bdHHemZ
	 jg0e8k3g+5l3DHIJtdTQFHYh0JE86XJMgMoFx44aNMGY1hFYykGOGCA8GAkZJSxyVc0IH
	 r4mQjs8fCcK8HfhQQHa9+vmADY5IWB3z9eMhMAbxtwJDxQmDvSQwM2aEh3Rqofv4R2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=El8qyE2L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9C7606A32A;
	Wed, 18 Nov 2026 19:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=El8qyE2L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0278B1F000C4;
	Wed, 18 Nov 2026 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031014;
	bh=x7e5Yh3ZEN/UPcwsxZy5G6eRszdkVd6zy7ikshAygs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=El8qyE2Lr2jC722W/HDeiIsbLkR0Rqgx3wDuzwzFmcHz5LjF6fynoj1/T3pChVT+v
	 92K4KmZxetlERon7PCxUOq9P2ChNCBrhRV5wLvxIRXuiVm8JO5C4MhG19KM7IrsQRd
	 wF/zlD32NN57/6YCphK/3kipKtBV83cs6QrS4SB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0907/1756] ipv4: reserve one IP ID per segment for UDP GSO packets
Date: Wed, 18 Nov 2026 15:50:34 +0100
Message-ID: <20261118150046.090328884@linuxfoundation.org>
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
index 5db785eb9ef97..903ad073995eb 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1412,6 +1412,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	struct iphdr *iph;
 	u8 pmtudisc, ttl;
 	__be16 df = 0;
+	int segs;
 
 	skb = __skb_dequeue(queue);
 	if (!skb)
@@ -1466,7 +1467,19 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
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



