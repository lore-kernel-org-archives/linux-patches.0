Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355E264F9C;
	Tue,  8 Jul 2025 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992843; cv=none; b=Hz/vjeyIdRUcdnLo3PG571rLWxIojn+3y2Sv2VfteCEz1bwVZNes3BmcVWiNCbbgTwW2yL3V4u1CZc4kZhTGqDipCVVxnObcLbyGyD9vc7bbWNdcs4h6JRfdn2Ll4f87eymnULJjIxKC+vJ/9Cp8SFpeMVJxTjlp6YE8eT++mlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992843; c=relaxed/simple;
	bh=B46FW1EjBhbj4mMaIXLQw62sVNCP8MfD4RRmf0hlHmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BzZNC0isQxm3FjwF0hdyIrhX1ulxThKiM7L7F8o93zF3OEcLhh7XxYLPm3RtoukMz1vPe8fEaC+C9faRQ7ZBwKB5rrMl5Kpf6YLm6TrwKOqjHGnwpAJHCjK89QVR6lFDn8DwhpGbfDwofWCB159yDoyBhKB3zwvpzNp4jRM9jZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSCF1ivf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSCF1ivf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8DFC4CEED;
	Tue,  8 Jul 2025 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992842;
	bh=B46FW1EjBhbj4mMaIXLQw62sVNCP8MfD4RRmf0hlHmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSCF1ivftdd5IGEmdvZ3tQapf7kp/dS+BmtS66QUlTT0/+n5MyxC8sSehqEdC1lox
	 Lue6NF8UBJRdJrFGrnLMSeWx2/f0DY4Beb1g5i6qAArL+hCSVL8PJcEJZXj3jiMuLc
	 k6OmVOg0O4C3EM5cvje6sttfrFHidw7P2CZBEMwI=
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
Subject: [PATCH 6.12 070/232] platform/x86: dell-sysman: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:21:06 +0200
Message-ID: <20250708162243.295239206@linuxfoundation.org>
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



