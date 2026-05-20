Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870144028C8;
	Wed, 20 May 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302452; cv=none; b=pOf+oB9hnKrMjxCtYJQy/sbkFkBHzFXLp+K5jnUr6LL0CFVxMqQtoxXlZ5MeC0lYPwdvNtKq968J9uxkq+Z6qOpnRvJpI68qA3myrfRVtvql0iXsANOwJ4AUmV88IFeZhHF77oLHk6B3dauPflZdbGi9gX8xrqIuxa2tXKcQMWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302452; c=relaxed/simple;
	bh=8Jive/MpmZoJio1Zn9a/4HtVc7hcn+6i6AY/+mAoC7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV0exQ/j+3HYHAlgKCJAESHECfIJNorh+S/vhli715vTk4Q7DfBPu8Jy/1hcdQEMF/cgqeSagKxi/IiQ/87MsMwjEKlnfojtmx8VsBNIinKUaXyLAh3q7sI/k1E+dxPQfXJfcUClVW84Ty8YpcRnogF1f+tVs1EPHkhlYekouyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdP1XI5U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdP1XI5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D931F000E9;
	Wed, 20 May 2026 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302451;
	bh=Rtf7VE5AiANDz9UiYEb2gehdNcQ+KqNaMSnNIHAdA+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdP1XI5U7N91KbyW7WoT4Ak2lhJQ1joW8q+2ytWQLoiusi0QBwCCkaoWCLsfby2sn
	 VOJAsgzzetD0NTbGsRKDCB2A9m+egwsXKV1vZAsizdQrsaBwA6SFtQzxZDuoa5AwHj
	 89NNcydXkgnAlUCa7qPxrySLIQ8yttzQSvv56JNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/508] scsi: sg: Make sg_sysfs_class constant
Date: Wed, 20 May 2026 18:21:36 +0200
Message-ID: <20260520162104.559629969@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit f1fb41765d0bff77514ffeaef37bbb45608f6c62 ]

Since commit 43a7206b0963 ("driver core: class: make class_register() take
a const *"), the driver core allows for struct class to be in read-only
memory, so move the sg_sysfs_class structure to be declared at build time
placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Link: https://lore.kernel.org/r/20240302-class_cleanup-scsi-v1-1-b9096b990e27@marliere.net
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 3033c471aaf6 ("scsi: sg: Fix sysctl sg-big-buff register during sg_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0dd8b9f8d6717..799773a879188 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1421,7 +1421,9 @@ static const struct file_operations sg_fops = {
 	.llseek = no_llseek,
 };
 
-static struct class *sg_sysfs_class;
+static const struct class sg_sysfs_class = {
+	.name = "scsi_generic"
+};
 
 static int sg_sysfs_valid = 0;
 
@@ -1523,7 +1525,7 @@ sg_add_device(struct device *cl_dev)
 	if (sg_sysfs_valid) {
 		struct device *sg_class_member;
 
-		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
+		sg_class_member = device_create(&sg_sysfs_class, cl_dev->parent,
 						MKDEV(SCSI_GENERIC_MAJOR,
 						      sdp->index),
 						sdp, "%s", sdp->name);
@@ -1613,7 +1615,7 @@ sg_remove_device(struct device *cl_dev)
 	read_unlock_irqrestore(&sdp->sfd_lock, iflags);
 
 	sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
-	device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
+	device_destroy(&sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, sdp->index));
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
 
@@ -1685,11 +1687,9 @@ init_sg(void)
 				    SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
-        sg_sysfs_class = class_create("scsi_generic");
-        if ( IS_ERR(sg_sysfs_class) ) {
-		rc = PTR_ERR(sg_sysfs_class);
+	rc = class_register(&sg_sysfs_class);
+	if (rc)
 		goto err_out;
-        }
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
@@ -1698,7 +1698,7 @@ init_sg(void)
 #endif				/* CONFIG_SCSI_PROC_FS */
 		return 0;
 	}
-	class_destroy(sg_sysfs_class);
+	class_unregister(&sg_sysfs_class);
 	register_sg_sysctls();
 err_out:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
@@ -1713,7 +1713,7 @@ exit_sg(void)
 	remove_proc_subtree("scsi/sg", NULL);
 #endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
-	class_destroy(sg_sysfs_class);
+	class_unregister(&sg_sysfs_class);
 	sg_sysfs_valid = 0;
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
 				 SG_MAX_DEVS);
-- 
2.53.0



