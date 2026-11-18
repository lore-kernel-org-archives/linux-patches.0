Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047115;
	b=0q5PaJmOirTQGwSNkQAxyE7zg1QAGNreoeL9GnY4B2XNCiBu35LMGjRDQD006+hogKm0
	 kY+Z5FbUA0HaXkuLUos9SDRr212sFZjX8CLHR9eslsLlbIs7qYH9twu+j+HqOResl1VPK
	 HPsSNPhMXH2Alq5IpiKeqy2Uq5JZL05clEFREqHmiSkHITOBSsL3K7ng9/+bsTiSnb2Jz
	 dKfu63ZWIA9QzKrmJXWTqnlhJhdVK1K2Lqs02JLaTrfFZwl33LEb4FkO+PUyUR4m3xwu3
	 WAFBEJIS0Gv8v0CctlfjTZbWrN1Az4Yk7ifFhZvZ8O01cbba2vzmJJjuEZq2Um9YTMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wJ7O8mKx9ho+9CEu3XI4IZqDFmSclIv2+Ih53Hdw00E=;
	b=brh+9PwgLFngtElHjCm0OsTM8nEso0QgqWRHat20Zg4RMNmxmW4Ya8v8IAezfkBvY53D
	 uspCR5oRhvguzanlYUUov0VAiF9o0Iyemp55NWf4Vw8G/haakg1Ddrr8aEVbM5Uf0+oWL
	 OJLxSvJOH+bYRgHL3wT7FSbCd5JsKoO6PjJKLvsBSbj88dyzUi+sU6IAGH9GvYF4Zz6Iu
	 L65oBm/js6kgzKFqCCS9PVSm6GNvhRqBy5hd8Qe+j93IaW0+5gIRoOlx0ZpLNy1BPuKDN
	 JsLur2faScKbU+0Hi3Qy3JNqqSCmPpJatoeRj6alXvz92C8kA+gfCBaQiqbTN6hi5Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnkAKsuK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078C606A320;
	Thu, 19 Nov 2026 00:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnkAKsuK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AF71F000C4;
	Thu, 19 Nov 2026 00:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047114;
	bh=wJ7O8mKx9ho+9CEu3XI4IZqDFmSclIv2+Ih53Hdw00E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnkAKsuKFJE859ZcA6wc4Xfh6nmhXc2kRnRcX6XCGGsvWRn0sLvsKYRD/Bf6Jyy8G
	 /lsvDh8pmtOpZl/474o7JDTlGR2i7fB3eh5RvdLOiFF/+1/6Ma9WQtGok0of4mCh9e
	 kw/33vbLjIHnSEbvU10GEsX+pyrFmXItY4Qqi9UM=
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
Subject: [PATCH 6.1 1524/2857] ipmr: drop packets with unknown ingress VIF
Date: Wed, 18 Nov 2026 15:42:38 +0100
Message-ID: <20261118150256.195679793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted IPv6 context to preserve wrong_if++ for the unsigned long counter instead of atomic_long_inc(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 3 ++-
 net/ipv6/ip6mr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 623c41514d4c3..c79267abadb85 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1992,7 +1992,8 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 	/* Wrong interface: drop packet and (maybe) send PIM assert. */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		if (rt_is_output_route(skb_rtable(skb))) {
 			/* It is our own packet, looped back.
 			 * Very complicated situation...
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 362e670fe7f7e..45120e9c750d9 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2159,7 +2159,8 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	/*
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		c->_c.mfc_un.res.wrong_if++;
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
-- 
2.53.0



