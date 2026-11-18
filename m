Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051494;
	b=rjSvtfSf9Zism3NrzDPn7YbWSsxPoy7lcGbvB/NvzEkJY8dPfEF8ihOmeSNUpt5eJYOW
	 7+575B0FOD5EQHkZWrKsNU8IbvIY5/xL2Mgd5hokeP52z+vQXqwQAwN8rWhCZpitVkktk
	 LLFqiSjqXB1103QT9sJtiioxY1rRthPDFEm/zee2NemHumwP30/FujL80o1MZ8ymCLAIX
	 ghoht4BD6bqPJlHCr0wcWV2uLgHen8XSx8kDO0dQNq5twhE3MKW8K1R8Rghnxk3RUq2aS
	 LAz0XQO7OIR78RiOnECEoRgJsMXwnneXFXZy532Uvg+GIjVfq8Vl57GNRXtSkDj+eEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5J8J/jrwQgVMkGAHBRoxL/yPW1P6z/MsT23vS/yRAY=;
	b=NyRQbJWdAzZm6uiL2rfFxjCi0tUuG0PeUB/CRyOhrQaH75H/rYaqycpHGFsheozwLMPs
	 ct+Oxyl3wAEc6TradKUCYqJ1Jw1uBHLWSg7rFZu/bjjzVp8tV+uqFkzs7EFH5KdZIGsHM
	 Ao7nEy+tkwxM626O84hZChp5ziaBElQJv1CBKR8WiLSDWlCOsdqU6zGXi4JkSHsLHZ3aP
	 fwEn7JZGZIEsbDflXY/uiM2wZFbZpUN2ukk2j8qphxDDkDrA99QYLukvz4U17RkxWm6hy
	 ceDMFcrsP3Bqp4ic2W/jXnKqdOGD/+DjK2dEjDdlvp7xnOjZiGNRkNZWyUi3cYRtoiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sUP/m4VT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E8606A31C;
	Thu, 19 Nov 2026 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUP/m4VT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CD81F000C5;
	Thu, 19 Nov 2026 01:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051494;
	bh=T5J8J/jrwQgVMkGAHBRoxL/yPW1P6z/MsT23vS/yRAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUP/m4VT0eJCQOJGl2U0EZR0DxSt2ORVvrcZNmhO01GcU6R78zFEkrpKzvAywL8Fh
	 ObmtXSyyqVoBIGF2DjPxJdY8+ZflL8CGuzi0zAzBGVo9hLoIyC43riRVKjsxiCxkj2
	 Oeej4wH21mZuhoWq6j801PSHUlCnTmoeKxBwdSic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0228/2214] ksmbd: enable TCP keepalive for accepted connections
Date: Wed, 18 Nov 2026 15:31:44 +0100
Message-ID: <20261118150019.359744803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/transport_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 28dc86dfb0301..c0a038666ec34 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -259,6 +259,12 @@ static int ksmbd_kthread_fn(void *p)
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



