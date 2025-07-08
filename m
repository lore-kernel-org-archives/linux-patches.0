Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F3E2E0B45;
	Tue,  8 Jul 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992397; cv=none; b=R7JktnylFMzJJmgm9JL6JZa2zR1E/Sse8ah1p0S+tZNjdhHuGUXeY21eUZIEm+fPRWN4TnndfhzVvpSHHQbAah1mgQJ+j0T/rovNg4QznsFY/MpyCGwU0LV9S3ypZi5/Vq18fkBOxVyyM+axe+dS1nwvZMU0TCEouOpCOc4scdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992397; c=relaxed/simple;
	bh=YmJT1Hm7JYxa/XxCT/EfgYOFDqdKV006CBzhjlqRL04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSlNdfL/betiiwOJP1+nY0cJWOPU4uPcchCuWmMkYiTMgnc2leCiG0a/eBf8+uSL5bB96FaR9hsaME8rUophpaMROuIESi94SNQP3rMXJQcVruy1Tv7xTuaC+MTuzoCMGt5Q6kR90XNSo/lHqK0eSlLB5hIwmxIOBEnsqFLG9wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HASht7oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HASht7oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD3FC4CEED;
	Tue,  8 Jul 2025 16:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992397;
	bh=YmJT1Hm7JYxa/XxCT/EfgYOFDqdKV006CBzhjlqRL04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HASht7oa7qSlbITZmD1EFuvV0pDql7wmUkQ6sFRiAoTNSYsh19gYhGSvZhVZbFvSb
	 YMFJ/XUC4j1tNRcUpI35eUuGL5GAcJ42onPaW3pVShGrgHOeo50HmaCGwkjWu1no3V
	 y94iY0XYAeHwndrnEMrKjf8lT9NeP5j+SOG+2TsY=
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
Subject: [PATCH 6.6 048/132] platform/x86: dell-sysman: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:22:39 +0200
Message-ID: <20250708162232.070870381@linuxfoundation.org>
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

[ Upstream commit 501d2f0e78951b9a933bbff73404b25aec45f389 ]

The usage of the lifecycle functions is not necessary anymore.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250104-firmware-attributes-simplify-v1-5-949f9709e405@weissschuh.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 314e5ad4782d ("platform/x86: dell-wmi-sysman: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/dell/dell-wmi-sysman/sysman.c  | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index decb3b997d86a..3c74d5e8350a4 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -25,7 +25,6 @@ struct wmi_sysman_priv wmi_priv = {
 /* reset bios to defaults */
 static const char * const reset_types[] = {"builtinsafe", "lastknowngood", "factory", "custom"};
 static int reset_option = -1;
-static const struct class *fw_attr_class;
 
 
 /**
@@ -541,15 +540,11 @@ static int __init sysman_init(void)
 		goto err_exit_bios_attr_pass_interface;
 	}
 
-	ret = fw_attributes_class_get(&fw_attr_class);
-	if (ret)
-		goto err_exit_bios_attr_pass_interface;
-
-	wmi_priv.class_dev = device_create(fw_attr_class, NULL, MKDEV(0, 0),
+	wmi_priv.class_dev = device_create(&firmware_attributes_class, NULL, MKDEV(0, 0),
 				  NULL, "%s", DRIVER_NAME);
 	if (IS_ERR(wmi_priv.class_dev)) {
 		ret = PTR_ERR(wmi_priv.class_dev);
-		goto err_unregister_class;
+		goto err_exit_bios_attr_pass_interface;
 	}
 
 	wmi_priv.main_dir_kset = kset_create_and_add("attributes", NULL,
@@ -602,10 +597,7 @@ static int __init sysman_init(void)
 	release_attributes_data();
 
 err_destroy_classdev:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
-
-err_unregister_class:
-	fw_attributes_class_put();
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 
 err_exit_bios_attr_pass_interface:
 	exit_bios_attr_pass_interface();
@@ -619,8 +611,7 @@ static int __init sysman_init(void)
 static void __exit sysman_exit(void)
 {
 	release_attributes_data();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
-	fw_attributes_class_put();
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 	exit_bios_attr_set_interface();
 	exit_bios_attr_pass_interface();
 }
-- 
2.39.5



