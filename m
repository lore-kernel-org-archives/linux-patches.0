Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214142;
	b=Ay/RcNZV7+O1ea89vMxSgUfToVlG2Q6qIM0zieF10msowwUl1+wRa1Zp70yWUwWArxI3
	 5Mk1vE4wkiYwnPpDe7hrK1OW8sJrkB+NxyZu/vsiYRpDBN7yhwnltl0lfQzkSW+X98D4d
	 Rr0/7Fcbo8oYy3qHwg8sSSocdBwmFvTa8HEMcZg9WZCGDcUIwCK12ybCaUIRa8XM5f9Dz
	 MZlN3KrZN+SKuZkFZ9Ze/fA/zkG8QUXlDJpiU8xEt6HfXdFhwUfCtNlGqYdZCVqFfISM/
	 53OzgxRLRcbtmMoip8BC2IBaVqTCDYsuQzspURgQBPsGmM4X37p9uoz0PoMFC1OPYTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mp36gDLN7CxFBFsdq+WklIvolfomSISsVBGOUwHjQtE=;
	b=f4nwPrfNH1sCdL5WAOg7NgbYO/KMLNssmbhsAvA3nDjnIsNv/04riTyODlTkque9TqHZ
	 GJVk2ciwDYb3kNr97X0+3a7IJHnHDIX52+F/JQKj6TClRIS2Rr6EjDHycycme/5OTLBd9
	 j4Ufgc8MY13+P4XYOfQP7v+GepbpkPRVTvbuQnEOaGGisvU34ocmyZVCdjsVkbOsLSld7
	 oToNx4J87gUitRNKBvg+9BpEfS47ov7Q8ph8tO54wg5EBAFXpQuAFt7xnigFWCfnqGyWe
	 0HCGI/lJWRlE+q2vdm36e8U7J1DEofZd21cGMCeQzX82odcrLvMi0lvXhvh1PxnNGKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lia+rgtn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C279D606A31C;
	Wed, 28 Oct 2026 19:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lia+rgtn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDDA1F01825;
	Wed, 28 Oct 2026 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214141;
	bh=mp36gDLN7CxFBFsdq+WklIvolfomSISsVBGOUwHjQtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lia+rgtnmTqFPpwB3sRGV+XbKRh+AEgjlfWWIERQJa3PAR6RTTuhx6se8GAy0OIrT
	 9t2Xqb1+IZAZcgE8CWYyAqZAqhnQnYEUC2nV7NkjIsSJtjKRJcm693Zc2pD8h1v1rz
	 XBQ+68LDHSokPJ0nZty90o2NkpiMAgo//FSpGV2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0753/1887] ksmbd: prevent connection release during oplock break notification
Date: Wed, 28 Oct 2026 17:47:29 +0100
Message-ID: <20261028170516.580185943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3aa660c059240e0c795217182cf7df32909dd917 ]

ksmbd_work could be freed when after connection release.
Increment r_count of ksmbd_conn to indicate that requests
are not finished yet and to not release the connection.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 19 +++++++++++++++++++
 fs/smb/server/connection.h |  2 ++
 fs/smb/server/oplock.c     |  6 ++++++
 fs/smb/server/server.c     | 10 ++--------
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index d99e1343955a3..a0c548447c2af 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -442,6 +442,25 @@ void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops)
 	default_conn_ops.terminate_fn = ops->terminate_fn;
 }
 
+void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn)
+{
+	atomic_inc(&conn->r_count);
+}
+
+void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn)
+{
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	atomic_inc(&conn->refcnt);
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
+
+	ksmbd_conn_put(conn);
+}
+
 int ksmbd_conn_transport_init(void)
 {
 	int ret;
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index a38e264889eea..2a6628bb312d9 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -176,6 +176,8 @@ int ksmbd_conn_transport_init(void);
 void ksmbd_conn_transport_destroy(void);
 void ksmbd_conn_lock(struct ksmbd_conn *conn);
 void ksmbd_conn_unlock(struct ksmbd_conn *conn);
+void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn);
+void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn);
 
 /*
  * WARNING
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 0b71399af50cc..31f84f59e40a7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -657,6 +657,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 {
 	struct smb2_oplock_break *rsp = NULL;
 	struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
+	struct ksmbd_conn *conn = work->conn;
 	struct oplock_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_file *fp;
@@ -712,6 +713,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 
 out:
 	ksmbd_free_work_struct(work);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -746,6 +748,7 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
+		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
@@ -767,6 +770,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 {
 	struct smb2_lease_break *rsp = NULL;
 	struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
+	struct ksmbd_conn *conn = work->conn;
 	struct lease_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 
@@ -813,6 +817,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 
 out:
 	ksmbd_free_work_struct(work);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -863,6 +868,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 			list_del_init(&in_work->interim_entry);
 			release_async_work(in_work);
 		}
+		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index a61488b6b5904..08fe608ac75a2 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -291,13 +291,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
 	atomic_dec(&conn->mux_smb_requests);
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -332,7 +326,7 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	conn->request_buf = NULL;
 
 	ksmbd_conn_enqueue_request(work);
-	atomic_inc(&conn->r_count);
+	ksmbd_conn_r_count_inc(conn);
 	/* update activity on connection */
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);
-- 
2.53.0



