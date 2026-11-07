Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065448;
	b=zqLpZJHhjLWh0BrNTYN897S4+2rWTPoEJYQ5XyT0aD/0fbH+QJD4/BK8rquQC8+eSWym
	 J2Zyfuft5jF+hcifORjwzzDqS2dlImVRYWZcisAhMhTd87gX0/p3CH4/odLSJGBbvXyYw
	 TH/YmmqQuoqJUr8Wq2xDC/xVNqLWBKl8lNJl7svYrnJy1CEMXeQ2hvl1f6y/ryi4jYZcP
	 oCRa6n9PJTSPqBGiqknOQ5xWGyd0ISYw2zLHqnzv8d+p0YsPaXzvMyTtgHkltC6ReeZ51
	 kQe3LnCOn/bIz/cxeT2idq1T8xbiSDrBTIVDuK2qdOEdR868GUTGxpT7Qt20uLQkLiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ua5kAruTQOyt3j7sbuyeV8B9LeLq5OK7fEFJ92oxgU=;
	b=DlPrCqyU0eECMTwNvG6uRBK8NMlUPfVjTWFQjcosVC7m3R8T9RcCBrPj4Adf2R+TWIDH
	 E48QgxI4fqkWxMcdMsonyZ8qkBOyFuqsIes8JHeKOgOfec7fIWsvOkUQx9mM1jF6Vo+eI
	 4PPlWzv8ecYNAEK+ytQV93serCX17IWVb9/VS/ec0cZ0BsdzPzuQQsjnLFVwghXbDwyk+
	 BC8JRDCNWX62m+gXmVAyQYqsE2lvImmjnbpjKaK/5vFbCHsuzJrkhZkfSj+LQEG0b3CIW
	 2ngZjKEEZM7A03bvq1uQURM2yH9TehWBh8O2l91y0H2p7FLNGhIzUGtnrPUWJ4RPpeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSVoaSSZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38280606A32C;
	Sat,  7 Nov 2026 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSVoaSSZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E31F0089F;
	Sat,  7 Nov 2026 15:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065448;
	bh=/Ua5kAruTQOyt3j7sbuyeV8B9LeLq5OK7fEFJ92oxgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSVoaSSZFOQsHjD5f/sQ9lBNY2OCB+u0HIqEY4aeZYiNAVwNsDv3JtHRzkGkD9R3d
	 2d7YNKvHiTCt0JE3S83VA53MXqsWpmY+tPwH7w5DG/IR42OFXhZHRpR3YYFj/iOcmc
	 Op7GBET4IHPmDBcWIsJbFna0oGc4xneotES7lMF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Naman Gulati <namangulati@google.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1151/1257] ipmr: drop packets with unknown ingress VIF
Date: Sat,  7 Nov 2026 08:57:27 -0500
Message-ID: <20261107135010.999681737@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 09280680f2ea060514be2a39ea84209fb6d721d4 ]

A packet can race with VIF publication and make ipmr_find_vif() return
-1 even though the VIF device pointer is already visible. The parent VIF
device check can then pass with an invalid ingress VIF. For (*,G)
entries, this can also let the packet be forwarded back out its ingress
VIF.

Drop packets whose ingress VIF lookup fails in both IPv4 and IPv6
forwarding, before checking the MFC parent device. This prevents
forwarding with an unknown ingress VIF and avoids the (*,G) hairpin.

Without the early check, the negative index can reach the IPv4 offload
lookup only for an skb marked for L3 forwarding offload, currently done
by mlxsw. The race is rare; the supplied PoC reports only the UBSAN
negative-index diagnostic.

Fixes: 4eadb88244d1 ("ipmr: do not acquire mrt_lock while calling ip_mr_forward()")
Fixes: 9b1c21d898fd ("ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Link: https://lore.kernel.org/netdev/b966eb102e98f299e45be59ada033a8766e4c6df.1791899747.git.zhilinz@nebusec.ai/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Naman Gulati <namangulati@google.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Naman Gulati <namangulati@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/5271fcb94a4d9e697ed64a348e92ea9e74faab1c.1792608753.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 3 ++-
 net/ipv6/ip6mr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index ac1ed8acde8fd..f51014b37178b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2078,7 +2078,8 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 	/* Wrong interface: drop packet and (maybe) send PIM assert. */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		if (rt_is_output_route(skb_rtable(skb))) {
 			/* It is our own packet, looped back.
 			 * Very complicated situation...
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index c50e4b7c81844..ed9d786f1a423 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2218,7 +2218,8 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	/*
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		atomic_long_inc(&c->_c.mfc_un.res.wrong_if);
 
 		if (true_vifi >= 0 && READ_ONCE(mrt->mroute_do_assert) &&
-- 
2.53.0



