Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622231;
	b=AUiLtrm7RjRslGbfwug99mlFV0L29axgABFik8NpZYwx03nCrLXbH6UyO3MEAkD0vcq/
	 ss/jkbTAN+gAcQNvpXeYyTCoC0nw63YAglRPkCo5QAmYuugd5sOvN9cMCK5tSy8EYnpoC
	 7bBJqhdAwaor1Kg18zm6t0MOcXlXV+AM6pYwZpqehHVMl59LwlzGc5hXV8LKkn/hXoXEM
	 44DURgoan++csXoIfuqDURDAv0CahOJwBvmCD/ce/UfFUUXMaLQDlYPqGMSnAbTUt4eX0
	 C15MIOOGFwyWocMAOk0ubpVSvCGgcS1D+V1gPvGcsoXn8kiVIDDC5ZpnhRtKoP8c9Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tspfG4lVvR+eRwLSd5SSyjgrWv/Ykh5TkaVSG05um7M=;
	b=TTuTo3t0YqvePLtJWjRhvJlRGYOndrtm+dyyCjytyM9S6tD6Uz0105jCpozKW7hjrbCt
	 7MwliI6vtTgzWzWZ7TqA5xktTt8CZ6fuQgXCaZb/NQ8ILnUIBPCFuJtQ8LA+u7lCPfeJP
	 sMkxhEFPBkj1keUrnq0hKO9sWvBTKCyrApn9Hg7RoBJ9FuydC5D32glWUw85Tw1x976vQ
	 Ds8eiTWm9krb+EtPfST8Ms3ES2He+opAQ6qlvXCPwc6GPF9vSI2H5258mK/mX3eOvD85V
	 7vB6Af6axeAWBNSV12SrBBXcFHVHbGBfRThyKxIw4/p+0ej0aT8CmfJQ6LmPUSvkO1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VK3ptXYF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F8606A321;
	Wed, 25 Nov 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VK3ptXYF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7CE1F000CA;
	Wed, 25 Nov 2026 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622231;
	bh=tspfG4lVvR+eRwLSd5SSyjgrWv/Ykh5TkaVSG05um7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VK3ptXYFBnODSxlit6pbkqsSnFQ3cUYbzmPQOCF8rocKJRa+ZDHiCzPwInvKACJNf
	 CDQyV3Xh9Cj4TgoD5X/lhqmtQUGeJDzPODSXGTmyS3B9UHRtEDCCxvfWfkJz7E6XSm
	 DZ1lfEjXIZMI/WQet7SF7VITgCV9ptpoixMu0sSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Sun <sunwenbo@cmss.chinamobile.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/990] af_unix: Inherit SO_INQ in unix_stream_connect()
Date: Wed, 25 Nov 2026 15:30:38 +0100
Message-ID: <20261125143833.127849761@linuxfoundation.org>
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
index 0638779e7c375..9c92d13aa6363 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1773,6 +1773,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	newu = unix_sk(newsk);
 	otheru = unix_sk(other);
 	newu->listener = other;
+	newu->recvmsg_inq = READ_ONCE(otheru->recvmsg_inq);
 	newu->scm_rights_notrunc = READ_ONCE(otheru->scm_rights_notrunc);
 	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
 
-- 
2.53.0



