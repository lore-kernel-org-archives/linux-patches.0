Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056520;
	b=t+OSaVOdLFHDH8Vmjp1GH9BP3/acTFGdApe1+yn52woyLPrPOs0qaSXYwgWkpzfRx9zJ
	 Qdm3uqmtoibrzTzX24TtfvE8QCnEMia81Yp+MLlAWxrowdI7vkop9mtZhrS2OEll1tZD0
	 w2ctZYu/yVnxyHuAuCcu/JrF+wLfxZ/vPUgG2UPAlSgyaUeNfufuoFon3ZrXNyxwwea5b
	 boNnSH4iPQCikp0UxrkEye+Ke1zLZdpkLC16eZZxpBFPqIs9adlJof9a5+3x1jeoXjRkh
	 2i1k+qYc18aiDgdSM8UMv+dQ0IPw6peE57QWKu6z1guQ+o/U/vVi9A+K74+KlPovEAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ikbZax530/N2qN9a+VDdm+CSvWEcd1S1GePdiLw1jN8=;
	b=YOEzRu4fyZrxC16pNUu29JcuPKwFcyd1j6j9QZKz5JWmRIp9V4pqyPpwYRMOc/AIDlx3
	 NFwiTkUWDw4rYOEORHEyO37JQuyjJD6F8R1+dVv+Tmh6k7qmlTELaYgFzQstTx+Qyks9t
	 nSvJMupjF1TzEgIzl0DmiJMZphpD/LOOwW98Xl4Hj/3UnRV0mTrg5AYeCrl8YtPx6ZIQt
	 KZk5vETC00rY4vupq91nnouTzLxMqNvmBObSwyODhTv6HqhAQFM1nuG1JC56z2daLEqzC
	 Sfgt0IftqCIuZLqNmqZymcHzPaMSJk6uwb0kN3yuXcSUuG07s/o4YLaUB2aTZIisA7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBECVeoQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B902606A337;
	Thu, 19 Nov 2026 02:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBECVeoQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874BC1F000C7;
	Thu, 19 Nov 2026 02:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056520;
	bh=ikbZax530/N2qN9a+VDdm+CSvWEcd1S1GePdiLw1jN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBECVeoQvFtZnV4cNNVqZRXQJLjVc2T+DjyVYxSZCN6wGlN9fC5kM2dDBb8AaHIsM
	 Lojyd2qp79ce/oEFvJAIiAetpeYgA9L3/8IhMTJwVle992MeF4eTVUKXX8vN7J7p2I
	 ASkLKIaXIMwKqH8KMBsTbYFEpEtV7TM0xfE+pQ+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2017/2214] calipso: update payload_len when removing the CALIPSO option
Date: Wed, 18 Nov 2026 16:01:33 +0100
Message-ID: <20261118150131.425682159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit 00accbd9d5021b942a16078bd5717d7865f6971c ]

calipso_skbuff_delattr() removes the CALIPSO option from the hop-by-hop
extension header, or the whole extension header if CALIPSO is its only
option, and pulls the skb by the removed length.  It never updates
ipv6hdr->payload_len, so after a successful removal the header still
claims the original length.

calipso_skbuff_setattr() already adjusts payload_len by the length it
adds; the delete path was missed.

This is reached on the forward path when a packet carrying CALIPSO is
sent to a destination mapped to an unlabeled NetLabel domain.  The
forwarded packet then has a payload_len larger than its real payload
by the removed length (8 to 264 bytes), and the receiver drops it as
truncated.  So removing the label on the forward path has been broken
for every packet that is not resegmented later (SYN, UDP, ICMPv6...).

Adjust payload_len after the header is moved.  BIG TCP packets carry
payload_len == 0 (see ipv6_set_payload_len()), and ipv6_payload_len()
then falls back to skb->len, so leave them alone.

Tested with client, router and server network namespaces on one kernel
(arm64, QEMU): SELinux permissive with a minimal mdp-generated policy
(network_peer_controls=1), "netlabelctl calipso add pass doi:16", the
default NetLabel mapping left unlabeled, IPv6 forwarding on the router.
The client sends 5 UDP datagrams with a CALIPSO hop-by-hop option
(DOI 16, set through IPV6_HOPOPTS) to the server through the router:

  before: router Ip6OutForwDatagrams 5, server receives 0,
          server Ip6InTruncatedPkts 5
  after:  router Ip6OutForwDatagrams 5, server receives 5,
          server Ip6InTruncatedPkts 0

Fixes: 2917f57b6bc1 ("calipso: Allow the lsm to label the skbuff directly.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Link: https://patch.msgid.link/179147329205.58079.5847298721173675285@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index e4e2ee5059c3d..583c912ffe60d 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1432,6 +1432,10 @@ static int calipso_skbuff_delattr(struct sk_buff *skb)
 		skb_pull(skb, delta);
 		memmove((char *)ip6_hdr + delta, ip6_hdr, size);
 		skb_reset_network_header(skb);
+		ip6_hdr = ipv6_hdr(skb);
+		/* BIG TCP packets have payload_len == 0 */
+		if (ip6_hdr->payload_len)
+			be16_add_cpu(&ip6_hdr->payload_len, -delta);
 	}
 
 	return 0;
-- 
2.53.0



