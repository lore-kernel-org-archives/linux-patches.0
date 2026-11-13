Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590992;
	b=qbo6dndBpSIwNY5hlkf4wJzEnBuaxub/UU9gIMMncpPn/wAK9yzg4yyc2GgGsjpLwQSx
	 PnKdJg3yE7sDC8icXtqZAoD/SvPvrTED79HiG+9hhjdcXkg2xrBSsuFEwjVhxM6F3Nv+0
	 /uymtfpkKaXu9MYfbt88lGT2/SdLAVYcLjOMER/GLLKLfpDaNQrPWchxuJcGe481Q8FsK
	 NnU5vfiXC/yB9AVRpcRAZf3VbmnxQCET54TBVeLv3L34c8rydMfW8GaIkZt3X2/9fhPVv
	 ns2Nu7ThGN1BRkWp21/BLGGwz5/8OjK8nExPHrC63NbQWUPlI/RrsSCFPnkgEMwT5Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l8okJYodu8vTjRk+55OXH7ZpKRSV3u+y0NVxu7MTxjo=;
	b=xx84mJjgqqt0B2+DO7cjLCmguoAf1gN1SsPM3QIsjbUCyeOIDdbELvuqOS+fvEc6O7hd
	 gtOcnsi+byoReGm5ZtYWF8LORJUbOXwrNrWxQPIgZ2RhKlzVBqsbj1dYxJeDQTRVtfaY6
	 cAwFVmzq4EcOCS5Tn4ITpDMpTlY0OwlrgS3i+0gqKPSqg3VgqXK1NfNO+Nz72hcwT3cjz
	 Lw8R73X8tp2s5NB0F6dTjpcvXI4vjEqg8xmIgfm6foHbIhkliz0tKnui1Er+VcUhskdo7
	 vDW5quTyPBM9PQs/IhMIYU1QswxpW0dlNYaayFOPrZbqjLu2M2EzrGZzOgx/h7ka69Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q95K6U/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A0160703D0;
	Fri, 13 Nov 2026 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q95K6U/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4F41F000C4;
	Fri, 13 Nov 2026 17:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590992;
	bh=l8okJYodu8vTjRk+55OXH7ZpKRSV3u+y0NVxu7MTxjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q95K6U/o5DwGfFqNbrYGDg2/WGjV4+S7gYrDP3OVGX+6Fs0g2v8i4pjDe6YuNOPrY
	 5bsDwqu9WcRw7utI3jqksg3Mq3rtdj8qrDYqTNAIKFqOoOWcFZdcjSo3DjuJEE/POB
	 yEDkSmqvobHwetwA3sE+KcHpryn/KUm9kYkG4AuA=
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
Subject: [PATCH 6.12 166/670] ipmr: drop packets with unknown ingress VIF
Date: Fri, 13 Nov 2026 10:45:30 -0500
Message-ID: <20261113153817.705683057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index abd234f0861f5..3b58e8e88ad25 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1991,7 +1991,8 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 	/* Wrong interface: drop packet and (maybe) send PIM assert. */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		if (rt_is_output_route(skb_rtable(skb))) {
 			/* It is our own packet, looped back.
 			 * Very complicated situation...
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 47afc8cef6880..9a1d04e197ff4 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2146,7 +2146,8 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	/*
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		atomic_long_inc(&c->_c.mfc_un.res.wrong_if);
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
-- 
2.53.0



