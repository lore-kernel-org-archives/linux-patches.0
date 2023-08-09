Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE82847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B87AC433C7;
	Wed,  9 Aug 2023 10:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578460;
	bh=lCrw2pmBuwjI6uZyEZg59JggqsoMoyvtG8ZeARrhmWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbtrGuIFTfBUXlaUG0vgiEL2JG/tAi07J3wvegt4RelISqtGTA23yx8pZAxYFWq26
	 8LhYfuREkGfsKG04ubQocVIAnVgxR1h/zbaMfnzHiE7oUW7gUQVWMgcQGKeyOdj7H2
	 0RcoX7NcKNNPEkuaRadVMpAU5uhg+o9zeNokcT2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/127] net: add missing READ_ONCE(sk->sk_rcvlowat) annotation
Date: Wed,  9 Aug 2023 12:40:25 +0200
Message-ID: <20230809103637.941213082@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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
index 86e88de1238b1..1b1fe67b94d4f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1717,7 +1717,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 		break;
 
 	case SO_RCVLOWAT:
-		v.val = sk->sk_rcvlowat;
+		v.val = READ_ONCE(sk->sk_rcvlowat);
 		break;
 
 	case SO_SNDLOWAT:
-- 
2.40.1



