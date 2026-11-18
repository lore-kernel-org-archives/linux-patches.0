Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034225;
	b=pbLIynYC/kzPM7A8dKab07M/oafWLspMTp2Kf2wvUfQgOOKMRRFBJqWZ7zWkcJS4yLSV
	 awY4G86sgYPbdIFwb+G3zpC18PWLpLftZkXBDcwcfL+NIaIF+i5tGF5ThX7VQydnkzSrf
	 Xm6NXGboTNvE8tXVcPjdOufvr2h1EUOGzogqD15y6pXkeKnYBDIPCKxfEJeFs2jJCQ/GO
	 haIbPt40lkpc7qMcA0FtxR81tuCsLvrKfIbFMDf1V+Csc9okh7hCbyMb7/A3zLR/w+4d8
	 PAWmEWM5UjuM32VWsb6iCHRsLlzy3puKQjVp3Sty8CHI7vXeTFVZaPE9mKbm5gK1jIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DJ2W+E7SDkzkG3NDNSpejGbTPHhPyM0UGPI86JeE3Ik=;
	b=Kl48LzmQf2pHVw5FDs8CWkJVwxwVN55PKEqGmCfltjuaID13dvALVV0bYM0pz2MLuMGm
	 PZrXuDc64nDqANpHgKwWqDnMjulRc8A9nid1VtzqjdJpOshHyZpWJ+ADavQMfu951X4h+
	 6HKzH0A2GDGzBuufOwU0dwlr3YUf0l8j232El3Yk5zyVwoQGFog+3iiA0061nP7ipg4z/
	 gdAXPIRWnCwsbvvM0jVNiKgedqT9JaANHtuFqfXMDRXnyEUFr2UzPt6THukSgB4BxeeRr
	 ovUaLSxALNsFhQsnH3marHYxHUGVPhiJuzli3TvHToxFJ2qEq7wqoa+AzD5LXert+WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaDhxzLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD212606A336;
	Wed, 18 Nov 2026 20:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaDhxzLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FCB1F000C4;
	Wed, 18 Nov 2026 20:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034225;
	bh=DJ2W+E7SDkzkG3NDNSpejGbTPHhPyM0UGPI86JeE3Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaDhxzLDUeA7pJIAJXRr1L/qJiCqS2EF2Ice1B+amjYMvtFfm7CY6nyUlYy0X0nV1
	 gqui4ML3t30IKEr0h8z0YPlT3Sm2paEzZG+Hgtg3OeLvUOQ/3HQChuFLMDWBi21zr7
	 gyLjjCT+c91XQHJgW333XG4wqG9rRL1Jaq0t8oMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0295/3318] smb/server: cancel async requests when closing connection
Date: Wed, 18 Nov 2026 15:15:17 +0100
Message-ID: <20261118150324.498225202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/connection.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 35971331a785d..ec265f12c4902 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -232,6 +232,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
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
@@ -543,6 +563,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 out:
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
-- 
2.53.0



