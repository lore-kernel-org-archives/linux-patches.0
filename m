Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056983;
	b=Kun+CxdoD3zI0lUbxYA+8XttWx/4NmcC381zRb75fuzsKYP6exkDaqxsLSgm6ceCW02Y
	 qn/L+yod2QCCw1OHXBry16hFiq1x+gMuICFMHqg6m3HWd0Y4Nsq2irGfAuZbHZc6Y0Nfh
	 Se9UvXYvwEVG0QT7pZZTXwcKjTpOWqE3zwGXXWvrtcY2LOaaX2pZqdPpSmfurgU4Pjbw4
	 +OJoMrtNz4hOkU/94FlmH8oMRlbfgNCJwg8LXHD4gQm3eaVjGO15W84Gv3l5Yk17INrUG
	 GAapu9tgVfJzEwZ8w8yfMThD1MNOluOcVvQygIvmhO9c10Pj05NzFhZHwkEA/WhHQ1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ho7ApxqUpg0stT8spQkjpsRwkfIxgq7V3v8awR5Bx/M=;
	b=uyrNs9u7jNLzNXmmEGv3nRAlwXhEEFJboi1O0/SFijDM4TktcokOqIVf8i5yr9EfNYbU
	 +oEmhXNq3B4qf4zgW1n+qmAC9fXVqb0eZUxtIztZWYlze571w91vDknMa1VduNdu9GZJQ
	 pt93VkrX+Z4LVcLbY1K3stYqtnwoWR3V6N4TBsEAcXfBnrmV2yQyC6kew0xNQOa3dHsBJ
	 PnmMOCkhaKAy6Dx/yVrVUTjzWxX+L+j5PvZfYPKpyoJvwMkbChKhWGNKlddAaorzsVX0I
	 ZMF2+UFCwwjlJ+b8gEbqE32i9VDXqZrlxLSn0PCs7eIj/RJa0LmUzntkb/d/rdNuuJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCATsfAE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6049B606A320;
	Thu, 19 Nov 2026 02:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCATsfAE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA86C1F000C4;
	Thu, 19 Nov 2026 02:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056983;
	bh=Ho7ApxqUpg0stT8spQkjpsRwkfIxgq7V3v8awR5Bx/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCATsfAERPJUnffWfWiWbp5SGXenOsW6NDbs7aK+U2fzWuVzFxteKOdm58s3QnStq
	 ZAVWEqXe88f1raAD57tTRov3lvoRid6s6jdDdp4SzwDgOBQ1i/RmifB5GO2vrJMUtq
	 4wtSCZ5MBjcpyOjgY76bDS9Re+cUUkkHIMOjxdJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Aleksei Marov <aleksei.marov@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2183/2214] block/rnbd-srv: Replace sess_dev_list with index_idr
Date: Wed, 18 Nov 2026 16:04:19 +0100
Message-ID: <20261118150137.684719273@linuxfoundation.org>
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

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit ce11bdf946176d48c2c0d36b56f0bf368c177298 ]

The structure rnbd_srv_session maintains a list and an xarray of
rnbd_srv_dev. There is no need to keep both as one of them can serve the
purpose.

Since one of the places where the lookup of rnbd_srv_dev using
rnbd_srv_session is IO path, an xarray would serve us better than a list
traversal. Hence remove sess_dev_list from rnbd_srv_session, and replace
its uses from xarray.

Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Aleksei Marov <aleksei.marov@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20220707143122.460362-3-haris.iqbal@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 08ebf69c78a0 ("rnbd-srv: publish the sess_dev at the end of OPEN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 17 +++++++----------
 drivers/block/rnbd/rnbd-srv.h |  4 ----
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index cb0ad191e2561..f0c0de92163ed 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -228,7 +228,6 @@ void rnbd_destroy_sess_dev(struct rnbd_srv_sess_dev *sess_dev, bool keep_id)
 	wait_for_completion(&dc); /* wait for inflights to drop to zero */
 
 	rnbd_dev_close(sess_dev->rnbd_dev);
-	list_del(&sess_dev->sess_list);
 	mutex_lock(&sess_dev->dev->lock);
 	list_del(&sess_dev->dev_list);
 	if (sess_dev->open_flags & FMODE_WRITE)
@@ -243,14 +242,14 @@ void rnbd_destroy_sess_dev(struct rnbd_srv_sess_dev *sess_dev, bool keep_id)
 
 static void destroy_sess(struct rnbd_srv_session *srv_sess)
 {
-	struct rnbd_srv_sess_dev *sess_dev, *tmp;
+	struct rnbd_srv_sess_dev *sess_dev;
+	unsigned long index;
 
-	if (list_empty(&srv_sess->sess_dev_list))
+	if (xa_empty(&srv_sess->index_idr))
 		goto out;
 
 	mutex_lock(&srv_sess->lock);
-	list_for_each_entry_safe(sess_dev, tmp, &srv_sess->sess_dev_list,
-				 sess_list)
+	xa_for_each(&srv_sess->index_idr, index, sess_dev)
 		rnbd_srv_destroy_dev_session_sysfs(sess_dev);
 	mutex_unlock(&srv_sess->lock);
 
@@ -285,7 +284,6 @@ static int create_sess(struct rtrs_srv *rtrs)
 
 	srv_sess->queue_depth = rtrs_srv_get_queue_depth(rtrs);
 	xa_init_flags(&srv_sess->index_idr, XA_FLAGS_ALLOC);
-	INIT_LIST_HEAD(&srv_sess->sess_dev_list);
 	mutex_init(&srv_sess->lock);
 	mutex_lock(&sess_lock);
 	list_add(&srv_sess->list, &sess_list);
@@ -679,11 +677,12 @@ static struct rnbd_srv_sess_dev *
 find_srv_sess_dev(struct rnbd_srv_session *srv_sess, const char *dev_name)
 {
 	struct rnbd_srv_sess_dev *sess_dev;
+	unsigned long index;
 
-	if (list_empty(&srv_sess->sess_dev_list))
+	if (xa_empty(&srv_sess->index_idr))
 		return NULL;
 
-	list_for_each_entry(sess_dev, &srv_sess->sess_dev_list, sess_list)
+	xa_for_each(&srv_sess->index_idr, index, sess_dev)
 		if (!strcmp(sess_dev->pathname, dev_name))
 			return sess_dev;
 
@@ -798,8 +797,6 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	list_add(&srv_sess_dev->dev_list, &srv_dev->sess_dev_list);
 	mutex_unlock(&srv_dev->lock);
 
-	list_add(&srv_sess_dev->sess_list, &srv_sess->sess_dev_list);
-
 	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->id);
 
 	kfree(full_path);
diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
index 7cc3b299134e5..84820077f5d84 100644
--- a/drivers/block/rnbd/rnbd-srv.h
+++ b/drivers/block/rnbd/rnbd-srv.h
@@ -25,8 +25,6 @@ struct rnbd_srv_session {
 	int			queue_depth;
 
 	struct xarray		index_idr;
-	/* List of struct rnbd_srv_sess_dev */
-	struct list_head        sess_dev_list;
 	struct mutex		lock;
 	u8			ver;
 };
@@ -48,8 +46,6 @@ struct rnbd_srv_dev {
 struct rnbd_srv_sess_dev {
 	/* Entry inside rnbd_srv_dev struct */
 	struct list_head		dev_list;
-	/* Entry inside rnbd_srv_session struct */
-	struct list_head		sess_list;
 	struct rnbd_dev			*rnbd_dev;
 	struct rnbd_srv_session		*sess;
 	struct rnbd_srv_dev		*dev;
-- 
2.53.0



