Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5A224AEF;
	Thu,  9 Oct 2025 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025477; cv=none; b=kgE2TAF6AnfgCJglkCunKQT0IJyHaUwP5JHvk62ZkJZ6Qoz6owLWzhTJbX6tzphR/K9QJbDo8dhdPjnIoR+K6Wsuq4KRUh6cAFhIPISRv4jAf7s+TIeUTcP18l+TVBkg/B5hFFE10xjeKQyiE+gUPel4lUV8eqWedGeQsMc2kQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025477; c=relaxed/simple;
	bh=4L2YR+eu9T2l5uBTdNJ+L5qMxcFHeYzv3+MxaV0q/TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sswuj0UcrmlHrfjKtAlrzPydjOyIDQPw1eXGM3oZYDUr6IUIeSypRBLlnN1heLtmwocVRIq2s6rO3S8uoYXSLfRu2rzSMsmoRCxxpDhvEnRk3CmjjtAGDcvN8OvdizjOhLJJDF3RIw+t0Xx5PZnnN73ExpsFpHxKHzxMMiVdcKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lL7cYKCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lL7cYKCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B767C4CEE7;
	Thu,  9 Oct 2025 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025477;
	bh=4L2YR+eu9T2l5uBTdNJ+L5qMxcFHeYzv3+MxaV0q/TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lL7cYKCp6O0kZ5tkchhAWHE5b1gWdVZwDzBGWyu1JsKabZ11lKqPnosqv6R/qRfFw
	 JGPvuBZ/XLb3s2jPIPO0dbDXx/bY+IWXQklXMHDV8/hrVXJFt0b6rgZ1aYR5SveRpv
	 uv+pCukaa2bmyJCSrhLKgsL0H5t7e6U7TALas5vZ1eaKzKL2bpttFTLa0eD5m9Rz8+
	 dAolZknqTdeCXSeoP0OGVn8pEp7lzMAdQ3kvInDzolHKCGg8BC1kPZ6SAuoHxIgBxU
	 wWCMHQzqRgY6wJsARxPZjQaUXIrs6T8dgxjufEc+/MKVC60UvF3OQXtFALTa/Gr9HK
	 9MG339dqwEOIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] mfd: intel-lpss: Add Intel Wildcat Lake LPSS PCI IDs
Date: Thu,  9 Oct 2025 11:54:29 -0400
Message-ID: <20251009155752.773732-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit c91a0e4e549d0457c61f2199fcd84d699400bee1 ]

Add Intel Wildcat Lake PCI IDs.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250915112936.10696-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch only extends the `intel_lpss_pci_ids[]` match
  table in `drivers/mfd/intel-lpss-pci.c` by adding a new Wildcat Lake
  (WCL) block with 13 PCI IDs that bind to existing platform
  configurations:
  - New IDs at `drivers/mfd/intel-lpss-pci.c:371`..`:382`:
    - UART: `0x4d25`, `0x4d26`, `0x4d52` → `bxt_uart_info`
    - SPI: `0x4d27`, `0x4d30`, `0x4d46` → `tgl_spi_info`
    - I2C: `0x4d50`, `0x4d51`, `0x4d78`, `0x4d79`, `0x4d7a`, `0x4d7b` →
      `ehl_i2c_info`
- Uses existing, well-vetted configs: The mappings reference existing
  platform info structures that have been in the tree for a long time:
  - `bxt_uart_info` at `drivers/mfd/intel-lpss-pci.c:156` (100 MHz, UART
    swnode)
  - `ehl_i2c_info` at `drivers/mfd/intel-lpss-pci.c:229` (100 MHz, BXT
    I2C properties)
  - `tgl_spi_info` at `drivers/mfd/intel-lpss-pci.c:243` (100 MHz, CNL
    SSP type)
  No new logic, no new properties, no quirk changes—just table entries
that reuse existing variants.
- Scope and risk: Minimal and contained. Only affects new devices by
  enabling binding of the LPSS MFD on WCL hardware. No impact on
  existing platforms or probe/remove paths. It’s a classic device-ID
  addition.
- User-visible effect: Without these IDs, WCL systems will not attach
  LPSS subdevices (I2C/SPI/UART), which commonly breaks I2C HID input,
  sensors, serial, etc. This is a functional fix for users running
  stable kernels on WCL systems.
- Dependencies/backporting notes: No architectural changes and no API
  churn. On some older stable trees the SPI info symbol was named
  `tgl_info` instead of `tgl_spi_info`; the backport is a trivial name
  adjustment. The referenced info structs (`bxt_uart_info`,
  `ehl_i2c_info`, and TGL SPI info) exist in maintained stable series.
- History/regression check: The addition was introduced by c91a0e4e549d
  (“mfd: intel-lpss: Add Intel Wildcat Lake LPSS PCI IDs”), and there
  are no follow-up fixups or reverts touching these WCL IDs. Similar ID-
  only additions for newer Intel platforms (e.g., Arrow Lake-H, Panther
  Lake) have been accepted and are low-risk by precedent.
- Stable policy fit: This is a small, self-contained, obviously correct
  device-ID enablement that fixes real hardware non-functionality
  without changing behavior elsewhere—well within what stable trees
  routinely accept.

Conclusion: Backporting this commit is safe and beneficial to users on
WCL hardware, with minimal regression risk and no architectural impact.

 drivers/mfd/intel-lpss-pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
index 1a5b8b13f8d0b..8d92c895d3aef 100644
--- a/drivers/mfd/intel-lpss-pci.c
+++ b/drivers/mfd/intel-lpss-pci.c
@@ -367,6 +367,19 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x4b79), (kernel_ulong_t)&ehl_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x4b7a), (kernel_ulong_t)&ehl_i2c_info },
 	{ PCI_VDEVICE(INTEL, 0x4b7b), (kernel_ulong_t)&ehl_i2c_info },
+	/* WCL */
+	{ PCI_VDEVICE(INTEL, 0x4d25), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x4d26), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x4d27), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x4d30), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x4d46), (kernel_ulong_t)&tgl_spi_info },
+	{ PCI_VDEVICE(INTEL, 0x4d50), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x4d51), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x4d52), (kernel_ulong_t)&bxt_uart_info },
+	{ PCI_VDEVICE(INTEL, 0x4d78), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x4d79), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x4d7a), (kernel_ulong_t)&ehl_i2c_info },
+	{ PCI_VDEVICE(INTEL, 0x4d7b), (kernel_ulong_t)&ehl_i2c_info },
 	/* JSL */
 	{ PCI_VDEVICE(INTEL, 0x4da8), (kernel_ulong_t)&spt_uart_info },
 	{ PCI_VDEVICE(INTEL, 0x4da9), (kernel_ulong_t)&spt_uart_info },
-- 
2.51.0

