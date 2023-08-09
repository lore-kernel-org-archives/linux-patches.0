Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2621775C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1C2C433C8;
	Wed,  9 Aug 2023 11:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581196;
	bh=F7AL7vukE5KEdwhGO2B+1N4+SXnAM1eH1pyLlZsgskM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJjE01zCbE+1Q0cJDSe15JlsPK8Ie9vSxIAaTyEOf2OVz8r12VYEpqnebmGlxhGHn
	 q1NMYKxcQjh09oYA/Psn6Jvauc0mVRwQYzPkiXIRvATjcO5eXSSCRjj+xuik1z8+T5
	 fazHwg1HiLxwXojb82HmGAwuBlacZE+5aq96OhyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/201] net: add missing READ_ONCE(sk->sk_sndbuf) annotation
Date: Wed,  9 Aug 2023 12:42:21 +0200
Message-ID: <20230809103648.391646803@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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

[ Upstream commit 74bc084327c643499474ba75df485607da37dd6e ]

In a prior commit, I forgot to change sk_getsockopt()
when reading sk->sk_sndbuf locklessly.

Fixes: e292f05e0df7 ("tcp: annotate sk->sk_sndbuf lockless reads")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 66aab0981f666..6f422882d34f2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1332,7 +1332,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_SNDBUF:
-		v.val = sk->sk_sndbuf;
+		v.val = READ_ONCE(sk->sk_sndbuf);
 		break;
 
 	case SO_RCVBUF:
-- 
2.40.1



