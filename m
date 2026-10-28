Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212701;
	b=Jbu4MQX59q8trjyPzEpShI/ia20I+WManVbrR2oqZcKWSnhFi1tkCnBQJEFeEiR4VSRi
	 Gd8WIDJljKL3s4+uLVpFU9T8R+xRtCOMh3Ilai6ixk6qmtibLvtGXuJ4+0X2jkh9MlTAS
	 TaIi84blUUxnDzQSyhUCRZnye+41EjOVsP+AVPqRFXDAkn862xkmsU6Z1lQR/zXZpRdeC
	 BDgjjQUFjEePYbuBuLtwk0BJ1EFe2fMbK2w3MJKK6WiLeATI5vRQhPfoZI/3YBhqg8CF1
	 LJ3Y36q4Fuf/JDpaBM5c6VkYKlfENkWo+vmbEieHVhE/0Rtwbq3twCBA6FokkI7SSaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y3YSTJqoeW+bLSJYh9QCf3Oq0Bcoi7eslEDoR4dLLkQ=;
	b=p7dFMtJpcDDejGWU/VtQDtg4pxT0fY2sOp8MAfsgK8mM7bMWGyV2p4FKSAtjoX3pkhqn
	 H3KdWH3v8mvRHnRDvAc6iM+SLovY6sAcCHQxir8FRrHXpSn0bDtlWBqG0PM+4+17AqkSJ
	 iXxCZvBQh26hIbYZTzOZf0+slVzTKRRp+H9JZ7M0QZtK2wv9l/AEdMoMAQg4pJ+mtY1NZ
	 ah93FRqxd0vWCqWQHL3qQ56K5LFfA2ExOiYxpcNEXWNGS9o8G5em+QSrBbN1uYYZY2lpY
	 h/l6jnpoOLwGugOBkm+gfdE1H1e15+7hhhO0p45tMeUmsz3mAyYRty5IgVlxjXyOk9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gp9yMD5L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD728606A31C;
	Wed, 28 Oct 2026 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gp9yMD5L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371A71F01825;
	Wed, 28 Oct 2026 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212700;
	bh=y3YSTJqoeW+bLSJYh9QCf3Oq0Bcoi7eslEDoR4dLLkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gp9yMD5L3AJF/R8i7s1EmAeBKWLTsZNq97C5pgcz4RxZdn4BT1yQpvGWVfYAUQrZZ
	 zF7ykUGNEjIX55xUMXQvIARFfDAZUuFha2CHUrslX9sAXItpMm9snJVvE2kOYplZF5
	 B4QOSgH+o9RRkyk4paYJ7qkEtoilW9+sEjdfcrdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0244/1887] netfilter: bpf: reject invalid NAT manipulation types
Date: Wed, 28 Oct 2026 17:39:00 +0100
Message-ID: <20261028170504.783905089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 16d464013ec2267b00a83f4bfbb97b3ecc63bfa7 ]

As bpf_ct_set_nat_info() is not validating the NAT manipulation type a
wrong value can be passed directly to nf_nat_setup_info(). This triggers
the WARN_ON() at nf_nat_setup_info() and if panic_on_warn isn't set,
then IPS_SRC_NAT_DONE is set without adding nat_bysource and conntrack
cleanup tries to unlink an uninitialized hlist node.

Fix this by checking that NAT manipulation type is correct before
calling nf_nat_setup_info(). In addition, if the WARN_ON is hit, return
NF_DROP instead of continuing with the processing to avoid similar
situations in the future.

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_bpf.c  | 3 +++
 net/netfilter/nf_nat_core.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_nat_bpf.c b/net/netfilter/nf_nat_bpf.c
index 0fa5a0bbb0ffe..1d89cce3f7cab 100644
--- a/net/netfilter/nf_nat_bpf.c
+++ b/net/netfilter/nf_nat_bpf.c
@@ -41,6 +41,9 @@ int bpf_ct_set_nat_info(struct nf_conn___init *nfct,
 	if (proto != NFPROTO_IPV4 && proto != NFPROTO_IPV6)
 		return -EINVAL;
 
+	if (manip != NF_NAT_MANIP_SRC && manip != NF_NAT_MANIP_DST)
+		return -EINVAL;
+
 	memset(&range, 0, sizeof(struct nf_nat_range2));
 	range.flags = NF_NAT_RANGE_MAP_IPS;
 	range.min_addr = *addr;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 310449731a021..6586cce471eb6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -588,8 +588,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
-		maniptype != NF_NAT_MANIP_DST);
+	if (WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
+		    maniptype != NF_NAT_MANIP_DST))
+		return NF_DROP;
 
 	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
 		return NF_DROP;
-- 
2.53.0



