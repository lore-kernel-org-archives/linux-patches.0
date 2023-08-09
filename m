Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BCC17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B402C433C8;
	Wed,  9 Aug 2023 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580661;
	bh=gb3tivW3/BPDTH+L1SQc01dCru93Dbv7hw9LxSXOydI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HzHiH7HK7pEawdmbA1HlsDNU9Q/mrnQIMaCLUlQ1f/zjGA1qtF6fllOHWVuc0okRQ
	 8O4qkAdCVzCdF43vjlWWaB+vN1rfQkBeowOEP+O0fyZePcJeT8z4QRpFkMYG8YtVZu
	 cvCvUtQmoK5onF3HiZfsNNv5W72PaboQ/iqhFT3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/154] net: add missing READ_ONCE(sk->sk_rcvbuf) annotation
Date: Wed,  9 Aug 2023 12:42:15 +0200
Message-ID: <20230809103640.409322518@linuxfoundation.org>
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
index e6d26cfba32d5..6d695da921094 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1262,7 +1262,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_RCVBUF:
-		v.val = sk->sk_rcvbuf;
+		v.val = READ_ONCE(sk->sk_rcvbuf);
 		break;
 
 	case SO_REUSEADDR:
-- 
2.40.1



