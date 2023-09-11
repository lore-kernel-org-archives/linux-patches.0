Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD261170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480C6C433C7;
	Mon, 11 Sep 2023 14:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442362;
	bh=/+UpIhYG0uSl3qMhmN0b30lbt/28I/B6BKogcf0iZYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVzXmHsa8QgCQMO15qMLGJpI4NY9YPR3Y3Uscp8KxbzYqYPxXWY5nhlONqePkiasj
	 hACkOughrzWfrl5nJLKT7xHj3RwA1TqB6o3XXGqtH0F21TgOFyYEIUaxttAeVwyxBv
	 wMjPlF5pLLYS7/9/xf3Zpa92TyOTPXlydJ0/hQNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Lau <martin.lau@linux.dev>,
	Lorenz Bauer <lmb@isovalent.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.5 739/739] net: remove duplicate INDIRECT_CALLABLE_DECLARE of udp[6]_ehashfn
Date: Mon, 11 Sep 2023 15:48:58 +0200
Message-ID: <20230911134711.696518946@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenz Bauer <lmb@isovalent.com>

commit 74bdfab4fd7c641e55f7fe9d1be9687eeb01df67 upstream.

There are already INDIRECT_CALLABLE_DECLARE in the hashtable
headers, no need to declare them again.

Fixes: 0f495f761722 ("net: remove duplicate reuseport_lookup functions")
Suggested-by: Martin Lau <martin.lau@linux.dev>
Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230731-indir-call-v1-1-4cd0aeaee64f@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c  |    2 --
 net/ipv6/inet6_hashtables.c |    2 --
 2 files changed, 4 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -333,8 +333,6 @@ static inline int compute_score(struct s
 	return score;
 }
 
-INDIRECT_CALLABLE_DECLARE(inet_ehashfn_t udp_ehashfn);
-
 struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
 				   struct sk_buff *skb, int doff,
 				   __be32 saddr, __be16 sport,
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -112,8 +112,6 @@ static inline int compute_score(struct s
 	return score;
 }
 
-INDIRECT_CALLABLE_DECLARE(inet6_ehashfn_t udp6_ehashfn);
-
 struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
 				    struct sk_buff *skb, int doff,
 				    const struct in6_addr *saddr,


