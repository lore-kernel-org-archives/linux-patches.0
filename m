Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024584;
	b=izzf+aPoxrbSc50JihSYZ88nEYcFCXL4Ey8j8qk3cCp1srEcGAPaE5mHEto/0yugK3E4
	 BWRZAQZQwBO5bpXiO0kLptr1R6p5B5sZhoSgshL/1pk9mwb6lYFuBFC9uKGwSf+F9YLXI
	 cUc+nWI9W6ipkjy1mLKFItGuCyz7euS1oVboFfn4U40MQ1vERHQqGthX7Voifi04W2eLk
	 0aYZPkdUl5Xb9YA7CxiMOaR8BaZJQvWXOXr+/xMQSSCcBLye3ccTc28o7ZRnXU0eyNeIA
	 IifvDgv2Q7eauML1lbShg4v3uKb/bwNZ3cAQP/BytHpL0x9SDnuyGkv5iJEtarsKY/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sfQRjR3CrBIbgoQjhcN5Fuizp9d5VInrf1n6rT0QzZo=;
	b=MzmTz2Ry4Mf3xbGKEYSGWAJDFsDK284jn7BmlRb5D9mO4VLBHA5b1erLcJhPji93iAyZ
	 mi9Rm3uKEqSg39EWNh6FjZk0QMtM3r05g42LDuWWY/3Wlqe8MzowspD+wDrDeGprJ3Ctz
	 gxfyWYXUBMkmewZLJlBw+vI11Zu5sBUiOt7yxlyR7617yCnSKANIHiXgH1/2FnBG3rHCW
	 fXBUl9VdaEpfboRsEU7Vuj4WyY4BJdkz1O0VDkJPHjS7GTO3llMfN7EHCa5VxVH7KdH07
	 W5J74/ETbN7NeynLZ7BFi3ZTG+Elt1Fu+DubRiqBw3irX6FUBk3XjGjYX3hffpgbm6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RO/nl1Di";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08244606A320;
	Wed, 18 Nov 2026 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RO/nl1Di
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBDF1F000C6;
	Wed, 18 Nov 2026 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024583;
	bh=sfQRjR3CrBIbgoQjhcN5Fuizp9d5VInrf1n6rT0QzZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO/nl1DiRaH1qu3lkAoPijV627nKqr/mZ268gg9LV5OJa4gO3BEuk4Vu4vUatG4id
	 3rCuY7/RvugacnzkHbQtatZxq87rXJ89U8iG6Qjzw+5i0Mzz6m2hdxmH7kRPD2giAV
	 bb5OSoFJ4MGYWqC8gw1dv6eSBNLu76UGdGeMgCSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0775/2151] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
Date: Wed, 18 Nov 2026 15:41:50 +0100
Message-ID: <20261118150150.361882812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit a8708aa9fe1095ca7859cb3f102b6a3fa0fb98bd ]

SYNPROXY is resetting conntrack seqadj when a closed connection is
re-opened, but it was using nf_ct_seqadj_init() which is a no-op for a
zero offset.

This patch introduces nf_ct_seqadj_reset() which sets the offset values
directly to zero and avoid setting IPS_SEQ_ADJUST_BIT flag, it changes
SYNPROXY code to use it when needed.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_seqadj.h |  1 +
 net/netfilter/nf_conntrack_seqadj.c         | 17 +++++++++++++++++
 net/netfilter/nf_synproxy_core.c            |  4 ++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_seqadj.h b/include/net/netfilter/nf_conntrack_seqadj.h
index 883c414b768ee..0f5bbb14a25aa 100644
--- a/include/net/netfilter/nf_conntrack_seqadj.h
+++ b/include/net/netfilter/nf_conntrack_seqadj.h
@@ -33,6 +33,7 @@ static inline struct nf_conn_seqadj *nfct_seqadj_ext_add(struct nf_conn *ct)
 
 int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		      s32 off);
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo);
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off);
 void nf_ct_tcp_seqadj_set(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index b7e99f34dfce8..8dba6a0d5dc21 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -29,6 +29,23 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
 
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct nf_ct_seqadj *this_way;
+
+	if (unlikely(!seqadj))
+		return;
+
+	spin_lock_bh(&ct->lock);
+	this_way = &seqadj->seq[dir];
+	this_way->offset_before	 = 0;
+	this_way->offset_after	 = 0;
+	spin_unlock_bh(&ct->lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_seqadj_reset);
+
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off)
 {
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 69f84c44801dc..309bee4e1ed65 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -685,7 +685,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1115,7 +1115,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
-- 
2.53.0



