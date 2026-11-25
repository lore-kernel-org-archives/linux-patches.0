Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619276;
	b=egH9HmePayEMZicKBprBBnE9hVp3AdI4Q3snRZIWWajIzqsDYP0VZwFTYLo2KxvcCTwG
	 u7EdnzJ8oI8jNR2ACnMLkg2EXAJ0Uymx3lgq7cweQPJO6uL6mAEhB1ak1nnNgM3EtVhM7
	 QDXlKAISZaUjEx+wqQz6fkGfsdHRAvTafTduoxwGK2/42ARL/L3TsNxr6gwQrsRjNSPt1
	 Qwlhz1veeyKsXeWFftWuzFHVYe86DIt1c+qv1yr/iXCD+49LQU6a8OJXzAXHS1V90VoG3
	 yX5wcvz1cn9kYSxV4B1+qdgOZp9kbT4XIfm8+5gygjzScaJP0V6bPEMjN1bFntGEXZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TNK46Xz48WQK4yf4Hmjw+POLl4TCrb57VuW6CUjaV9s=;
	b=WP1gT49PSjMYz+WHWuF+5FhODk3NWxbUBStteAoFyGxaaTDvl8etT3xETjz903jC0BNd
	 9EIFYA1AO1E5+N+xRz2IT4mfKnUrcHZsSdsCAohDEvFimk5TAO+h/V71LQRWJjXSqDNZA
	 dYxgIUivS2Y+YOcGIWntFtXeSKRx2g0kt1HxRSbO/8B2n5uF1bE7i5FUMmWvIcGCgoQwC
	 J8m07hI3TPxkR6cFnVDaxsmXdDvL95WxnpvT+EVGsyIvCxbeoILUPCmTNn8fp+jmOxsUU
	 WnYM+HzJvgu7idHUN1nHU1r8O6ISfRna6v8PeUvlINo1j88z8W232aiKJHgK7Ho5jIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZSqsceP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF2606A329;
	Wed, 25 Nov 2026 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZSqsceP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0301F000C6;
	Wed, 25 Nov 2026 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619275;
	bh=TNK46Xz48WQK4yf4Hmjw+POLl4TCrb57VuW6CUjaV9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZSqscePdHX+WAxilf4dYfsEHCnVPP+ahln+NVhZ9P9CGrKICowJfIxZ7S1VQqOW1
	 FLCKYZm5165hdZW9vEVTrU5m8CCLQP9Cpa3g+seYj7oCZE98cjGLTE3xJBu1fdg7h4
	 nxFR2vh/frhgTSOom73Zfu/lC3CPS5FfYB+AXCKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Sun <sunwenbo@cmss.chinamobile.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0543/1005] af_unix: Inherit SO_INQ in unix_stream_connect()
Date: Wed, 25 Nov 2026 15:31:21 +0100
Message-ID: <20261125143834.464911419@linuxfoundation.org>
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

From: Wenbo Sun <sunwenbo@cmss.chinamobile.com>

[ Upstream commit 0359338fd8cf1a2dc001d0cd69c331c17decee88 ]

When SO_INQ is enabled on a listening AF_UNIX SOCK_STREAM socket,
accepted sockets created by unix_stream_connect() do not inherit
u->recvmsg_inq from the listener, unlike TCP_INQ, AF_VSOCK SO_INQ,
and AF_UNIX SO_RIGHTS_NOTRUNC. As a result, recvmsg() on the
accepted socket never puts an SCM_INQ control message unless SO_INQ
is set again after accept().

Copy otheru->recvmsg_inq to newu->recvmsg_inq in
unix_stream_connect() using READ_ONCE() to pair with the lockless
WRITE_ONCE() in unix_setsockopt().

Found during LLM-assisted code review of unix_stream_connect() while
comparing option inheritance between SO_INQ and SO_RIGHTS_NOTRUNC.

Confirmed on UML (x86_64) by enabling SO_INQ on a listening AF_UNIX
SOCK_STREAM socket before listen() and accept(), sending data from a
connected client, and observing that recvmsg() on the accepted socket
returned no SCM_INQ control message.

Tested on UML (x86_64) against the reproducer, verifying that
recvmsg() on the accepted socket now returns the expected SCM_INQ
control message, and ran the tools/testing/selftests/net/af_unix/scm_inq
selftest (all 6 test cases passed).

Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
Signed-off-by: Wenbo Sun <sunwenbo@cmss.chinamobile.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261111023222.77227-1-sunwenbo@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 42cffeafc8c14..6be50ef557d69 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1752,6 +1752,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr_unsized *uad
 	newu = unix_sk(newsk);
 	otheru = unix_sk(other);
 	newu->listener = other;
+	newu->recvmsg_inq = READ_ONCE(otheru->recvmsg_inq);
 	newu->scm_rights_notrunc = READ_ONCE(otheru->scm_rights_notrunc);
 	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
 
-- 
2.53.0



