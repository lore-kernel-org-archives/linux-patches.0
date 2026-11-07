Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064938;
	b=U0SgoTrX3iWPydl1ZDgcBlaozYnS/XYHQg6BFBn7HWS7PkiNFLPUM5YrdSfsyFrcqcb1
	 bflmQcON9iSwgd5xMW8vxkUdJCyb8ihrTXgFh+Dl2ifQM1WT9n3XY6jdhC2j6/fUUNRpq
	 5YAH2fpQrJE0cA/NN1i/ymgwZn0y2vuzA51Wiund28d8gP0yH2eSpl2P0QB4yt7Ansng1
	 3w1szaplUS/6XIX9hx3HKKPlTJKwSmpHpFuD0QR7aS4ejscpEHOFpr3X/kbVKAIXuU7If
	 NBmgR+z3QVhAUOhXQX5kAiJw65ua5zjrc6GCtM+5IPQ5miWEn6NDYCyMS9CJb2JvNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vhbIT1vgvftVdboGuo5CUkFZMO21l3Q+Y5qpvj90Dvo=;
	b=o7/6vt5UYkvlxPXVKuSHKDhJeugL8whdeL8rIwOj6R3XUcNqaQaM8LHvm+7dj7RD4fqE
	 EI5i5ye7iu7jMJgFtnAvAGA6rqfxJ64YNZ7z12+Fi5HjEJl6GLo7+/qQdbuK0j7OsmMrX
	 Z58r/OAYU7WHdPjfTjnhwrBZqkpwEpZpgoJrF4w4BuAOLZYwtRoeDn6sQMkGWvg8UgZ+N
	 sI+NlaSL0fzlOpllJSCtKaKAVrP58pbsJAscDv+0UnuAXGhIgVwTdzt/FLfrpU8lJYGu4
	 Bcjsk9VKG9nmMg02OHyAL0e1/gy4qHO0LP2M+OLWY7CGSex1AXt1upqGxS/FjFshuzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4TwyIPz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACFB606A339;
	Sat,  7 Nov 2026 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4TwyIPz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF361F0089F;
	Sat,  7 Nov 2026 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064937;
	bh=vhbIT1vgvftVdboGuo5CUkFZMO21l3Q+Y5qpvj90Dvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4TwyIPzuQpN2YHpgN/cdnVuPWyIXOXcePCl7qX8A8Ne39u7vLJk+EO5HnegVOcU2
	 Xb0gmMpNwqVfCQ50bic/JBdzRTv+78KnZGfy5cNdGhkg60+YAMkvQ924JQWCGLEAZu
	 73ALhjWpXrQjMvqgZHAllxpejQ/icP1ng0d5P5Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0828/1257] ipv6: defrag: orphan skb before queuing
Date: Sat,  7 Nov 2026 08:52:04 -0500
Message-ID: <20261107135002.203204448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

[ Upstream commit 5dfa91a5ec53cfbf907a1fca095ac3ac7a4e94c9 ]

IPv4 and nf_conntrack fragment queues orphan skbs before returning
-EINPROGRESS, but ip6_frag_queue() leaves the socket association intact.

Commit 18685451fc4e ("inet: inet_defrag: prevent sk release while still in
use") moved skb_orphan() into ip_frag_queue() and nf_ct_frag6_queue(), but
missed ip6_frag_queue().

Without orphaning, inet_frag_reasm_finish() clears fp->sk on frag_list
skbs but leaves fp->destructor set to sock_pfree. Freeing the reassembled
skb then calls sock_pfree() with a NULL socket. A socket using
SOCK_RCU_FREE may also be released while its fragment is queued, leaving a
stale socket pointer; this is a second consequence of the same missing
orphan.

Orphan the skb before returning -EINPROGRESS so the queued fragment no
longer retains the socket association or destructor.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/5c396b7011168cd98b9812df4d6bbd00a96048e7.1791008591.git.petalzu987@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 05c51f669754a..a7964125c764c 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -232,6 +232,7 @@ static int ip6_frag_queue(struct net *net,
 	}
 
 	skb_dst_drop(skb);
+	skb_orphan(skb);
 	return -EINPROGRESS;
 
 insert_error:
-- 
2.53.0



