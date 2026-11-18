Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034284;
	b=rVUBi2kDwYoOt7oZMqrjxXNrQUVbBL7Nq4aFq84eQJ05SqC8+NTFYcUBx2s2G4fBRbnW
	 GssE9K1sEWNwBJftnWgax8kOVoBgb879hk6qpwh2noRl/BNKgiiQw6LBuC8ehUSQQ8S53
	 VBEsxjyUACyjOBrfgsL0mVgsKL+MibKAWY2FTYSrhmaGnA637mVN+hqRsVWTZvlmlyFmp
	 sw3zd/c+a3BzDUAPtdbKuhsRnRsk6Lh4rgx+6HIKTZly+Z1Tm+RZ+j0JFdWziLssWvNUa
	 s3SIt1DRFx4w3KLrsZAZ4TJW9BpNXDq1Q+1G/shUvBp0GtMSM0HozF+ela/94X6Cibg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1XlDl9jCQunBwxyvpph9IzsyW5tFvY6CshtN/S9BE0=;
	b=5q0tpWhkcg/pyaFrdC4rzhV/2Yg01YugHhGcOcuJrXLduKjBHgjaFEb+1XBkkmUSdnoW
	 +KDNdLmCCY0G0RFbLY6xhFtz1OIA+Dx88aOu7FqH/n/jz6LyG8n6JuNz1l78Hk5CfPxeL
	 37dJginI0+KUm9QCo8zK/zoNsAcM2JYaeNazmSPmx+xTERdg/8ly8bL0PWEf5vXCpbGIj
	 0/zJieX4hdlXztheMgjDnyDTbVtCeUf/s9QqaakdTOoqw+s1AuDhgXMptMTW/ly2PE4ry
	 3p7TzxSoJgCwQwaKAfsWa2XN/e57hdwCmsCBkeS6hRtK0IxauInI4x3yuKTyvOUUpZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dks3NYfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C260A2604;
	Wed, 18 Nov 2026 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dks3NYfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87E1F000C7;
	Wed, 18 Nov 2026 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034283;
	bh=m1XlDl9jCQunBwxyvpph9IzsyW5tFvY6CshtN/S9BE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dks3NYfDjbhW8+3cjEwlPu5xazo9T9FOyKnXpDWcpjXBJhfdN4Kc9TkaJ8xAcKO3N
	 FzE+PuRZTCuN+Vty4e7MvFrrGs31vamq9+jDj1gRthKd7/CEwPbxlvWtTkZYDIV2b4
	 jPwlZe1cU9EV75a9mIPDeVbV4ulALZv/Z/gabhlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0314/3318] ksmbd: enable TCP keepalive for accepted connections
Date: Wed, 18 Nov 2026 15:15:36 +0100
Message-ID: <20261118150325.238103704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index faf6f7a34a2be..a8a0d0b28cd49 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -326,6 +326,12 @@ static int ksmbd_kthread_fn(void *p)
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



