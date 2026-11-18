Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051308;
	b=qnr0WwbKJdNqQdJixLtsRG0Rl5ADDwzgLKyDrSETLYkNCBsZPd7IbL3xXl8IMoIiMuqU
	 fspalqcYRSwR+0i3MfVJt9WG+DmpMZzImj5AA31K8SGrI+gcbRHjk3HiIFFS4InUqyd0b
	 WjYbjx3Igsk7krTSxwn0u4Hpi7HqXjw8hrqJqc/MSAlzh7fuHX6sbBMWMBnTYrbqrJ099
	 APSNRt3FWRyp/tDwWHb80fdn97grKDrFvdXXCdjEOoB7GDjpzzy9Qaiw4d040aeIAGdrn
	 NWdSP/029Uje2YbziHktB0ay+fm4ap59A3uSNcTn8/0LNr1PWoxiMvCbAmIbeT9EteQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sXFa4YcDIEQRqRGiuyy1vMe8PcfMXsNL4KAecCilPM=;
	b=vror73kse1/K+BlXOJuouNxeHl0A77JIgDcgUwvo9Hz5gZyv/VKVDAZ3FuYt6Nj0+YdV
	 ZyB1FZp5RtK97DOOehgaHnHot+6Ialb+lMkNZpxsahcZ63zM+gusozlp3xEQZQMPt2ziO
	 dMaoTwhKCe5xzYvuuYuK3sp0jOLrbsuiDhczH0YB2LGty4cspyioF9hybhX9SouKzZSdG
	 yp41I4/Axe4gP2SFRzoiPOm9qFEzIUgLNtjLvN4UTg/xs8JJPGap8CZTvCY3crJtiFQ94
	 4iDJtcAbmcYDpj4VtpMKpRgHgrVlikXLLfpZnT5gN/fvNRz4t6Z09N4ySKRZ355aIPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZDbrf2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75568606A31C;
	Thu, 19 Nov 2026 01:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZDbrf2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6E01F000C4;
	Thu, 19 Nov 2026 01:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051308;
	bh=7sXFa4YcDIEQRqRGiuyy1vMe8PcfMXsNL4KAecCilPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iZDbrf2QdB2l2qUWFXbuaE+sBGMFoU3nSmIM1DKtquf9P1Zu46yZ8KvMwi1kKVZT
	 GwJJAyy726ZMaBvjHa7aIS9pVSaEWQZ7D+1l6Qveax814lTkAt2c3d1ahsgdc6Uzr1
	 N6wtGhUc3zdHA+UqsM13TNGaSyxtJpvISrxthGTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>,
	Jianjun Chen <jianjun@tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0161/2214] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:30:37 +0100
Message-ID: <20261118150016.559249423@linuxfoundation.org>
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

From: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>

[ Upstream commit bf80e6802273a900311b44e47c9b1a59c6d2473c ]

Commit be0502a3f2e9 ("netfilter: conntrack: tcp: only close if RST
matches exact sequence") keeps an established conntrack entry in
ESTABLISHED when an in-window RST does not match the expected sequence
number exactly, so the endpoint can validate the RST with a challenge
ACK.

The timeout selection nevertheless uses the CLOSE timeout for every RST
packet.  The bug is that timeout selection is based on the packet type,
not on the state transition result: even when RST validation keeps
new_state in ESTABLISHED, the timeout is still forced to
TCP_CONNTRACK_CLOSE.

Linux TCP independently rate limits challenge ACKs per socket.  A second
non-exact RST can therefore arrive after the first challenge ACK has
restored the timeout but before the rate limit expires.  The second RST
lowers the timeout to 10 seconds again while the endpoint suppresses the
second challenge ACK, allowing the conntrack entry to expire while both
TCP endpoints remain established.

Using the ESTABLISHED timeout for such RSTs would avoid this short
expiration window, but it could also retain stale entries for the
five-day default because conntrack cannot reliably match the endpoint's
exact TCP state.

Use the UNACK timeout for RST packets that leave the conntrack entry in
TCP_CONNTRACK_ESTABLISHED.  Exact-match RSTs and accepted RST packet
trains still fall through to timeouts[new_state], which preserves the
CLOSE timeout when conntrack accepts the RST as closing the flow.

This avoids the aggressive 10-second expiration window for non-exact
RSTs while preserving the short timeout for RSTs that conntrack accepts
as closing the flow.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Reported-by: Jianjun Chen <jianjun@tsinghua.edu.cn>
Signed-off-by: Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 60e3b3217f9ab..babb7b3eaaee4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1221,8 +1221,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
-	else if (unlikely(index == TCP_RST_SET))
-		timeout = timeouts[TCP_CONNTRACK_CLOSE];
+	else if (unlikely(index == TCP_RST_SET &&
+			  new_state == TCP_CONNTRACK_ESTABLISHED))
+		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
-- 
2.53.0



