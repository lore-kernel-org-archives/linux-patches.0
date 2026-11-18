Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034093;
	b=M+3et95dfCk8Y/qh2H5iu11ce+Gn96KKbqtvqsyDTjF/s59m2rbcwHlpgd2RhDRk9K11
	 FDxoKQFULy7ivOvi6A0XqOYqfh3Wp0gJIDuffRX3xUuIrGqDcqyDLRd8GbYjN/hwdynHN
	 HfczsTA7P2tS0hL7xly7MIGjHZF/JCvesmr0ENoK5gNP+pj2r8w6V+WHuw3keNGfT4bec
	 CmcZgJo8Qxi1433y2c929UvMC/1i9cv1i4uNXfmPwzMtz44p5FkmRrBmLOGXYdOzSUtWT
	 98Up6fjZhMPmrwmqJmiJwJlpdgzmLiVHMywadmapqHYtJpKkknccpLi+q7Yg/sydgtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MZX/SEyucO3/dm5EUeRd4IMNqmeKWuUJF88FaLWNpl4=;
	b=H695ZkWtRKONZATdaAQo9zKk0cLaAfTtdriVn+Qsj1c5uOrRx3d5Lr0nHwNH2hyWps3T
	 AJXVIYdjWTAGtgyMKm/jhNHomaW4SlV1U1XYcYbo+L/w8QcsI35Yd25L/a5P3AdBGsdDX
	 P16poKs+StrqOYqDTxrRuRVoz8EWC609GFoFpGxreqpxi/XPRM/HfuAPsFxiUEDhksG1F
	 vnSaE7ggSBuNXZCADZ2iOdLcgHWMOCOIheO1zvsaC8HRwtDqOdH06RXSLNBoLerbtFpcB
	 jK6qvxjm5LyfjunFGVtEapreTNbPPZn8fvOx5HcbcfblMbkA7CbQPTSVBnQLpeC1pYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCUJ+3ea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59BB606A320;
	Wed, 18 Nov 2026 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCUJ+3ea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD19A1F000C4;
	Wed, 18 Nov 2026 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034093;
	bh=MZX/SEyucO3/dm5EUeRd4IMNqmeKWuUJF88FaLWNpl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCUJ+3eaM6jvHvPhboROuByYNg7W6RmfW9CZN98Tf9OIRrs/OxAvIZrB4DDUrZezi
	 nrTPQo76sbOueVGsHVhkuB8NNtrO1GzCbGdv4qCoxY7+Ebl5BfJOX0XjSUto8Psjbl
	 tE3fNyxcNAGu/9a/SgF8rFWI2ok5nxdOr0hu8a8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>,
	Jianjun Chen <jianjun@tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0207/3318] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Wed, 18 Nov 2026 15:13:49 +0100
Message-ID: <20261118150321.115281702@linuxfoundation.org>
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
index aaf316c665661..1ca76c0becd05 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1324,8 +1324,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
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



