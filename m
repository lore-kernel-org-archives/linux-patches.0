Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042699;
	b=NGh8+vNdTjCHfSEjw2lv1tuBxEMZAmuIMze4Sdoa5eS3GNXg4K8iMliR8S6JUGYMBS30
	 PKFemUwHylcdVdjHU3WI6xOw3SQn1omv0Q/9e+cg7GN4eex7NldN3nVqxhtAW8JgB6QvD
	 7cZpkN5McrJp1fFgxHogMdDJC4sqmfu2BKxTQ8z+QawCb+vCN1w+8z1MsRk7vsdClwJE1
	 qbLRXyLN/oLLNlScXmHG367SRv6JxhjRbaZyLL9JcayGJEfHJncfzsIzNXkpREjfC4EJA
	 75PDo62BQxa8/cGT9+u/iSROYLSQ1qP/L7S63uYdb3UJ/RNNMF73BDZOGOQZqY7v7YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HyxuGyHkqKWfqkhy6rFJV7iPaEIDM3weyNAjPPZsxOY=;
	b=uz7OP/D/5LtbrHsFoaeWXVjCNfoBar8xVwC7HO6UF7kY5blp9yKffBCd6QWEiv4ugZGy
	 9A7xm9dGDvPYS7D38Ww5x++tsm+C+Ybiieq2how/g5dHRN4T/AhqDMe6BhDBXoletuC3B
	 pAgvtMJPshLKJy18kZ7eHQ68Fvz6Pl6r7T3eshJans2WnN2P+3FwgJGP5uTg3jQi8ccFX
	 wURmgWNXTPX72AjSHbhAWGmP0JV/ZEdibGnMnAoGX1MZfWHCBoyDvVWGfCi+1xptOCIjA
	 A0ofoudhQolcKX2JopYw+/Q2dfmpwTQpUkM8F76il9LYGCG/WV7PpECBpDwkz7xauCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIgF7e+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34EC606A320;
	Wed, 18 Nov 2026 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CIgF7e+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045FC1F000C5;
	Wed, 18 Nov 2026 22:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042699;
	bh=HyxuGyHkqKWfqkhy6rFJV7iPaEIDM3weyNAjPPZsxOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIgF7e+FkV+RlEPffL4ey5rcO5PgAl0dbYol1lYpy0y/ApV/gmGorl7HBxJNlp43Y
	 1+LFumb+A8lfiqpkt+eHJCp/LaABSAQDjSlB55Kpjr7XphpWMEeX/67+QghHJYGpVh
	 S4PnDElL5u47iACv9imJW2ArBuz8g28isJ556teI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3264/3318] block/rnbd-srv: drop the sess_dev kobject unlocked
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150457.540235415@linuxfoundation.org>
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
index ede36fa0da687..102b78d4f9fe4 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -193,6 +193,10 @@ static struct kobj_type rnbd_srv_sess_dev_ktype = {
 	.release	= rnbd_srv_sess_dev_release,
 };
 
+/*
+ * On failure the caller has to drop the reference of the kobject. The release
+ * function takes the lock of the device, which the caller holds here.
+ */
 int rnbd_srv_create_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev)
 {
 	int ret;
@@ -200,17 +204,13 @@ int rnbd_srv_create_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev)
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
index 50aa800231666..40968b8d8b85b 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -573,6 +573,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 		return sdev;
 
 	kref_init(&sdev->kref);
+	INIT_LIST_HEAD(&sdev->dev_list);
 
 	strscpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
 
@@ -770,7 +771,12 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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



