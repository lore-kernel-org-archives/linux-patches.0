Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0721B34189;
	Fri, 24 Nov 2023 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swP5T+uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D12C433C8;
	Fri, 24 Nov 2023 18:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850864;
	bh=2vX+ycUjyKXFP+PIJ+uoAAVSyfIm65CaKNROSrlqiyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swP5T+uypiEdSrS0GI3rzP7HRIZoO0tTwPiZ3OSB3kcSleyJSf9nd+PyZP4UEi7F9
	 BiVcLXr2KaTwZcSID/nvBu//N/Hhm0RllbEVNdk5afNckMWV7DP20lg7gszltMGpH3
	 mO5a7SYvrDRMQSaX4L+xKodB9s1Lql8P5ec73lGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	k2ci <kernel-bot@kylinos.cn>,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 195/491] netfilter: nf_conntrack_bridge: initialize err to 0
Date: Fri, 24 Nov 2023 17:47:11 +0000
Message-ID: <20231124172030.348875780@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 71056ee847736..0fcf357ea7ad3 100644
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



