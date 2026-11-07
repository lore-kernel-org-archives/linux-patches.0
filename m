Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061005;
	b=qjVSTokQPldhmlWLs8YIcn5dstWSmXIN1jcTQzj4PRik1RaLo3UT4nLuhq/ZZW6oVMsO
	 b2oCp1iyVh6RvopvklSbHYtavHlFIRgIEWld0oGgL/6LHIO/59C9XKoc3SBykXZMMPSBi
	 fGw1IT9wBRYCEeNfC4zrlrAcAfbZvKzZ9TVJf1Nv3IsmeLe4efGtJBvWaoX77SCprpShq
	 LJCygAF6ThiGDl1wkv74p4JaWCGOI+ufMQc6mFsnd3JpJspfzSQ/kMZeCrx+AZnHV3XKW
	 KdeLYNBnLW7GE5TQzvWrTuUoBt0INxh5A7RGu8GGdyVUcGKwhjMRpkc0guxlbwXq5eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xy4bvcGPmAlADOvFMrx2fjUEUPJOwwR/35BDNdTryhk=;
	b=STS+alqyQG5zi3oyMwIkJVDAe4OFl40bIYFcP6cGU3MqR9/f7psqQ6inDQFZCmp9bEKX
	 lrSH30W5kFSWBG1MoC4zE7L0WCBjnMfsor3OQ3NSm85dJipBATnbgv66Nf4wUGcctN9kM
	 fxVA+TKebPYMPO0zv0Xu0+UTfX0ldB7NAjsjib3J35jQT2JmVRGRCF4bY62ouhoEKgBMc
	 2EiygKBbbrjJrxyDUvRXOaO3k/wABGIDTafVgqlCb5UdPJxcw+LVMUwD/S4gRZ93FycMI
	 7dyO7MJyd43XjJVH1JvdgrsJW8RjSww0fpVCNhTceosZCfG8e+Z8dlo6jaKu7PUP6GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5liEGAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAA9606D80E;
	Sat,  7 Nov 2026 14:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5liEGAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029A91F008A5;
	Sat,  7 Nov 2026 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061005;
	bh=Xy4bvcGPmAlADOvFMrx2fjUEUPJOwwR/35BDNdTryhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5liEGAZpQcbxnhtG6LlZfPqH7aaf0/p6J2eXv/+TYxWnGLk8r+3v5ooI3bePAVFm
	 XjS1zns9uYLqnkjmlJzot/sbe9YSgobIcgQTWqzDWdb5pbo94fNZIvBh5xnAU9bqzK
	 5sB3DGB2wSZR5T4QfUQhjLBZLRdElmC1WDq7tfeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0349/1536] smb/server: cancel async requests when closing connection
Date: Sat,  7 Nov 2026 08:39:25 -0500
Message-ID: <20261107135007.477430471@linuxfoundation.org>
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
index 898e1832ce05a..d3dd89e612c6e 100644
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



