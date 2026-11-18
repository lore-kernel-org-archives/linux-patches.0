Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033194;
	b=yZmS5xfhcwZ0k0XmLUP0RoHUXBgJio9usdvfPortM5eZrywEItQZIFnrp4En4hPqvKYh
	 2UXSzOr0gXvqfbEZ6sEhAV3VFnj7eMwRhSEsnszkTR53OrJt8E8JXgzmUtWJOQcpzuj8w
	 m0Z2xDWZ+bUpqBEkWbqd6kxX6hEBEboGzhIFBuOA/EaAfY/fr+aXTqnPY2LXjdacAsq9d
	 xD9INHot4KnQHKCBk5HkldRY19y2Qyb2jG0DqP7CJ8QwBvPyZ0bUNQcHvRGkSe5xOTDXy
	 CYnLTsGhBYlfi6aqTeu6n+ZlpATgnZuSb0ygdgA9RUc6yjjFj4eXhbp9onw8fwCUgdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C0A8XTNMfdzKsEMSKJ+/CDFza2nfyw3ETveURuyOC8E=;
	b=aSeOvGSwyk7WoVxoe8bHJ1onhIMJQrvqbAYefeTYR/e/Vtapo9ZvsPzU7Yy8hT56Cgp3
	 leyt+5G9Wy4Ju2FWCElAiRyT9PbBlbIai24X0LGegbh5PRJhLksBARexqOdapNJzi8wv2
	 s0BukOrAkintuvDd0td4xZ/4AFpE+9cW3XkWzCOSJ78Wsw4NGJqV4EQpIL6a9NaoAq5AL
	 h8MZLzI/eBGtxggdJ5RqcOsunU6nCWhKq3e9GrMK5uuhow3c8WhuvSyoJHf+m7DWq2P8F
	 2IHQsOl9igyp+0P3MxJNoct9VIQwGBEQDtRBxRgolwjJgEpp237+2Tt9bQL1NxW983A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmmwufEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81671606A338;
	Wed, 18 Nov 2026 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tmmwufEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C85B1F000C4;
	Wed, 18 Nov 2026 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033194;
	bh=C0A8XTNMfdzKsEMSKJ+/CDFza2nfyw3ETveURuyOC8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmmwufEmpDW57rRBDGmPCGi9LBoXNYLLRiK5jwHHUYzzmxXbLfpgHawp9CfK2tJeN
	 83ofePakj+AR3s8G60PT7pAZYskjuOD2MHuBESulHi1LLRwNimA78F7UmgeXT1elr7
	 U3dvxtJWiyzXvr8DI6dqLXtSvu0W5BeWdyelmNqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1680/1756] block/rnbd-srv: drop the sess_dev kobject unlocked
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150116.581377838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 33d5d1738be5a..9d00c42f2624c 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -193,6 +193,10 @@ static const struct kobj_type rnbd_srv_sess_dev_ktype = {
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
index 441a6512616a6..8895862f55839 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -589,6 +589,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 		return sdev;
 
 	kref_init(&sdev->kref);
+	INIT_LIST_HEAD(&sdev->dev_list);
 
 	strscpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
 
@@ -787,7 +788,12 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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



