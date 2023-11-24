Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A8339BE;
	Fri, 24 Nov 2023 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlRTetWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1C1C433C8;
	Fri, 24 Nov 2023 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851913;
	bh=A3Vz4NSS4VjmnxHwI1O0wxgNbo/9IriK2WPv8SotwZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlRTetWVB+veA7K0tzBELNaFVdrMZVMjOXyyjd9AQ+NHYAPnKALm1uPFt/D5RRQ1k
	 G/X2a+3goDruOW8IAiceKBAR6UdM6y2SwUNVdZMQCnima5fhKaDsOn+r6SRVfho0NS
	 jKR856oAZQm7ZTre0wM71iIpG/qvU+lEoBXTn8P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	k2ci <kernel-bot@kylinos.cn>,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/372] netfilter: nf_conntrack_bridge: initialize err to 0
Date: Fri, 24 Nov 2023 17:48:53 +0000
Message-ID: <20231124172015.351104697@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73242962be5d7..06d94b2c6b5de 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -37,7 +37,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	ktime_t tstamp = skb->tstamp;
 	struct ip_frag_state state;
 	struct iphdr *iph;
-	int err;
+	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-- 
2.42.0



