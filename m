Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033191;
	b=kTwNDjwT0N4z6lb6e0j2FqYAiuVUPcLfRR7cmv+KbQSOd8zCysw4zOp59TxhoBQ7t0by
	 obT4/kqKzn7WV/gpzuQUpQsXAgqwzwfBvMpmzSyDJxK1BwBEY0RNBAZKJQzDx/7kEyKde
	 hSdhfbUQuKWaIF+PNHAdg9yqCi3Rhf57qNgT80jdE80Lh9hB4N+p8Zdnly+Gz4PVTe7Cd
	 y0mKbWf5EJ1ZCg/3HjTktVa0/OFeFf4DtaMHUKB+DyHjJAecrodPhtbssxaVckvGjXgJY
	 ztQ2/PdsejrvDDFOLL3xk3gwUggPLhGzQWdUy7c/zjvlFWWSarTTm0JEDytf3+AR2nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8GAZGV1JqCPOWN3YC7NwWYmRyJIG6yPLcS1O//HLAks=;
	b=WADQqIy2jojX9aeBTuC4PPmB7dYpsUdHROALVqLqtNphunGXp4c+kW2QQjXaul++s4Nc
	 k6r0AEYHLYP7TOGbn8rw3ihYErsqtWycF0KkfuK2EQn6GJkkJXUv3Lps3/ibodg5LC3ny
	 Zz913Rqe8rpHgr+5R+JLK3Iu6hej6Xw4qVGLIhby58WiHwr6siZ3Rk6AJLk00vsPwfShT
	 2Xf5yGISr6ZOxIhgsRmlaQlBnn15YH5iFDRzay5CZqXuz7v2cFWNL2YuyoLUmUar9JdHn
	 m/VpJoVtY93HM6ex4prIFdZ2YCCumaJfZxOy+R6naFu/RpfgAFn2UHbGdd1yITKzeww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wk1RiRgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9345606A334;
	Wed, 18 Nov 2026 20:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wk1RiRgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CA61F000C4;
	Wed, 18 Nov 2026 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033191;
	bh=8GAZGV1JqCPOWN3YC7NwWYmRyJIG6yPLcS1O//HLAks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wk1RiRgTijz4sKWFJJeVa62gE5oKCrqu8wiGb7K3pfru6iFEzNj5bFbSGiQMa6Xxq
	 fltm8/CajQI7ZwJkoiSY0DIuSHnFHGfDZr53o7oyNtJsM5N+7iYAH6+nJwkgovlQEf
	 eq6Q+seHctj1Zv3RwjjXY8OfA4q1x69eu46iNWQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1679/1756] block/rnbd-srv: dont free the device on a sysfs error
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150116.544232701@linuxfoundation.org>
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

[ Upstream commit d9667ade40f986c565769a900ced6ee95edd33c6 ]

rnbd_srv_create_dev_sysfs() drops the only kobject reference on its
error paths, and the release function frees the rnbd_srv_dev.
process_msg_open() keeps using it and ends in destroy_device() with a
list_del() and a second kfree(). This doesn't need memory pressure: a
client opening a device while its last mapping goes away gets -EEXIST
from kobject_add() against the old directory.

Only undo kobject_add() on failure and leave the reference to
destroy_device(). Initialise the kobject once, the next open retries.

Fixes: 8cee532f469b ("block/rnbd: server: sysfs interface functions")
Fixes: d3a95ccaaf4d ("block/rnbd: call kobject_put in the failure path")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-17-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv-sysfs.c | 16 ++++++++++------
 drivers/block/rnbd/rnbd-srv.c       |  3 +++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv-sysfs.c b/drivers/block/rnbd/rnbd-srv-sysfs.c
index 64780094442ce..33d5d1738be5a 100644
--- a/drivers/block/rnbd/rnbd-srv-sysfs.c
+++ b/drivers/block/rnbd/rnbd-srv-sysfs.c
@@ -44,12 +44,17 @@ int rnbd_srv_create_dev_sysfs(struct rnbd_srv_dev *dev,
 	struct kobject *bdev_kobj;
 	int ret;
 
-	ret = kobject_init_and_add(&dev->dev_kobj, &dev_ktype,
-				   rnbd_devs_kobj, "%pg", bdev);
-	if (ret) {
-		kobject_put(&dev->dev_kobj);
+	/*
+	 * The release function frees the device, which the caller goes on
+	 * using and which others may share: never drop the reference of the
+	 * kobject here. That is for destroy_device().
+	 */
+	if (!dev->dev_kobj.state_initialized)
+		kobject_init(&dev->dev_kobj, &dev_ktype);
+
+	ret = kobject_add(&dev->dev_kobj, rnbd_devs_kobj, "%pg", bdev);
+	if (ret)
 		return ret;
-	}
 
 	dev->dev_sessions_kobj = kobject_create_and_add("sessions",
 							&dev->dev_kobj);
@@ -69,7 +74,6 @@ int rnbd_srv_create_dev_sysfs(struct rnbd_srv_dev *dev,
 	kobject_put(dev->dev_sessions_kobj);
 free_dev_kobj:
 	kobject_del(&dev->dev_kobj);
-	kobject_put(&dev->dev_kobj);
 	return ret;
 }
 
diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 0c7d40ed8d199..441a6512616a6 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -207,6 +207,9 @@ static void destroy_device(struct kref *kref)
 		 * Destroy kobj only if it was really created.
 		 */
 		rnbd_srv_destroy_dev_sysfs(dev);
+	else if (dev->dev_kobj.state_initialized)
+		/* The files could not be created. Frees the name, too. */
+		kobject_put(&dev->dev_kobj);
 	else
 		kfree(dev);
 }
-- 
2.53.0



