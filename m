Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8AC7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9689FC433C8;
	Sun, 17 Sep 2023 20:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981267;
	bh=Kb4hDg9erNmJlflywbwn7t6n8FXOmdmrPJXWqYn/Zlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oz1lC9IpmB0qpEYLzgBTqWJusmDysaQJRKZPpMOrLY8GcOrV9qzN6ZhGwharyYtzB
	 VmqsnyEuDAHoPn9kE2AVFUsLCsSWDOx52N75VY36dpP6bIneI7q8vTi8dcbwfN0h4g
	 E0aYxPruK22PRDwaSnzPIKiABkI0ystDVgTWyyfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/219] net: use sk_forward_alloc_get() in sk_get_meminfo()
Date: Sun, 17 Sep 2023 21:13:44 +0200
Message-ID: <20230917191044.478849564@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 66d58f046c9d3a8f996b7138d02e965fd0617de0 ]

inet_sk_diag_fill() has been changed to use sk_forward_alloc_get(),
but sk_get_meminfo() was forgotten.

Fixes: 292e6077b040 ("net: introduce sk_forward_alloc_get()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index fa988063630db..6ff58fa5f41ed 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3715,7 +3715,7 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 	mem[SK_MEMINFO_RCVBUF] = READ_ONCE(sk->sk_rcvbuf);
 	mem[SK_MEMINFO_WMEM_ALLOC] = sk_wmem_alloc_get(sk);
 	mem[SK_MEMINFO_SNDBUF] = READ_ONCE(sk->sk_sndbuf);
-	mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
+	mem[SK_MEMINFO_FWD_ALLOC] = sk_forward_alloc_get(sk);
 	mem[SK_MEMINFO_WMEM_QUEUED] = READ_ONCE(sk->sk_wmem_queued);
 	mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
 	mem[SK_MEMINFO_BACKLOG] = READ_ONCE(sk->sk_backlog.len);
-- 
2.40.1



