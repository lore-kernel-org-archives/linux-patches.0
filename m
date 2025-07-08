Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4CF23A98D;
	Tue,  8 Jul 2025 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992762; cv=none; b=atXsNlH6sel85bhWRNtydVNUtqqf7GV1ve5sXrwyQmm81aAeH8WcLbbCeoi0jQxkqeEg9E10+yIp3udWwhSCfSOd77c0uXoaxGVd3WyUYtKVNiRXyo6vE9GHtI5yk2f1/TaJ4qeArzx6nMuYhHoU0IzOh1Erpm2hLmfvcn0Z/co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992762; c=relaxed/simple;
	bh=zIcqvy6k5ibG2MZvunhQWJW81rfCJbV6Z0+5ldsd19A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftwyGafSkAhtxt/SHlGXB9KJdkl3aQDFyvQgjtvPSm+Nl61T2WnZDABBx8ZOYQV8s8b1iqYPM7fTmm4BvE4d5RGese+A28seiTOG9e/Aip3UOaF6Rcq9TZEcjNDofZczn9WvsJs8XOwmdKbwXRkGvx1nJh0CRe5tWeO2CVMCABI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aliF+D+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aliF+D+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74421C4CEED;
	Tue,  8 Jul 2025 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992761;
	bh=zIcqvy6k5ibG2MZvunhQWJW81rfCJbV6Z0+5ldsd19A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aliF+D+FbZHFf+dA5L/dZdG76FRHxRe5lVieYMN58SjQMeTf2G7e/9UbVQJJ8x5u1
	 ej/veQHnh/EqgpIAyCiVgCpowPYnNb0EpjAOWiietLGZ19wWZKTEIn6dSCGOI4qjZO
	 CoWJ5F6ejWb1K1xVIbDNg7QuAMkPmAcLdbDUiPAI=
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
Subject: [PATCH 6.12 064/232] platform/x86: hp-bioscfg: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:21:00 +0200
Message-ID: <20250708162243.139017851@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2dc50152158a3..0b277b7e37dd6 100644
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
@@ -972,11 +970,7 @@ static int __init hp_init(void)
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
@@ -1043,10 +1037,9 @@ static int __init hp_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 
 err_unregister_class:
-	fw_attributes_class_put();
 	hp_exit_attr_set_interface();
 
 	return ret;
@@ -1055,9 +1048,8 @@ static int __init hp_init(void)
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



