Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619588;
	b=zfv/OI42Xt5F6qKEw5C8nKVnkF7ue+LpyLiGLqKlHW8UU8EWsA52HkazXwIv6Z9QHUOW
	 vay9oF/r72sDDiu7TZNW7LI2Fy23H301YuNg3AzrTK6+kta7cvodwg9GYl6bSmo9tURGD
	 Ddxt6hD5V9LlNhXrqNFvPKqGxokKB7zRa92gEe+f/1viXwYjjsqjVRMc2+E8WeSc0Ny0q
	 Jw6mtxAKJ23J7pAWxAVadwT/l/V+xJOnFkHUfie0nshuzdsZXjPdEZgcn1/51Wyi+3Two
	 7WonO0WHIiOcX/pd/otFzVYX3rRmctU9J5QHMnbpKds+qJ0rpIASl3Ti8B0uwKhU9Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mdOAhcuGgRFEWlCYjvijkdQ2n4t/4AorPWOEIF5UI+M=;
	b=JcSMkFsDV+Ir47Bx7yCR66W+BgLQaxWdK7iLWhRmZuv0kpmHqKz2+pObdGKCFu98loKs
	 56R9KtNzNzIhhlR0nyV7EEkWteyPoaHaTVbr0YLFAbpktrN68PsF0WxukP0vBhyMv2B3G
	 Ti+anf5irJ1BuqrZ88hb4S/cR/t++GSZeA5uoLXTglVJn+oS7IuQ87fK3yhdVjDondXlP
	 4Dc00DsH0izDgWCVdLmb9RnVibtvWFgl+OiBCGtAz5ff4umKHrXTcy3qvvg7Hi8KU7K+q
	 mR/pqWNtLr1+0Vfjz4DYROHD/jj5bYMNAuDSeOUftthm9ynUugXgYmCeqjsj67x7CAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tR+SEi3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05115606A329;
	Wed, 25 Nov 2026 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tR+SEi3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33611F000C6;
	Wed, 25 Nov 2026 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619587;
	bh=mdOAhcuGgRFEWlCYjvijkdQ2n4t/4AorPWOEIF5UI+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tR+SEi3DNwDzCIISQno833sNo0eaNnfmQv2GbVx6Bc0PGD8vOJ2SZeRsTOuwyGJoO
	 6HWAw4XDw4XVtYWRk5e5mKXMFKwN2SGfLL/68TQtk0AmqZhFFLx+1hdDxd7JxuYkd1
	 F0PZuevoE7TaJ+2x9LgRsJwZ1Tb0Nb2KGelqspzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0643/1005] tcp: fix authentication bypass via unsupported TCP auth options
Date: Wed, 25 Nov 2026 15:33:01 +0100
Message-ID: <20261125143836.815022225@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 7cc235fb1251fec1183e3158c60d2e504c2a8e8b upstream.

tcp_inbound_hash() parses both TCP-MD5 and TCP-AO options when at
least one of the two features is enabled. With TCP_MD5SIG=y and
TCP_AO=n, a packet carrying an AO option reaches the disabled
tcp_inbound_ao_hash() stub. That stub returns success, so sockets
configured to require MD5 authentication end up accepting
unauthenticated data. A forged AO option skips the unsigned fast
path, which is the only place where tcp_inbound_hash() can return
SKB_DROP_REASON_TCP_MD5NOTFOUND.

The inverse configuration with TCP_MD5SIG=n and TCP_AO=y has the same
problem for an MD5 option on AO sockets.

Note that TCP-AO depends on 64BIT: therefore, every 32-bit kernel with
TCP_MD5SIG=y is in the vulnerable configuration.

Make the disabled stubs reject options for the unsupported
authentication scheme. This matches the real helpers' behavior for
sockets without keys. It also means that kernels with TCP_MD5SIG=n and
TCP_AO=y now drop segments carrying an MD5 option on unkeyed sockets,
as kernels configured with TCP_MD5SIG=y already do.

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Dmitry Safonov <dima@arista.com>
Link: https://patch.msgid.link/20261107224733.1104094-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp_ao.h |    3 ++-
 net/ipv4/tcp.c       |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -303,7 +303,8 @@ static inline enum skb_drop_reason tcp_i
 		const struct request_sock *req, int l3index,
 		const struct tcp_ao_hdr *aoh)
 {
-	return SKB_NOT_DROPPED_YET;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 }
 
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4974,7 +4974,8 @@ tcp_inbound_md5_hash(const struct sock *
 		     const void *saddr, const void *daddr,
 		     int family, int l3index, const __u8 *hash_location)
 {
-	return SKB_NOT_DROPPED_YET;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+	return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 }
 
 #endif


