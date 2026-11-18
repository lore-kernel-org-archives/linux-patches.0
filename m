Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028269;
	b=a4JtlLTBQM4/jeSs5gn1l4Vw+Ls2fpbu5OeNuwzV86LeoqqOnvdgDD0PpenljZiFcXAJ
	 lSOluHvKzkpuMfecNscJbr/yZpEFueJRmamM/MyVnBwVwTh+fIO0Hg+kjDf8KtpXPYi6I
	 sAxQf/pYgbJoBbKmcVkTt6kJnin0TSq/6mYTePumu9+WywATaYY4Zvn2RyEcDXWdByXx5
	 TePTRkfg1RzsESU/EvQuy/Oa7Vt/uEVi0t/eroN6qZNRQope++FiQOAGxAF4jSDZzmgL4
	 CKWhq2gpomq72/sOCq/mOQ8n8YAC+lsUKVYtTBx58Dybpddg+mQHJoR+MhD7TizNihA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BP1bRuZFOgjR5Z0Ak0534khAQ36tY2ZxCm3tjOJpcM8=;
	b=GX2DRa5tYCoOgVBZm/tmmbPYtdiC5C6ZcZgYWRdBq2NY34Fg5oUHt56P+aAr6r5oXRFU
	 rczpe8GciX+k1FgdiCbrHSAzJqT7t5n0FWqPCLHkIagw+1ICKR4H5h8iUkhrInNR0KEEA
	 KRKzrHdp3HSXPPCXeIgbYctr1YhrrVhBNw4sj1G1SkkfyWOwECexq5iT5yKqi3nivKu2l
	 ose1w9Sl+dhre9xX8edEQ7VMmEreJIf2eFdmKofAw8zG+YX1Klv/4txd3fmGoPrZzohWI
	 rlf9jcXt3QkoWEF3VRC66ACISi/lRWTn4PxbgZSHhp4s4mW2GLfd0DImQrUEDx7uYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wy1d1v8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78828606A335;
	Wed, 18 Nov 2026 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wy1d1v8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09221F000C4;
	Wed, 18 Nov 2026 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028269;
	bh=BP1bRuZFOgjR5Z0Ak0534khAQ36tY2ZxCm3tjOJpcM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wy1d1v8k66e09xoFmBDCDhZxqfa/TwaUNK3oRyfkTbIo7bV1NZMO93BPENGVLviwV
	 2zDj25qSRAKuvXu8DGGSN8AGGvtbkuQqyS6LAYt+uLmRqwJGQKa8aEyyZuPvIpBlHm
	 jMVpf4Q5HM9PXfEdPtjGLKsC1m69CS8oC2ACu23Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2083/2151] block/rnbd-srv: dont free the device on a sysfs error
Date: Wed, 18 Nov 2026 16:03:38 +0100
Message-ID: <20261118150237.586002590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7eeb321d61402..527de52cc941d 100644
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



