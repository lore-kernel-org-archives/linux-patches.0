Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027182;
	b=cSVmgULtGDyqAWeHcb+jmCZXBv1bNjqoNzDi8reEzUOG0bIr5FlZKtCzXhGccYO7NJV5
	 Zn5CxWozf1lAsNr2oqYqmJU1o3EyeVwX8hbpiPc6rfqwRHAlpkbKJugeEWYKQjF+T5/Rr
	 XIsTVoEI/wLCSSx7COzL8LGYEnOzB4EQL0q+vUGhZouTpEs6m1fzRNpKCUued1UXsIBtx
	 7Trb+zHF4FAkJ+wVqw4X9o+lVRrpvdhzvgd0wxKIgrw2zFvIthqWljMm3jC4w3GPHp/dY
	 ef4BhgCFL6sOZxB8Z+MjTCgzdn/7ualZmj68quYhPV5qP79qJfN8JEgPB6vSqgr7t0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZBiiOM7eufnAUJVJ9vTBQXkuzv+ppVdGhdoU1b0i/Q=;
	b=GYLZ87n7xdgff4LTyBCViQChBY3rcBchKXlked1oGljPAOjvHg7l+s6DN/53i4dGhxey
	 pQgtChYsXsetv9Qd7xFp+YS4Oon9rus/V6OOb6AAmDJ+FVdx+Wna928dE8QGKZb5K8SYy
	 QkFSNf6xJ+aT7sjDRrGmLsF6lib73qZqHIwY6PhhoXep4GxEzmWaAVxZp7NkIxFnchThe
	 QM4ESd+ktVQDBe0dOovWO5TZBOxa00xxxfq5G5r1GFA876gp7G1rRz22huFCYoMCsR8w4
	 f1mKKApgTL4UjXjH352UMtr3nd1KnVjlvTpfZY1/lv7vL+yNFOwZGCv+KZTSJh9K7yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wKsrEP/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCC2606A320;
	Wed, 18 Nov 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKsrEP/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CBE1F000C4;
	Wed, 18 Nov 2026 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027182;
	bh=7ZBiiOM7eufnAUJVJ9vTBQXkuzv+ppVdGhdoU1b0i/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKsrEP/ghGV1x+FLFDr/VVftMxyRi7rk3lSHoj+dMbGUyEWmq9HqyixtSVph/y+Fx
	 YK5fiEzm8w2uAaxzPfEKW2up+1m9Jr3H22qFuoNSuE0EDs1EROGE2JzV8/vtsZuvA4
	 taWYx5wTlfWhpq0qBbtMn3YVT8h04XfmxxQmMBTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1700/2151] calipso: update payload_len when removing the CALIPSO option
Date: Wed, 18 Nov 2026 15:57:15 +0100
Message-ID: <20261118150223.753479498@linuxfoundation.org>
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
index 2bc3a8fac86bf..5775ab1c39c04 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1429,6 +1429,10 @@ static int calipso_skbuff_delattr(struct sk_buff *skb)
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



