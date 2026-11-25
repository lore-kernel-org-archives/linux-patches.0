Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619148;
	b=dHyCkDisd4AwNhI1xxvknQKFW0/jJIvQ0evmICrAcKBgUeJaF4V6klIpDKeUzVYtJ65N
	 909Sjus+XK13fgLNn5pdPXSILGYtDYl8rReapZShtTwBPrUu9CNFeOVNv27WcedCCgps8
	 W+AsQyfGQoQUwV21qKsBzyP/LXjYbz4RDqC4gn570tkAXKEHf96iEoOO5gEPQsPDhxQpV
	 FNlBtUlsX6qZbJHhEZ8FDul6BUK73e1zDU0A3scxi4XaARPa8T1ZjJ4SAGOgSzzMUZdqI
	 C3M3Tbd7IcUA/8vzD9gL1syknNWgFHY0K2fnd+lIuoDMvr5hKGayM4NvjlDhkSakaGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mbd0crMK7wPVtRc0ZvOcBjeadlYvec2vREMFFL+/siA=;
	b=PaxuxQYtesAaLNTGRLAShk1tPByi5hj80H0L3yIH3yAjsv95joL0vO5fwFAlO+pbDnjj
	 is98SLJY35pNQbtNEiBMUZemjtIwy9dcxTzBLzE9GMfimAQ+vyx4gLN4NM1cJkTg7sDpK
	 hilNkIrLN9n7J36kmc1BynLJnWyhUUsYRofjSa5yQ9OLuxa5/Eon300ePr0Tj1BKSdleE
	 gJMvxD1dguGi6f3b66v147zrJ3f0ulDYZPJmUzuwWG1Rxm7mhIiP9ekHJWU+u1CgFokKV
	 bnxizu665///eQLth/HexehOhrtyYYzpBi7nZSr24xHjNnFmX8lXb47qi3euQpvC8ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5dHlRBR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6822F606A31E;
	Wed, 25 Nov 2026 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y5dHlRBR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9781F000CA;
	Wed, 25 Nov 2026 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619147;
	bh=Mbd0crMK7wPVtRc0ZvOcBjeadlYvec2vREMFFL+/siA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5dHlRBRu+dwfjdVVVjqDj798mkc6KXbml5Oqf0pIguGe2wmBPPMNToduOc7N6uba
	 LOIVdBiRQm9fqCg1KStmNoMv6fDMQj7QwfKsNWKvTQ34fse9E/jxwUbhuQ70D9gzoJ
	 E1GIMnj7RMWZKMoBJ9Aqcq9ELCl05Q7sUHM1MHp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0461/1005] net: protect negative destination advice with RCU
Date: Wed, 25 Nov 2026 15:29:59 +0100
Message-ID: <20261125143832.545070777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4b77d2792c3e482afa108c08f224ea6fa396d80b ]

SO_CNX_ADVICE calls __dst_negative_advice() while holding the socket
lock. Connected UDP sends can still invalidate or replace sk_dst_cache
without that lock. A concurrent sk_dst_check() can drop the final
destination reference and allow an RCU callback to destroy it while
__dst_negative_advice() retains only a borrowed pointer. This can cause
a use-after-free while accessing dst->ops or running the negative_advice
callback.

The writer-side ordering fixed by commit 92f1655aa2b2 ("net: fix
__dst_negative_advice() race") does not protect this reader from an
independent cache replacement.

Hold an RCU read-side critical section across the lookup and callback.
This follows the datagram release callbacks and covers IPv4, IPv6, and
XFRM advice without changing cache-reset or reference-ownership rules.

Fixes: a87cb3e48ee8 ("net: Facility to report route quality of connected sockets")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104131744.1056562-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 60ea55dc18854..f8038be27f003 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2214,10 +2214,13 @@ sk_dst_get(const struct sock *sk)
 
 static inline void __dst_negative_advice(struct sock *sk)
 {
-	struct dst_entry *dst = __sk_dst_get(sk);
+	struct dst_entry *dst;
 
+	rcu_read_lock();
+	dst = __sk_dst_get(sk);
 	if (dst && dst->ops->negative_advice)
 		dst->ops->negative_advice(sk, dst);
+	rcu_read_unlock();
 }
 
 static inline void dst_negative_advice(struct sock *sk)
-- 
2.53.0



