Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830836;
	b=OfdXEKva0HZMY5r+5ZlQWVkQBMFIjIa05wdfm31ZCP7K1coPGX6K/eZCY1h5wJ+/OP/L
	 rQqN87A/TwlB6fgFRc5qvwOIm5hSUouPV2WNeZRuBJQvFaYDc13Gz8+RpB8Vaqh6nDz80
	 CRvbKM4jP2MBKxdORjXLJ6jmZo0zk85jixgNXwDriEuM1JHt1dhuAD8jOYT4EeptV4KMv
	 DlDeveqshpD8+Ct/4g+z0Akm+NW/l+xw5jWTaWZkvpv3vWjuRWlpXADlmYHmCWDLNF1Fm
	 hvZNVDPMbTlN9vSCef3tfNkY8Vjm+9NLlZliIr6MoaQ1mhCR4hrNqHM9x3t/Nae3KPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DoIXRaLgu5QdVQhdH9OJ6ZZH1qoZfo4lGzoixcLih5I=;
	b=y6JlfLft/sUEMGx7N575ag1xtDOkh1EOy8TDKUDS3E/U4ftHEBUzNP+Qf91ZNj2YUs0K
	 Xh0lF7XWLDHesYdF+MzNDOZMp6HWJu+ZMC5U5EtZcDgFhV8mf01DhXY8pcUwvSbc2D1D2
	 3zHtKjNSaj1bYvFndmO8hCq+c0+xdpiCIOvbXQURFlselgHXBYPybVMYB9U7yFh79o4zY
	 pbhM3Hm/V2AWE2HiEVVn0s6lfy37WZgpZ4Lkpq0pU/PibBbIJI93nCSsf8N2ctAc2CF7J
	 qA+A8pRZwCK1HjCMsz3Vc5K66ZA6xgg5xcOg2bZGtQPccnzux1TT1lHzCKMUu5QsPoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkR62y5u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69F606B2D8;
	Wed,  4 Nov 2026 22:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkR62y5u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3461F0093A;
	Wed,  4 Nov 2026 22:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830836;
	bh=DoIXRaLgu5QdVQhdH9OJ6ZZH1qoZfo4lGzoixcLih5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkR62y5ufjrk6+Sc+wQkpf56PEmvVDR67buKDsjQaQzOwUr3IH8w+nDyVlzERGdtx
	 0mzHlfD1t4rPKR/ED5+oajICYsS4TqBa6jl3efg8DTQYox62j6dKs00/uxxdBwO6ak
	 KL4WyWhmJ2iwAsEdJGj126AqSE//gs0xysFcCpjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>,
	Jianjun Chen <jianjun@tsinghua.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0301/1005] netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets
Date: Wed,  4 Nov 2026 16:00:34 -0500
Message-ID: <20261104211052.348804104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 91da35e2b0d8d..456721e40ed0c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1325,8 +1325,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
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



