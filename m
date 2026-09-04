Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFA842C500;
	Fri,  4 Sep 2026 06:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503017; cv=none; b=M2WkOMjmX7ecLvw58LH0Me067RRpAhXQSRjRJ7KbFyk5vbVQXTw+AT555q+JjvF0EWyPp4/YAqziwhen2y2WMm862SVSDIKsukyRCNItnx+/hIeFLSeqxK0b0Hlv86ozMAdVdX8xkcxhWszZJB0AQJlKoZCxn/LmWTUQPBmtDIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503017; c=relaxed/simple;
	bh=7Oh7UxNWxW2grkiYQiBNx/umh/gh9iD/v1hha7VxY6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRgsIGM66ZkGDG8EPTNTrPxG5ixNXoYAVSHJQDI01hmIZhexu5va+6kBZgShGHTTY1dU7g3BWWiT2gST9Gc37TuvgmQQlxVg/D8QeqCF5rMNUuKgkIYajku67mZZ97F+DdA74D+l8R03yMbiCLioIoGRqMP8gA/KMrkMD3Glv/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTZ9B6zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTZ9B6zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763FC1F00A3E;
	Fri,  4 Sep 2026 06:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788503016;
	bh=ldIe0IJaNNwkzteBoCWbghYkABCWzzTFxKU9YyFGBQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTZ9B6zhxZ3EdT9u/hV7e9ZWF486qvXHTVFZA22kk89KcfEJXdUZoHRXsJhE4kibG
	 NNa1voPS0LKKMTDe5HtdML07qRYhh7S8PafUPeMgtbvhqeC+Mp/XguABMbiFSaoN56
	 yRbxrDUwGx4ZHek9WBsgsecPZAS78jvtea9EFJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Shiyuan <gaoshiyuan@baidu.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/403] iommu/amd: remove return value of amd_iommu_detect
Date: Fri,  4 Sep 2026 07:02:54 +0200
Message-ID: <20260904045743.235910491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Shiyuan <gaoshiyuan@baidu.com>

[ Upstream commit 5bb494d5cbb9a3403ba8b1c8bc145b42fc119078 ]

The return value of amd_iommu_detect is not used, so remove it and
is consistent with other iommu detect functions.

Signed-off-by: Gao Shiyuan <gaoshiyuan@baidu.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20250103165808.80939-1-gaoshiyuan@baidu.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c  | 10 ++++------
 include/linux/amd-iommu.h |  4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 36a814b6c4de5..0e270533bf12b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3484,25 +3484,23 @@ static bool amd_iommu_sme_check(void)
  * IOMMUs
  *
  ****************************************************************************/
-int __init amd_iommu_detect(void)
+void __init amd_iommu_detect(void)
 {
 	int ret;
 
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
-		return -ENODEV;
+		return;
 
 	if (!amd_iommu_sme_check())
-		return -ENODEV;
+		return;
 
 	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
 	if (ret)
-		return ret;
+		return;
 
 	amd_iommu_detected = true;
 	iommu_detected = 1;
 	x86_init.iommu.iommu_init = amd_iommu_init;
-
-	return 1;
 }
 
 /****************************************************************************
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 2b90c48a6a871..062fbd4c9b772 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -31,11 +31,11 @@ struct amd_iommu_pi_data {
 struct task_struct;
 struct pci_dev;
 
-extern int amd_iommu_detect(void);
+extern void amd_iommu_detect(void);
 
 #else /* CONFIG_AMD_IOMMU */
 
-static inline int amd_iommu_detect(void) { return -ENODEV; }
+static inline void amd_iommu_detect(void) { }
 
 #endif /* CONFIG_AMD_IOMMU */
 
-- 
2.53.0



