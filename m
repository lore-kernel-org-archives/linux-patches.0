Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210187;
	b=YOdneKml6me9MsrEK9SkNbnDMZSQdV22h4JyqSVY5HMZ7yVXyj1Wc1Eb8wXaHPbf26ap
	 XdrKDVPGkPJOnC5Cx0ETv65gchL3qAb/qMo0UGa92Gq0/gFN8X5P33E1qdJM8JjoXatqq
	 2DcbzQq//kfNCKWxbzYwoE/V5zQ4YtjnE0dvogV94IXmkqfb5veqNX4A2DxAmR5+MJ2jF
	 mNt05tRNIqGvQQ/Q1loT82oqy6Myg4olqxyuvikYhWcp0ZTlzQhs3VusGAFcVQdhS3apb
	 HecBRzQ1y8KteVPQF5gXko28tBLGShfF0cVuC5nocEmYhCfql1Ad5+Tm7WePI0a2IZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9n/5/N3wzVShK0/ISRXpX6uSSJ5plj6f5rTOhZPmp0Q=;
	b=nNn9DQIxJnmVthHKvHVrbe7k3FHYmmYG6C67IitUy4RkL16XY3RpqQEKVPqR6IiRuPLO
	 iuc+KC1xwVgLG3GuvHdMD9VsVbDHsPm4Cwfq+9aQIKFhmcppKQxgrfSfT08U+GYB8q9pn
	 9v4fmeCkFx3zmhATVoz9xTQ1A4BujAY9eZhPWJnT2DtxONE+2PIZse7qFZU5tkuP+udwd
	 o7r0BYAdkEcKgwufpltSPPVlxkbGcuO2O7nhn2TDZYP4/H13vYZHxeKpRUWnn7bl1x+Kz
	 /Mh2kts5YQ/f1tLOTOMjSl/Bxnyu6b6tdcZvXEqBAHuyjeawiIXe7T+u2+QaoolRaXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihoNsxnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE1060A3811;
	Wed, 28 Oct 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihoNsxnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE681F01825;
	Wed, 28 Oct 2026 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210187;
	bh=9n/5/N3wzVShK0/ISRXpX6uSSJ5plj6f5rTOhZPmp0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihoNsxnLySxUdVibp0a3aGVKTVsTRdLR2WuaJXeA1OEvitx3UutwhJpyiDi2qbB4n
	 cm5IcNdqP02h9DMrDxm3U6afbHmuP+alA5tEUOWHVp5HNdQBofP7HegJUEQw/GCexK
	 gSVCpo/J5BNPE3X9U8XbkS23z0BckWAWBnGLeSK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/168] gtp: disable BH before calling udp_tunnel_xmit_skb()
Date: Wed, 28 Oct 2026 18:00:44 +0100
Message-ID: <20261028165945.645543028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 5638504a2aa9e1b9d72af9060df1a160cce2d379 ]

gtp_genl_send_echo_req() runs as a generic netlink doit handler in
process context with BH not disabled. It calls udp_tunnel_xmit_skb(),
which eventually invokes iptunnel_xmit() — that uses __this_cpu_inc/dec
on softnet_data.xmit.recursion to track the tunnel xmit recursion level.

Without local_bh_disable(), the task may migrate between
dev_xmit_recursion_inc() and dev_xmit_recursion_dec(), breaking the
per-CPU counter pairing. The result is stale or negative recursion
levels that can later produce false-positive
SKB_DROP_REASON_RECURSION_LIMIT drops on either CPU.

The other udp_tunnel_xmit_skb() call sites in gtp.c are unaffected:
the data path runs under ndo_start_xmit and the echo response handlers
run from the UDP encap rx softirq, both with BH already disabled.

Fix it by disabling BH around the udp_tunnel_xmit_skb() call, mirroring
commit 2cd7e6971fc2 ("sctp: disable BH before calling
udp_tunnel_xmit_skb()").

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260417055408.4667-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Ting-Han: this tree does not have commit e3411e326fa4 ("net: ipv4: Add a
  flags argument to iptunnel_xmit(), udp_tunnel_xmit_skb()") or commit
  1bec9d0c0046 ("ipv4: Convert ->flowi4_tos to dscp_t."), so the
  udp_tunnel_xmit_skb() call differs in context; the change is the same ]
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index f0ee46d3c873e..39515aba86e68 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1827,6 +1827,7 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 		return -ENODEV;
 	}
 
+	local_bh_disable();
 	udp_tunnel_xmit_skb(rt, sk, skb_to_send,
 			    fl4.saddr, fl4.daddr,
 			    fl4.flowi4_tos,
@@ -1836,6 +1837,7 @@ static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
 			    !net_eq(sock_net(sk),
 				    dev_net(gtp->dev)),
 			    false);
+	local_bh_enable();
 	return 0;
 }
 
-- 
2.53.0



