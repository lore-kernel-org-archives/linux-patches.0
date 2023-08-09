Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4193517744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF944C433C7;
	Wed,  9 Aug 2023 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580656;
	bh=uVgnSk2t4tHv/P4XL4Wkzr+x/EmlfgRC4kqp0gdEDo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhWzwVJh9BqSVsLuJgdFCTQotANLQVnJryCYoYkVWTS/TPjNy279W7KTumEmbo0jS
	 so32yIGVljh56bm6Ww2+KnGOd9glKA9I1KZ0ufJRyuN7S7Mu+XVaR8EGg5zTmXcNCq
	 jf2lgbOehYVRzVYWDyepqnKFAGXORuYXcf0ZfAVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/154] net: add missing READ_ONCE(sk->sk_rcvlowat) annotation
Date: Wed,  9 Aug 2023 12:42:13 +0200
Message-ID: <20230809103640.343184702@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e6d12bdb435d23ff6c1890c852d85408a2f496ee ]

In a prior commit, I forgot to change sk_getsockopt()
when reading sk->sk_rcvlowat locklessly.

Fixes: eac66402d1c3 ("net: annotate sk->sk_rcvlowat lockless reads")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 539c39ad1e488..a73111be68581 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1350,7 +1350,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_RCVLOWAT:
-		v.val = sk->sk_rcvlowat;
+		v.val = READ_ONCE(sk->sk_rcvlowat);
 		break;
 
 	case SO_SNDLOWAT:
-- 
2.40.1



