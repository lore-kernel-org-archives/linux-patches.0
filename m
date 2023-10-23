Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8947C14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mu3idL4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029A1C433C8;
	Mon, 23 Oct 2023 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059719;
	bh=sINyUQC2Tkad5zrFqeT9R8ku7MZhf5L5u50Q1PsaWBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mu3idL4XcQGQjfOUzdgJbqmvJUNVTH+t9I/P7yrXWalst00Y4krm9DuqZSVRzAy2D
	 r9ZurrF8HXh/OlttFc/t3mohycumPbOawMYWpVjoT9+vE5KWM3ZjWJWElyP3gQXySZ
	 feMYT7aoePrxVs7nVhkN3G3IJhg31p59EMh1K11o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/98] net: fix kernel-doc warnings for socket.c
Date: Mon, 23 Oct 2023 12:55:52 +0200
Message-ID: <20231023104813.707818167@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 85806af0c6bac0feb777e255a25fd5d0cf6ad38e ]

Fix kernel-doc warnings by moving the kernel-doc notation to be
immediately above the functions that it describes.

Fixes these warnings for sock_sendmsg() and sock_recvmsg():

../net/socket.c:658: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:658: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
../net/socket.c:889: warning: Excess function parameter 'flags' description in 'INDIRECT_CALLABLE_DECLARE'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 86a7e0b69bd5 ("net: prevent rewrite of msg_name in sock_sendmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index dc4d4ecd6cea2..adf1fb37c17c6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -645,14 +645,6 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
 }
 EXPORT_SYMBOL(__sock_tx_timestamp);
 
-/**
- *	sock_sendmsg - send a message through @sock
- *	@sock: socket
- *	@msg: message to send
- *
- *	Sends @msg through @sock, passing through LSM.
- *	Returns the number of bytes sent, or an error code.
- */
 INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
 					   size_t));
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
@@ -663,6 +655,14 @@ static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 	return ret;
 }
 
+/**
+ *	sock_sendmsg - send a message through @sock
+ *	@sock: socket
+ *	@msg: message to send
+ *
+ *	Sends @msg through @sock, passing through LSM.
+ *	Returns the number of bytes sent, or an error code.
+ */
 int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	int err = security_socket_sendmsg(sock, msg,
@@ -853,15 +853,6 @@ void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
 
-/**
- *	sock_recvmsg - receive a message from @sock
- *	@sock: socket
- *	@msg: message to receive
- *	@flags: message flags
- *
- *	Receives @msg from @sock, passing through LSM. Returns the total number
- *	of bytes received, or an error.
- */
 INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
 					   size_t , int ));
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
@@ -871,6 +862,15 @@ static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				   msg_data_left(msg), flags);
 }
 
+/**
+ *	sock_recvmsg - receive a message from @sock
+ *	@sock: socket
+ *	@msg: message to receive
+ *	@flags: message flags
+ *
+ *	Receives @msg from @sock, passing through LSM. Returns the total number
+ *	of bytes received, or an error.
+ */
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
 {
 	int err = security_socket_recvmsg(sock, msg, msg_data_left(msg), flags);
-- 
2.40.1



