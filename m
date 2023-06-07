Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672F34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A924CC433EF;
	Wed,  7 Jun 2023 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169261;
	bh=R/3dDBsTQVMSJNSLM49EAIqVkmO7MrgKF61TN9pBRrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsSYOtSW3RnHVmoAFh+d2bIISB7cQXZI9Jsw9T9hWYQLGrtabhKlsTcUiz+JgJ0z+
	 a3grs01+LCAl/GuyyvUzpxCCizdlyyoj79o2IE5GxEMarDsFa4ZopY2CnrkYYDBsfb
	 SyLlYgsXxVKugNJKd8Muns4+lAHzrSeUDcpAWHiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 014/286] iommu/amd: Fix up merge conflict resolution
Date: Wed,  7 Jun 2023 22:11:53 +0200
Message-ID: <20230607200923.467429618@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 8ec4e2befef10c7679cd59251956a428e783c0b5 ]

Merge commit e17c6debd4b2 ("Merge branches 'arm/mediatek', 'arm/msm', 'arm/renesas', 'arm/rockchip', 'arm/smmu', 'x86/vt-d' and 'x86/amd' into next")
added amd_iommu_init_devices, amd_iommu_uninit_devices,
and amd_iommu_init_notifier back to drivers/iommu/amd/amd_iommu.h.
The only references to them are here, so clean them up.

Fixes: e17c6debd4b2 ("Merge branches 'arm/mediatek', 'arm/msm', 'arm/renesas', 'arm/rockchip', 'arm/smmu', 'x86/vt-d' and 'x86/amd' into next")
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230420192013.733331-1-jsnitsel@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 24c7e6c6c0de9..471f40351f4c8 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -16,9 +16,6 @@ extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(struct amd_iommu *iommu, u16 devid);
 extern void amd_iommu_restart_event_logging(struct amd_iommu *iommu);
 extern void amd_iommu_restart_ga_log(struct amd_iommu *iommu);
-extern int amd_iommu_init_devices(void);
-extern void amd_iommu_uninit_devices(void);
-extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_set_rlookup_table(struct amd_iommu *iommu, u16 devid);
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
-- 
2.39.2



