Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208642;
	b=dXevCw11plqoGxJKpt8P9rjuvKzTqq4K93ac2Ni6tMmtXvCvgGQs5YYvCEg0rUiHbFrR
	 5S3o+RBHniKluNTC1tbUsOc63eZXaGci9+LwrK3AP0Yd3dUH5YM6wSwzFNai0jTb2hGAg
	 tmKWFOUcue7o9u1P82ODkrAcfNPYK/mF2GfKCzKhNbf7giXxAOPoUTxqrQUT8Cv0mB/sZ
	 SU87hOYuP7cV/98rclSgh+WDqcyW+kGeWF1W6FgBZ9bOiUTEUfAGh+CsmInL/bG2esSI2
	 B0gMfbIL0RKrDnv3geAigX8MBkozdQ6C1Cz1XcSeZo7oZxIKN5nr/E+A41TWqqgbHDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DVErP2Hq6mJo+++riQFrtfE/mpH+Hq+zuHuTpQ9eOiU=;
	b=mNl7AInCX5QAMDz3k/MXQ9JkRcIMSq+lUbx0zDAD5BdwbdChRlx89gHLvK9zzJNf6ZRx
	 qxfYCVC6CfsPktbjunsghKjGMpqzFWX+emrRhn6OrGzHPpGk0kZZCfqFL6P40VuoDSpEK
	 dt29gVtgOrEcZ4CWgCHAgMMYb7krN+asDuQszpTIh2SffoWTg1ovpQSy5lgbyt/VGaMh4
	 x5oZZI4NCGiT5Df8vAzlR5YAjdWcHDlhR9TLq5NGTW+WzKGBMUU0kjEWNzmgGeROWRNfK
	 RO7kMLe4AwAaqixUuHmF58ymxOAGpmYbOSonrWp1cjVkwuz2y9b3tdR/q1y9h6CNZlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZ3MDQza;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A65606A31E;
	Wed, 28 Oct 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZ3MDQza
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634A31F01825;
	Wed, 28 Oct 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208641;
	bh=DVErP2Hq6mJo+++riQFrtfE/mpH+Hq+zuHuTpQ9eOiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZ3MDQzaPARGj8G7XoV46tEljPXJTXHeax/Pwz7e8sNKjlk9tb16DxwLYlrHVkA54
	 /eckECOeBGlKCC/pc3HyDTkvQvAkJAT8ZV9eWFL/M9f3tZPz0ZbtCM0fMNUrDy/6f6
	 DfLwmuSNCqY7iVqL/Tiw2fmDAqglcM2NmC+kgibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/516] rds_tcp: close NULL deref window in rds_tcp_set_callbacks
Date: Wed, 28 Oct 2026 17:55:00 +0100
Message-ID: <20261028170007.013623146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



