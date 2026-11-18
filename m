Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056978;
	b=Y8QchQ/430mTZx4FSFdEwtpMBGmq7h0VfU6L8eh+7Qb+WReVCHwbe3DQPbsOWEKf3+1A
	 QAnvYh6PkVczgTCDLq2XqAS3i/ELdHwsYHxP3kTJr/Qtj1QTMjRL49h5CHrevFL/dXjmJ
	 xI8SpleH5jv7w0q4tG6flc+JgT0dp6nB0/5CQeuBGJ5Sep83zixPucqEV6w4Eqvwk+C5c
	 kdl+FsHO3iXkWJIPMb+bS6O/A0TxA1Jn2Qm8mNGRm9o6zNxYlKkKHF2QD8lay9V044g8k
	 mA4qPfdX9Dz3Ar/Z/q/vMM/yudH2Ck6YWwcfwY0b+SEGKCRb09QKpfhDJsmbvQTdoAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ntV48EG0AbnV4kSR3AmfWUICCZzEK4AO+71MKyC46k=;
	b=JwovvgJvaguMVNi/qfROYDfHuCb+EGaadtt2gsRuaWVq5XS5r0UxhiYgjLqDxJAqlUVh
	 pfHoJvXKhuo1DP2uqeB9eAReexAdiGo1c4TfIXMq5E08UbWfY8iksn1omwI1vb4aSnTWz
	 BY6lGFRHSV1rFpT04iyaJAadJKy+9y2Zdrr4mxGPEPcnE6UBfaNnjCauKjPz1DWYARG0U
	 Kzo0g5MIYtoT0XI062n70/CcSdtFcyZKHkysBXv8orr4lGtVq+yxb22SfNYMm/XUhRYSI
	 tgkNJ/ohFH4Krqs0XUvex4G3kox6HAj/gaoOa7rctNukOMeWwHBjTUmU2SegNRGah3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9Fm0C8c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CE5606A31C;
	Thu, 19 Nov 2026 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9Fm0C8c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394DA1F000C4;
	Thu, 19 Nov 2026 02:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056977;
	bh=3ntV48EG0AbnV4kSR3AmfWUICCZzEK4AO+71MKyC46k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9Fm0C8cDn2h8+ayCTH1PkCPGepCMgmawRv8QqwdsXP3tgZNMXKigXkb9tA9aYCDS
	 DkBwU7Gwd1Z0s8z720bXrb//FOKvNGSNOU7RB81Zk82wMyfLWXCiZ3wTxlVVJtf56P
	 d18RXNStyqMhhOkgUryPwSQoZ4usajuXH/oB8HjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2181/2214] block/rnbd-srv: dont free the device on a sysfs error
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150137.618216405@linuxfoundation.org>
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
index 122fee8aedd8a..e467bb63511ad 100644
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
index 6e6423d8c149a..ad9cf2ab14671 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -197,6 +197,9 @@ static void destroy_device(struct kref *kref)
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



