Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214527;
	b=BFPeZGtR4wwKx5IwP/sBW9TSdywZWnlsOJQI4o1RFFCd5nK960bn8luLij5/PKx+0v5D
	 +07KYdxvDdQ7SlhkPSM4oziKR32H3q4p4vseTibMGFc82C0MTProjvCAbNSKyaH9jh9ap
	 UEFUiPg5r27xPEFoBbNRJUbhRjcpnC3BWBQdlLW+BmCw2ONgtfplFP4/rMEzD5DJsKeam
	 5cuYdz99cmirn7qkm+PWxZdfJnod0WpaG0mRWa/zcakDWlfKR3v33Y7UsIcMzLFZ5R0gu
	 x4IKq1ayRXq9UjODQwqHY02zaIM7jkZUU0Ady2m+HKYGQUCGybSH6uv6gt7NiDUyhPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdVywH7nYCEk0FUoc2cgwC670WClWJXE386Pi8SA+e0=;
	b=on4w/NLUz4OOewwmrEicwHB7h3+0gYTd76xQfgxAE3rVSygdW4sqyTsziW7djEN2NXIg
	 U8cLm0/P7N94KJyTasyBB2xC9HeVPpqZyEeRzKMFXyS/8iE/iRKgj5pJhi/mNaIACNm10
	 E6qwMH7chca7RKUA1lPncCrJa0dULNSwBqOrYc1Dnum0LVgCkBXKckrMaVNbGb8/1IhGa
	 BtbjeNQJB1Z0GOWpJqYzFXgqXdeL0ZozkLifjFet0C5ZC0FPTdoBxXNlE+/wgAtY9WPTG
	 lfvhnuuLEtbqwWw+qyCqcuhYeXO3PWYIuzAXPr4V9T4jsqZd90bpcZVkdPvJ8HrlZTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuzEjVnK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25823606A32F;
	Wed, 28 Oct 2026 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuzEjVnK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774611F031E2;
	Wed, 28 Oct 2026 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214527;
	bh=QdVywH7nYCEk0FUoc2cgwC670WClWJXE386Pi8SA+e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuzEjVnKl6z3SwJqRn7HJkjBLMYl0GTaq7ZoqaqzjU/ak1q2QZfS9Bj65hY6HJ+yW
	 RjyiiySBIjq8NRIbIxBdcCFTMRZsgW8856kSydf1fHHL9T7B3PHsrM9Vd6nbid461K
	 qN0Kub3i1vsgKNbpFFnHdOhu4cSW7wTHMroHY7EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0889/1887] tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()
Date: Wed, 28 Oct 2026 17:49:45 +0100
Message-ID: <20261028170519.650937725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b62a59c18b692f892dcb8109c1c2e653b2abc95c ]

Use RCU to avoid a pair of atomic operations and a potential
UAF on dst_dev()->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 156685b4ae68a..bb40b42f13d7b 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -575,11 +575,12 @@ void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 		}
 	} else if (tp->syn_fastopen_ch &&
 		   atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times)) {
-		dst = sk_dst_get(sk);
-		dev = dst ? dst_dev(dst) : NULL;
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
 		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.53.0



