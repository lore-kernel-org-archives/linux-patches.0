Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386CA11C84
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722ADC433C9;
	Mon, 11 Sep 2023 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446126;
	bh=25GGYIv3aBG3y5EjHVi/8NPPEtPbCz0DL/JtPjzpMV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dhh9UEVc7JFwfu71pUviT+xu3mjHfCg8f7g7mJaugEb7CR+eBj5Pp6OYCOY0gKICN
	 /BQYTvYXVbbq/Gnp/rFw/Khz3Ly3f1xeU74a/1qzOdpwxBoI4NJSmh1Bc8dRLRqRAg
	 HP+p4JcCn2F/d6Ya9B9Wdhl1NTKbBVy9snteGdeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Lau <martin.lau@linux.dev>,
	Lorenz Bauer <lmb@isovalent.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.1 591/600] net: remove duplicate INDIRECT_CALLABLE_DECLARE of udp[6]_ehashfn
Date: Mon, 11 Sep 2023 15:50:24 +0200
Message-ID: <20230911134651.083112308@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


