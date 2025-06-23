Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F211DF98B;
	Mon, 23 Jun 2025 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713248; cv=none; b=tH3zWAPelGQDKRFyH9+L/6k+dVwY4XxDfG94L+gYZRueyIpCHMJRmabJWRthHUf+lYu8Hou8Ix9rW5b15Rb0eju6T74QD5Se6RpkejZUtEqG1Dc5VfxZDnCOTvQpMxTAI12YLnnSCsuS3t6A2y/QWKRfWDvgCNAUo0u6lvLndI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713248; c=relaxed/simple;
	bh=Lu8axZud9lzZ8uBPyGIfqtrROcCDAujI86qdnp+jCI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+HlBKr/i+2rErx2G+9cw70F0obwr1BN9b5E2NW9stKNsyAJcZq2kvBhQEohJC2PWQab7z1BYxeyhgzXc3z+OUfe7gXK9vKKJk0vBhH+fkLPwRW+JPvUbImGaOAxcRTD6QOUN91pUssDz0PO8r6x1bUPPhizgh8PRNAMct4Md2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptOpLcNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptOpLcNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ECFC4CEEA;
	Mon, 23 Jun 2025 21:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713248;
	bh=Lu8axZud9lzZ8uBPyGIfqtrROcCDAujI86qdnp+jCI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptOpLcNdTKtZdv8X+VzXvgk/b6Q80m6Cj80zuMIyAN5+FgG5bYE5PjTfMd7u0CTB8
	 pkJckX2LE6Qr8WHHyIoA4zIj+4UQHOX6IkUb3t06xlzjzlAUs5tjDn3vuCVOBdiU9y
	 FOrg7WiYwyPXY2ttcEz+5nUSgI1+/wTtL5BuZNoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rolf Eike Beer <eb@emlix.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/508] iommu: remove duplicate selection of DMAR_TABLE
Date: Mon, 23 Jun 2025 15:02:11 +0200
Message-ID: <20250623130647.359980625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index dc19e7fb07cfe..fad36f0a4d14b 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -192,7 +192,6 @@ source "drivers/iommu/intel/Kconfig"
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
 	depends on X86_64 && X86_IO_APIC && PCI_MSI && ACPI
-	select DMAR_TABLE if INTEL_IOMMU
 	help
 	  Supports Interrupt remapping for IO-APIC and MSI devices.
 	  To use x2apic mode in the CPU's which support x2APIC enhancements or
-- 
2.39.5



