Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02D230AACA;
	Thu, 19 Feb 2026 02:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466698; cv=none; b=GgcTucE/zVV2D/RoC0rtAOS1WkHDTUIUSAxmgYmQyWSK0c5iFgcsRBZkHi5tWPpljN+UteStj9WRtAG16I0xq+ikxuLVJGI6K49qCouOk8LSI8UFvgTU9aWjt3uWhaY7/rnwmdL6bflNsFtkKFLRUVVBjVoiBxqv8bPxN3vNsgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466698; c=relaxed/simple;
	bh=e1QKYOEoJfJuHxB3889YBgLbPInb2ZzwwOWVGKzfyug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFOFK6YV2LwW22btzNgOTQ6Q9mZX8N/f20WmT7zyYAnJPPIcg1Vy54mJjzmg4we24duntoB30wy9XAwqS/QY0DCM5zWJy2MCQOdCQQk6xbaX6aV/iFsA6XfCM4vpLfERPreBKuh8VQ0iGPhUfj2qo+O+iV/DjuoJYUBgC7XLWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjEUZwVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjEUZwVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F7C19424;
	Thu, 19 Feb 2026 02:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466698;
	bh=e1QKYOEoJfJuHxB3889YBgLbPInb2ZzwwOWVGKzfyug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjEUZwVHfFiYtg6/KBj+VHfPr3i0cFN6Qbry5RW0fd64tN2WXs9GoIopr4DU5wc0r
	 HTPxU/8lqBNKPehfuhX4jqOEW4zwzIEUmoFytc3GnzH6RpWUorFymJaWAFo2JT0Os1
	 s4X67+B+rUINRg47dUFoEkiYGOErz/lkDeZLIQNmXHWAYuMHAElEzWKksFlZ6Rtl5q
	 Rrh3ZcWEfCmM6upuNj7UL/mOa7pOSeMIxGqEqeVBRAyXGfw7+PpQcI02XQWriUgJft
	 CYmlybxRLHX3bYgVIXYebSdQpa+93P1s8ZmpJb3nYLDVgWYSoemI3g54prTiQVqRLA
	 ghmiP+Ls2UF1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] mfd: intel-lpss: Add Intel Nova Lake-S PCI IDs
Date: Wed, 18 Feb 2026 21:04:03 -0500
Message-ID: <20260219020422.1539798-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
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

LLM Generated explanations, may be completely bogus:

All three info structures (`bxt_uart_info`, `tgl_spi_info`,
`ehl_i2c_info`) are well-established and used extensively throughout the
driver for many other Intel platforms. The new NVL-S entries simply map
new PCI device IDs to these existing, proven structures.

### Classification

This is a **new device ID addition** — one of the explicit exceptions to
the "no new features" stable rule. It falls squarely under the "NEW
DEVICE IDs" category:
- The driver (`intel-lpss-pci`) already exists in all stable trees
- Only PCI IDs are being added — no new code, no new info structures, no
  new logic
- The device info structures referenced are already present and well-
  tested

### Scope and Risk Assessment

- **Lines changed**: 12 lines added, 0 lines modified, 0 lines deleted
- **Files touched**: 1 (`drivers/mfd/intel-lpss-pci.c`)
- **Risk**: Essentially zero. Adding entries to a PCI ID table cannot
  break existing functionality. The new entries only activate for
  hardware with matching PCI IDs (Nova Lake-S), and they reuse existing
  well-tested device info structures.
- **No dependencies**: This is fully self-contained.

### User Impact

Users with Intel Nova Lake-S hardware need these IDs for LPSS (Low Power
Subsystem) peripherals to work — I2C, SPI, and UART controllers. Without
these IDs, the LPSS driver won't bind to the devices, meaning I2C, SPI,
and UART peripherals on Nova Lake-S systems won't function.

### Verification

- Verified that `bxt_uart_info`, `tgl_spi_info`, and `ehl_i2c_info` are
  all defined in the same file (lines 156, 243, 229 respectively) —
  confirmed via Grep.
- Verified the change is purely additive (12 new PCI_VDEVICE entries)
  with no modifications to existing entries or logic — confirmed from
  the diff.
- Verified the pattern matches dozens of other platform ID additions in
  the same file (APL, RPL-S, ARL-H, TGL, ADL, etc.) — confirmed via Grep
  showing extensive use of these same info structures.
- The commit is authored by Ilpo Järvinen (Intel) and acked by Andy
  Shevchenko (Intel), both established kernel contributors — confirmed
  from commit metadata.

### Conclusion

This is a textbook example of a new device ID addition that should be
backported to stable. It:
- Uses existing, proven driver infrastructure
- Is trivially correct (PCI ID table entries)
- Has zero risk of regression to existing users
- Enables hardware support for Nova Lake-S platform users
- Is small, self-contained, and has no dependencies

**YES**

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

