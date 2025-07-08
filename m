Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0012E659;
	Tue,  8 Jul 2025 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992081; cv=none; b=NxSAcJbDigA9p+NcId1a4fu612yVv+qN34K+Fz/XrjUzsI1g73FYWgCr2PI/fXsetTqa3FP41gSmgg7G2vixbDyGOD/Nwcie8MW2Vfgymaxfik/s71bYctiVlXKbli0/H1uVzOYwB9YMS331HYyUbBWZA/zIxt+7zEc+1dTvvFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992081; c=relaxed/simple;
	bh=2s5SU0k/lkhKUs2U3Dns6+QMVnp4RwGYV4b59NK2OKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al4g7V7Jbx0UlM0enhhiMvvG2Ct970QhfLmPWGf1tO9tTb2kG9EXxQQ61vr3naGHwtADFnNxNbPKO531R9WsIEiS5Url0VDfSG7RHeCQ0jwkqVX2NczoznJ9sQmcVov06YtsCte2L6ZjS7ftJCk09MMuGJFrc9JXhsDevJUIsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWpsNUX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWpsNUX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C73C4CEED;
	Tue,  8 Jul 2025 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992081;
	bh=2s5SU0k/lkhKUs2U3Dns6+QMVnp4RwGYV4b59NK2OKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWpsNUX2bVYjDce7a9TeCBBm8rdxrf4MpFYBM6/6PmykTz9vL8um6NKMm818gtxmA
	 Bk9S6RJrB1nsHWjLfqdLTtccxFoQLiGN7a8DDQjIO6LD7DgFWJdQD/zUaQ4A2bpl2L
	 BjNnmC2QgT3CeTcYhwcLEsVWjnOgGt3C0gHuHnWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/81] scsi: ufs: core: Fix spelling of a sysfs attribute name
Date: Tue,  8 Jul 2025 18:23:14 +0200
Message-ID: <20250708162225.636353536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 228aa43e14ed5..70f8c2e9c00d1 100644
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
index 17e38979b8223..ff30e2d22d906 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1262,7 +1262,7 @@ UFS_UNIT_DESC_PARAM(logical_block_size, _LOGICAL_BLK_SIZE, 1);
 UFS_UNIT_DESC_PARAM(logical_block_count, _LOGICAL_BLK_COUNT, 8);
 UFS_UNIT_DESC_PARAM(erase_block_size, _ERASE_BLK_SIZE, 4);
 UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
-UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8);
+UFS_UNIT_DESC_PARAM(physical_memory_resource_count, _PHY_MEM_RSRC_CNT, 8);
 UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
 UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
 UFS_UNIT_DESC_PARAM(hpb_lu_max_active_regions, _HPB_LU_MAX_ACTIVE_RGNS, 2);
@@ -1282,7 +1282,7 @@ static struct attribute *ufs_sysfs_unit_descriptor[] = {
 	&dev_attr_logical_block_count.attr,
 	&dev_attr_erase_block_size.attr,
 	&dev_attr_provisioning_type.attr,
-	&dev_attr_physical_memory_resourse_count.attr,
+	&dev_attr_physical_memory_resource_count.attr,
 	&dev_attr_context_capabilities.attr,
 	&dev_attr_large_unit_granularity.attr,
 	&dev_attr_hpb_lu_max_active_regions.attr,
-- 
2.39.5



