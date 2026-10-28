Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214768;
	b=Xf6wmHAmaauuQvcO8FxkxM73tny1r4BhyJFZLKiAuMycMN/+72wvTzVJ6sMGkJ47gOvL
	 ESzaAr3Tt7EvEo2iHyLx9E5H4muHDKrM6xu5ius58f++YXUmnE0UBcGFG+M/Z1vGvyG89
	 4qE1A/PMexfvmA2MShrRClnhKUaCuLs0Zv8fMI3oPl8rZhySEGoFh5b2JCC7beye1k99k
	 dr85jTUT6lCD9mJ3GrmD9CAMjVKCb81pLQrIMyXp8qjZUZNvrOcDH6SvBViwLrh718Gfd
	 g+mK1Y0/j2I9hyJg+KgnLzYPZFD018qqAQowS0CNq8f6f+eK1eRT6q9+zv+zYkZvNzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3mIbD/0ge9o46+zHmSYVFFq0k7UHUOnwkmXAQrp87cI=;
	b=BDzombOW63QPIeqbs07vRQzsmBp1nQ6mOvYH7+ltTqeFec2FoIc3+PQVb3EXwwPhE3Ac
	 bdvFOCRioYwML3KSyrbaHl3r4uSTTPmSZC0VKgZlQq06wYQowyknYShktn38CeqWnHXpL
	 c+EvcTZJrz51sKDD4lMSQHZjMw+aZPAh19v4/IJwLmATNhgqOSpGriDB1HG+UYvB3sTNN
	 N6q2Z8JVak1GEEXT4B51ExVOOXtRo6V3BNVk+x0Dgwo2VG3F4QSHZcpZVjtMUQal+KsJ/
	 cxo8t1dXAu1Jl32kEW4zDyz6hV2lP8nCrt5tWuWpzdzdfxbdQRHGAtpVvFGkj5GA5cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1w480cVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15717606A322;
	Wed, 28 Oct 2026 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1w480cVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4081F01825;
	Wed, 28 Oct 2026 19:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214767;
	bh=3mIbD/0ge9o46+zHmSYVFFq0k7UHUOnwkmXAQrp87cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1w480cVAdlO0AFn+RV+j0ssPxFtBkAFgCcFo7T3bbEIAgnWplL6GmiuLOtWz4RFWw
	 xSYcKyHqspVt/qKzkJPn/5UejLJtwtxG3SzW3PbfbWvE276d2b8nbwXk2SdgK5HhdM
	 z7oD14dz5KrTec8qOoLS5OHwrU4wp9OcCFTo9kcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <tanyuan98@outlook.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0975/1887] mpls: add seqcount to protect the platform_label{,s} pair
Date: Wed, 28 Oct 2026 17:51:11 +0100
Message-ID: <20261028170521.597561490@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 629ec78ef8608d955ce217880cdc3e1873af3a15 ]

The RCU-protected codepaths (mpls_forward, mpls_dump_routes) can have
an inconsistent view of platform_labels vs platform_label in case of a
concurrent resize (resize_platform_label_table, under
platform_mutex). This can lead to OOB accesses.

This patch adds a seqcount, so that we get a consistent snapshot.

Note that mpls_label_ok is also susceptible to this, so the check
against RTA_DST in rtm_to_route_config, done outside platform_mutex,
is not sufficient. This value gets passed to mpls_label_ok once more
in both mpls_route_add and mpls_route_del, so there is no issue, but
that additional check must not be removed.

Reported-by: Yuan Tan <tanyuan98@outlook.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Fixes: 7720c01f3f590 ("mpls: Add a sysctl to control the size of the mpls label table")
Fixes: dde1b38e873c ("mpls: Convert mpls_dump_routes() to RCU.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/cd8fca15e3eb7e212b094064cd83652e20fd9d31.1774284088.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/mpls.h |  1 +
 net/mpls/af_mpls.c       | 40 ++++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/mpls.h b/include/net/netns/mpls.h
index 19ad2574b267c..f364286adf288 100644
--- a/include/net/netns/mpls.h
+++ b/include/net/netns/mpls.h
@@ -16,6 +16,7 @@ struct netns_mpls {
 	int default_ttl;
 	size_t platform_labels;
 	struct mpls_route __rcu * __rcu *platform_label;
+	seqcount_t platform_label_seq;
 
 	struct ctl_table_header *ctl;
 };
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 5e0900bd48b6b..73443cf8b69ce 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -74,16 +74,31 @@ static void rtmsg_lfib(int event, u32 label, struct mpls_route *rt,
 		       struct nlmsghdr *nlh, struct net *net, u32 portid,
 		       unsigned int nlm_flags);
 
-static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned index)
+static struct mpls_route __rcu **mpls_platform_label_rcu(struct net *net, size_t *platform_labels)
 {
-	struct mpls_route *rt = NULL;
+	struct mpls_route __rcu **platform_label;
+	unsigned int sequence;
 
-	if (index < net->mpls.platform_labels) {
-		struct mpls_route __rcu **platform_label =
-			rcu_dereference_rtnl(net->mpls.platform_label);
-		rt = rcu_dereference_rtnl(platform_label[index]);
-	}
-	return rt;
+	do {
+		sequence = read_seqcount_begin(&net->mpls.platform_label_seq);
+		platform_label = rcu_dereference_rtnl(net->mpls.platform_label);
+		*platform_labels = net->mpls.platform_labels;
+	} while (read_seqcount_retry(&net->mpls.platform_label_seq, sequence));
+
+	return platform_label;
+}
+
+static struct mpls_route *mpls_route_input_rcu(struct net *net, unsigned int index)
+{
+	struct mpls_route __rcu **platform_label;
+	size_t platform_labels;
+
+	platform_label = mpls_platform_label_rcu(net, &platform_labels);
+
+	if (index >= platform_labels)
+		return NULL;
+
+	return rcu_dereference_rtnl(platform_label[index]);
 }
 
 bool mpls_output_possible(const struct net_device *dev)
@@ -2209,8 +2224,7 @@ static int mpls_dump_routes(struct sk_buff *skb, struct netlink_callback *cb)
 	if (index < MPLS_LABEL_FIRST_UNRESERVED)
 		index = MPLS_LABEL_FIRST_UNRESERVED;
 
-	platform_label = rtnl_dereference(net->mpls.platform_label);
-	platform_labels = net->mpls.platform_labels;
+	platform_label = mpls_platform_label_rcu(net, &platform_labels);
 
 	if (filter.filter_set)
 		flags |= NLM_F_DUMP_FILTERED;
@@ -2597,8 +2611,12 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	}
 
 	/* Update the global pointers */
+	local_bh_disable();
+	write_seqcount_begin(&net->mpls.platform_label_seq);
 	net->mpls.platform_labels = limit;
 	rcu_assign_pointer(net->mpls.platform_label, labels);
+	write_seqcount_end(&net->mpls.platform_label_seq);
+	local_bh_enable();
 
 	rtnl_unlock();
 
@@ -2679,6 +2697,8 @@ static int mpls_net_init(struct net *net)
 	struct ctl_table *table;
 	int i;
 
+	seqcount_init(&net->mpls.platform_label_seq);
+
 	net->mpls.platform_labels = 0;
 	net->mpls.platform_label = NULL;
 	net->mpls.ip_ttl_propagate = 1;
-- 
2.53.0



