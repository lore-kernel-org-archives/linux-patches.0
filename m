Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061140;
	b=iW9rHpGgMCyx6bneazPlS7Ebhhwz3IJ4Tk5SdehjaAQh5ZmKj3L7PNMh1dQNh3GHgUO+
	 tz9tcVN6VcYEONnGliMrqn2xtjAKD1f8r7I6cplB9I69LQUT5TwJsUM9CkPYWhNNy/Fmk
	 W7OJWpo9AgN1vRscjcKbFQn+QJvMsnepaklQGSVQrG7F1OvyRJRVWThKAap7AfDYVSE/z
	 Sqdbemu+TzF1yhv1K2IuNGI8/Gw+GiLnkUrOy6z6dRHQggwstOrKxNgZD04VwIQfUrlMN
	 yGSzm5FXmRx00ME4DTES6YA9OCwixEiuIWZaviPy/v277n2aR5fdtGlE7DtMrvXcK1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lh9xmHbuGttEB9A/Mj11LNY1wbW6B0BJW7LVJe+wgHY=;
	b=iGWmvGXdffYh8lWgFUayAdr3SRivChBI9QoSw6mvjW5WrftmnKAdosS8GPs/QQdmkftY
	 a5tR8j3CUiE082ad3pSJSAiIHeV7TF7RNdGrcX1+MhbSE5K+1a7b+y5rKxfOGOWXNEdNl
	 /iVvpgZty/c/sXL6bLapa5MCFBgUSFqJzVhKykrJbaw21yj0G5xMmbsePPjM6BmyJCc1N
	 eDwirsE3lBO25RSXPhj5Q9OnBoCIf58rRPHGkisXzSMQxKxxGAQWmfdNamQgjFIXT+7OD
	 Ju5weGn2wzZ1EKDCFIOuW9Kmd4aT1EgWN//U9mlViLh8DitjAh2P66mmZONAAcGR7Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMa4eOF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B01606A33E;
	Sat,  7 Nov 2026 14:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMa4eOF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7A91F0089F;
	Sat,  7 Nov 2026 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061140;
	bh=lh9xmHbuGttEB9A/Mj11LNY1wbW6B0BJW7LVJe+wgHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMa4eOF1EAloDKe9260p+yxBQrSEmxD3uQKCT0WMGAdJDuWLNACIyj9ttaad4wgwX
	 o7NIMet4qtSGASV1g5orvyoX74fCQBBcpkSnkPozhnHdyhtO8AjAMcsa8I/Rn2TNpu
	 C29WCloS9VcBLTfmO2+3EyH1gS9lIHwgDVOr1iAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyeong Lee <iostreampy@proton.me>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0448/1536] netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()
Date: Sat,  7 Nov 2026 08:41:04 -0500
Message-ID: <20261107135010.119881379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4aa63842fc92de1bce59d4709a0d32e718890bb2 upstream.

Add a new function to insert a pair of expectations, this is required by
the SIP and H323 NAT helpers. The spinlock is held to check if there is
a slot for both expectations, in such case, insert them.

This removes the need for nf_ct_unexpect_related() inside the loop to
find a pair of consecutive ports, otherwise inserting expectations whose
dead flag is already set on can happen.

Bump master_help->expecting for the expectation class after checking if
the expectation fits in the master expectation list, which is needed for
this new _pair() function variant to run the eviction routine including
the preallocated slot for the first expectation in the pair.

[ Joas: nf_ct_expect_insert() and __nf_ct_expect_check() do not take
  a master_help argument in this tree, so keep their existing
  signatures; nf_ct_expect_related_report() gets master_help from
  nfct_help(expect->master) for the moved expecting[] increment. ]

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/178377968720.33756.12204817361601593230@proton.me/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_expect.h |  3 ++
 net/ipv4/netfilter/nf_nat_h323.c            | 22 +++++--------
 net/netfilter/nf_conntrack_expect.c         | 35 ++++++++++++++++++++-
 net/netfilter/nf_nat_sip.c                  | 20 ++++--------
 4 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index be4a120d549eb..8efc1ed0925a0 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -160,6 +160,9 @@ static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flag);
+
 struct nf_conn_help;
 void nf_ct_expectation_gc(struct nf_conn_help *master_help);
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 10e1b0837731b..d55994fccf5d4 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -179,6 +179,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 			struct nf_conntrack_expect *rtp_exp,
 			struct nf_conntrack_expect *rtcp_exp)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
@@ -221,22 +222,13 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		ret = nf_ct_expect_related(rtp_exp, 0);
+		rtcp_exp->tuple.dst.u.udp.port = htons(nated_port + 1);
+		ret = nf_ct_expect_related_pair(rtp_pair, 0);
 		if (ret == 0) {
-			rtcp_exp->tuple.dst.u.udp.port =
-			    htons(nated_port + 1);
-			ret = nf_ct_expect_related(rtcp_exp, 0);
-			if (ret == 0)
-				break;
-			else if (ret == -EBUSY) {
-				nf_ct_unexpect_related(rtp_exp);
-				continue;
-			} else if (ret < 0) {
-				nf_ct_unexpect_related(rtp_exp);
-				nated_port = 0;
-				break;
-			}
-		} else if (ret != -EBUSY) {
+			break;
+		} else if (ret == -EBUSY) {
+			continue;
+		} else if (ret < 0) {
 			nated_port = 0;
 			break;
 		}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f9352dada84ee..1e1e3a4a0d1c3 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -425,7 +425,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 		exp->timeout += helper->expect_policy[exp->class].timeout * HZ;
 
 	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
 	cnet = nf_ct_pernet(net);
@@ -524,6 +523,7 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	if (ret < 0)
 		goto out;
 
+	nfct_help(expect->master)->expecting[expect->class]++;
 	nf_ct_expect_insert(expect);
 
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
@@ -536,6 +536,39 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flags)
+{
+	struct nf_conn_help *master_help;
+	int i, ret;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	master_help = nfct_help(expect[0]->master);
+	if (!master_help || master_help != nfct_help(expect[1]->master)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = __nf_ct_expect_check(expect[i], flags);
+		if (ret < 0) {
+			if (i == 1)
+				master_help->expecting[expect[0]->class]--;
+			goto out;
+		}
+		master_help->expecting[expect[i]->class]++;
+	}
+
+	for (i = 0; i < 2; i++) {
+		nf_ct_expect_insert(expect[i]);
+		nf_ct_expect_event_report(IPEXP_NEW, expect[i], 0, 0);
+	}
+out:
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_expect_related_pair);
+
 void nf_ct_expect_iterate_destroy(bool (*iter)(struct nf_conntrack_expect *e, void *data),
 				  void *data)
 {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 6b00c81084fe2..115d955bfaef0 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -585,6 +585,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 				     unsigned int medialen,
 				     union nf_inet_addr *rtp_addr)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -615,24 +616,15 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(rtp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
-		if (ret == -EBUSY)
-			continue;
-		else if (ret < 0) {
-			port = 0;
-			break;
-		}
 		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
-		ret = nf_ct_expect_related(rtcp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
+
+		ret = nf_ct_expect_related_pair(rtp_pair,
+						NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == 0)
 			break;
-		else if (ret == -EBUSY) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret == -EBUSY)
 			continue;
-		} else if (ret < 0) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret < 0) {
 			port = 0;
 			break;
 		}
-- 
2.53.0



