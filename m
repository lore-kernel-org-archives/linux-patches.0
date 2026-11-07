Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061802;
	b=IF8XGvaoxGA8vVhUbri8m/9/FzkY0lJ2fEK1+SfXphjQxrkyrkWavrMoWZ21nG2ecaYQ
	 ZdUzvXLVDdTY/30KYgqSou4KGQIAhEtbhojPxix7u8D0Lu3go5wBn8jxjFT6TjIwdSJb4
	 DQ3YC/+Gur46yGpO4j4/wwXrlwRfcqXSIQoEBqExaLVya0HHc1ijbGQygEOnTI96IPSP5
	 RA1gpH8mppbOLg65PjOAI3DAZ1hvqkYKQv+NB8yXK/vOWpURVDpra7NvozLHipvXqfjO+
	 Hrn13/SnakQxi06nItESfWqGcK52GywXEaJ3hmi4ptLckbRJoqMEVf3RpThN1vIyUWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Z1J4X24jJUhKuvlCbtdv2svDKZaFIKky8EBlRiKy1Y=;
	b=OPt0/9KP+mpq1gR3lszkXtMbFrZC6yOB8HxgiKPCxAYGnxmHiYwOKooXhllUa+2sR9rD
	 yUiYRtzSHUQa7MUn/M9YJC3yhA4INehLqQuLN3pObtf0YO5kVyUsfY4Nh5q+fmdFGrTXw
	 9RdUF/fqfKRiE2gyyAn0tHBGZyJ7gl0ZdHm7OhRpsPJHhRxCoxajeT7cNQFlQLKVK03OL
	 lUsmCYybw5OUZQDcs5mI+sNWiQUrY4HmampWttKLppomcyCaZKGm0BYT2uZ06wCDMC9T8
	 2rgtOFaff7jXec4mzkKM/tqL1Zont3VlJWdrF3qvmqkwEoGI1P8DQC+nXYhuYAaHR7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VbC8XrUB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BDA606A330;
	Sat,  7 Nov 2026 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VbC8XrUB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AFC1F008A3;
	Sat,  7 Nov 2026 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061801;
	bh=0Z1J4X24jJUhKuvlCbtdv2svDKZaFIKky8EBlRiKy1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbC8XrUB/xAsWzc+S8CVD6BJdoUkvxz/nPc9jluHQJ3IAOp3zvWyUd6l8y/1MxYVD
	 hCdB8nwwNNmjl05UQvX7MSznhlcvyWcGK7nG0u4bYd59/SZ3v2olsZUCBYuZhxcfXb
	 1lrsFUB8e8qg7uZR79nlUszLwBzKCMt0nskmkEok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org
Subject: [PATCH 6.12 0791/1536] rxrpc: Fix return in rxrpc_recvmsg_data() for service calls
Date: Sat,  7 Nov 2026 08:46:47 -0500
Message-ID: <20261107135019.758526894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 18a71e111c7505e16c2de91480561fc491f41341 upstream.

When rxrpc_recvmsg_data() gets called on a service call that has received
all of the request, RXRPC_CALL_RECVMSG_READ_ALL has been set, and this
causes rxrpc_recvmsg_data() to jump straight out, indicating the end of the
call (ie. rxrpc_kernel_recv_data() returns 1) without waiting for the call
to be processed or the reply to be transmitted.

rxperf_deliver_to_call() also has to be altered to call
rxrpc_kernel_recv_data() to collect the final ACK on a service call as does
afs_deliver_to_call().

Fixes: d001648ec7cf ("rxrpc: Don't expose skbs to in-kernel users [ver #2]")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914151340.3227501-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261006133011.531806-10-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/rxrpc.rst |   13 +++++++++----
 fs/afs/rxrpc.c                     |    4 ++--
 net/rxrpc/recvmsg.c                |   13 ++++++++++---
 net/rxrpc/rxperf.c                 |   16 ++++++++++++++--
 4 files changed, 35 insertions(+), 11 deletions(-)

--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -910,10 +910,15 @@ The kernel interface functions are as fo
       want_more should be true if further data will be required after this is
       satisfied and false if this is the last item of the receive phase.
 
