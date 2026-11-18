Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050720;
	b=y4B2T+mQTg4c6Q9ZClqR2eKE591Z3atxtDK3GfuefQ+NqdXh+uxROkBnA72I2cXF7qos
	 f6mp0EKqsnqKYxDRKroKR7Nt26wWnwnxpDXgw/zjN0xn8yXzOXp+C9rWtkvEcYxoMJH+Q
	 0Kk/wBUEO/RW5+Xz2rrYRvOH2XTc3CSAth1UYIEOwB0Gmtfjpr3bpSkl+2RymxkOWy79k
	 1MKpO1KPcJfGR+IWZuZjoqkun5NVYeWiAltXokaERdZvSPfi1DHiIdmNWFYAi09OqKcz1
	 XVd/ZGvZr1S13aA8/Ia+D57IWAfENBkzRw46wG1TUSllNryzioeqmoWjq6eQxtpFYTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bci27fR/d7rD2lCHSsY/9FIXKlx5+07+bbZj8hmCWWs=;
	b=ob8Uq+iDrjMHIi11rTSNhhUC/n5d0g2KfJboigpYS7UuAMgYT9uE3oHxeL5IN8Oasrf7
	 6QeB8tn3Pw+AzvBBY0YXuM5oa+C0cCbfHPlub9sskt2zS9Ubgn8kFoBj2vdL0jDd8ysO0
	 tEJ4m5QS36egT5x+pf8+E7A6bHwWBcBZg4q/PI04k2xKZdGA9cpuncdY05RCqKBPCMn3r
	 yUtqexsbuDGkSIhJJlDBrulSGJDtVQ3xpaN6SGLEDKXEVt4NaBRrO6XTI8wnolms7hJnn
	 Di5RErtk3by/NHZXHtszJd0CJpB9HC2vH3zEFe7CTq3G2Am5UDVRcf4Ew+QRyXsH0MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKNFm2KD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69957606A331;
	Thu, 19 Nov 2026 01:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKNFm2KD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4021F000C6;
	Thu, 19 Nov 2026 01:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050720;
	bh=Bci27fR/d7rD2lCHSsY/9FIXKlx5+07+bbZj8hmCWWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKNFm2KDVJo8IpAbbDHU7JOZgw7STNfsYizL1s9Q56l9WibhOG0XCJtn45CiaYTM2
	 Nz4cJMSxCuvr5d0LZuQEE5npEbu795kZiU0qSL0/s5AZZbuDWuzJccIyUQQH+Wp5p9
	 YWK4Cuu+o8oJXrC9IqE8ByR6dKWRgCN2/ytWIs7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2809/2857] block/rnbd-srv: rename one member in rnbd_srv_dev
Date: Wed, 18 Nov 2026 16:04:03 +0100
Message-ID: <20261118150342.744235082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 94e37655e7a53..7874d60e07bfb 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -180,7 +180,7 @@ static void destroy_device(struct kref *kref)
 
 	WARN_ONCE(!list_empty(&dev->sess_dev_list),
 		  "Device %s is being destroyed but still in use!\n",
-		  dev->id);
+		  dev->name);
 
 	spin_lock(&dev_lock);
 	list_del(&dev->list);
@@ -435,7 +435,7 @@ static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(struct block_device *bdev)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	snprintf(dev->id, sizeof(dev->id), "%pg", bdev);
+	snprintf(dev->name, sizeof(dev->name), "%pg", bdev);
 	kref_init(&dev->kref);
 	INIT_LIST_HEAD(&dev->sess_dev_list);
 	mutex_init(&dev->lock);
@@ -450,7 +450,7 @@ rnbd_srv_find_or_add_srv_dev(struct rnbd_srv_dev *new_dev)
 
 	spin_lock(&dev_lock);
 	list_for_each_entry(dev, &dev_list, list) {
-		if (!strncmp(dev->id, new_dev->id, sizeof(dev->id))) {
+		if (!strncmp(dev->name, new_dev->name, sizeof(dev->name))) {
 			if (!kref_get_unless_zero(&dev->kref))
 				/*
 				 * We lost the race, device is almost dead.
@@ -485,7 +485,7 @@ static int rnbd_srv_check_update_open_perm(struct rnbd_srv_dev *srv_dev,
 			ret = 0;
 		} else {
 			pr_err("Mapping device '%s' for session %s with RW permissions failed. Device already opened as 'RW' by %d client(s), access mode %s.\n",
-			       srv_dev->id, srv_sess->sessname,
+			       srv_dev->name, srv_sess->sessname,
 			       srv_dev->open_write_cnt,
 			       rnbd_access_mode_str(access_mode));
 		}
@@ -496,14 +496,14 @@ static int rnbd_srv_check_update_open_perm(struct rnbd_srv_dev *srv_dev,
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
 
@@ -788,7 +788,7 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	list_add(&srv_sess_dev->dev_list, &srv_dev->sess_dev_list);
 	mutex_unlock(&srv_dev->lock);
 
-	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->id);
+	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->name);
 
 	kfree(full_path);
 
diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
index f5962fd31d62e..6b5e5ade18ae0 100644
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



