Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA246AA6C;
	Tue, 21 Jul 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648083; cv=none; b=KEe6ZEUrEzWj6uPiSCaPGGDOk1T0DCyPo9UUVICssEOjfYL11B6V1gG5TctNDIhTzr+JX3oND2bGbieeVwS9gxsI4N4+Q/4sGGH4fW9SX3FL7kqykZlG/7KU4S7R5tyf+7e/9VjimIWRa8+S5DSMYiM1qlFSWUflYuCQilE6uXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648083; c=relaxed/simple;
	bh=Mc3ZnHf9K5ZMTTUu0KsABqwagJTKfA2uG+m7nxHKR+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7o4xkHcilgftO0mWNksaOxzYAj+W6HI9X5iqM4aHB7pMXsn7HTPw/4MI+FeWsLNhu3yWBW2TdtTrv4GIESYtrZQO3LAPEwnbYgQwXexCXYqs1jFeImrLytCbCmoaidsJYeY9/9u5zHeuwr8RELodzi+t3asKeO3l1oO2ajSRtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hmf+AMyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hmf+AMyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31F81F000E9;
	Tue, 21 Jul 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648081;
	bh=fBB4gIhLM7cKa+RypC2i5cCUJao6N4RxnQmDYJb7qwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hmf+AMypKnr/nj3T8Gz6ThL4VG0a5iSSFKBtkiBCBX8YwkUxql0+sgMj83DypOMu5
	 4N5VcHB8vdLSkXphMRJV00TKcZrk4QjDa02GZXqA3/VOtETSXdvC/mCSxaaacKBXl4
	 CJQXXdfx8WBVlV45QwNhor6eqE+N6eqfdIPkmrhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Li Daming <d4n.for.sec@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0038/2077] afs: Fix uncancelled rxrpc OOB message handler
Date: Tue, 21 Jul 2026 16:55:11 +0200
Message-ID: <20260721152553.587677298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit a4057e58b07005d0fe0491bdbf1868c1491909ee upstream.

Fix AFS to cancel its OOB message processing (typically to respond to
security challenges).  Also move OOB message processing to afs_wq so that
it's also waited for and make the OOB handler just return if the net
namespace is no longer live.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260609140911.838677-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Li Daming <d4n.for.sec@gmail.com>
cc: Ren Wei <n05ec@lzu.edu.cn>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-6-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/cm_security.c |    3 ++-
 fs/afs/rxrpc.c       |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/fs/afs/cm_security.c
+++ b/fs/afs/cm_security.c
@@ -101,7 +101,8 @@ void afs_process_oob_queue(struct work_s
 	struct sk_buff *oob;
 	enum rxrpc_oob_type type;
 
-	while ((oob = rxrpc_kernel_dequeue_oob(net->socket, &type))) {
+	while (READ_ONCE(net->live) &&
+	       (oob = rxrpc_kernel_dequeue_oob(net->socket, &type))) {
 		switch (type) {
 		case RXRPC_OOB_CHALLENGE:
 			afs_respond_to_challenge(oob);
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -128,6 +128,7 @@ void afs_close_socket(struct afs_net *ne
 	_enter("");
 
 	cancel_work_sync(&net->charge_preallocation_work);
+	cancel_work_sync(&net->rx_oob_work);
 	/* Future work items should now see ->live is false. */
 
 	kernel_listen(net->socket, 0);
@@ -148,6 +149,7 @@ void afs_close_socket(struct afs_net *ne
 
 	kernel_sock_shutdown(net->socket, SHUT_RDWR);
 	flush_workqueue(afs_async_calls);
+	cancel_work_sync(&net->rx_oob_work);
 	net->socket->sk->sk_user_data = NULL;
 	sock_release(net->socket);
 	key_put(net->fs_cm_token_key);
@@ -989,5 +991,6 @@ static void afs_rx_notify_oob(struct soc
 {
 	struct afs_net *net = sk->sk_user_data;
 
-	schedule_work(&net->rx_oob_work);
+	if (READ_ONCE(net->live))
+		queue_work(afs_wq, &net->rx_oob_work);
 }


