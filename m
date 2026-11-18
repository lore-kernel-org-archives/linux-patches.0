Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054860;
	b=1r6FrIO7+DmwScmJUuiWwnj5zv3+IMjHEOOA58O+EFS6ojA6GFDCQW0TrqaypDDFwy/T
	 YRmDUE+EClTxs0ErZMUh1VTiTlFtLwdwduw9cfi5Q/0A/zpvZGO3mSdJsj/0KcSvZrMGm
	 o/U8dvXpwCzSlLy1R+L7NjTwbd6pfMlqJ7/foQu6qQq1ewcJW0ZIsITRj1amEAC0qfbAL
	 NW/JINZ+JHD/mbS34vYivCxB8D8SEDTn6ppz7/91fTYzd6tYRkpvZEJBO+KmVtrJOO8JX
	 ilsXALVDwbtcSjFrh50fkwuJMaX+lcB36hjDlVkrQnGZjyEj7Q3V0CZofYMTPdjR36g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ronz9CEIw/TUIdgv2JikvB2EZhreEuXr2xx34ZSZhkc=;
	b=yaYEHQScFCEXzmdjwLZjVItuqTP+cu5bNbrEnj3ssU+Vts6b9D5PdbymGgEPfgfs7Per
	 hAVaSTS4tej6YQ5BRjUmhfSKlLZQb6jpd/p+zH8C67eGR1aPvZsBXz1nKk1bpLMyjuT4h
	 RU40gLurvjocwL6qqp6RfeuOGlrbwy8teECkoEmiKKTaVXtmfcf4RzzAObNEFIuMcDC/r
	 mcIYriYKrRL7INK6vROMs3FOxQAWq7vIb13Z++NflZT9KQq+At1dFw/YGeLgoQyc7oBnQ
	 A5Dru8WcRPuX+0V0ZNvxoiBkj06RjSDvElpsTznKjNOy9kNQGNaU3rFQCTLZZHL2EJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M63eWxoU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9140606A31C;
	Thu, 19 Nov 2026 02:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M63eWxoU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466401F000C4;
	Thu, 19 Nov 2026 02:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054859;
	bh=Ronz9CEIw/TUIdgv2JikvB2EZhreEuXr2xx34ZSZhkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M63eWxoUSc8YF1EE1yCSsU0eb0FkjXcALuGBY3tu7ZmZgyrXpaE19RwrG9n/LlKe6
	 rnBnTXagbAaCpwC4tIipGzhBcKIYXIfFUMVqx6z0S8Pj7Txqm4m1ZOoDu4aD7j2hzt
	 XommVSxea2e0lcEpmk9y9Jq7MN9pzQ+gdz2gU03g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1374/2214] fs: dlm: let handle callback data as void
Date: Wed, 18 Nov 2026 15:50:50 +0100
Message-ID: <20261118150106.366958324@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 5c16febbc19bb463bfb8e80cb5b24ec6ff1a439f ]

This patch changes the dlm_lowcomms_new_msg() function pointer private data
from "struct mhandle *" to "void *" to provide different structures than
just "struct mhandle".

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Stable-dep-of: 7bf1aca6d626 ("dlm: validate lock modes in recovery messages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 19 +++++++++----------
 fs/dlm/lowcomms.h |  4 ++--
 fs/dlm/midcomms.c |  4 +++-
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 80aae70431fea..db689a2ecb905 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1200,8 +1200,7 @@ static struct writequeue_entry *new_writequeue_entry(struct connection *con,
 
 static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 					     gfp_t allocation, char **ppc,
-					     void (*cb)(struct dlm_mhandle *mh),
-					     struct dlm_mhandle *mh)
+					     void (*cb)(void *data), void *data)
 {
 	struct writequeue_entry *e;
 
@@ -1213,7 +1212,7 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 
 			*ppc = page_address(e->page) + e->end;
 			if (cb)
-				cb(mh);
+				cb(data);
 
 			e->end += len;
 			e->users++;
@@ -1235,7 +1234,7 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 
 	spin_lock(&con->writequeue_lock);
 	if (cb)
-		cb(mh);
+		cb(data);
 
 	list_add_tail(&e->list, &con->writequeue);
 	spin_unlock(&con->writequeue_lock);
@@ -1245,8 +1244,8 @@ static struct writequeue_entry *new_wq_entry(struct connection *con, int len,
 
 static struct dlm_msg *dlm_lowcomms_new_msg_con(struct connection *con, int len,
 						gfp_t allocation, char **ppc,
-						void (*cb)(struct dlm_mhandle *mh),
-						struct dlm_mhandle *mh)
+						void (*cb)(void *data),
+						void *data)
 {
 	struct writequeue_entry *e;
 	struct dlm_msg *msg;
@@ -1269,7 +1268,7 @@ static struct dlm_msg *dlm_lowcomms_new_msg_con(struct connection *con, int len,
 
 	kref_init(&msg->ref);
 
-	e = new_wq_entry(con, len, allocation, ppc, cb, mh);
+	e = new_wq_entry(con, len, allocation, ppc, cb, data);
 	if (!e) {
 		if (sleepable)
 			mutex_unlock(&con->wq_alloc);
@@ -1289,8 +1288,8 @@ static struct dlm_msg *dlm_lowcomms_new_msg_con(struct connection *con, int len,
 }
 
 struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
-				     char **ppc, void (*cb)(struct dlm_mhandle *mh),
-				     struct dlm_mhandle *mh)
+				     char **ppc, void (*cb)(void *data),
+				     void *data)
 {
 	struct connection *con;
 	struct dlm_msg *msg;
@@ -1311,7 +1310,7 @@ struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
 		return NULL;
 	}
 
-	msg = dlm_lowcomms_new_msg_con(con, len, allocation, ppc, cb, mh);
+	msg = dlm_lowcomms_new_msg_con(con, len, allocation, ppc, cb, data);
 	if (!msg) {
 		srcu_read_unlock(&connections_srcu, idx);
 		return NULL;
diff --git a/fs/dlm/lowcomms.h b/fs/dlm/lowcomms.h
index 26433632d1717..eced4ce57e98d 100644
--- a/fs/dlm/lowcomms.h
+++ b/fs/dlm/lowcomms.h
@@ -39,8 +39,8 @@ void dlm_lowcomms_init(void);
 void dlm_lowcomms_exit(void);
 int dlm_lowcomms_close(int nodeid);
 struct dlm_msg *dlm_lowcomms_new_msg(int nodeid, int len, gfp_t allocation,
-				     char **ppc, void (*cb)(struct dlm_mhandle *mh),
-				     struct dlm_mhandle *mh);
+				     char **ppc, void (*cb)(void *data),
+				     void *data);
 void dlm_lowcomms_commit_msg(struct dlm_msg *msg);
 void dlm_lowcomms_put_msg(struct dlm_msg *msg);
 int dlm_lowcomms_resend_msg(struct dlm_msg *msg);
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 3f32f860ee9a6..8e97da3555c57 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -1014,8 +1014,10 @@ static void dlm_fill_opts_header(struct dlm_opts *opts, uint16_t inner_len,
 	header_out(&opts->o_header);
 }
 
-static void midcomms_new_msg_cb(struct dlm_mhandle *mh)
+static void midcomms_new_msg_cb(void *data)
 {
+	struct dlm_mhandle *mh = data;
+
 	atomic_inc(&mh->node->send_queue_cnt);
 
 	spin_lock(&mh->node->send_queue_lock);
-- 
2.53.0



