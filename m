Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043600;
	b=5pviTqgyGPqwD8bzsgQCluSPBYCaTgbZ2NHV/a7z6E3a+PPRGlfBiMZWTLMhUPcYqu5r
	 Buvyo00bRhPONTYI0878+tmpp8DPpN9Ag2JQPtM1zRLPMqmf/kOk0QNHUh0QwXJNbcog5
	 JWugN+B0AkiXlJ7OvFUAtvaBkeVkVWJ5Fsc1gjv1x7EhJOISb181xbTCSHDhjYXsC20k4
	 i/tmymeKVQxkQ/8H7LcAKx6XQt/J+pR3hEIp/f7JqCxeAsptcnPPzHDGNTeSxOrbxzD8a
	 N8+Lae4zcWOgSAtqGR+BmayhlUIS9aCPlbV2IjNgWLrSCmuegsOgJwgXSfE4s9SnoRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qHzemehVRTK1+6g8NTNNX27VaSp/s3eWTyjaATI/Jmg=;
	b=FQA8SKVgmYj0Ldc1jSXYJ3xcAsES4oo4+xHg3USOceLl26Yxkswhxw/RtZb/AspEDilu
	 fMAKA9CIhq3UYJwl2IrcSDNRbZla2JpxJogDfSjUCAU8K4SjlYCepI8JsyUBhyavZMX5A
	 wnuJ7upf/bv3GxI7SdO0e+FmdqHUhr0/FE2ORmxU97Tt6dxdvM+ZdXI+RrHN4aaWQyVPt
	 Mq5qBDKHD5cNYRfD6ScpFcYSgmhGbKqjqArKyK+2nr5P1CAn8sGV63GVC6qGxfa2EVBWc
	 vEnRz8LAMjYre2hJDyxLwV24RsirugkjtPcFZezVow6KIh3jN0oDXeDOEEVOsqxloIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLsTc9y4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2795F606A325;
	Wed, 18 Nov 2026 23:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLsTc9y4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788431F000C4;
	Wed, 18 Nov 2026 23:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043600;
	bh=qHzemehVRTK1+6g8NTNNX27VaSp/s3eWTyjaATI/Jmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLsTc9y4y4pccRDEzMCuwr1jPTzlP6rbPY/fs0ViteDR8l5oJfVKXDqwlilzFHt0x
	 T9SVpmoezz8FLEXIQGTIq5pK/jUF8CrqfFvFoxDghYpfTCDUhOPU/FX6ViEm3uHuRM
	 gOtfzwk3237a1tADsi7H38l5q1JU9x4UYHA1Lbf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0267/2857] ksmbd: enable TCP keepalive for accepted connections
Date: Wed, 18 Nov 2026 15:21:41 +0100
Message-ID: <20261118150211.045517173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 4bbd1e1cb02ff..9ef3b3153819e 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -304,6 +304,12 @@ static int ksmbd_kthread_fn(void *p)
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



