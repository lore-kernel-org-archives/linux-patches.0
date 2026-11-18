Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050714;
	b=TUIQH/O+qjIFMx/9sgGrCGDHzwwiwjjPIFCeOIs45IN3GGg3FyVmW9dKmdCEFsk0nXwz
	 hWIJS+W8Bmkuf6olwmavkVLqbGyxojRMlxJN0mDWCCVQLPyxPNebeG2Xbn0Rhv0vAP1Ci
	 wzMyb0hJFm/0+pUo4TEzt8Nyuz8Oow/iai/uUeP4o8qgia/dLLjb8uRlV9f9IU/30xSWd
	 7uY5HSRC+wivbZcnAfLZW5zwKMGbP6UmyG6OOtZToX5TWlNTOhV/9YcW3yIttkU43ZrGI
	 MUwNB3yqL5WzU/ZWoTgXBwrycD90hrMvnJTM0k7vCoPAah2Gpp7m8clwAy259D8O4lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RE/F8bba63XwttwdmhtdJRmwS3MiGB8p0+6uaP9xN6Y=;
	b=n7LpyHNeJhWkHd2R3dml8/5Y2T2HSkcBrBPr/Wm8HJ21XZXBPvOWq7/wPuO1+VXXk37d
	 qvApBif7B19ZJyzY6e9rLJKkydNvWnbD0Pgx/mBd9gHCJWSIKUvnjiD0XvoxKSXpOiDVm
	 P6hj+QXUubZAN4V+hQYjHs4mactxoN7Br4044yXI/g/4G7YEYuzF/QKANvptGhs+pxYE/
	 t6iojWa72Ydbo0hZ13kdIxLfT8xTjBg7acg+FpGoQte5ctTL9x1LBkVar+ytAFpBTMpEx
	 YaonwUcQmdb7GBqGUfeHYAHi3hImT3v6iNvqkFEm0BHGL6k3J8dB0xsWHtD7O671jbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igh7R1Wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD523606A32A;
	Thu, 19 Nov 2026 01:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igh7R1Wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE67C1F000CA;
	Thu, 19 Nov 2026 01:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050714;
	bh=RE/F8bba63XwttwdmhtdJRmwS3MiGB8p0+6uaP9xN6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igh7R1Wp5PJr4dGRUu7uVMaCior5sj/7bcySVIjEVsFo3cheMzH3ZVv2lrYVrEzSO
	 QXDB1OlngwCPwiSTJIrGFfjFFMqNAJYaECRcRZ0kt7e6qgLBRtcbI8vcEehxraujpF
	 7LnolVZ4cU/xpInjsEK6w+VOBB8wGGNz11gyRcRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2807/2857] block/rnbd-srv: drop the sess_dev kobject unlocked
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150342.668983994@linuxfoundation.org>
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
index d9d6a5fd7cf58..8cf9236cc1a1d 100644
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
index c47ad07972699..67108aeda467d 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -575,6 +575,7 @@ rnbd_srv_create_set_sess_dev(struct rnbd_srv_session *srv_sess,
 		return sdev;
 
 	kref_init(&sdev->kref);
+	INIT_LIST_HEAD(&sdev->dev_list);
 
 	strscpy(sdev->pathname, open_msg->dev_name, sizeof(sdev->pathname));
 
@@ -775,7 +776,12 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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



