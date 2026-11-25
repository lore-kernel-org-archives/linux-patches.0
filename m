Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619273;
	b=UvbBKnccqyCvWc2YKZ4JPhkgjOCjYsB9dD6rfob7gIvvaoKRGvUsOV++PJ4/jaIa7+gb
	 WyHzS5yQEftiEeH7oZPzO8sp42QWqLIF45nqqMuldHtiMpS5aSX5iK4vHzajR9ynakAOd
	 3bDvzkdNrS2Qd+zN4S40Afpq2uWZ0r/z0h+kBp6ycSiVW8UxtiHGdSArkZVRiInGdoinb
	 hcoybIqq8mLnxNkBssVmJuvDqqCres5h74+ZiRamTnexVFvpBQ/wnJWwqVeS+w/s5A8lr
	 V0F3Bk3lA1YCj6w2kFh1fEu0ee3EqmZGzWzrXq2xR1LXS2AvQSzcLXWoT4IwWt0JZuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Z7cD2dIWeAS6fJRySzyJvPRoYq8mD5Y9rNbsRVjs1I=;
	b=X08Jh57ScDOuwEvBFMajhKu1DcZyreB7b9DWylN/XtyrbVyRLYvKLEDBj0cf/QGMi2rb
	 bgzPz3gxFCJ6X9B3P5LEPghI1zN3abiSzxVDOeIs4Hj0fBneF2M/HAVV5BCCRxc+MaccS
	 v3u2UU1EJvpb8jk+3bvGFyQVyFYgkTj5qMHZAqNCznpZOlfSqBnOA/kfUG22w0kkOoDYY
	 T0cXZyE27Dy5Auv8ddER6Xbn4P69D6crabK1v0hUZPJU+KZpVtLUNhzm6RucgdFeSWdjQ
	 ItepJx9KRZYqm5jG9dcduRrxsM9wBHQRRJKlmQHEMl50/KyfB2J11jQGOHm8tbxCvYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXIz5ENL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D2F606A321;
	Wed, 25 Nov 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXIz5ENL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A091F000C6;
	Wed, 25 Nov 2026 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619272;
	bh=9Z7cD2dIWeAS6fJRySzyJvPRoYq8mD5Y9rNbsRVjs1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXIz5ENLmFzRGRosINV9aCMnKa0dIqntWXynrDZAouW3vLSKu6ke+KSvIsrz+4wNc
	 DUA0aQk4Vax5orlDcrpdBuu7XmS/HT1T3o7TeFMJ+Avg7Ln8AsphXSCQlTSobNPyzy
	 V47bgvlqYt9UhoNJDzsnpdDCFJ7sAaDB5guZymt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0542/1005] tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().
Date: Wed, 25 Nov 2026 15:31:20 +0100
Message-ID: <20261125143834.442759562@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a9782a6f2bbd0c444689725a710d8b21eab61bc5 ]

When connection migration happens in tcp_v[46]_rcv(), a new
listener is passed to tcp_check_req().

When either of the following is true,

  * the new listener queue is full and
    net.ipv4.tcp_abort_on_overflow is set

  * the packet has RST or (not stripped) SYN

tcp_check_req() sends RST and calls inet_csk_reqsk_queue_drop().

Here, the new listener is passed, and its qlen is decremented
wrongly while reqsk is tied to the old listener.

Once qlen underflows, inet_csk_reqsk_queue_is_full() always
return true, and the new listener stops serving.

Without the patch, this script times out while waiting for SYN+ACK
since the new listener drops SYN, but with the patch, 3WHS completes.

    0 `sysctl -q net.ipv4.tcp_migrate_req=1`
   +0 `sysctl -q net.ipv4.tcp_syncookies=0`
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEPORT, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
   +0 setsockopt(4, SOL_SOCKET, SO_REUSEPORT, [1], 4) = 0
   +0 bind(4, ..., ...) = 0
   +0 listen(4, 128) = 0
   +0 < S 0:0(0) win 32792 <mss 1000>
   +0 > S. 0:0(0) ack 1 <...>
   +0 listen(3, 128) = 0
   +0 close(4) = 0
 +.01 < R 1:1(0) win 0
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 5
   +0 listen(5, 1) = 0
 +.01 < S 0:0(0) win 32792 <mss 1000>
   +0 > S. 0:0(0) ack 1 <...>
   +0 < . 1:1(0) ack 1 win 32792
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
   +0 accept(3, ..., ...) = 6

Let's pass req->rsk_listener instead.

Fixes: d4f2c86b2b7e ("tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261111020304.1532064-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0ddfd5af6e58f..a05bb02e204c3 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -974,7 +974,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+		bool unlinked = inet_csk_reqsk_queue_drop(req->rsk_listener, req);
 
 		if (unlinked)
 			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
-- 
2.53.0



