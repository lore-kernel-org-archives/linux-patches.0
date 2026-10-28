Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210783;
	b=uA+f85cumAOVXDMin+zQhgs4S1w5RmZPn6W+E1XqCqs5XQX3geJwLNoIjGKJQJfG2sor
	 cO2jsY+YxNTBJVSI0bip8BU0FfLCh/uZGDFv4xxSabFTl8UOsRvcPfBejXFLAjI+r5n0n
	 N/4YS+K3pRnofvjs+6AVizPysuMhfjXHf5onyXwgzbwaguN7y1U8xnD8HSRM9Y8+h2y8k
	 zn6yDYnE6x6FuKw/qbVzPvCC3udRahIt9ao+JxXebgeBb8eY2fBxmLqFYukD2nL0zdJKk
	 AK93ynKIEqQmkb5voxVNg4rs3k0v/Gd1kKijnsRrKty2ph56jR9xegn1SxqzokszTCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sqyk2+yNiax6e9Eye+J6bXFKN8Te0An1M4fjXa7jVcI=;
	b=VhNuW0QzH0O9eqYgx+g8V64fsWm61hAUXSzOFFkYMP5myn0W+ljUC/fUET5rSLuAF2zE
	 LtReT4vDddX4QNVrbExQG4pNWyJd4uipsUIKtdLUEjMElsdwc0jBqhiGZ8sSRrx563gX6
	 ZXRCVExiORVmGAc3gM3tlMLCaFETRMbixgNBdNA53KRQnwU9flKyggkQNFajaVsLEQCKo
	 EQSdYEDANSbB6Qx5KdSoIAcOw1tdSs+9HDcp52HidFii6tYUPtNWR0B3gBcHVjR6O/i1U
	 EEwe2XYpaCG5nNi48V+njLJu66c65uoOd8s/aRugiPtV4u9cT6A3u9cH2/NW0od8cgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=milGoUPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C462606A31F;
	Wed, 28 Oct 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=milGoUPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D71A1F031E0;
	Wed, 28 Oct 2026 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210783;
	bh=sqyk2+yNiax6e9Eye+J6bXFKN8Te0An1M4fjXa7jVcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=milGoUPk7IQyxL4tD+oA8ZioZj+wauPKyV0csGqk89dLo+00zyrb80FwWI4fvFIi4
	 4fmimdMnT0LNb4W6vLxA0xqt3x4lLAkFOgTyK6jEX0fyxFLHi+U8Uk2GbQl+YCfNwg
	 3ZZmCcXrxg4nlJqDl+NwD/91XmRXkutsYOQPNMWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/571] rds_tcp: close NULL deref window in rds_tcp_set_callbacks
Date: Wed, 28 Oct 2026 17:54:54 +0100
Message-ID: <20261028170011.504717464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit d2bfdbb69cf87676981b1043010b6224d84c6d3a upstream.

rds_tcp_set_callbacks() links a new rds_tcp_connection onto
rds_tcp_tc_list under rds_tcp_tc_list_lock. It releases the
lock, then assigns tc->t_sock = sock outside the lock.

rds_tcp_tc_info() and rds6_tcp_tc_info() walk rds_tcp_tc_list
under the same lock. Both dereference tc->t_sock->sk without
a NULL check.

A reader can acquire rds_tcp_tc_list_lock between the writer's
spin_unlock and the t_sock store. It then sees a list entry
whose t_sock is NULL. The dereference of tc->t_sock->sk is a
NULL access.

Move tc->t_sock = sock inside rds_tcp_tc_list_lock, before
list_add_tail. A reader holding the lock then observes the
linkage and the t_sock store together.

The restore path is safe. rds_tcp_restore_callbacks() does
list_del_init inside the lock. The matching tc->t_sock = NULL
after unlink is harmless to readers holding the lock.

Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260512142807.1855619-1-maoyi.xie@ntu.edu.sg
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

[ achender: resolved context conflict; tc->t_rtn initialization is not
  present in this tree ]
Signed-off-by: Allison Henderson <achender@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index fba2c7a2210ba..f8bf7356f78dc 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -231,16 +231,19 @@ void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp)
 	rdsdebug("setting sock %p callbacks to tc %p\n", sock, tc);
 	write_lock_bh(&sock->sk->sk_callback_lock);
 
-	/* done under the callback_lock to serialize with write_space */
+	/* done under the callback_lock to serialize with write_space.
+	 * Set t_sock inside rds_tcp_tc_list_lock so readers walking
+	 * rds_tcp_tc_list under the same lock cannot observe an
+	 * entry whose t_sock is NULL.
+	 */
 	spin_lock(&rds_tcp_tc_list_lock);
+	tc->t_sock = sock;
 	list_add_tail(&tc->t_list_item, &rds_tcp_tc_list);
 	spin_unlock(&rds_tcp_tc_list_lock);
 
 	/* accepted sockets need our listen data ready undone */
 	if (sock->sk->sk_data_ready == rds_tcp_listen_data_ready)
 		sock->sk->sk_data_ready = sock->sk->sk_user_data;
-
-	tc->t_sock = sock;
 	tc->t_cpath = cp;
 	tc->t_orig_data_ready = sock->sk->sk_data_ready;
 	tc->t_orig_write_space = sock->sk->sk_write_space;
-- 
2.53.0



