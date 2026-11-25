Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626333;
	b=oTmga7qZkP1LjJQTnIIHb/g+72bC1xDaY0Q6ch6JRsgsgAmxnnEJQhZgUv2qixN2+4de
	 1Hy6iqitYmZCQRjvsv8/nJiC/FzRUxkrwGVLgzH/LWhdNLYY9oIyh16Wzf4ef1WGRyz0L
	 SaghBSy6VdAwNr1eq/1IPzyJvxAfuOpOt1U7raIbjsSp3WvUPvKp18iKQXBdgXAaKSmnK
	 ZfAyNhcsfxeGgBgIhINKiQ1D4CLXhjY74vjDpO1uXC2mRyQQ+eIC3M+PeUKxL/yPcHND7
	 WrB/FFMLWTA2TFGU9rv2YYa6kYOvIR7ToDahao16zDxJJttLEbHT2QiwYdulaShmH7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bhq0LzqjgeJLwAZPkiKvRhzl3CALm4ahZGNY5+GhHSk=;
	b=GWB5r7BrOhB7yk7ohWHUXz+FK+U1+XoO5Bd6HKtvtlCnVJjskbB6UyuoGXbe/YfF3vyS
	 t8sqiY7UBE9tH9dIuWgu7POJHm1c439j5J/jnsEL+dQHM4djivpfCAhM05LEXfb6eLP6X
	 LascDVo+ydOIOyUDw3yqP6DBbMZdHoU4VhZbX9Q1QMhXuLzDVBo4xGsh27F0Zd4jTVYFR
	 Gej2VmfDJiocw81au99n0H/Aj15mH6+MMLm2Thh4E+KzMFrG+4ye0SSHgsDkq58B+8h83
	 dVxj7Ow/pAY1tK+axeM885W/XsV3+DWnUBVXF8HIPchfwsGTTUPJFqC+Ja0mA73ubHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uJXuY/bx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443D606A31E;
	Wed, 25 Nov 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uJXuY/bx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24B21F000F2;
	Wed, 25 Nov 2026 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626333;
	bh=Bhq0LzqjgeJLwAZPkiKvRhzl3CALm4ahZGNY5+GhHSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uJXuY/bxI6ooekgOA7HN3cKg8hS1bSW0m33mNeWKOhDB3L13YgNYfVtTyQAwzzvc+
	 gE2MHQL+SftAFVn80x8IVqakRP/BqGM1aS882ShYKkEOsB6v4dDi/8mD+Io9D0i02L
	 mnDjmx556z/NbExeoycf98gPO6JW7HIo/8sNd1gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 810/816] tcp: Set unhashed_state in inet_twsk_hashdance_schedule().
Date: Wed, 25 Nov 2026 15:39:18 +0100
Message-ID: <20261125143907.919585096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,10 +103,12 @@ void inet_twsk_hashdance_schedule(struct
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


