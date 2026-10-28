Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214151;
	b=h6gWgmKDDaHOsRm/CqPBJ/Gdh2qgib1LnrEu8rklA7skGwNKPKlwotKw/HaapINS5EkO
	 Pw36ER02hjs1SdVe5qIXEaRuVp7JJDMrKFO2MRfsCXo+sAt+hBNa8yUSFMpvlJxguaZZP
	 A/S/EzbksqyjriYtuzOp4lLQttiT94woS3QLnYt/BIfvjVmXR+W2R2avxmh1hyKSFB+9D
	 CP0iE7t1wYbNXstNh8ViimvN2KhciWY4Wm/A6GaUA8nqUk388vIeauz4p2OxGiSWZ+EKr
	 WTSkUC5rsAx9JAyWpLh2PnTBunI+wBp6jJR2XNZ7S54DAGjwuInGioWi9egL/sIZ3QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EEhBdsMviUUfU/yH8Bp+sdIuLi/hzQ2me7/15xN5K28=;
	b=Ksn3a9LEBtOv4rKpuWJ9vIJvcSAguHxW+7eycsokmFqSINuDUCaV5sNWts3U6iiC/hae
	 /MCb+8KUxw72CAsHzWoxAUTtIgsK7YbhKQ8NUaL5687q2yzLWvkTxgyo6wCbleKUpqvm2
	 4wo8G12km3tcMihjE/R40foJ5/ral/oIFWUGLL7E4QObNiUqdHmaCFZxsmmiKNEC7KIym
	 nV8ykHFTx4UWstae6s5EtqOm3kBg/VEFzkiZW8dZzCq+y0Wb3oyCqGFhZsglL2Wi+plrT
	 s3f8BA3QXc+t9AIxBmIQEnil23o0haROqYAOHoqYwZPsfiDYVAMtLfs+jinMTz6DDMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpKlB7kY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615F3606A31A;
	Wed, 28 Oct 2026 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpKlB7kY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD361F01825;
	Wed, 28 Oct 2026 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214150;
	bh=EEhBdsMviUUfU/yH8Bp+sdIuLi/hzQ2me7/15xN5K28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpKlB7kY/v3j7k2Gr48m6m+z6Lxj3qaKNGu1tyYeTTXaPCy6fpHQndX2jKYY3WnxJ
	 AuU3hnaJti8XEB7qHdtnb4+KfVHDZ2AFaAA4LQEKplaRA4lTd8GLS48dhoBJulDyl7
	 hDAaFjdjLwE/DQoDEoPsq25mkdegkzaTnylWiLYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0755/1887] ksmbd: fix use-after-free in ksmbd_free_work_struct
Date: Wed, 28 Oct 2026 17:47:31 +0100
Message-ID: <20261028170516.624508509@linuxfoundation.org>
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

[ Upstream commit bb39ed47065455604729404729d9116868638d31 ]

->interim_entry of ksmbd_work could be deleted after oplock is freed.
We don't need to manage it with linked list. The interim request could be
immediately sent whenever a oplock break wait is needed.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c |  3 ---
 fs/smb/server/ksmbd_work.h |  1 -
 fs/smb/server/oplock.c     | 37 +++++++++++++++----------------------
 fs/smb/server/oplock.h     |  1 -
 4 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index d7c676c151e20..544d8ccd29b0a 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -26,7 +26,6 @@ struct ksmbd_work *ksmbd_alloc_work_struct(void)
 		INIT_LIST_HEAD(&work->request_entry);
 		INIT_LIST_HEAD(&work->async_request_entry);
 		INIT_LIST_HEAD(&work->fp_entry);
