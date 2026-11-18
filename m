Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042697;
	b=TFsAWYyhL9I36z2v3fmo8ZCur6U0/DJVQLlRjguZbp8QKx2ayQh1iou2mciCDUgyz+s7
	 6ypHAr9mdTDFTCauBtCiCyCRKEX2y1Rr2vIbHHH6oyRbwBSKsyaA6T3NNQmLvWNhcdiZ1
	 ksbCAEROb6NN0FLX6CGTfRFi8w0OfDwAEfWCv20QVU3SiNYb9NjHxvwUYT/B0l6XxhW84
	 WGNAXQrRK07P5aJ22v+TGxHIp2d+ln0QXcFjNSwozgcWVNmka2mfpX+0riRHoCKBWRj5i
	 9AMVVyFL/bww/sPXEq0KlKL0/B4OXkXDIWKqG7Gyw4U8D28ur2U3HNiYFHY1IzYfStg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YHC8E8CyLK7X3ZBsGk6AiiBMMDPcsJn+XJIrUjMM+s=;
	b=pRb+Jf8HvOBNj8ECFrGRT1ybpt2aUbVgyeOwg8jd3892Sxpis52paCtWwUe78rwkkTL2
	 jHI+UYfTsOUJ5vDT4nvuVUliNbx2hcK/vseaZ68AciqolH3wt6r+29C++EzrdYI5HOWLQ
	 Q/m4S5RHgHSu+xbLbfhcnIpgE0p9pRYQyBoHVJA5Y8bv8LC3QXEjGYu2txlVTR2K+c44m
	 XD7+pobNC2OOMrKwX9OyN/O9Oc9hf18whKAkekl/wHSwwsgKd6IFBlZjGGDpklb28aMeV
	 S5o0rWC7kotU05ahiyMgrl/tgNdPXBKx0b8uFUZM3FH1fhTBXtIsrFUeCoFQdDg+m2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Sn5ynS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06DF606A31C;
	Wed, 18 Nov 2026 22:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Sn5ynS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4141C1F000C4;
	Wed, 18 Nov 2026 22:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042696;
	bh=6YHC8E8CyLK7X3ZBsGk6AiiBMMDPcsJn+XJIrUjMM+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Sn5ynS3cxJYUQ6/OMvs5Va75yoANl3mhv4DmI85PyDCOfVk3ijWhAx7WUACUsWfb
	 /8DhAegDwCuO6ddgIZ/skxkG0bg7lLbVGNwLIP3IZbaQj11ssfOectjYy0/aTYG4pa
	 b/6/RwynynxFfO+Na2U2M2e3a8oeQQakg2PJ0Lcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3263/3318] block/rnbd-srv: dont free the device on a sysfs error
Date: Wed, 18 Nov 2026 16:04:45 +0100
Message-ID: <20261118150457.509808193@linuxfoundation.org>
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
index cba6ba43c2c28..ede36fa0da687 100644
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
index ebc0f4c091051..50aa800231666 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -192,6 +192,9 @@ static void destroy_device(struct kref *kref)
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



