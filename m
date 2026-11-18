Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020753;
	b=48wEX3cK1j0IRtSX+4N0nvSNO+25Cp9jUE+Ybp91KVvo1sIGS2RTN+Zn6fXwEJu6E9/Y
	 QgS4KA1uqAK43yHb2OIOGK9gswDCD/X6e1cLvd/AGbQN2A3so/rJdEwNxEw7+pAn6vvzu
	 gHxJReyD7s9yR9tyyRQqg9v2enRoeWZDWTVYqPfr/vIEUOIMQGYRawTs98R6cV0hESH0c
	 pBuv2C4lxkTR3w/2mmp0qFbwMJb0gtxDCDqAw936UqbjUwYTqjImKJr99kYy+yGuXSWid
	 axHY0dwDqWFKC6KdU6yIlDw65S4wFR68IoYYRhfx8g4hrioYGtvIuYZonTvlsKElBEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnHwb0MLq55KjDY/b7IU68FQSyj0oJC+sqbrFYRN7uM=;
	b=5kUcMCdjrl11CyfpPak5CmADcQ+yKeN7p8oBIOIo20QOmdiy+nwSm39hCtBfnGcKvvKW
	 3/HHUID2tJobG3tDRfFaE1dRZJCIX0w8YUBzkgtxs14SPHHg01ngh5vOLRZR+kViuDBhW
	 rJtYnK4H8Hz1qpc3LHnsNYNdzXiVw9v854dn1L1ke7xU25ue78Q6JL7SLsDQRiXInTJqA
	 T28W8jyVEF9SbXtcxqSrPwLoQ6feQ/Whi01la6s49TbU7aXJjeGrf3Bh2qQ98yoNe1sMt
	 He/L/jMrmz38q81J1DPgmEQqi4t15smtbQVlcl/wtFa7JYqMvXkj4ePnPcyO0qOIYpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f5vg5nov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562D7606A325;
	Wed, 18 Nov 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f5vg5nov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07681F000C4;
	Wed, 18 Nov 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020753;
	bh=jnHwb0MLq55KjDY/b7IU68FQSyj0oJC+sqbrFYRN7uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5vg5novCSWyUUdAZoFjC2gMa7EVPjo7HZ+8vPyP2FFrk52Hpq41X4IOQW+98rpAq
	 3ntCeWjxQdBGivnsZ8jEsyxCO0UDXpAK5ByAESJV2GnGoaOxvWb9VJT0hEaSoFv7rO
	 CtvsZjlTa/HiXRDdyEBr2LE+cUQ1lefUWETmtSkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2065/2651] calipso: update payload_len when removing the CALIPSO option
Date: Wed, 18 Nov 2026 15:55:05 +0100
Message-ID: <20261118150400.390250310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3017a456d289a..e399a42e30839 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1428,6 +1428,10 @@ static int calipso_skbuff_delattr(struct sk_buff *skb)
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



