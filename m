Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620703;
	b=CBU4fQ6loFyCzSiBMiYa+IZc0GYR3ouX+8BtkZ1Mnf3CGYCV9W8WRo9cDYoCmcGsvXBF
	 ocaWPCK/JoXxReYa/2c454tNYSDUqDMqA6WA9nhAxULHG/xCTQCB1XwK6Tr+1kNb7wlec
	 7gdg5fHHpUe+XF5PTzfaQ1gTVEM1HZRjkkNtSNNNa4dzDecENf0szl1f6Sfpr8CYV7Zmr
	 bo+QGiw0NueAiXgNy9eFeTK9jHRkNJbQ29DCFHB9CKNU3gc+5qfQA41U/FrE7C18yzg/Z
	 8CwEta7X/FIaNERaFqZPvABvUSjekQjhEyLa+gmKda+8WRz7EobVuZO7MF2V/Q+O7Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y/eZh36r2b2M/MV9kUnVPyReaneyongdcAiOZMPpEmw=;
	b=lG+57aTXju96qiGUUky+lgdZMCj1zGeRaBvnKUaKL6ge4MUXyxRHhxB+lXEQIi+SvRRB
	 OBSOSmx8FcKUmzfNj9HJuxFVegONqnFFyye9IHSaaw79mlLtM+KMdgTj6FPQbFHbiFcud
	 LSkwcAUNxd680Z771ShW63dz/wNstV/zE4bTnA0eW6glKUzX3xaxqmMC8sTnzY2eSyB/G
	 bBQpFxuMK0oYHTJBC8CKf1CTfZ03N9VJDSZ/MgDmLdmwOdmzj08j2v002lstVS7mY81s5
	 aWv/JKtnbjZsjjx3in5ig/Ndjq3D2c3L1xFt72sPSc0R6MbQ/BBxE7I3kWzx/d8djRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLTGyM1q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39E606A31E;
	Wed, 25 Nov 2026 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLTGyM1q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3971F000C6;
	Wed, 25 Nov 2026 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620703;
	bh=Y/eZh36r2b2M/MV9kUnVPyReaneyongdcAiOZMPpEmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLTGyM1qDEHK4WQ5O1FGyuQaNyQiILeUl+J5LdwVb/gYzmRFD/l1ksLjvo2Dj/Ua0
	 P59hN8RMaqkbjehqRbfJVTVuNSbGkaaNyWPpwELXcwRm//wFvcan0D2VzEAS1frVct
	 Gn8QNuC+9DMLKFnsmlMeuZaG3mGyIlEsYK7tmG+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 1005/1005] tcp: Set unhashed_state in inet_twsk_hashdance_schedule().
Date: Wed, 25 Nov 2026 15:39:03 +0100
Message-ID: <20261125143845.192780499@linuxfoundation.org>
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
@@ -105,10 +105,12 @@ void inet_twsk_hashdance_schedule(struct
 				  struct inet_hashinfo *hashinfo,
 				  int timeo)
 {
-	const struct inet_sock *inet = inet_sk(sk);
-	const struct inet_connection_sock *icsk = inet_csk(sk);
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_bind_hashbucket *bhead, *bhead2;
+	const struct inet_sock *inet = inet_sk(sk);
+
+	icsk->unhashed_state = sk->sk_state;
 
 	/* Put TW into bind hash. Original socket stays there too.
 	 * Note, that any socket with inet->num != 0 MUST be bound in


