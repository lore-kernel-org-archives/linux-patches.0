Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD4145BF7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7eJdhZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F802C433CA;
	Wed, 15 Nov 2023 22:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085764;
	bh=dhZjmULb1qcLKA9rnCNDxZBWUmgCTE9Hi0O6QbS6U5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7eJdhZew047B4REA+gYIMwnL3b9qm+wcL5inGcBQi52y8EwlJZrvMBuIvaK2ub1q
	 /0Qa4F5Ef+qyvdBG9hQSbUut41NOFlTnhYv7UC5l6e1er860DrMVLEkG7lj18U0wtG
	 NN16I4NDNYq4l3RBKDxahf2ysqDjYdNYeV2KIzeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/119] tcp_metrics: do not create an entry from tcp_init_metrics()
Date: Wed, 15 Nov 2023 16:59:59 -0500
Message-ID: <20231115220132.896847543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a135798e6e200ecb2f864cecca6d257ba278370c ]

tcp_init_metrics() only wants to get metrics if they were
previously stored in the cache. Creating an entry is adding
useless costs, especially when tcp_no_metrics_save is set.

Fixes: 51c5d0c4b169 ("tcp: Maintain dynamic metrics in local cache.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 5077a94fffeaf..627e3be0f754b 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -474,7 +474,7 @@ void tcp_init_metrics(struct sock *sk)
 		goto reset;
 
 	rcu_read_lock();
-	tm = tcp_get_metrics(sk, dst, true);
+	tm = tcp_get_metrics(sk, dst, false);
 	if (!tm) {
 		rcu_read_unlock();
 		goto reset;
-- 
2.42.0



