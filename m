Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711733557F6;
	Tue, 16 Dec 2025 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886223; cv=none; b=Kf4azemrD2j3cAkER0rT5F6MAW6OU53W/yypG79yq54XZ2OMWEucw6zDLws6xyhJZkAnWE5LyN42jZ0u7pErFrIvzUnBMwtLM//4dUG1pIFhAvr0ZgqdpeswQkRBC+4cwqdPe2D3VmwuW2UUly7wQB+KVjCqlbU9NvoxfeeutEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886223; c=relaxed/simple;
	bh=vZ6IEsNhYfLJtZpJAS6z7/enNwAa4kU6Kg4oTswBfno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO9+S0HNYviLgVy6hnRd5TfP8BziJE7ntZ0nJiXTub9bQcGpBP1TKrVMPu8MKNLxlBQJFQV8jmYbe3Uq7jJxgHEMj0NQf2Xf+DuxOcFamm6kMYRt/BH/KkhY8ve0PSVQNiGgwjq5BTAZYjGH7Xlswkd7+/rLYY5hEJdxZAeFB5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMi+Gv2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMi+Gv2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5569C4CEF1;
	Tue, 16 Dec 2025 11:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886223;
	bh=vZ6IEsNhYfLJtZpJAS6z7/enNwAa4kU6Kg4oTswBfno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMi+Gv2gA8II4/MTCZMFgpU5Dl64s8iKfOdJe5H140+6KMYQFtERT/2xVOKWX9MJI
	 LslieRj3MujPps3CVrAM8dA5q0ccYXC0wrU2hrqymIoR1ztvc92FblnhmI/oMwKA0C
	 s8udePJ65Lmq90+dxV0wcBDFhxIfuFBtbp9b6FK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 373/507] selftests/net: packetdrill: pass send_omit_free to MSG_ZEROCOPY tests
Date: Tue, 16 Dec 2025 12:13:34 +0100
Message-ID: <20251216111358.973505703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit c01a6e5b2e4f21d31cf725b9f3803cb0280b1b8d ]

The --send_omit_free flag is needed for TCP zero copy tests, to ensure
that packetdrill doesn't free the send() buffer after the send() call.

Fixes: 1e42f73fd3c2 ("selftests/net: packetdrill: import tcp/zerocopy")
Closes: https://lore.kernel.org/netdev/20251124071831.4cbbf412@kernel.org/
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20251125234029.1320984-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/packetdrill/tcp_syscall_bad_arg_sendmsg-empty-iov.pkt | 4 ++++
 .../testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt  | 2 ++
 .../testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt  | 2 ++
 .../testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt | 2 ++
 .../testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt | 2 ++
 .../selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt     | 3 +++
 .../net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt          | 3 +++
 .../selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt  | 3 +++
 .../net/packetdrill/tcp_zerocopy_fastopen-client.pkt          | 2 ++
 .../net/packetdrill/tcp_zerocopy_fastopen-server.pkt          | 2 ++
 .../selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt       | 2 ++
 .../testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt  | 2 ++
 12 files changed, 29 insertions(+)

diff --git a/tools/testing/selftests/net/packetdrill/tcp_syscall_bad_arg_sendmsg-empty-iov.pkt b/tools/testing/selftests/net/packetdrill/tcp_syscall_bad_arg_sendmsg-empty-iov.pkt
index b2b2cdf27e20f..454441e7ecff6 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_syscall_bad_arg_sendmsg-empty-iov.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_syscall_bad_arg_sendmsg-empty-iov.pkt
@@ -1,6 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 // Test that we correctly skip zero-length IOVs.
+
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
+
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
    +0 setsockopt(3, SOL_SOCKET, SO_ZEROCOPY, [1], 4) = 0
    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt
index a82c8899d36bf..0a0700afdaa38 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_basic.pkt
@@ -4,6 +4,8 @@
 // send a packet with MSG_ZEROCOPY and receive the notification ID
 // repeat and verify IDs are consecutive
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt
index c01915e7f4a15..df91675d2991c 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_batch.pkt
@@ -3,6 +3,8 @@
 //
 // send multiple packets, then read one range of all notifications.
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt
index 6509882932e91..2963cfcb14dfd 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_client.pkt
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 // Minimal client-side zerocopy test
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt
index 2cd78755cb2ac..ea0c2fa73c2d6 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_closed.pkt
@@ -7,6 +7,8 @@
 // First send on a closed socket and wait for (absent) notification.
 // Then connect and send and verify that notification nr. is zero.
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt
index 7671c20e01cf6..4df978a9b82e7 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_edge.pkt
@@ -7,6 +7,9 @@
 // fire two sends with MSG_ZEROCOPY and receive the acks. confirm that EPOLLERR
 // is correctly fired only once, when EPOLLET is set. send another packet with
 // MSG_ZEROCOPY. confirm that EPOLLERR is correctly fired again only once.
+
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt
index fadc480fdb7fe..36b6edc4858c4 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_exclusive.pkt
@@ -8,6 +8,9 @@
 // fire two sends with MSG_ZEROCOPY and receive the acks. confirm that EPOLLERR
 // is correctly fired only once, when EPOLLET is set. send another packet with
 // MSG_ZEROCOPY. confirm that EPOLLERR is correctly fired again only once.
+
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt
index 5bfa0d1d2f4a3..1bea6f3b4558d 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_epoll_oneshot.pkt
@@ -8,6 +8,9 @@
 // is correctly fired only once, when EPOLLONESHOT is set. send another packet
 // with MSG_ZEROCOPY. confirm that EPOLLERR is not fired. Rearm the FD and
 // confirm that EPOLLERR is correctly set.
+
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-client.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-client.pkt
index 4a73bbf469610..e27c21ff5d18d 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-client.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-client.pkt
@@ -8,6 +8,8 @@
 // one will have no data in the initial send. On return 0 the
 // zerocopy notification counter is not incremented. Verify this too.
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
 // Send a FastOpen request, no cookie yet so no data in SYN
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-server.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-server.pkt
index 36086c5877ce7..b1fa77c77dfa7 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-server.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_fastopen-server.pkt
@@ -4,6 +4,8 @@
 // send data with MSG_FASTOPEN | MSG_ZEROCOPY and verify that the
 // kernel returns the notification ID.
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh
  ./set_sysctls.py /proc/sys/net/ipv4/tcp_fastopen=0x207`
 
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt
index 672f817faca0d..2f5317d0a9fab 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_maxfrags.pkt
@@ -7,6 +7,8 @@
 //    because each iovec element becomes a frag
 // 3) the PSH bit is set on an skb when it runs out of fragments
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
diff --git a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt
index a9a1ac0aea4f4..9d5272c6b2079 100644
--- a/tools/testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt
+++ b/tools/testing/selftests/net/packetdrill/tcp_zerocopy_small.pkt
@@ -4,6 +4,8 @@
 // verify that SO_EE_CODE_ZEROCOPY_COPIED is set on zerocopy
 // packets of all sizes, including the smallest payload, 1B.
 
+--send_omit_free	// do not reuse send buffers with zerocopy
+
 `./defaults.sh`
 
     0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
-- 
2.51.0



