Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4B217AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939F1C433C7;
	Wed,  9 Aug 2023 11:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581198;
	bh=gLkwXysEjaLL0/95IFRJgF1+SoRi5rwjfkbQmEESotY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPKKhdQWriNO2Sp389SsBJ/kvoJ+u48vRQKl9Mr9lXZ92uZmTRgQyFS/PkrC9icjT
	 YfW6xSTRxK4TtEgiXFv/9/ATIvgYcqXukKXGtOj63oHEpWDarVcRrE2VSLVkTyt2OX
	 Lm7zgxRmph3cDp2W9tjHv8e1x0GUOVPyY4NOqdJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/201] net: add missing READ_ONCE(sk->sk_rcvbuf) annotation
Date: Wed,  9 Aug 2023 12:42:22 +0200
Message-ID: <20230809103648.420170354@linuxfoundation.org>
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

[ Upstream commit b4b553253091cafe9ec38994acf42795e073bef5 ]

In a prior commit, I forgot to change sk_getsockopt()
when reading sk->sk_rcvbuf locklessly.

Fixes: ebb3b78db7bf ("tcp: annotate sk->sk_rcvbuf lockless reads")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6f422882d34f2..708018b58e906 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1336,7 +1336,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_RCVBUF:
-		v.val = sk->sk_rcvbuf;
+		v.val = READ_ONCE(sk->sk_rcvbuf);
 		break;
 
 	case SO_REUSEADDR:
-- 
2.40.1



