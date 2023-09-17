Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A167461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB6C433C8;
	Sun, 17 Sep 2023 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980722;
	bh=c5rbceCLLUE0Nn9xO+/aSifQYGls09KMNsvy2LvuZtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTBrmhK58XQ1ReNb5XzgDVjzBvPjHUtdDuGccEL+DTF/nu+0xKZZHHt0h2fVGOouF
	 TFwlramrky37hEQP++R+z8OiO3uUwfodT1XNDDE9ysUW9hLSYGLxLzEdDbXriqaDY7
	 8IhA1JebJ0lSfaO1NsuxS+jzOBCf/4I5PIY4fImo=
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
Subject: [PATCH 6.5 275/285] ipv6: fix ip6_sock_set_addr_preferences() typo
Date: Sun, 17 Sep 2023 21:14:35 +0200
Message-ID: <20230917191100.676202195@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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
index 2acc4c808d45d..b08bd694385aa 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1356,7 +1356,7 @@ static inline int __ip6_sock_set_addr_preferences(struct sock *sk, int val)
 	return 0;
 }
 
-static inline int ip6_sock_set_addr_preferences(struct sock *sk, bool val)
+static inline int ip6_sock_set_addr_preferences(struct sock *sk, int val)
 {
 	int ret;
 
-- 
2.40.1



