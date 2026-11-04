Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830941;
	b=gU46wN9exwxNqxyTsoSpdhJzz3JPq5rxrMkKaVFdulEVKbnXHuyQ+z+mWYz+7c+eHrKs
	 WDAvVePevsPNDS8BZalrFfG5ByOJLBXcs8zxD26kv7FaeDl+UMk67LRw/1xHwn7Z5k96+
	 Jp1/2piWF+BFKNMVVMV0faT9fseFhslMndQ3p0IhGtv1uON3mPljUx/AwHI+roOjtEhGk
	 3eT6Ead4mhBsT1mPNQUCPDBUHhShWYmHl7ZWS/vl+x5j0gfoBl5iZeyFI3Dg4mCaKXx9S
	 OsMu6AsqzYoXWCeNZsjlhIx/+hAyniVhst9ea8Hp0+nS/yJ+k6PziPT/oNF34TwKIJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jOWSsvPaYeP5hlExvfMsJZW+ZOJKB3ZWDTUNI3rY8hM=;
	b=YWePIePCCSRaopBU45q69B9jnutMXNq8WFfhXC1mr/6zxf6Y4n5ClWb/NE8ZuzSCJxau
	 acwkyWDcniwB6q4Sns9PfzmKQzC0OIGcxNu1SzJHnlp+6sCa5xc2Z0WsfmDFesyka5awG
	 9/9fVGYIE2LlKgRr0RpvvoWpZqDB6VueRGXfBTHOnW+sqx+5Hf/WG1OyPK8YmFjrQRLOB
	 zvpkyo0EIAwkIgefBRXqL6HNyXAnspdFZfv0efamCcKAhRtuh5AWPj6SoOIT+bhAxSfBK
	 TsTuV4XU6762bplneBIJtbNSwq9LcwKbzM+FLyx7dAix6Xb4gqzJR/9RB72JuztYXnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awHPQPNX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823D8606A844;
	Wed,  4 Nov 2026 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awHPQPNX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBAF1F00919;
	Wed,  4 Nov 2026 22:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830941;
	bh=jOWSsvPaYeP5hlExvfMsJZW+ZOJKB3ZWDTUNI3rY8hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awHPQPNX8p0lSIsuDfUqe1KCHwSpcZIBpnuPL2yy5keyBOvMla01D4ADyLpY7Kdgi
	 0cqumJAWRgDqrIXLNiyNFFTVpuFKyqwiKmxiIYms5wjj+uJMpn1cXAeFF7cV7HoxA5
	 /YeK1tzv2dFQip1NUDT7TSwRM9/kGPuU+6GR1c1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0415/1005] smb/server: cancel async requests when closing connection
Date: Wed,  4 Nov 2026 16:02:28 -0500
Message-ID: <20261104211055.715059277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16fcedf45739f..8f1b70e39362e 100644
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
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
 	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
-- 
2.53.0



