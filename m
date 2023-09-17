Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53526FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DCEC433C8;
	Sun, 17 Sep 2023 20:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983338;
	bh=1iOZB3hoYMKGD6g4nSKxO9fJg7PU0ybs0T15dHH7LhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAfgQ0ZdZ0lSX1jDluXqxNDbS9grDuTuNqG1+RyZvJXFyTMc/F24N0KYkUWe/cTG+
	 4AoG8JWVBpWPLG3iVbFWoVVI2pW4JzSSyJQXV9VrFv6eL6b3a2kUXeynE7bY11oBWY
	 fQLfhLd0i6vv5vTf61kSbNcCdZlRL79+h3b/W+tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/511] ipv6: fix ip6_sock_set_addr_preferences() typo
Date: Sun, 17 Sep 2023 21:15:34 +0200
Message-ID: <20230917191125.960361412@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8cdd9f1aaedf823006449faa4e540026c692ac43 ]

ip6_sock_set_addr_preferences() second argument should be an integer.

SUNRPC attempts to set IPV6_PREFER_SRC_PUBLIC were
translated to IPV6_PREFER_SRC_TMP

Fixes: 18d5ad623275 ("ipv6: add ip6_sock_set_addr_preferences")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230911154213.713941-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 20930086b2288..6b3309e55dcb1 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1258,7 +1258,7 @@ static inline int __ip6_sock_set_addr_preferences(struct sock *sk, int val)
 	return 0;
 }
 
-static inline int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
+static inline int ip6_sock_set_addr_preferences(struct sock *sk, int val)
 {
 	int ret;
 
-- 
2.40.1



