Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E012EB15;
	Fri, 24 Nov 2023 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAeMZj+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25C8C433C9;
	Fri, 24 Nov 2023 19:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853858;
	bh=7Rp1cF7CzsO7gPpVqHA0MNX/eEzB1loO5lN2Sn9S5CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAeMZj+GM1RE3IdKnAi77IcyWJTW0Wf81BI20tKP6FguSE/App7cvd+STGxWK1N2y
	 Q2nFnDfowFPNkkdueGmSAK+edMk/fQf/sGg1Rhr1TLD1vwSk+tmCnYF40UczG3BXEx
	 WluJr1Qs2iBCltU/NGVZQ62dTPLhUV6k8v70Pius=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	k2ci <kernel-bot@kylinos.cn>,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/159] netfilter: nf_conntrack_bridge: initialize err to 0
Date: Fri, 24 Nov 2023 17:54:35 +0000
Message-ID: <20231124171944.340964283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkui Xiao <xiaolinkui@kylinos.cn>

[ Upstream commit a44af08e3d4d7566eeea98d7a29fe06e7b9de944 ]

K2CI reported a problem:

	consume_skb(skb);
	return err;
[nf_br_ip_fragment() error]  uninitialized symbol 'err'.

err is not initialized, because returning 0 is expected, initialize err
to 0.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index fdbed31585553..d14b2dbbd1dfb 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -36,7 +36,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	struct iphdr *iph;
-	int err;
+	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-- 
2.42.0



