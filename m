Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388617C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A78C433D2;
	Mon, 24 Apr 2023 13:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342364;
	bh=uPchl7ZkQL+IK/urJ96O7Pbb/ToTjJOXYdfF1x0qsVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGa3sej/V5aOgvu4kG7JdCVOo/0IjknGFQuTzF5KDcWbZZdSHl6jtdMNwOSdJ9USC
	 l3krOLvksc85RYkCU+CWzLf8YFD1qX62RkyvrccTvr9+WFZczVkwrUXGILZtz3Hkoa
	 8vQfPZq/WdvwhgL6VuluMMs+6NGS2Jgz8rdjB0pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/73] netfilter: nf_tables: fix ifdef to also consider nf_tables=m
Date: Mon, 24 Apr 2023 15:16:26 +0200
Message-Id: <20230424131129.487671734@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c55c0e91c813589dc55bea6bf9a9fbfaa10ae41d ]

nftables can be built as a module, so fix the preprocessor conditional
accordingly.

Fixes: 478b360a47b7 ("netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n")
Reported-by: Florian Fainelli <f.fainelli@gmail.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ef00dd3108362..7ed1d4472c0c8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4462,7 +4462,7 @@ static inline void nf_reset_ct(struct sk_buff *skb)
 
 static inline void nf_reset_trace(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	skb->nf_trace = 0;
 #endif
 }
@@ -4482,7 +4482,7 @@ static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src,
 	dst->_nfct = src->_nfct;
 	nf_conntrack_get(skb_nfct(src));
 #endif
-#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || IS_ENABLED(CONFIG_NF_TABLES)
 	if (copy)
 		dst->nf_trace = src->nf_trace;
 #endif
-- 
2.39.2



