Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694822C21E3;
	Tue, 12 Aug 2025 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025054; cv=none; b=KIZWIrILm74JeOeDaNC2xs4SQP+OAemyWTZN8wUHv9yDD05g72SgIj6Bn4yQ1K4GwlclficAt4HCjJm99K85pF/sDPiHSmvq4+87PYVZsJq3ukENPq+fPOAtbhxmBA8sUJU4dcbdT882vPn0r4ud8+3curn5fpQ2elsP691Fn7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025054; c=relaxed/simple;
	bh=yZAIuE4mfVt9Fc8s3J+S7ad86KTD105cup/6+1lg5gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIytMG4yiAYmPKU9++yJo69Pw1Fi0Ko9jDP9bpRVJrux/r7XW0MZ49TJAPtB9tr1lwDN7Qpm1EPmsGMOy8BhdmuPxNXZ2Y6j5/5/4nA6FPnPwkwTUFnYS3qPSe30IxIST0cvkWudXK+gDoGXDcyFwbr1nMO10fAWeY2apW9uIbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPNYr8rh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPNYr8rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36CDC4CEF0;
	Tue, 12 Aug 2025 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025054;
	bh=yZAIuE4mfVt9Fc8s3J+S7ad86KTD105cup/6+1lg5gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPNYr8rhTlyMt66L6jP0w4TbJDaYxg2/zzG8kMJNCUCS44/xUI8dBmMTOEVarnWcs
	 MgcXgsGmQ3/WRlsZ4o43sV1TkDHG6q/heRUP97l/VivVl5XDdDwJZsbmRaFm6/rNxH
	 TCDMegzrCwDv0lkSWZFi4t/4y5vqFR1DSvu0TFCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 555/627] irqchip: Build IMX_MU_MSI only on ARM
Date: Tue, 12 Aug 2025 19:34:10 +0200
Message-ID: <20250812173453.012023440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3b6a18f0da8720d612d8a682ea5c55870da068e0 ]

Compile-testing IMX_MU_MSI on x86 without PCI_MSI support results in a
build failure:

drivers/gpio/gpio-sprd.c:8:
include/linux/gpio/driver.h:41:33: error: field 'msiinfo' has incomplete type
drivers/iommu/iommufd/viommu.c:4:
include/linux/msi.h:528:33: error: field 'alloc_info' has incomplete type

Tighten the dependency further to only allow compile testing on Arm.
This could be refined further to allow certain x86 configs.

This was submitted before to address a different build failure, which was
fixed differently, but the problem has now returned in a different form.

Fixes: 70afdab904d2d1e6 ("irqchip: Add IMX MU MSI controller driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250805160952.4006075-1-arnd@kernel.org
Link: https://lore.kernel.org/all/20221215164109.761427-1-arnd@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index c3928ef79344..5f47e9a9c127 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -539,6 +539,7 @@ config IMX_MU_MSI
 	tristate "i.MX MU used as MSI controller"
 	depends on OF && HAS_IOMEM
 	depends on ARCH_MXC || COMPILE_TEST
+	depends on ARM || ARM64
 	default m if ARCH_MXC
 	select IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY
-- 
2.39.5



