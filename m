Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC09264F9C;
	Tue,  8 Jul 2025 16:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992837; cv=none; b=YlS5TsVkS0B0YLlP/3u4UBQenzGjCgyy9oiFgKX5f2aZIrEEgnh+WqksJd8ZaHEn75v159esG9AN5XZPCrtP9Cy+dQb3ri0s1uRcb18Ynp3WXisgUj6jQmPSy5brLT6NFwWeNaEx6hLykfgXplIrWeGYkt6dxZc1thkFUPx4U4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992837; c=relaxed/simple;
	bh=5t5BkgXuSljvLekdV0XxBgdA2r9hQbjVI1MV0akgCck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHkPYfR64jNcI42F+hIAogoiwmFRvDU67Z0FiNqWEa6tjY5is6WyuCcqdJUnqaDT3o0u0XwD5yRKlYUzgOXD1uaHG5qQFPa2qlmx047aq758rO6twSCHLp6sUzjZuyDKCCVjHa1/Z3hCMX01AQNwqaBNTmVthXrjx/hPSr1lz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty3ITRNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty3ITRNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C0CC4CEED;
	Tue,  8 Jul 2025 16:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992837;
	bh=5t5BkgXuSljvLekdV0XxBgdA2r9hQbjVI1MV0akgCck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty3ITRNdvuc6rZkSQvFiNP/khgLTWrEh6fU2dcNbh6/ZZNwg8gaVGun8hOJfr4LoP
	 xH8q7Be2PqBtzAX9U55JPXYT1XiHOJzfhZ1nlr+jca1eYxGUigiZwy8V2555SaroF5
	 pHYR2M9U5vYWlcZrwkDH4qy+BCSX5Ow3+FDsDrWE=
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
Subject: [PATCH 6.12 068/232] platform/x86: think-lmi: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:21:04 +0200
Message-ID: <20250708162243.242401425@linuxfoundation.org>
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

[ Upstream commit 55922403807a12d4f96c67ba01a920edfb6f2633 ]

The usage of the lifecycle functions is not necessary anymore.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250104-firmware-attributes-simplify-v1-3-949f9709e405@weissschuh.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5ff1fbb30597 ("platform/x86: think-lmi: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 1abd8378f158d..a7c3285323d6b 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -192,7 +192,6 @@ static const char * const level_options[] = {
 	[TLMI_LEVEL_MASTER] = "master",
 };
 static struct think_lmi tlmi_priv;
-static const struct class *fw_attr_class;
 static DEFINE_MUTEX(tlmi_mutex);
 
 static inline struct tlmi_pwd_setting *to_tlmi_pwd_setting(struct kobject *kobj)
@@ -1375,11 +1374,7 @@ static int tlmi_sysfs_init(void)
 {
 	int i, ret;
 
-	ret = fw_attributes_class_get(&fw_attr_class);
-	if (ret)
-		return ret;
-
-	tlmi_priv.class_dev = device_create(fw_attr_class, NULL, MKDEV(0, 0),
+	tlmi_priv.class_dev = device_create(&firmware_attributes_class, NULL, MKDEV(0, 0),
 			NULL, "%s", "thinklmi");
 	if (IS_ERR(tlmi_priv.class_dev)) {
 		ret = PTR_ERR(tlmi_priv.class_dev);
@@ -1492,9 +1487,8 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 fail_class_created:
-	fw_attributes_class_put();
 	return ret;
 }
 
@@ -1717,8 +1711,7 @@ static int tlmi_analyze(void)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
-	fw_attributes_class_put();
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 }
 
 static int tlmi_probe(struct wmi_device *wdev, const void *context)
-- 
2.39.5



