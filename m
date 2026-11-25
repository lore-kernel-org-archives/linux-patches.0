Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623836;
	b=wbaWTL9SPC9xEYYZIotvj58jnh5+Cf5SlklLa9NUTZm0L80czm2yY/6PO7zp8d9HVDwz
	 24BN6mccIDj6fXsMubrP5TQlqpAVfggP+iUxqBXX8m2019BzM5wkL+JDlrpS9Fe6+Y0tr
	 9n98uj/ra8/jjOu/yaWzFsmIedZ7Sm2bys5wKHgxmEFVd6vpJwBlMc4jPFThdbCuMSv8s
	 IhidOgM8qHh44BnmGj0JI59G5pvDit0PBdDWP9MlMeAOFO+fgUjZDILvlB1iA/jul4oFQ
	 ywYGUYmANdjFcf4KX3CCtG8U4RW15f63cqxu4bvC3uj160KFHg+kCg69+2HDUhZRjHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oDooWGGGITfiSW9lbqrmXJX+CF3oXcyXt6g2tBDydGU=;
	b=zxlxQCIZQagVTQUxcXlgEZsXi8NWd032unqY8T8+9QObV2VVMdYyniRFqSWOfsykTYFP
	 39p6F0yIVfa0Sms3lW/LSEaZiAhbwlJ3RLiIbg4ckwZWnlDautEytCe0OA4wBukIDNOUB
	 n7QRzwGs6GX98x8aiRRVJRaYEFEc8PH5YHmBPvL4Ui5FHOHdF11R6lsRi6dxBcb51o4lD
	 NwZomUJzO8Wdr90n5p4oR2PgqSmmc30xD6tgCLS1H01MRrDG5EPSUz0JJr1A8oKTl4S40
	 lI8w9flemqumzvVJroqW91hO4AkcCJ9h5E/j5hOAdthO+2hzgD2tSxVJDEDX9Fv5JRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJKRXfY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E981606A321;
	Wed, 25 Nov 2026 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJKRXfY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606611F000C6;
	Wed, 25 Nov 2026 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623835;
	bh=oDooWGGGITfiSW9lbqrmXJX+CF3oXcyXt6g2tBDydGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJKRXfY2+mpvIa2kAuT+bzfxhTXMw3sfT8acglsUhGM9t1D+GgwWURsRAdYQQaPwO
	 VkuLiw3A5PEWsikGh9W1fG8Oa1RubUREphOIVwI2Ts/x9xYYyNu7KBljs+43ShB4oo
	 mcqUwZWR6FkI+JtorYBsTKbAcIdtiXVqbFZ6qpyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 988/990] tcp: Set unhashed_state in inet_twsk_hashdance_schedule().
Date: Wed, 25 Nov 2026 15:39:15 +0100
Message-ID: <20261125143845.119418598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 404381b4f1053a271a85679cc76a543b10ae043e upstream.

inet_unhash() sets inet_csk(sk)->unhashed_state only when the
socket is hashed because tcp_set_state(sk, TCP_CLOSE) could be
called multiple times, e.g. tcp_abort() calls it directly and
tcp_done_with_error().

However, inet_twsk_hashdance_schedule() also unhashes a socket
when replacing it with twsk, allowing the socket to bypass
checks for inet_csk(sk)->unhashed_state.

Let's update inet_csk(sk)->unhashed_state there as well.

Fixes: 8cc3aef0cb19 ("tcp: Do not allow buggy transitions between ehash and lhash2.")
Reported-by: Daniel Zahka <daniel.zahka@gmail.com>
Closes: https://lore.kernel.org/netdev/DLHLRA8GVI5B.2Q1IRQG5BVJNZ@gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260917191554.1600494-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_timewait_sock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -111,11 +111,13 @@ void inet_twsk_hashdance_schedule(struct
 				  struct inet_hashinfo *hashinfo,
 				  int timeo)
 {
-	const struct inet_sock *inet = inet_sk(sk);
-	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_ehash_bucket *ehead = inet_ehash_bucket(hashinfo, sk->sk_hash);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
 	struct inet_bind_hashbucket *bhead, *bhead2;
+	const struct inet_sock *inet = inet_sk(sk);
+
+	icsk->unhashed_state = sk->sk_state;
 
 	/* Step 1: Put TW into bind hash. Original socket stays there too.
 	   Note, that any socket with inet->num != 0 MUST be bound in


