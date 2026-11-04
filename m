Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830999;
	b=U1U36xCCKoe2CIcotzHRDUtMRleM6xXgwwtedFPQ1CLgARm9hqkD85kjZGXwkdkUitgf
	 D7NHSNeQFTnXV42J5E12iVM9wQN0TlWghCVITJO9wmcTcZiQlXiKtmT5mCPkupW/hhOFy
	 MTaslfBTxPnL6SMoKAj4PupECQ7KyGdlTpJOsu5w0lt617gIx70UY5xrDdhWDPkdiSTp/
	 LfyAUFfYSCHEwVQ9+wCAHNJBOwNCoQ6OrwgGIqT/eaeF5oT0uoapauDNuaGlulaTMk13R
	 rtI3LG06u4TN5BER+6f17cjL1B8oLmrokqYRpCaonNA2iVz9u3+6S88P2n08z3YcG8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUnXA6y8uDMEdw5XWTwUykB5W8VAcW1siMJXZigFdiY=;
	b=aYTKXYc9kkjK1PT8h6uypkmLqI3V+aMr0n623GGFxnLCUv+Jt6SFAGifUY4Kggf3c/6L
	 FTUj0o2UPwSUmdfBnSmsSEewQOLqYWc1K1wSAi4RnvP1lTynC2P0lqnvc7sNhy2PEzljF
	 1lOhbCXTb+xV+ICcc2tArTKCIPh333LUAiQyVPAf86Ltn5xswgJl1c8G3CZ3B99yPgC/x
	 d7cl87fstxHiWrUMmyl+q4CJDmeaXxNbCE0T44gWCrUe0TcmJ1xkGWZNftJ0Zfn1GqWLI
	 zEOPgLQ/60ozTAHmNQvXqZ4BzkMjh+1s0rxkG6cGYd/JOmrgwvOClX8YliVnFV1OAdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru9oD+pY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFA606AB06;
	Wed,  4 Nov 2026 22:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru9oD+pY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F368C1F000C1;
	Wed,  4 Nov 2026 22:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830999;
	bh=qUnXA6y8uDMEdw5XWTwUykB5W8VAcW1siMJXZigFdiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru9oD+pYL2sLTOw2gygHdRrMDS1Im748yzK+xDy8uMptBu5wlHKumH9ZRLc4zChoK
	 2jWsvBdp+S5cz5C+//GYhEFIir+AccJPIixljDHz1CXIGZsfTbdq3RpcXvNKqZqNiV
	 BKWSJN0yexJ77lmLR+dzKzNKXQZTEKzjEgyez83Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0448/1005] ksmbd: enable TCP keepalive for accepted connections
Date: Wed,  4 Nov 2026 16:03:01 -0500
Message-ID: <20261104211056.605440038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 56549c18a4f75309161ca780feaa4d17904e3ee9 ]

A client that disappears without sending a FIN or RST can leave its
ksmbd connection in ESTABLISHED indefinitely. ksmbd sets a socket
receive timeout, but the connection receive loop retries timeout errors
without a limit, so the connection remains in conn_list and consumes the
per-IP connection quota.

Enable SO_KEEPALIVE on accepted TCP sockets so the TCP stack can detect a
silent peer failure. The keepalive idle time, interval, and probe count
remain controlled by the existing TCP sysctl settings.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 472d387098767..ede54bb049532 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -312,6 +312,12 @@ static int ksmbd_kthread_fn(void *p)
 		ksmbd_debug(CONN, "connect success: accepted new connection\n");
 		client_sk->sk->sk_rcvtimeo = KSMBD_TCP_RECV_TIMEOUT;
 		client_sk->sk->sk_sndtimeo = KSMBD_TCP_SEND_TIMEOUT;
+		/*
+		 * Detect peers that disappear without sending a FIN or RST.
+		 * Otherwise the connection handler can retry receive timeouts
+		 * indefinitely and keep the connection in conn_list.
+		 */
+		sock_set_keepalive(client_sk->sk);
 
 		ksmbd_tcp_new_connection(client_sk);
 	}
-- 
2.53.0



