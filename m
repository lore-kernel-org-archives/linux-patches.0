Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056975;
	b=M3jDtYUaWjfv2AaeB9qfYy0DwyWSfUcoURoTS6OAMw8wVC7xDARcwgsZGAvrPw96OQu+
	 2vbhDcgv+eqy94euCudP795wYLvyGCiqZOOy4jGapnCUQm8ZhlnD/u5K99T2ARPCmf4tc
	 hSmQqagvVm5GMDl37AdG+neLTSt7tCu06yJqeElV65uRUkHkcBYS+XDECeYKU4FEX2/o+
	 qVLCsOW/1cWAaJ2RRr8bisLdk9Ki/Qnzo7U7IngY5dRuxKI8RfUjSvlMZC7IFmmvzKNsb
	 BW76TTQAfQuaB6PYw3f2pQNG5Nb+0A+/Q0ZcO3Fgo6h/L6D7wZT6U5iGESj01IOdm+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCS2JsNcDkHGaPD89N2qQq1qBhKpPwcH6NGOAeNKXb4=;
	b=eDGRyYdXdX9VdSyKwCaj2qYshO6RVDGMyQ1NsJ28PIoIJlqXzJ9nUSDmBSC8eA9DISZ7
	 jfTmjdytH0AlZ+y6Xksyu8qg5M0xfpyCJyCPGZeubSZSV/auFRdp1ytipnwLPJfpLaDVb
	 oMt3plcb+Rr4pq+1MAC9F6LZmdwF7UmlbgByQF/ql25XH9k6PtTFuSM/NgQKb20hAr66v
	 zP3fFOI9Mj2td7/+MVj8Ozq3gX4jM3AYvZSs9l4bZrfMrQpIhUwgDIraKtQ5DpNalDqq5
	 C0Mx6xGJmhUMaqcVL5iv+ndeFHVBBQCdJiZ4PSTkkE7HqA67Q61gYqL2qx/Xq7lofNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akb3+p3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10C606A320;
	Thu, 19 Nov 2026 02:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akb3+p3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E191F000C4;
	Thu, 19 Nov 2026 02:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056975;
	bh=FCS2JsNcDkHGaPD89N2qQq1qBhKpPwcH6NGOAeNKXb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akb3+p3WShxzzp12WlnfKHL7qRjFT84hC9THFbd/74/CKhX6QthPEb6hM9xjfFSTY
	 yMzAhzuIFWWbTRl/ztbar0/qDQO/SOTRXujU43h3mZGP6mrZ7CRt5AmIBiZ3vwiTvK
	 m8tIW/lDHVL0pNqrQAY7jshee+54m8Abrzjb32YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2180/2214] rnbd-srv: remove the name field from struct rnbd_dev
Date: Wed, 18 Nov 2026 16:04:16 +0100
Message-ID: <20261118150137.584247631@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6e880cf59932a14bca128fc8e8faae0554932942 ]

