Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A148472
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199D2C433C8;
	Mon, 11 Sep 2023 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442874;
	bh=NkTO03MKoHEjJWRjskXOxqq55bCmsA0Pw9083pDjW74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCAb7dKm/hMZROXNZrcXNaYbbQdTRLdcgm8URJVEsS5GHV4IbGdyAGAFogyOoDoDy
	 F8DjevqK7b/vHSlWvyxLdtWR71b/mi6Bbw3Z87dQHNHbNGRgWG8SnE+knrDfhMRIZ7
	 BFbwMxxjs+7leizPptibMJE/d3npXLqJc7yjQzWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 151/737] tcp: tcp_enter_quickack_mode() should be static
Date: Mon, 11 Sep 2023 15:40:10 +0200
Message-ID: <20230911134654.704421525@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 182337a8cf94a..ca6435f5d821e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -355,7 +355,6 @@ ssize_t tcp_splice_read(struct socket *sk, loff_t *ppos,
 struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 				     bool force_schedule);
 
-void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks);
 static inline void tcp_dec_quickack_mode(struct sock *sk,
 					 const unsigned int pkts)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 57f1e4883b761..094b3e266bbea 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -287,7 +287,7 @@ static void tcp_incr_quickack(struct sock *sk, unsigned int max_quickacks)
 		icsk->icsk_ack.quick = quickacks;
 }
 
-void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
+static void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -295,7 +295,6 @@ void tcp_enter_quickack_mode(struct sock *sk, unsigned int max_quickacks)
 	inet_csk_exit_pingpong_mode(sk);
 	icsk->icsk_ack.ato = TCP_ATO_MIN;
 }
-EXPORT_SYMBOL(tcp_enter_quickack_mode);
 
 /* Send ACKs quickly, if "quick" count is not exhausted
  * and the session is not interactive.
-- 
2.40.1



