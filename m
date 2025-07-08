Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF9A2DECC4;
	Tue,  8 Jul 2025 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992356; cv=none; b=Qd1KpJCakeGDOjhfGIKxcYksmsWXhYAzdRvvxljmlVch62NWCnDSiT+fKQSiW4tWYzVybvQ9jdnwVDkmxPtMB7NvIDDdysNClIEOmMWmey6uG/x84FJZk6MI8N419vWOMAkaikmCZI2mSN0z26S+ifH8DOWsyL3+riKxmxeZih4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992356; c=relaxed/simple;
	bh=4cBebe0Dhq04ofStaXBqoaVm+hpn/a1TzidTI6IEYsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIbbioOSO3aIDq54cymzk+JD+3o4QPy++I9bfCdnNIBd/AnZ5vtAca0sAHp03n/noXR2jDYngKpWpbcpu/lTPCh0YihmN5yY4dKH2cTHg+IdzEGqlEDa5y4BEVF8MWB+1IQt3klNWDrv/nOWNgHqBu39whd17Kbr4uzets+1JMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u9pNKT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u9pNKT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991EBC4CEED;
	Tue,  8 Jul 2025 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992356;
	bh=4cBebe0Dhq04ofStaXBqoaVm+hpn/a1TzidTI6IEYsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u9pNKT5DMt2edBdVX21URDXP61RniS3Ijkeqb8XMl/tO6D1JGI7GNX/dWEAHkpbk
	 YczcUCZ+WUQw+1dWAoiclYIo4ufphBDhJbWW6J+ndq6sK3kHRSxt1b2zQ4XAyCcpq9
	 M9kOikaH7Sonv79Rm1mm+xw6APHwRB4Ff5gA3t1k=
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
Subject: [PATCH 6.6 046/132] platform/x86: think-lmi: Directly use firmware_attributes_class
Date: Tue,  8 Jul 2025 18:22:37 +0200
Message-ID: <20250708162232.015775908@linuxfoundation.org>
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
index 3a496c615ce6b..f0efa60cf8ee2 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -195,7 +195,6 @@ static const char * const level_options[] = {
 	[TLMI_LEVEL_MASTER] = "master",
 };
 static struct think_lmi tlmi_priv;
-static const struct class *fw_attr_class;
 static DEFINE_MUTEX(tlmi_mutex);
 
 /* ------ Utility functions ------------*/
@@ -1272,11 +1271,7 @@ static int tlmi_sysfs_init(void)
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
@@ -1385,9 +1380,8 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
 fail_class_created:
-	fw_attributes_class_put();
 	return ret;
 }
 
@@ -1610,8 +1604,7 @@ static int tlmi_analyze(void)
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



