Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4AC881E;
	Tue,  8 Jul 2025 16:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992239; cv=none; b=Cq1w+Zs50kn1Xgv7sbjKcIXcP2dOCXN0LiDw2AjXvePbgwwokC4ZUdJF1tZN+XBX4nl5/iEzXTzSCi7Dw4eQRzVUWtgoV5yuHmDZi4C1UW8PiHwi46f/tE8UPfxz9cRF1GUzGC+KGzPMemF3+dq1P/ww07XgdYy9LuWoPAl3/dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992239; c=relaxed/simple;
	bh=jpkqf1vCz/tltOfB1oB45JZ+TP6J0/f2hyR66qVK1HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl0Tti7FfNAs9iOHjQQdHb5H/uHmzwCgXDNifcrSuaD14wafOU1cswdNTh+cRdM3w9ESK85gTaSbQ5BE1sxBUcS2DlxG9e5KaEPJYZZlCoDlcSoOnPnkEN25rCpAJS0Bz9pOnOSiXU0I7id24YXg0HqspnFwgKQkoTqQ3JQhGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAd7RYOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAd7RYOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F98CC4CEED;
	Tue,  8 Jul 2025 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992237;
	bh=jpkqf1vCz/tltOfB1oB45JZ+TP6J0/f2hyR66qVK1HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAd7RYOrqzVcKwA43H5ZS23KFGi3v17QfF0DOvVrYPO1Aq7P1MzawwjpDMC2OKVQZ
	 5kJzhD43M4MVVbO7CYXKL6Yh6Ar/jJKWZRXL6PQ03KtJ14ReUZowhXG6WjHn2KaRZU
	 nWcZ0iK8rNCG9A8L5anYgPXIE7MZrLVUUfS2FqTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/132] scsi: ufs: core: Fix spelling of a sysfs attribute name
Date: Tue,  8 Jul 2025 18:22:16 +0200
Message-ID: <20250708162231.454804695@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 021f243627ead17eb6500170256d3d9be787dad8 ]

Change "resourse" into "resource" in the name of a sysfs attribute.

Fixes: d829fc8a1058 ("scsi: ufs: sysfs: unit descriptor")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250624181658.336035-1-bvanassche@acm.org
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 2 +-
 drivers/ufs/core/ufs-sysfs.c               | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 0c7efaf62de0c..84131641580c9 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -711,7 +711,7 @@ Description:	This file shows the thin provisioning type. This is one of
 
 		The file is read only.
 
-What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resourse_count
+What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_resource_count
 Date:		February 2018
 Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
 Description:	This file shows the total physical memory resources. This is
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3692b39b35e78..6c48255dfff02 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1278,7 +1278,7 @@ UFS_UNIT_DESC_PARAM(logical_block_size, _LOGICAL_BLK_SIZE, 1);
 UFS_UNIT_DESC_PARAM(logical_block_count, _LOGICAL_BLK_COUNT, 8);
 UFS_UNIT_DESC_PARAM(erase_block_size, _ERASE_BLK_SIZE, 4);
 UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
-UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8);
+UFS_UNIT_DESC_PARAM(physical_memory_resource_count, _PHY_MEM_RSRC_CNT, 8);
 UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
 UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
 UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
@@ -1295,7 +1295,7 @@ static struct attribute *ufs_sysfs_unit_descriptor[] = {
 	&dev_attr_logical_block_count.attr,
 	&dev_attr_erase_block_size.attr,
 	&dev_attr_provisioning_type.attr,
-	&dev_attr_physical_memory_resourse_count.attr,
+	&dev_attr_physical_memory_resource_count.attr,
 	&dev_attr_context_capabilities.attr,
 	&dev_attr_large_unit_granularity.attr,
 	&dev_attr_wb_buf_alloc_units.attr,
-- 
2.39.5