-		INIT_LIST_HEAD(&work->interim_entry);
 		INIT_LIST_HEAD(&work->aux_read_list);
 		work->iov_alloc_cnt = 4;
 		work->iov = kcalloc(work->iov_alloc_cnt, sizeof(struct kvec),
@@ -56,8 +55,6 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 	kfree(work->tr_buf);
 	kvfree(work->request_buf);
 	kfree(work->iov);
-	if (!list_empty(&work->interim_entry))
-		list_del(&work->interim_entry);
 
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 9c3f834901e13..6372ba368e14a 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -96,7 +96,6 @@ struct ksmbd_work {
 	/* List head at conn->async_requests */
 	struct list_head                async_request_entry;
 	struct list_head                fp_entry;
-	struct list_head                interim_entry;
 };
 
 /**
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 31f84f59e40a7..58f351be5d905 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -45,7 +45,6 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	opinfo->fid = id;
 	opinfo->Tid = Tid;
 	INIT_LIST_HEAD(&opinfo->op_entry);
-	INIT_LIST_HEAD(&opinfo->interim_list);
 	init_waitqueue_head(&opinfo->oplock_q);
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
@@ -830,7 +829,6 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 static int smb2_lease_break_noti(struct oplock_info *opinfo)
 {
 	struct ksmbd_conn *conn = opinfo->conn;
-	struct list_head *tmp, *t;
 	struct ksmbd_work *work;
 	struct lease_break_info *br_info;
 	struct lease *lease = opinfo->o_lease;
@@ -858,16 +856,6 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
-		list_for_each_safe(tmp, t, &opinfo->interim_list) {
-			struct ksmbd_work *in_work;
-
-			in_work = list_entry(tmp, struct ksmbd_work,
-					     interim_entry);
-			setup_async_work(in_work, NULL, NULL);
-			smb2_send_interim_resp(in_work, STATUS_PENDING);
-			list_del_init(&in_work->interim_entry);
-			release_async_work(in_work);
-		}
 		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
@@ -899,7 +887,8 @@ static void wait_lease_breaking(struct oplock_info *opinfo)
 	}
 }
 
-static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
+static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
+			struct ksmbd_work *in_work)
 {
 	int err = 0;
 
@@ -942,9 +931,15 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level)
 		}
 
 		if (lease->state & (SMB2_LEASE_WRITE_CACHING_LE |
-				SMB2_LEASE_HANDLE_CACHING_LE))
+				SMB2_LEASE_HANDLE_CACHING_LE)) {
+			if (in_work) {
+				setup_async_work(in_work, NULL, NULL);
+				smb2_send_interim_resp(in_work, STATUS_PENDING);
+				release_async_work(in_work);
+			}
+
 			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
-		else
+		} else
 			atomic_dec(&brk_opinfo->breaking_cnt);
 	} else {
 		err = oplock_break_pending(brk_opinfo, req_op_level);
@@ -1151,7 +1146,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			}
 
 			read_unlock(&p_ci->m_lock);
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_conn_put(opinfo);
 			read_lock(&p_ci->m_lock);
 		}
@@ -1192,7 +1187,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 				continue;
 			}
 			read_unlock(&p_ci->m_lock);
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_conn_put(opinfo);
 			read_lock(&p_ci->m_lock);
 		}
@@ -1293,8 +1288,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		goto op_break_not_needed;
 	}
 
-	list_add(&work->interim_entry, &prev_opinfo->interim_list);
-	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II);
+	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_conn_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -1363,8 +1357,7 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
-	list_add(&work->interim_entry, &brk_opinfo->interim_list);
-	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II);
+	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
 	opinfo_conn_put(brk_opinfo);
 }
 
@@ -1427,7 +1420,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE);
+		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
 next:
 		opinfo_conn_put(brk_op);
 		rcu_read_lock();
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 0e2b1d63ca26b..1890e7f82427e 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -74,7 +74,6 @@ struct oplock_info {
 	bool			is_lease;
 	bool			open_trunc;	/* truncate on open */
 	struct lease		*o_lease;
-	struct list_head        interim_list;
 	struct list_head        op_entry;
 	struct list_head        lease_entry;
 	wait_queue_head_t oplock_q; /* Other server threads */
-- 
2.53.0



