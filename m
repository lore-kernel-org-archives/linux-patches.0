Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056980;
	b=rzaiZH1Mb9eHlNqdmiop2HYLh9fZ1xEEAO/aU9lgo2io98LKl0h4fun4mBLIxbip9Lkt
	 OuwEYREMYwRP3S3oW9l8pFAl06OyNNKi77x5uiw9U6OHRJ2+4YJF8BoyuNJiNg9tAkdGT
	 NBApWk3JuEdnGMViqDi4kFE0aSnLQ0N+aG4fpAPoupdezGavW9k44NNTAwxM3kv15hHV9
	 Z8kGTtRCWPLAdvDSwln5nusq+JqShf9VUIt7LiPfxMZJag/cOdTWR7puDioELUqjTc5UQ
	 82vN8YfuB49+D2G4ItQDyQSo3BDCT58OPeLR4F+6bPLXV4xWBeZwKOeXkVqP8v5VfIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHjsEoJAZ+mMNKx6DlZLqcvdcCZMPOUJRg3akkcXEhQ=;
	b=38MXzSy6LTFOksyauOxUocqsPlpzI2UVselGbj0JtPBZo3MZEy7G9TjGcJIMHBVDs8KV
	 3ACfvv53jVh3iTBlud4PDeON8aJeAbhS2CO71EyVq4EJl3VYJhTnIAtrNwx1RFunuTley
	 7CNMR7oxPY039w1HEl84B2yhvRWo9LcENVIXyYluS+gFYo6+NAf6ZJFx02CXAQB4zkXx3
	 ybaxrXdfo0VOmp6HCujN9Q3SmZ66kM/4x0KHPmb9o02f+bVEeN3BgFS1r7YdgFN8zQr5x
	 h3I5GgOIGKs0/Jia1jdl68DRalMVtY5LOgxlF/JeW9IykxZR5AFmKl3M3x92HD0NtrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3YJIF+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8A2606A31C;
	Thu, 19 Nov 2026 02:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3YJIF+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC6C1F000C4;
	Thu, 19 Nov 2026 02:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056980;
	bh=ZHjsEoJAZ+mMNKx6DlZLqcvdcCZMPOUJRg3akkcXEhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3YJIF+W2lISu2HeDLCZURu09dV6vsPxlpyNUrb5D6j+SvCVssGCnH5T+cb5L56NF
	 0KPDPDnVVzumfeIcUwc9k7b4Q1vBU6/TntT+WMQ+RDfJZNNUqyGV3AsppYT2eZ2TNb
	 lnfM0f90+mi+bRi5n71Plmyzn5kZsGzD+7SvYE0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2182/2214] block/rnbd-srv: drop the sess_dev kobject unlocked
Date: Wed, 18 Nov 2026 16:04:18 +0100
Message-ID: <20261118150137.653674759@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 81941915d53ef3384ab4e4b68e92673e66cf66d7 ]

rnbd_srv_create_dev_session_sysfs() drops the kobject reference when it
fails. The release function is rnbd_destroy_sess_dev(), which takes
srv_dev->lock, and the caller holds that lock: the worker deadlocks on
itself. A client opening one device as "ram0" and "./ram0" gets there
through -EEXIST from kobject_add().

Have process_msg_open() drop the reference after releasing the lock, and
leave the rest of the cleanup to the release function.

Fixes: 8cee532f469b ("block/rnbd: server: sysfs interface functions")
Fixes: d3a95ccaaf4d ("block/rnbd: call kobject_put in the failure path")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-18-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv-sysfs.c | 12 ++++++------
 drivers/block/rnbd/rnbd-srv.c       |  8 +++++++-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv-sysfs.c b/drivers/block/rnbd/rnbd-srv-sysfs.c
index e467bb63511ad..0408dde579a95 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -194,6 +194,10 @@ static struct kobj_type rnbd_srv_sess_dev_ktype = {
 	.release	= rnbd_srv_sess_dev_release,
 };
 
+/*
+ * On failure the caller has to drop the reference of the kobject. The release
+ * function takes the lock of the device, which the caller holds here.
+ */
 int rnbd_srv_create_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev)
 {
 	int ret;
@@ -201,17 +205,13 @@ int rnbd_srv_create_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev)
 	ret = kobject_init_and_add(&sess_dev->kobj, &rnbd_srv_sess_dev_ktype,
 				   sess_dev->dev->dev_sessions_kobj, "%s",
 				   sess_dev->sess->sessname);
-	if (ret) {
-		kobject_put(&sess_dev->kobj);
+	if (ret)
 		return ret;
-	}
 
 	ret = sysfs_create_group(&sess_dev->kobj,
 				 &rnbd_srv_default_dev_session_attr_group);
-	if (ret) {
+	if (ret)
 		kobject_del(&sess_dev->kobj);
-		kobject_put(&sess_dev->kobj);
-	}
 
 	return ret;
 }
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index ad9cf2ab14671..cb0ad191e2561 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -585,6 +585,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 		return sdev;
 
 	kref_init(&sdev->kref);
+	INIT_LIST_HEAD(&sdev->dev_list);
 
 	strscpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
 
@@ -786,7 +787,12 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 		rnbd_srv_err(srv_sess_dev,
 			      "Opening device failed, failed to create dev client sysfs files, err: %d\n",
 			      ret);
-		goto free_srv_sess_dev;
+		/*
+		 * rnbd_destroy_sess_dev() undoes everything down to the open
+		 * of the block device.
+		 */
+		kobject_put(&srv_sess_dev->kobj);
+		goto free_path;
 	}
 
 	list_add(&srv_sess_dev->dev_list, &srv_dev->sess_dev_list);
-- 
2.53.0



