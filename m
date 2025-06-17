Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122AB2ECD2F;
	Tue, 17 Jun 2025 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174975; cv=none; b=nBDh4P3qq8nR7qTxHisztx5/7UJV5RN/79Q9BqV33N00E0cyirB1A8unHAHmX5eklk/I7QyMDLROvrwfnIioKIslBj+ulLQq3W3tAk6Rc7mYpJnqAR54kCO9k7uccK1WJW/TRM7c3ezi9unjuS5UhCmuIsfn/OH5wiILJyQ0RI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174975; c=relaxed/simple;
	bh=vIKSRr30tzMzTTjJswWoECTKVMQJeI95naqkSvwr4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH8Zr+amF337YuzPWQrgLgNI3Wxb2k1h8NogkzzvbP2J60ndHbsHmYnP8HEb9i9HBUtp7ZPyR8Tdt/lJM9Tv76+vrQ3laW2rQe1wHFSZhMOZby2k/Dlu1pI5vxLl8bthToYgtajHxsEC5RFOBhEudFp25VEPmcHVspIiIhQevnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmF3zLnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmF3zLnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98267C4CEF0;
	Tue, 17 Jun 2025 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174974;
	bh=vIKSRr30tzMzTTjJswWoECTKVMQJeI95naqkSvwr4Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmF3zLnHII9lBes09IZX6EmMtyCLsy+Zcbcf+mOp3Y2azl+alj7+1nk1v31KdAPjt
	 fMd5JQI2lTOVeH3D0dbf3MsUs+6USGRlEhrj1dLMhzKPAI8VqDqV4N2pBxJTZZx6mA
	 PmQ8G8wNiX2hwY3josDPpbsncAFKtgFupcjLK26M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eb@emlix.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/356] iommu: remove duplicate selection of DMAR_TABLE
Date: Tue, 17 Jun 2025 17:24:01 +0200
Message-ID: <20250617152343.307706553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Rolf Eike Beer <eb@emlix.com>

[ Upstream commit 9548feff840a05d61783e6316d08ed37e115f3b1 ]

This is already done in intel/Kconfig.

Fixes: 70bad345e622 ("iommu: Fix compilation without CONFIG_IOMMU_INTEL")
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/2232605.Mh6RI2rZIc@devpool92.emlix.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d57c5adf932e3..20aa5ed80aa38 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -191,7 +191,6 @@ source "drivers/iommu/iommufd/Kconfig"
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
-	select DMAR_TABLE if INTEL_IOMMU
 	help
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-- 
2.39.5



