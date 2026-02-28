Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0188426ECD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301184; cv=none; b=mwmOCIPKKocp1ZXPrWVwdXesu0S3WeYboNXBq+H++HFTEPdq108nj1CHrhzScXYauIo8RT1Pmc+qMujqLY5q2deM0qWVMWVgvI3E9VWnX6HEpCe2MPrg1LXVdQUzDXCseK3M1YQAMpx9TwgRwmnWNhHHOZQh0bZqCwW6SDDa+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301184; c=relaxed/simple;
	bh=0UMkOyGjMxIoCr9XoxNfWkc7FQFB4U5HlxQCUve25mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k2JEOoU0tGEcymLbNpim8Dplthli9kAG2QQtNSdSu54H+AouYyUbqWZlI/HxV9dNl2T3PRgDlqwCqyIuPgQBmUKBZPHWbBU/5h4JqtMYjYywKFsIySYMxCpedlOs+uoizKCzH1H1dqPKpWACJGgy9aWPNkt/K4u8hppa3nWD/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LClLwIRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LClLwIRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0E2C19424;
	Sat, 28 Feb 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301184;
	bh=0UMkOyGjMxIoCr9XoxNfWkc7FQFB4U5HlxQCUve25mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LClLwIRPQH2ve3drdq6OOR1wdbVGTzoBjaUTirw/ckGZ3Upzlb8GWytKg+vcyD9p5
	 dqTPf69yPXUee6YeDO4tTA1jkC5WmH6gbi6mlGkvFnQ8ru9e+JSEj5bIIzlwqLkuJW
	 XczsQlzYCyk/mfJMOXcQgtGweilaqCSvroTz3XWyo42RKGXPEy9VBGRkmf/rmO53RU
	 u3SAsBJwoE8oEkwKxJUYxYCxi6L1/uxrJ1kc1n/EtG+QdTiJ3gedabjNXvbTJmQNos
	 DXeX/OBQIXJTWNJQwI8AtTfOjP0tMZA9nDrpQLv30d/aKETZW+O5orVCfo6BtlhCfE
	 RAba+3esk8guQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/752] mfd: intel-lpss: Add Intel Nova Lake-S PCI IDs
Date: Sat, 28 Feb 2026 12:41:05 -0500
Message-ID: <20260228174750.1542406-354-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit cefd793fa17de708d043adab50e7f96f414b0f1d ]

Add Intel Nova Lake-S LPSS PCI IDs.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260113172151.48062-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel-lpss-pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 8d92c895d3aef..713a5bfb1a3c2 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -437,6 +437,19 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x5ac4), (kernel_ulong_t)&bxt_spi_info },
 	{ PCI_VDEVICE(INTEL, 0x5ac6), (kernel_ulong_t)&bxt_spi_info },
 	{ PCI_VDEVICE(INTEL, 0x5aee), (kernel_ulong_t)&bxt_uart_info },
+	/* NVL-S */
+	{ PCI_VDEVICE(INTEL, 0x6e28), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x6e29), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x6e2a), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x6e2b), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x6e4c), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x6e4d), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x6e4e), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x6e4f), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x6e5c), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x6e5e), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x6e7a), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x6e7b), (kernel_ulong_t)&ehl_i2c_info },
 	/* ARL-H */
 	{ PCI_VDEVICE(INTEL, 0x7725), (kernel_ulong_t)&bxt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x7726), (kernel_ulong_t)&bxt_uart_info },
-- 
2.51.0

