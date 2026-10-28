Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213928;
	b=Y0/hSL5fT+nHxqE2b8ews6XCcVIgpqSOeNW1RCe0HkEXaP1NeBumWPLUTwkFRAfTUUry
	 UkDh6ufeaKbjHEz8661soYkj9JZ1WI1vuyHrB6vOv6yznxx7Un7EfXR6PzmYp0IcDQwPL
	 87lTBWYwbMt9p4TWgNv8hgDZizmUtwAs32EAarL6uoxZmBSjwUK1LK67oHrIO9RrPAJIV
	 5KEuYgA3EmnkljvAtPsVr9x1f/hFCzN5mB/Rc/Sv3oMNVig5T+r0y394I8EXtZfJq39yl
	 J5nVWtIYjlXjfGpemtUwyVqxftIGz9gMI/Yurd1t9r3kClj9UZmZNTNVTysMttJildw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T1IjRyUtizqlaczNpEsHHETjxSA3EYznVzEKsBTewIU=;
	b=zCksuAPd/54JlmmGgfY7qV5Fhx8kPnxrFp0C4NMl98yyhqpdBIwLpNzmmqvBFfl31LR7
	 AZ4/6fgRan75LvWhZn+NZNSrQFEoOVI0y3nxf4ru7M2Tj4yey5K0TlbJ1ldHnDb65mrbs
	 1Gaf2VtYQAWkBFQ/8JR3xOrsLs+05LuZVhjz2E4XVwjl89/YNcXARw2BrWo3zTFl3RRz+
	 9WsXL3fs2Cd2cEiErxh+DYsywWgBHgkBkq7v0o1sOgXUWIgUEAUgeC4dyaYg/kyatbUp6
	 902Ukw4ojilJx5onjymPkAvyCzyyUzaIGbbM6i3k2efAR76HifSeZqMMr9cAq6pJK1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMiHqUyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B01D606A31E;
	Wed, 28 Oct 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMiHqUyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE641F01825;
	Wed, 28 Oct 2026 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213928;
	bh=T1IjRyUtizqlaczNpEsHHETjxSA3EYznVzEKsBTewIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMiHqUyRpJcc2klGAID12TL3/tKdc1Jy61oT/mXkYaelDB7D1lXxCjMKONKJe75Rd
	 LfNej8TPvXrBEgDBnj4ZNihSp64GrabN4XEQ9RJ1Df0T9WztbkvKAU7YxOUQTvGTGj
	 /nJmzI5zipW8+WTqgs6MBGUCQkDq0nhjLdPSGzs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0680/1887] ksmbd: check outstanding simultaneous SMB operations
Date: Wed, 28 Oct 2026 17:46:16 +0100
Message-ID: <20261028170514.886620743@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 0a77d947f599b1f39065015bec99390d0c0022ee ]

If Client send simultaneous SMB operations to ksmbd, It exhausts too much
memory through the "ksmbd_work_cache”. It will cause OOM issue.
ksmbd has a credit mechanism but it can't handle this problem. This patch
add the check if it exceeds max credits to prevent this problem by assuming
that one smb request consumes at least one credit.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c |  1 +
 fs/smb/server/connection.h |  1 +
 fs/smb/server/server.c     | 16 ++++++++++------
 fs/smb/server/smb_common.c | 10 +++++++---
 fs/smb/server/smb_common.h |  2 +-
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 0d27651aa4cc5..d99e1343955a3 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -115,6 +115,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	atomic_set(&conn->refcnt, 1);
+	atomic_set(&conn->mux_smb_requests, 0);
 	conn->total_credits = 1;
 	conn->outstanding_credits = 0;
 
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index d01f137223b42..a38e264889eea 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -113,6 +113,7 @@ struct ksmbd_conn {
 	__le16				signing_algorithm;
 	bool				binding;
 	atomic_t			refcnt;
+	atomic_t			mux_smb_requests;
 };
 
 struct ksmbd_conn_ops {
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index a5e9bb40e2191..a61488b6b5904 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -290,6 +290,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
+	atomic_dec(&conn->mux_smb_requests);
 	/*
 	 * Checking waitqueue to dropping pending requests on
 	 * disconnection. waitqueue_active is safe because it
@@ -311,6 +312,15 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	struct ksmbd_work *work;
 	int err;
 
+	err = ksmbd_init_smb_server(conn);
+	if (err)
+		return 0;
+
+	if (atomic_inc_return(&conn->mux_smb_requests) >= conn->vals->max_credits) {
+		atomic_dec_return(&conn->mux_smb_requests);
+		return -ENOSPC;
+	}
+
 	work = ksmbd_alloc_work_struct();
 	if (!work) {
 		pr_err("allocation for work failed\n");
@@ -321,12 +331,6 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	work->request_buf = conn->request_buf;
 	conn->request_buf = NULL;
 
-	err = ksmbd_init_smb_server(work);
-	if (err) {
-		ksmbd_free_work_struct(work);
-		return 0;
-	}
-
 	ksmbd_conn_enqueue_request(work);
 	atomic_inc(&conn->r_count);
 	/* update activity on connection */
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index bcecbd67189ad..0350697c9093b 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -388,6 +388,10 @@ static struct smb_version_ops smb1_server_ops = {
 	.set_rsp_status = set_smb1_rsp_status,
 };
 
+static struct smb_version_values smb1_server_values = {
+	.max_credits = SMB2_MAX_CREDITS,
+};
+
 static int smb1_negotiate(struct ksmbd_work *work)
 {
 	return ksmbd_smb_negotiate_common(work, SMB_COM_NEGOTIATE);
@@ -399,18 +403,18 @@ static struct smb_version_cmds smb1_server_cmds[1] = {
 
 static int init_smb1_server(struct ksmbd_conn *conn)
 {
+	conn->vals = &smb1_server_values;
 	conn->ops = &smb1_server_ops;
 	conn->cmds = smb1_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb1_server_cmds);
 	return 0;
 }
 
-int ksmbd_init_smb_server(struct ksmbd_work *work)
+int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 {
-	struct ksmbd_conn *conn = work->conn;
 	__le32 proto;
 
-	proto = *(__le32 *)((struct smb_hdr *)work->request_buf)->Protocol;
+	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
 	if (conn->need_neg == false) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index d4291834b04f1..75de404a9efcc 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -391,7 +391,7 @@ bool ksmbd_smb_request(struct ksmbd_conn *conn);
 
 int ksmbd_lookup_dialect_by_id(__le16 *cli_dialects, __le16 dialects_count);
 
-int ksmbd_init_smb_server(struct ksmbd_work *work);
+int ksmbd_init_smb_server(struct ksmbd_conn *conn);
 
 struct ksmbd_kstat;
 int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work,
-- 
2.53.0



