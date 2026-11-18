Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021381;
	b=Op+PMxA2SIibEdWBKsFrG64Lb8QUmY3lF8CENYufGayIzzzvjN4FaWtQaoUoOeCpAGxn
	 FXkFHXpmCfgBSUg2/PBhs/DkB0dtbilHMhFey9nWFfxx3f2Ktlvg+l7CVFGQhdAOPQzwl
	 CuH3EbKUfLgK3dUvvCIkqXzv0RBc4j+VKlRoS7QoyA4YxwCql89keyKo9uVW93C3mrCjW
	 fCk0HNBayGFdYEW1FSm/rVnqdLOtwJvqDieDY7DuqocGP+wWdM4K5q26wwBuipzC0lRbL
	 K6qg8zSw2yczL3KZ9sF9hvrYQCTEW1GPiHp9jn8YEGQBo8NlK+jxD8JzIyYhrfOZvCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtjCAkb5Kcolpgb4Bz3ohNs9m/2M1qFhttrftVTEOBg=;
	b=zXAlDQOPJOoPtTFOfxvm8eCbLMMJpzQU8hSdruuqXTMhkmDq7NoaI98x6o+C+/kkxm0v
	 JPnjHIx1qLmOaOeewDpD9fwjFs9KIJiqZMKbaF5njdw9y8lKOYkUCWSkeNo9het1XmUB/
	 rU6BqRw0I55vp20dVYXzYk16WjuruQZu25G/an+M0SgGVEQYgbEpZrtSAnGBQYXvSMA73
	 p04PSWQea4p2xez7l6lyeUjSXXs6Ejd20Eb4b/87TQ4ninY5AmcItnjHdp3tWUgVnq15I
	 LE7ViUhHMPwB4sU1Fn4AfoWAMfwmdOCx6WtAx+MBa/Kzew0NeYdDTcm4oPzSrJgv0MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHM7eJMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78660A2600;
	Wed, 18 Nov 2026 17:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHM7eJMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD481F000C4;
	Wed, 18 Nov 2026 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021381;
	bh=GtjCAkb5Kcolpgb4Bz3ohNs9m/2M1qFhttrftVTEOBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHM7eJMZ/bX2SeTI9SAiSH8zyfOWaxAbV2OfreEV9xLTeqCfR8FHY9QbAr6ZzFI+t
	 OxKviWu8qDDWlKZWpR83JKjilNWv8sLYqHrFWAwlM4gqelygrozZ700rb3G4xv9AqD
	 WGitTbOUf0r8Xpy+s0bd3emQ7k/4RzlqUYAadFWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2288/2651] ksmbd: print IPv6 client addresses correctly in procfs
Date: Wed, 18 Nov 2026 15:58:48 +0100
Message-ID: <20261118150407.653635005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit cf0ef575a56993147f087d3f251fc2a04fdffbeb ]

conn->inet_addr and conn->inet6_addr share a union, and three procfs
printers choose between them by testing whether inet_addr is zero. For
an IPv6 peer that field aliases the first four bytes of the address,
which are zero only for :: prefixed addresses, so a client with a
global IPv6 address takes the IPv4 branch and is listed from those four
bytes. A client at 2001:db8::1 is listed as 32.1.13.184.

IPv4 mapped addresses begin with zero bytes, so the listing is correct
until a native IPv6 client connects.

Record the address family where the address is stored and select on
that, in the client listing and in both session listings.

Fixes: fe4dc5987d7d ("ksmbd: expose connection runtime state in procfs")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c        | 2 +-
 fs/smb/server/connection.h        | 3 +++
 fs/smb/server/mgmt/user_session.c | 4 ++--
 fs/smb/server/transport_tcp.c     | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index b519376ecc17b..d66fc0fbe5269 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -114,7 +114,7 @@ static int proc_show_clients(struct seq_file *m, void *v)
 			sessions++;
 		rcu_read_unlock();
 #if IS_ENABLED(CONFIG_IPV6)
-		if (!conn->inet_addr)
+		if (conn->is_ipv6)
 			seq_printf(m, "client:\t%pI6c\n", &conn->inet6_addr);
 		else
 #endif
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index a4f5a64b36b4e..8e0da44a1e0f6 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -68,6 +68,9 @@ struct ksmbd_conn {
 		u8			inet6_addr[16];
 #endif
 	};
+#if IS_ENABLED(CONFIG_IPV6)
+	bool				is_ipv6;
+#endif
 	unsigned int			inet_hash;
 	char				*request_buf;
 	struct ksmbd_transport		*transport;
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index d131809dd08ad..a18533bb4fe39 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -153,7 +153,7 @@ static int show_proc_session(struct seq_file *m, void *v)
 		const char *name;
 
 #if IS_ENABLED(CONFIG_IPV6)
-		if (chan->conn->inet_addr)
+		if (!chan->conn->is_ipv6)
 			seq_printf(m, "client:\t%pI4\n",
 					&chan->conn->inet_addr);
 		else
@@ -256,7 +256,7 @@ static int show_proc_sessions(struct seq_file *m, void *v)
 			ksmbd_user_session_get(session);
 
 #if IS_ENABLED(CONFIG_IPV6)
-			if (!chan->conn->inet_addr)
+			if (chan->conn->is_ipv6)
 				seq_printf(m, "client:\t%pI6c\n", &chan->conn->inet6_addr);
 			else
 #endif
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7492aa08f9f31..2c0e6b9abd5e9 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -104,6 +104,7 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	if (client_sk->sk->sk_family == AF_INET6) {
 		memcpy(&conn->inet6_addr, &client_sk->sk->sk_v6_daddr, 16);
 		conn->inet_hash = ipv6_addr_hash(&client_sk->sk->sk_v6_daddr);
+		conn->is_ipv6 = true;
 	} else {
 		conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 		conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
-- 
2.53.0



