Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D972F2F12B0;
	Fri, 17 Oct 2025 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715018; cv=none; b=EKokMOwn4hAhDa4yJzyH7CbkYM3u/7I9G08S1kjZMPXRPJs/8TzpUlAKuLbAEahA4yo271snRqaFLsFAxMWkMjaGZqqkZHjWHeMrFoSyV1zVq3wzmWjMSaPyqLrKWZvmagQTJVZ0Es5YiMuApi186A6PXcVsqrcwLtWezOkCjQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715018; c=relaxed/simple;
	bh=eulh7JLEU6m1CXhvnYfPlEJn0fDJyXv8uOeZFpCKGwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMI9VS7OMj/tr5ZFATAH8hqcQL36YhJzVLbU9V7nMMlfPN/BJL9T1sxZTNT9Rnb/rnkDJWPiA8WnxT/Fk8cm3uW8p/aJnqsMDmDl60vsCNq1PV8yvhLcVVEJO4eSCBhtOXDdCX3dk6by0FhWohqV4vbksOfd811qNtQZqMqE9No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK2a8n6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK2a8n6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E58C4CEE7;
	Fri, 17 Oct 2025 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715018;
	bh=eulh7JLEU6m1CXhvnYfPlEJn0fDJyXv8uOeZFpCKGwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mK2a8n6AVpRRK53Szi94aUCWjOjNuDEtdcd3Voy1NkLIo4E2MTnAD7ZPefWWRpzdW
	 7BbI8DINjyBB1pXN5WcoGgoqcU/tRg+SKfeDXAa9G5JBKMDQ4Euh7XB8mVrIKM6GNL
	 n2Fa9x/Kd+UqNARWoYUZTTruWTxjM+j2QXlkadyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lee <chullee@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 070/371] scsi: ufs: sysfs: Make HID attributes visible
Date: Fri, 17 Oct 2025 16:50:45 +0200
Message-ID: <20251017145204.469342901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lee <chullee@google.com>

[ Upstream commit bb7663dec67b691528f104894429b3859fb16c14 ]

Call sysfs_update_group() after reading the device descriptor to ensure
the HID sysfs attributes are visible when the feature is supported.

Fixes: ae7795a8c258 ("scsi: ufs: core: Add HID support")
Signed-off-by: Daniel Lee <chullee@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-sysfs.c | 2 +-
 drivers/ufs/core/ufs-sysfs.h | 1 +
 drivers/ufs/core/ufshcd.c    | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0086816b27cd9..c040afc6668e8 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
 
-static const struct attribute_group ufs_sysfs_hid_group = {
+const struct attribute_group ufs_sysfs_hid_group = {
 	.name = "hid",
 	.attrs = ufs_sysfs_hid,
 	.is_visible = ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 8d94af3b80771..6efb82a082fdd 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,5 +14,6 @@ void ufs_sysfs_remove_nodes(struct device *dev);
 
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
+extern const struct attribute_group ufs_sysfs_hid_group;
 
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 96a0f5fcc0e57..465e66dbe08e8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8482,6 +8482,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
 
+	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
-- 
2.51.0



