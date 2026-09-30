Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F53B2D1A;
	Wed, 30 Sep 2026 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791671; cv=none; b=bxbtY+AJnqCztzoksUcvJGiEsKBrSUefSNWGqpoa8rxof6BYeVrQ1ECyTJlvQuAdsagnSigQHodnU4VG4kwAWE4xk4Kxxtaf7zq5X1tQOMHlpSwro+n5SbrwLX0mv03aDa0XSQHgtTjEF3ka4p+46ojuum6LRCNJ3I20eewP/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791671; c=relaxed/simple;
	bh=UXMoihERcrzpIyu62MZS5S8nk1in5LRmgxDLCm642ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAgyK6NfO8CKZCl1O5O0rrASXl7AlwPUKL/SyFjEp8bY5Z4TkhWuSNHef8LtrAgP95Uu4CL30gJZg7E3d+inzqyAbYaDacIDpkbl3XSOfylilqoaF/ZIMF+uEKYtccTcmRxB8wNti8uw6qQtcGkc8DbEt87BNQ82XO6xJ+CL/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isyHjqee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isyHjqee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C50A1F00898;
	Wed, 30 Sep 2026 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791670;
	bh=RTLuXAi1IXWC6cH47xIT54B71oMfad6CZGm5V118fg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isyHjqeePF0jU4Jgq3kgYXDIN+umgAsJaOhKSxjbf+S9hO79mCAKhqgyv4AYa0PAN
	 h+PbM80yMbofbX4oMOmPmP5PyGfjX8Trg6SyTTnSxC3yTs5S4o5t5ThBszTwzo+gPh
	 qAq1UbzrUfuorV83xsNLgHqMQFg2JHIBXq3+os20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/752] Revert "scsi: smartpqi: Switch to attribute groups"
Date: Wed, 30 Sep 2026 17:23:57 +0200
Message-ID: <20260930152406.222384648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit e3789fa42d068f0c0c5c24063a1f941c8c4a8627.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 46 ++++++++++++---------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6ecc56fb9fb25..f1ba5087e0eed 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6664,22 +6664,20 @@ static DEVICE_ATTR(enable_r5_writes, 0644,
 static DEVICE_ATTR(enable_r6_writes, 0644,
 	pqi_host_enable_r6_writes_show, pqi_host_enable_r6_writes_store);
 
-static struct attribute *pqi_shost_attrs[] = {
-	&dev_attr_driver_version.attr,
-	&dev_attr_firmware_version.attr,
-	&dev_attr_model.attr,
-	&dev_attr_serial_number.attr,
-	&dev_attr_vendor.attr,
-	&dev_attr_rescan.attr,
-	&dev_attr_lockup_action.attr,
-	&dev_attr_enable_stream_detection.attr,
-	&dev_attr_enable_r5_writes.attr,
-	&dev_attr_enable_r6_writes.attr,
+static struct device_attribute *pqi_shost_attrs[] = {
+	&dev_attr_driver_version,
+	&dev_attr_firmware_version,
+	&dev_attr_model,
+	&dev_attr_serial_number,
+	&dev_attr_vendor,
+	&dev_attr_rescan,
+	&dev_attr_lockup_action,
+	&dev_attr_enable_stream_detection,
+	&dev_attr_enable_r5_writes,
+	&dev_attr_enable_r6_writes,
 	NULL
 };
 
-ATTRIBUTE_GROUPS(pqi_shost);
-
 static ssize_t pqi_unique_id_show(struct device *dev,
 	struct device_attribute *attr, char *buffer)
 {
@@ -6950,19 +6948,17 @@ static DEVICE_ATTR(ssd_smart_path_enabled, 0444, pqi_ssd_smart_path_enabled_show
 static DEVICE_ATTR(raid_level, 0444, pqi_raid_level_show, NULL);
 static DEVICE_ATTR(raid_bypass_cnt, 0444, pqi_raid_bypass_cnt_show, NULL);
 
-static struct attribute *pqi_sdev_attrs[] = {
-	&dev_attr_lunid.attr,
-	&dev_attr_unique_id.attr,
-	&dev_attr_path_info.attr,
-	&dev_attr_sas_address.attr,
-	&dev_attr_ssd_smart_path_enabled.attr,
-	&dev_attr_raid_level.attr,
-	&dev_attr_raid_bypass_cnt.attr,
+static struct device_attribute *pqi_sdev_attrs[] = {
+	&dev_attr_lunid,
+	&dev_attr_unique_id,
+	&dev_attr_path_info,
+	&dev_attr_sas_address,
+	&dev_attr_ssd_smart_path_enabled,
+	&dev_attr_raid_level,
+	&dev_attr_raid_bypass_cnt,
 	NULL
 };
 
-ATTRIBUTE_GROUPS(pqi_sdev);
-
 static struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
@@ -6977,8 +6973,8 @@ static struct scsi_host_template pqi_driver_template = {
 	.slave_configure = pqi_slave_configure,
 	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
-	.sdev_groups = pqi_sdev_groups,
-	.shost_groups = pqi_shost_groups,
+	.sdev_attrs = pqi_sdev_attrs,
+	.shost_attrs = pqi_shost_attrs,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.53.0



