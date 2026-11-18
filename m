Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056986;
	b=VxBVCU97N/CTLs2i8o7//qowXq+w+1Hk3umK2XmFLLZyZFEkvv/F+7XhmPGCUcJsbDB7
	 3Ngs7Kbb/fcUlD/k9+D0Jyz0uqnnM5dsFV2/d9nKGQVxTxKz0fGQZF8a8AsrUEPvRCYHr
	 fE9xmffJ3B5w1aoT5jo8u5I5FVWaU6wq/ZncDh+WaPKHXo3FQ3Dzk7SXztLJXFwqgWOaz
	 aybAmO5HqDFyjDOgAT0RBWRx6VQcqaCmF4BTF/WA6ovuTZK3Bp/XWKYU5kO/y8mdNJrsP
	 e1qwPvW5J+wVoRwNMWMXCG2dCfNnt0cbKYacoqOch0NX4LNXLf7FYF5Y2JNeFC+d8aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mnSh9YBlqPc3Fc8gCTylGM9axBCSuLDrNQ/xRdr4C7Y=;
	b=TG4i7ofY+AueTQkQEaF2CbdJ49akqezpG5auHEJ+TCcwBQc4QAYyFVdlBcn/75NPCgSM
	 9pS/dABeT5g4hPblnyenSMZzKU59lH7liAuW4A6Q/cBOs5/4EWZPT/PGqLuzH5B0ZTMgd
	 JWS/EgHGroNmhVad3QRk1L6o5Aujk9WQo/Cntui8aWRkxL9LuEEBCiCVOwKRiJbuDywUm
	 7KX7l1qwbIyaoOEujJHy9dFMsMdWm8H3+cjlTP53F8ckCjR4cHeau1+kVaW6IkJHZC7Oo
	 fDP8rur0fIhmZIGo/c3VWRjTITNW57GCiWjyZ4o2w7YzRIXthoTqGJ1d9FbEMDbn+jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsKDoBdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE9606A31C;
	Thu, 19 Nov 2026 02:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsKDoBdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3311F000C4;
	Thu, 19 Nov 2026 02:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056986;
	bh=mnSh9YBlqPc3Fc8gCTylGM9axBCSuLDrNQ/xRdr4C7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsKDoBdvPvGuboptzXV6eZOdLSdWKIvgMWVYBZTKpcf6oq4306IGLMdZTdr72e6P1
	 7xQpK3wBxe5SMoKu9H7aQWCl0xR5KJOQ3+2A+XWK1PQJicXgEP1DTp2nYLHHbWO3fT
	 hw8kBkI56DA0lnF2v/KyE4mZrjilg7r6yd79FBMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2184/2214] block/rnbd-srv: rename one member in rnbd_srv_dev
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150137.723469508@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 3ecdbf91513511fae49eb0cfa9f39f690eb4fe11 ]

It actually represents the name of rnbd_srv_dev.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20230524070026.2932-6-guoqing.jiang@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 08ebf69c78a0 ("rnbd-srv: publish the sess_dev at the end of OPEN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 14 +++++++-------
 drivers/block/rnbd/rnbd-srv.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index f0c0de92163ed..1ed87cdf71c83 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -185,7 +185,7 @@ static void destroy_device(struct kref *kref)
 
 	WARN_ONCE(!list_empty(&dev->sess_dev_list),
 		  "Device %s is being destroyed but still in use!\n",
-		  dev->id);
+		  dev->name);
 
 	spin_lock(&dev_lock);
 	list_del(&dev->list);
@@ -430,7 +430,7 @@ static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(struct block_device *bdev)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	snprintf(dev->id, sizeof(dev->id), "%pg", bdev);
+	snprintf(dev->name, sizeof(dev->name), "%pg", bdev);
 	kref_init(&dev->kref);
 	INIT_LIST_HEAD(&dev->sess_dev_list);
 	mutex_init(&dev->lock);
@@ -445,7 +445,7 @@ rnbd_srv_find_or_add_srv_dev(struct rnbd_srv_dev *new_dev)
 
 	spin_lock(&dev_lock);
 	list_for_each_entry(dev, &dev_list, list) {
-		if (!strncmp(dev->id, new_dev->id, sizeof(dev->id))) {
+		if (!strncmp(dev->name, new_dev->name, sizeof(dev->name))) {
 			if (!kref_get_unless_zero(&dev->kref))
 				/*
 				 * We lost the race, device is almost dead.
@@ -480,7 +480,7 @@ static int rnbd_srv_check_update_open_perm(struct rnbd_srv_dev *srv_dev,
 			ret = 0;
 		} else {
 			pr_err("Mapping device '%s' for session %s with RW permissions failed. Device already opened as 'RW' by %d client(s), access mode %s.\n",
-			       srv_dev->id, srv_sess->sessname,
+			       srv_dev->name, srv_sess->sessname,
 			       srv_dev->open_write_cnt,
 			       rnbd_access_mode_str(access_mode));
 		}
@@ -491,14 +491,14 @@ static int rnbd_srv_check_update_open_perm(struct rnbd_srv_dev *srv_dev,
 			ret = 0;
 		} else {
 			pr_err("Mapping device '%s' for session %s with migration permissions failed. Device already opened as 'RW' by %d client(s), access mode %s.\n",
-			       srv_dev->id, srv_sess->sessname,
+			       srv_dev->name, srv_sess->sessname,
 			       srv_dev->open_write_cnt,
 			       rnbd_access_mode_str(access_mode));
 		}
 		break;
 	default:
 		pr_err("Received mapping request for device '%s' on session %s with invalid access mode: %d\n",
-		       srv_dev->id, srv_sess->sessname, access_mode);
+		       srv_dev->name, srv_sess->sessname, access_mode);
 		ret = -EINVAL;
 	}
 
@@ -797,7 +797,7 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	list_add(&srv_sess_dev->dev_list, &srv_dev->sess_dev_list);
 	mutex_unlock(&srv_dev->lock);
 
-	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->id);
+	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->name);
 
 	kfree(full_path);
 
diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
index 84820077f5d84..34e3cf0073b58 100644
--- a/drivers/block/rnbd/rnbd-srv.h
+++ b/drivers/block/rnbd/rnbd-srv.h
@@ -35,7 +35,7 @@ struct rnbd_srv_dev {
 	struct kobject                  dev_kobj;
 	struct kobject                  *dev_sessions_kobj;
 	struct kref                     kref;
-	char				id[NAME_MAX];
+	char				name[NAME_MAX];
 	/* List of rnbd_srv_sess_dev structs */
 	struct list_head		sess_dev_list;
 	struct mutex			lock;
-- 
2.53.0



