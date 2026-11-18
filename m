Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017625;
	b=y7K7ctFE0DevB/drroheQPbZK8nuIeiFLSmTLsQE7KWeLwIy5Ey1ek0CvZ/10GUahNsc
	 bzu3bnBk7H2luiB3zf0Hnei4u8fbdumIKCZKVbMhJD48MaZl9H67GTDRZz4sGbSjiaGmX
	 oPj31gGR8Mh6WCNVm0lhewjIY5yWJFak5Q4HGPFRQayWrrjHqZMeaUx2BhKnpEYIAct1+
	 sIkr3pNZmLFXlSaFNOKA+K3oWWGr0nvDIIh2GR8JETSaUVnhO6mo1a0OnLMqNosia6Ebn
	 bhPETumJ0LdHLTkVVmdqdaS2YbdxynHBHJUOOWs/XmyCOzAKXXCGQneHZLtW0TwXdRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WSUuZY1M8MjK4dF8l8pU1TdZfcFPY3XN86/uJ86dDw=;
	b=YjNEysHxdO+50q9jAh2KraJpp6lqeR6G6sCfc2/NF+te9UePilr/N1HSfBWqSWBfoD8h
	 6aqig6zVg4MHyg/Rnzf7UxNiWueF88S5Id67JXZgZrafHQimBupbAQbpBhMItSdrdxxBr
	 VFO8FYygtqa9A4M2MVm/RtJkpAgJ1Kh5nq+eSUM9BisSz1yP1bscFYbrnLPedk8LzqPdn
	 dYpJd6wLBLrHz5Q6zxR7gH5jf54s5mjKiyeRy2An1nE/3rw0EQxlsGdGfGHMIDRXgDg34
	 YkEmmm6p17d5eTdHyHi+S+c9FZxtL4/vSNELF74uMIdcjwquBF3KWBxTXBP7qbwUfhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAcklcyJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B08606A333;
	Wed, 18 Nov 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAcklcyJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36911F000C4;
	Wed, 18 Nov 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017625;
	bh=3WSUuZY1M8MjK4dF8l8pU1TdZfcFPY3XN86/uJ86dDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAcklcyJWCRZieWTJARWAfNA4GukvwR09yd/QwUjbsI3ETDjKxXYL+nWahuL/tpsR
	 bCcyMseplgnRnWcMTCvRcpMynRqK2Ss7h5OfrnCYv9uTVKFLIghIFxZCJhePwgf76U
	 LXF2tQYqxCON2bN2ZjuznTVMOLnkUmuB0VosQkWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0914/2651] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
Date: Wed, 18 Nov 2026 15:35:54 +0100
Message-ID: <20261118150320.800470424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 220216a4edc51..cc6a9037df6b0 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -32,6 +32,23 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
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
index acd360515972f..37f88702980a6 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -686,7 +686,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1116,7 +1116,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
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



