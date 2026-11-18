Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051583;
	b=PCWpEweY66AXQilu9tQBaUnXPRvDdW0LB6w1ibZBakT7INZKQ/4Ss0I5uSrF9/srlcfu
	 LNYJrJFOqRUl2d9hM0IJRPeNpqfRFb3Ezzh95Vr1ToXu31k42w4GLRXJ244wyiRNSLI9I
	 dm790C4noNk4Geevs9lNuZSJ65swPA8QOvn5WV+2CQoxjgNIumkd704ft3tkp4lSf6N74
	 Eb8MJdo/1vuujhbcqHKuMDeKO8wXzPHGkySW1l8B89NUQpXenCFXnO0ISBE9NqdN/EmBY
	 e/IczmdWyu5J+HGbR/RjWL72ACA2MiZw45Mywv+h9gUs81KW7o1ZK6bIlqU+Bc3rmkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ukg3OuRTuq3mi2QGvVuOaJ0bkgAuFYMNn3PFRmurIDg=;
	b=sGU0o+25CaWQK/cVp/3e2DzJyGVrUD3QX+ijhvT9i6VuGWWwVcPP8Wi3plFGAKp//4qB
	 ZYogj0bk8fg6tZJfnrUn6dqICPf8XEz2n/OOCS7qVMH/jTeJn9ITcsMnWVmRTFO2aqXc7
	 bDDAMCXHFe2ZXOl/ADsWi0xjcHQAlKn1aqZDO6nJvzdaT7DkWu8xki4sPB/iL86DqiRQo
	 HH0eFtYj9DevjiPvHbjTSW1ZWYvXuMYtMcSPTshK+DY1oDxs6MQGqJHFKtKNxWi9f024q
	 ZsT5Xc0r+24RcyqM7c9jHEqrOmY6O6YZXgLx2lP3WI0I82aFvjup6FHjVuX94etQtmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIWlojAy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384E606A338;
	Thu, 19 Nov 2026 01:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIWlojAy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0271F000C8;
	Thu, 19 Nov 2026 01:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051583;
	bh=ukg3OuRTuq3mi2QGvVuOaJ0bkgAuFYMNn3PFRmurIDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIWlojAysYMZlBphFlWVBws9ExuCntAJ3GVDvBuAc/Fl7WpQDpezUYimuYlNNBi3s
	 vRKo9d/Sa7lqv4vbMoBhXC1MUyuE9N8sXYttn2Kwioiw4qVQ4U2sFT530mzA+n/I43
	 hPasZgyvg+GgMZxlGQhq5a1f/+wDyma+H3SHfwi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0213/2214] smb/server: cancel async requests when closing connection
Date: Wed, 18 Nov 2026 15:31:29 +0100
Message-ID: <20261118150018.697298743@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 4fd5bad647bfa45eb86bfd2f03ba1bef3fcd5851 ]

An async request may still be waiting when a connection is closed.
This can stop the connection from closing.

Cancel active async requests before waiting for them to finish.

Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index b0a47b7923d52..65dd05290c9ba 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -190,6 +190,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	wake_up_all(&conn->req_running_q);
 }
 
+static void ksmbd_conn_cancel_async_requests(struct ksmbd_conn *conn)
+{
+	struct ksmbd_work *work, *tmp;
+
+	ksmbd_debug(CONN, "Cancel pending async requests on releasing connection\n");
+	spin_lock(&conn->request_lock);
+	list_for_each_entry_safe(work, tmp, &conn->async_requests,
+				 async_request_entry) {
+		if (work->state != KSMBD_WORK_ACTIVE)
+			continue;
+
+		ksmbd_debug(CONN, "Cancel async request id %d\n",
+			    work->async_id);
+		work->state = KSMBD_WORK_CANCELLED;
+		if (work->cancel_fn)
+			work->cancel_fn(work->cancel_argv);
+	}
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_lock(struct ksmbd_conn *conn)
 {
 	mutex_lock(&conn->srv_mutex);
@@ -422,6 +442,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 out:
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
-- 
2.53.0



