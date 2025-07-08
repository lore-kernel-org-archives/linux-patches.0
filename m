Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385020766C;
	Tue,  8 Jul 2025 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992468; cv=none; b=FXOUHjWXqWVsi9dmclkbHN6TEDMKlUzdw3o5zpQeqTQRsW4lHZcMyrxBzatnG6JSfjXLCCIqUiu8OSU0o8fc5XhUSihKt00bUqwEkKO3E2KY/pCM6qpHgGLMZ73ztIFsOskeGaMgf6kigpUuQoO/ledZdSk70Ut3ncv1+mshgO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992468; c=relaxed/simple;
	bh=x5meIhN0vQYs9wMn6jPtSBoGPl+p+pykBTJGvzUH8WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObmvAdishY5dZvXyFSlzBQxTzAeilRAqICQMYZQTSDnVAFbY7z7rQER/dzDrgQ2qq+YH3V+MSUXHP4rf/rmvwafd6Ub31RpL0TYFVws+xsrrkWpk3nXTPsh8NIpFrEX3gor5RVd0jbzEJD7oFYOkaPFS+ex2TzpLNNUUcoY6K0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSyYXYWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSyYXYWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B88C4CEED;
	Tue,  8 Jul 2025 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992468;
	bh=x5meIhN0vQYs9wMn6jPtSBoGPl+p+pykBTJGvzUH8WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSyYXYWROUQaS06us4bk9Y6DlegIpuzvUT385gT4LIjTevZOcnQXauMQryjTs6+if
	 Ch12nooSM76pSrf6CvGuFE5gLRxO/FIEiyxkRlK1GUJ8qIUoRD2QsigARUebTbxm2O
	 5SadzZgKVbHAqK+qJ0spY/RJLtdyNVU0nFdX0yt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Armin Wolf <W_Armin@gmx.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/132] platform/x86: hp-bioscfg: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:23:32 +0200
Message-ID: <20250708162233.565248838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 63f8c058036057644f095123a35895cd11639b88 ]

The usage of the lifecycle functions is not necessary anymore.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250104-firmware-attributes-simplify-v1-4-949f9709e405@weissschuh.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 11cba4793b95 ("platform/x86: hp-bioscfg: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index b8bac35ebd42b..049851e469f60 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -24,8 +24,6 @@ struct bioscfg_priv bioscfg_drv = {
 	.mutex = __MUTEX_INITIALIZER(bioscfg_drv.mutex),
 };
 
-static const struct class *fw_attr_class;
-
 ssize_t display_name_language_code_show(struct kobject *kobj,
 					struct kobj_attribute *attr,
 					char *buf)
@@ -974,11 +972,7 @@ static int __init hp_init(void)
 	if (ret)
 		return ret;
 
-	ret = fw_attributes_class_get(&fw_attr_class);
-	if (ret)
-		goto err_unregister_class;
-
-	bioscfg_drv.class_dev = device_create(fw_attr_class, NULL, MKDEV(0, 0),
+	bioscfg_drv.class_dev = device_create(&firmware_attributes_class, NULL, MKDEV(0, 0),
 					      NULL, "%s", DRIVER_NAME);
 	if (IS_ERR(bioscfg_drv.class_dev)) {
 		ret = PTR_ERR(bioscfg_drv.class_dev);
@@ -1045,10 +1039,9 @@ static int __init hp_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 
 err_unregister_class:
-	fw_attributes_class_put();
 	hp_exit_attr_set_interface();
 
 	return ret;
@@ -1057,9 +1050,8 @@ static int __init hp_init(void)
 static void __exit hp_exit(void)
 {
 	release_attributes_data();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 
-	fw_attributes_class_put();
 	hp_exit_attr_set_interface();
 }
 
-- 
2.39.5



