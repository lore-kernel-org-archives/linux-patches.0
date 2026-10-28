Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216517;
	b=dYn25iTRCcFojChjc3XGrVMCrgp8JptBrRyXhVUGbTSJ6bZr/WVCeOuaDTu7B/5FFbR+
	 uqAuVcS2XqhkCbdNxSpDsZfR5BB91BPYWPatR5KfF4UePjngXK+mWZDbSgNPyxwhCxeZn
	 YPHJwTD7qwtIoiAEtaAa/fN1LwvCjAcCQaA/lHcvR2/SD4bGIaGsY5rAXZXE/B1jWHcaQ
	 hfjsjTnLtNDN8Xah0fYUPZ0IdvIGmftp+btxw5pm6QTWbrKz4FK+F9DtrdSx0wvyNqfqo
	 q9kqeMD+OBBVaSuIDkxlzeY8pfgM1Fx2cV07Y6oVMib3Cu/YRb+4plLHMmnmFOOQQOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DQZg0JZW++jlcrJinQANCHvzqA6J/z1R88aG1y7Um1Y=;
	b=4R7IYZzNIwL3x75c080+9X4kYJXw9UY05jsT4Rb2jXIQOCNeypPfCUOOjdp3p83T42Mu
	 1BHckxOte8eRSMSDatu4tbr2mXkCSvtravmwvkfXLBwDt9jNL4DKbh611H2TcfHTtK2Ac
	 Bx4peU5uNpJnTlOMqmntAKsWL8+F/vgcF9videXrx6zmw7fLqtenBhhpzmeizBpij4Qbm
	 pHU0TEj8RwBnRdX2RMPY80i6kGVMTROKjNbJU24RKAjuBmSmcOXbS8cxNcfr/XD4qD/26
	 OYG4x9OUm20P/0EwseGOhu1YS8xeeEOhJALtRyu12I5yCWcyJZM4fD9VBO4SI3lCRgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHuZiCuC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1C606A31C;
	Wed, 28 Oct 2026 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHuZiCuC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06051F01825;
	Wed, 28 Oct 2026 19:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216517;
	bh=DQZg0JZW++jlcrJinQANCHvzqA6J/z1R88aG1y7Um1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHuZiCuCGhvRQvLGFfLcRUQtrnJuXCnl23XdvSf6z2SDAQtvBK56IKioh9l6QQxmz
	 hX8GVe/uhJ1jLxdrmcG0jbk6Hm1fIXTEDNGkMfx1R3E52yutK2XNtAqdXLHb+rAHCE
	 +Pl+zXj92lEiPyNNgjokX7CeIrhSjh6X9Hhdb2lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1583/1887] tty: make tty_class a static const structure
Date: Wed, 28 Oct 2026 18:01:19 +0100
Message-ID: <20261028170535.490568713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 862d8312eed994a8a9af7aa8e9e15456183b10a7 ]

Now that the driver core allows for struct class to be in read-only
memory, move the tty_class structure to be declared at build time
placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: "Ilpo Järvinen" <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/2023040250-landowner-unfitted-11f4@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c3b5623fd976 ("tty: skip cdev_del() when no cdev is registered")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/pty.c    |  2 +-
 drivers/tty/tty_io.c | 24 +++++++++++-------------
 drivers/tty/vt/vt.c  |  2 +-
 include/linux/tty.h  |  2 +-
 4 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c658cacdb9334..335f5744f320c 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -931,7 +931,7 @@ static void __init unix98_pty_init(void)
 	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
 		panic("Couldn't register /dev/ptmx driver");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
+	device_create(&tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
 }
 
 #else
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4124603a0b44f..1e78cc10b77d4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3086,7 +3086,7 @@ static struct device *tty_get_device(struct tty_struct *tty)
 {
 	dev_t devt = tty_devnum(tty);
 
-	return class_find_device_by_devt(tty_class, devt);
+	return class_find_device_by_devt(&tty_class, devt);
 }
 
 
@@ -3160,8 +3160,6 @@ int tty_put_char(struct tty_struct *tty, unsigned char ch)
 }
 EXPORT_SYMBOL_GPL(tty_put_char);
 
-struct class *tty_class;
-
 static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
 		unsigned int index, unsigned int count)
 {
@@ -3258,7 +3256,7 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 		return ERR_PTR(-ENOMEM);
 
 	dev->devt = devt;
-	dev->class = tty_class;
+	dev->class = &tty_class;
 	dev->parent = device;
 	dev->release = tty_device_create_release;
 	dev_set_name(dev, "%s", name);
@@ -3315,8 +3313,7 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
  */
 void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
-	device_destroy(tty_class,
-		MKDEV(driver->major, driver->minor_start) + index);
+	device_destroy(&tty_class, MKDEV(driver->major, driver->minor_start) + index);
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC)) {
 		cdev_del(driver->cdevs[index]);
 		driver->cdevs[index] = NULL;
@@ -3531,13 +3528,14 @@ static char *tty_devnode(struct device *dev, umode_t *mode)
 	return NULL;
 }
 
+struct class tty_class = {
+	.name		= "tty",
+	.devnode	= tty_devnode,
+};
+
 static int __init tty_class_init(void)
 {
-	tty_class = class_create(THIS_MODULE, "tty");
-	if (IS_ERR(tty_class))
-		return PTR_ERR(tty_class);
-	tty_class->devnode = tty_devnode;
-	return 0;
+	return class_register(&tty_class);
 }
 
 postcore_initcall(tty_class_init);
@@ -3610,13 +3608,13 @@ int __init tty_init(void)
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
 		panic("Couldn't register /dev/tty driver\n");
-	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
+	device_create(&tty_class, NULL, MKDEV(TTYAUX_MAJOR, 0), NULL, "tty");
 
 	cdev_init(&console_cdev, &console_fops);
 	if (cdev_add(&console_cdev, MKDEV(TTYAUX_MAJOR, 1), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 1), 1, "/dev/console") < 0)
 		panic("Couldn't register /dev/console driver\n");
-	consdev = device_create_with_groups(tty_class, NULL,
+	consdev = device_create_with_groups(&tty_class, NULL,
 					    MKDEV(TTYAUX_MAJOR, 1), NULL,
 					    cons_dev_groups, "console");
 	if (IS_ERR(consdev))
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9b1448d7cb4e4..bdfbf6a1efe22 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3603,7 +3603,7 @@ int __init vty_init(const struct file_operations *console_fops)
 	if (cdev_add(&vc0_cdev, MKDEV(TTY_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTY_MAJOR, 0), 1, "/dev/vc/0") < 0)
 		panic("Couldn't register /dev/tty0 driver\n");
-	tty0dev = device_create_with_groups(tty_class, NULL,
+	tty0dev = device_create_with_groups(&tty_class, NULL,
 					    MKDEV(TTY_MAJOR, 0), NULL,
 					    vt_dev_groups, "tty0");
 	if (IS_ERR(tty0dev))
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5bfdf02df9c75..2b90fe8afadeb 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -389,7 +389,7 @@ extern struct ktermios tty_std_termios;
 
 int vcs_init(void);
 
-extern struct class *tty_class;
+extern struct class tty_class;
 
 /**
  *	tty_kref_get		-	get a tty reference
-- 
2.53.0