-      There are three normal returns: 0 if the buffer was filled and want_more
-      was true; 1 if the buffer was filled, the last DATA packet has been
-      emptied and want_more was false; and -EAGAIN if the function needs to be
-      called again.
+      For client calls, there are three normal returns: 0 if the buffer was
+      filled and want_more was true; 1 if the buffer was filled, the last DATA
+      packet has been emptied and want_more was false; and -EAGAIN if the
+      function needs to be called again.
+
+      For service calls, there are four normal returns: 0 and -EAGAIN are the
+      same as for client calls; 2 indicates that the last DATA packet of the
+      request has been received, want_more was false and the call is still in
+      progress; and 1 indicates that the call is now successfully complete.
 
       If the last DATA packet is processed but the buffer contains less than
       the amount requested, EBADMSG is returned.  If want_more wasn't set, but
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -544,7 +544,7 @@ static void afs_deliver_to_call(struct a
 						     &call->service_id);
 			trace_afs_receive_data(call, &call->def_iter, false, ret);
 
-			if (ret == -EINPROGRESS || ret == -EAGAIN)
+			if (ret == -EAGAIN || ret == 2)
 				return;
 			if (ret < 0 || ret == 1) {
 				if (ret == 1)
@@ -945,7 +945,7 @@ int afs_extract_data(struct afs_call *ca
 		return ret;
 
 	state = READ_ONCE(call->state);
-	if (ret == 1) {
+	if (ret == 1 || ret == 2) {
 		switch (state) {
 		case AFS_CALL_CL_AWAIT_REPLY:
 			afs_set_call_state(call, state, AFS_CALL_CL_PROC_REPLY);
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -552,9 +552,11 @@ wait_error:
  * Note that we may return %-EAGAIN to drain empty packets at the end
  * of the data, even if we've already copied over the requested data.
  *
- * Return: %0 if got what was asked for and there's more available, %1
- * if we got what was asked for and we're at the end of the data and
- * %-EAGAIN if we need more data.
+ * Return: %0 if got what was asked for and there's more available, %1 if we
+ * got what was asked for and we're at the end of the call, %2 if a service
+ * call received all of the request but is still in progress and %-EAGAIN if we
+ * need more data.  A variety of other errors can be returned if the call
+ * completed with failure.
  */
 int rxrpc_kernel_recv_data(struct socket *sock, struct rxrpc_call *call,
 			   struct iov_iter *iter, size_t *_len,
@@ -593,6 +595,11 @@ int rxrpc_kernel_recv_data(struct socket
 
 read_phase_complete:
 	ret = 1;
+	if (rxrpc_is_service_call(call)) {
+		if (rxrpc_call_is_complete(call))
+			goto call_failed;
+		ret = 2;
+	}
 out:
 	if (_service)
 		*_service = call->dest_srx.srx_service;
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -292,8 +292,20 @@ static void rxperf_deliver_to_call(struc
 	       state == RXPERF_CALL_SV_AWAIT_ACK
 	       ) {
 		if (state == RXPERF_CALL_SV_AWAIT_ACK) {
-			if (!rxrpc_kernel_check_life(rxperf_socket, call->rxcall))
+			size_t len = 0;
+			iov_iter_kvec(&call->iter, ITER_DEST, NULL, 0, 0);
+			ret = rxrpc_kernel_recv_data(rxperf_socket,
+						     call->rxcall, &call->iter,
+						     &len, false, &remote_abort,
+						     &call->service_id);
+
+			if (ret == -EAGAIN || ret == 2)
+				return;
+			if (ret < 0 || ret == 1) {
+				if (ret == 1)
+					ret = 0;
 				goto call_complete;
+			}
 			return;
 		}
 
@@ -368,7 +380,7 @@ static int rxperf_extract_data(struct rx
 	if (ret == 0 || ret == -EAGAIN)
 		return ret;
 
-	if (ret == 1) {
+	if (ret == 1 || ret == 2) {
 		switch (call->state) {
 		case RXPERF_CALL_SV_AWAIT_REQUEST:
 			rxperf_set_call_state(call, RXPERF_CALL_SV_REPLYING);


