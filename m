Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043552;
	b=Wa2mIUrj5z0htF/MUAFS/vnls5pWfbwCnvO/Ap1gYjiRkgw0EzVhCvrJnKqDXaUoVIWg
	 +jEU69HUMA7xsouAqeFSMTHkDoY5ruWwCYS3yAg97q8OUC2w2SCfCjzjdGILATgI4CWbT
	 HT1xtgCq7Sw52SsHOaw0BvyaDceTVc/U7/Fh/xEKnxVF+qdBWidm8ce1HrPEpe7+dZX3F
	 /FRNSHKZh37wUO4Fkdnptlz5wPXCuY1GBRz8WRYoodAUk4RXLjezNaVzT1+3zcVsitGbM
	 1nU02iHn5Xubz5M7iMi/iH0zq8+tfyK7Dd16UP7YmkbuDMhzqLufUslVE+gHAu3A3sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1mBlUVDIHjpbmVM8CdiLIa/+OPbw2xhCZDapU7Hw2s=;
	b=k588DTT48+T+1riEMb4o1fhXKMCCrvgYcx/yL5Tcg652UGDzokl+mCAPGSbh/J9esMSq
	 G/GzviaK6fBdf2b6NnAXJJWbEJYjW8uEou23ch1ji6CaImY7X9a3xlgm6fCtVaYwEv6Dh
	 1ewgBvKyaP9mJozsgU67iLfGWmIosC9YZZGDbbbPBEUwo11GPLpEzgMADMLR12cU1o1mO
	 fqa/rGPY0QY76w2ArX9bR0NLB6Rr4mBXecCmg19DKL/Dg3OpcR8pjjTZy9CJ3QCHQdPn1
	 A8Z52vNHv3yygQJEdpkuE5xrFBEdBGQXsag5hExP5fBsddFIHwV5M3Ot2QytK0xRAFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltQdWeWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F53B606A32C;
	Wed, 18 Nov 2026 23:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltQdWeWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF741F000C5;
	Wed, 18 Nov 2026 23:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043552;
	bh=q1mBlUVDIHjpbmVM8CdiLIa/+OPbw2xhCZDapU7Hw2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltQdWeWtVC7ih6Z+04qV27iIKcc2RTGlL3uDKLRt/CayAQ1eCwsew2PH7pPRa8d1G
	 EYFY/YWc5jrrTF9bvCznolw1lspRzauhddaQllcIDX/9uwCCGASdbLbmML3k1zDP4W
	 z2ikzdTrDOmz4/DPjzmZNiHKghQK6Xy60li+RgIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0251/2857] smb/server: cancel async requests when closing connection
Date: Wed, 18 Nov 2026 15:21:25 +0100
Message-ID: <20261118150210.478603719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f1184ee9b2242..168292f73a843 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -194,6 +194,26 @@ void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
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
@@ -426,6 +446,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 out:
 	ksmbd_conn_set_releasing(conn);
+	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
 
-- 
2.53.0