Just print the block device name directly using the %pg format specifier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220713055317.1888500-7-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d9667ade40f9 ("block/rnbd-srv: don't free the device on a sysfs error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv-dev.c   | 1 -
 drivers/block/rnbd/rnbd-srv-dev.h   | 1 -
 drivers/block/rnbd/rnbd-srv-sysfs.c | 5 ++---
 drivers/block/rnbd/rnbd-srv.c       | 9 ++++-----
 drivers/block/rnbd/rnbd-srv.h       | 3 +--
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv-dev.c b/drivers/block/rnbd/rnbd-srv-dev.c
index c5d0a03911659..c63017f6e4214 100644
--- a/drivers/block/rnbd/rnbd-srv-dev.c
+++ b/drivers/block/rnbd/rnbd-srv-dev.c
@@ -28,7 +28,6 @@ struct rnbd_dev *rnbd_dev_open(const char *path, fmode_t flags)
 		goto err;
 
 	dev->blk_open_flags = flags;
-	bdevname(dev->bdev, dev->name);
 
 	return dev;
 
diff --git a/drivers/block/rnbd/rnbd-srv-dev.h b/drivers/block/rnbd/rnbd-srv-dev.h
index 2c3df02b5e8ec..201a021246c2e 100644
--- a/drivers/block/rnbd/rnbd-srv-dev.h
+++ b/drivers/block/rnbd/rnbd-srv-dev.h
@@ -15,7 +15,6 @@
 struct rnbd_dev {
 	struct block_device	*bdev;
 	fmode_t			blk_open_flags;
-	char			name[BDEVNAME_SIZE];
 };
 
 /**
diff --git a/drivers/block/rnbd/rnbd-srv-sysfs.c b/drivers/block/rnbd/rnbd-srv-sysfs.c
index 4db98e0e76f0e..122fee8aedd8a 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -39,14 +39,13 @@ static struct kobj_type dev_ktype = {
 };
 
 int rnbd_srv_create_dev_sysfs(struct rnbd_srv_dev *dev,
-			       struct block_device *bdev,
-			       const char *dev_name)
+			       struct block_device *bdev)
 {
 	struct kobject *bdev_kobj;
 	int ret;
 
 	ret = kobject_init_and_add(&dev->dev_kobj, &dev_ktype,
-				   rnbd_devs_kobj, dev_name);
+				   rnbd_devs_kobj, "%pg", bdev);
 	if (ret) {
 		kobject_put(&dev->dev_kobj);
 		return ret;
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 4bd58aa0e283f..6e6423d8c149a 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -421,7 +421,7 @@ static struct rnbd_srv_sess_dev
 	return sess_dev;
 }
 
-static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(const char *id)
+static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(struct block_device *bdev)
 {
 	struct rnbd_srv_dev *dev;
 
@@ -429,7 +429,7 @@ static struct rnbd_srv_dev *rnbd_srv_init_srv_dev(const char *id)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	strscpy(dev->id, id, sizeof(dev->id));
+	snprintf(dev->id, sizeof(dev->id), "%pg", bdev);
 	kref_init(&dev->kref);
 	INIT_LIST_HEAD(&dev->sess_dev_list);
 	mutex_init(&dev->lock);
@@ -514,7 +514,7 @@ rnbd_srv_get_or_create_srv_dev(struct rnbd_dev *rnbd_dev,
 	int ret;
 	struct rnbd_srv_dev *new_dev, *dev;
 
-	new_dev = rnbd_srv_init_srv_dev(rnbd_dev->name);
+	new_dev = rnbd_srv_init_srv_dev(rnbd_dev->bdev);
 	if (IS_ERR(new_dev))
 		return new_dev;
 
@@ -767,8 +767,7 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	 */
 	mutex_lock(&srv_dev->lock);
 	if (!srv_dev->dev_kobj.state_in_sysfs) {
-		ret = rnbd_srv_create_dev_sysfs(srv_dev, rnbd_dev->bdev,
-						 rnbd_dev->name);
+		ret = rnbd_srv_create_dev_sysfs(srv_dev, rnbd_dev->bdev);
 		if (ret) {
 			mutex_unlock(&srv_dev->lock);
 			rnbd_srv_err(srv_sess_dev,
diff --git a/drivers/block/rnbd/rnbd-srv.h b/drivers/block/rnbd/rnbd-srv.h
index 05909a0d73f64..7cc3b299134e5 100644
--- a/drivers/block/rnbd/rnbd-srv.h
+++ b/drivers/block/rnbd/rnbd-srv.h
@@ -68,8 +68,7 @@ void rnbd_srv_sess_dev_force_close(struct rnbd_srv_sess_dev *sess_dev,
 /* rnbd-srv-sysfs.c */
 
 int rnbd_srv_create_dev_sysfs(struct rnbd_srv_dev *dev,
-			      struct block_device *bdev,
-			      const char *dir_name);
+			      struct block_device *bdev);
 void rnbd_srv_destroy_dev_sysfs(struct rnbd_srv_dev *dev);
 int rnbd_srv_create_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev);
 void rnbd_srv_destroy_dev_session_sysfs(struct rnbd_srv_sess_dev *sess_dev);
-- 
2.53.0



