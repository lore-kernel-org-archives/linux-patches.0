Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A02EE286;
	Tue, 17 Jun 2025 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177202; cv=none; b=X4g/Wr2sfszLzGYexrS1ro6upRGPEUOuaATFfB+R7fYbQw1lgtgx0/ccxZizpL5FzQ12tsJ6joe0vQp97+K1n0t5zNROy9gD3lRYvP1VPMG7MWIotUQ0T9p7Ux5fGKL6KxuvRr7qeftgxHuY73AeePGzkNhxtADclESP8RnRing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177202; c=relaxed/simple;
	bh=3ceKxB66v8R6Ks33kTiiALSx83H9SBNiL9x0WrkJjgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZ7eOWJXx3388K/EdyaCJIM4DqsshwU5a1UpPwGFv734bs7cHQafb9OIgb900F8J2YQUMbsEp74TujAV1QJTbIO+E9Bu0Vawxk2XE33PMzMNVDSW9eafGrZQDmTljqXqdc+xz+L/zwlg7zgch/9y0xCs/IimcBkQ2ZIufXKSfqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTwXjs4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTwXjs4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B7BC4CEE3;
	Tue, 17 Jun 2025 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177202;
	bh=3ceKxB66v8R6Ks33kTiiALSx83H9SBNiL9x0WrkJjgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTwXjs4eByn0NF2KNzUjy+8vHrA5Cm3topSkzsX1S/oWRMDzBqmiF66yngRZ+N/y2
	 Ufb8jBAWpJrxVMVSLsnCWGw+44dwIYw2Rl9KD5BvoKve9ZPOywLQjQNxhWVg7RAxZa
	 gLZ51Tz/ahllxZ0onhQ+7QaDhrT4j/6JVB00dIp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eb@emlix.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 271/780] iommu: remove duplicate selection of DMAR_TABLE
Date: Tue, 17 Jun 2025 17:19:39 +0200
Message-ID: <20250617152502.503347273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cd750f512deee..bad585b45a31d 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -199,7 +199,6 @@ source "drivers/iommu/riscv/Kconfig"
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
-	select DMAR_TABLE if INTEL_IOMMU
 	help
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-- 
2.39.5



