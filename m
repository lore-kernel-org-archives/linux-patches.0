Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B81337C0ED;
	Sat, 12 Sep 2026 19:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240549; cv=none; b=FpbYliGsia30gfWfrxBA+kcvLThLMY4Q6B9EwyEuFlcJK3zrAuasrCMdCT7Z+P/He3QFF05L5Mnm2zFhYhjHfNEYPk4CyRotVpGy5E4CZLSGR88TjDyAB5CFl36UoosOk7qsqLDnBYPM5nK/jGE1Y1yggfSovPJKL5dglhf1USs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240549; c=relaxed/simple;
	bh=eWO3RZjYMpI1ixqLjFUUrgp8/nBvsL8J33N1TM3aZIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ET9TudxUhijex7NdtepcprUShghYsl4NVOIYzEycyW1ynJ91go+3Aux7pvCTK7lpPHrsdX2Yt3FmBk5Ln/46AjMVhBsfu8eqNLJ4tGN7xCg4/eHUA+k8kXoKC5ghAMyt2nYfgmS+Ld+MB468LoFyIhIe7l057FHX1oHWhvVQPNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i+aAaHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i+aAaHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF211F000FF;
	Sat, 12 Sep 2026 19:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240548;
	bh=Opp6xJqMGKTABuvgv8Fzti4tg2uYxDwFYFedVeJOMAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1i+aAaHzkogKsWl3yBJGCluKtVxVm0dPRXxhuT0EiNQ17mImdvDC918e2VgkiL2rz
	 mrz0NLTqwFyQMaSLkaBDT84dxQ2kOmNFoUGyoqggfAccgFJZ3BGnKdDyZqYcbDAlI5
	 /GguSzpI2259piMUSRYlYRDbglOoAK4Urn0frSpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 890/935] net: ip6_gre: Remove the unused function ip6gre_tnl_addr_conflict()
Date: Sat, 12 Sep 2026 09:05:20 +0200
Message-ID: <20260912065547.226295159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f00909e2e6fe4ac6b2420e3863a0c533fe4f15e0 ]

The function ip6gre_tnl_addr_conflict() is defined in the ip6_gre.c file,
but not called elsewhere, so delete this unused function.

net/ipv6/ip6_gre.c:887:20: warning: unused function 'ip6gre_tnl_addr_conflict'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2419
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221017093540.26806-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 709f34f7c28d ("net/sched: fq: add overflow bounds to quantum and initial quantum")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index a3cef396c8042..e61b317061587 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -851,26 +851,6 @@ static inline int ip6gre_xmit_ipv6(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-/**
- * ip6gre_tnl_addr_conflict - compare packet addresses to tunnel's own
- *   @t: the outgoing tunnel device
- *   @hdr: IPv6 header from the incoming packet
- *
- * Description:
- *   Avoid trivial tunneling loop by checking that tunnel exit-point
- *   doesn't match source of incoming packet.
- *
- * Return:
- *   1 if conflict,
- *   0 else
- **/
-
-static inline bool ip6gre_tnl_addr_conflict(const struct ip6_tnl *t,
-	const struct ipv6hdr *hdr)
-{
-	return ipv6_addr_equal(&t->parms.raddr, &hdr->saddr);
-}
-
 static int ip6gre_xmit_other(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ip6_tnl *t = netdev_priv(dev);
-- 
2.53.0



