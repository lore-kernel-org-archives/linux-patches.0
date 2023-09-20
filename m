Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8462E64E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E3FC433CB;
	Wed, 20 Sep 2023 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211831;
	bh=KMwybxpOHRcGAvvwHw597iQLctXboLAGaVAXqCmUexw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sx7L1Mf2PHsVE7QyT4MwW2lgYo9v9v6b4cDYhbIvvCdDGLmnIvYnJwcgEM4Y7Yy1
	 BJTecmGNi4mfa/ekieA25PBlbdVKkTQf9/XrP/+vIJez4U1RmuW8IK4gueJuqp6gl8
	 yCyKRJ2gelETjC4sbNAWAtoXSvoREwNi9G7zLNL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/273] tcp: tcp_enter_quickack_mode() should be static
Date: Wed, 20 Sep 2023 13:28:11 +0200
Message-ID: <20230920112848.005726961@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 03b123debcbc8db987bda17ed8412cc011064c22 ]

After commit d2ccd7bc8acd ("tcp: avoid resetting ACK timer in DCTCP"),
tcp_enter_quickack_mode() is only used from net/ipv4/tcp_input.c.

Fixes: d2ccd7bc8acd ("tcp: avoid resetting ACK timer in DCTCP")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20230718162049.1444938-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    | 1 -
 net/ipv4/tcp_input.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c6c48409e7b42..9c43299ff8708 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -346,7 +346,6 @@ ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags);
 
-void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
 static inline void tcp_dec_quickack_mode(struct sock *sk,
 					 const unsigned int pkts)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 281f7799aeafc..9e1ec69fe5b46 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -216,7 +216,7 @@ static void tcp_incr_quickack(struct sock *sk, unsigned int max_quickacks)
 		icsk->icsk_ack.quick = quickacks;
 }
 
-void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
+static void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -224,7 +224,6 @@ void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
 	icsk->icsk_ack.pingpong = 0;
 	icsk->icsk_ack.ato = TCP_ATO_MIN;
 }
-EXPORT_SYMBOL(tcp_enter_quickack_mode);
 
 /* Send ACKs quickly, if "quick" count is not exhausted
  * and the session is not interactive.
-- 
2.40.1



