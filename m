Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4463328507B;
	Sat, 14 Feb 2026 21:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104382; cv=none; b=pMeuDAeSFK/BKvjfrEhFCYcfydlA8U2jOnR0za0larKVhNG7KRvbANRpnF2e1kqLnyziSwi+Y8zRSvYYmYqc/2PiqoRWJX57oAnoRoDYJ70P46Du1yXqrNq5vGfZt/UPL+AUy0ETABhafWSJz1zatfhvXh0zgPUVKdxn6s+Tnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104382; c=relaxed/simple;
	bh=bFaeGYrHeuWOkuFHsyABSZ7c6pir7L/2GY3P/ZYUhuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxamGOqoqQPlT1y7objy/IW5+ISL7DkQrKlGsnb7+hcCTm4r5CCJsB2G5cb2cZEPpdMvELgtDfZNuKy69ZnXEXjGPgnj8QgcIERO111rAgiU2dcixPkUIsPXuXPxTwij6ZYKCM6ra6j+weasKpf6hSUB2Q9ByzK79vi83eSK9NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUNGANXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUNGANXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C0FC16AAE;
	Sat, 14 Feb 2026 21:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104382;
	bh=bFaeGYrHeuWOkuFHsyABSZ7c6pir7L/2GY3P/ZYUhuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUNGANXpvdFUYASlGNoEfKVYbUxAtnHxkUKvUxee0m4GK2j7x8GvTZffnE9OV2am0
	 Kz626TeqqQnciA2EfGAvuFbj8ZhR4qD/9qWTIRs2bbHyYkW8prL3tpFbtzqqRNTt7a
	 DAUqWMzbMqROWnrabearWA9iPUbyiqA2tgqF8+TGukVbQg4YRwKZZ9/Bm6JdqGXVi/
	 Ft2P44AkgId58e9Q0d0EJ2f2G6t3FdursBtCziZ5JuzUyTxxxhtFEi0rGbRxHDEVrY
	 r4ZffErk/LfL2GmPuYQe6puRZy84mBGlAn0kioYg6u9I006b3ib0OCOXGIv2QC+2Hm
	 6P0IT/jRx4HoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] PCI: Add ACS quirk for Qualcomm Hamoa & Glymur
Date: Sat, 14 Feb 2026 16:23:20 -0500
Message-ID: <20260214212452.782265-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 44d2f70b1fd72c339c72983fcffa181beae3e113 ]

The Qualcomm Hamoa & Glymur Root Ports don't advertise an ACS capability,
but they do provide ACS-like features to disable peer transactions and
validate bus numbers in requests.

Add an ACS quirk for Hamoa & Glymur.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260109-acs_quirk-v1-1-82adf95a89ae@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

This commit adds ACS (Access Control Services) quirk entries for two
Qualcomm root port devices: Hamoa (device ID 0x0111) and Glymur (device
ID 0x0120). The commit message explains that these root ports don't
advertise ACS capability but do provide ACS-like features to disable
peer transactions and validate bus numbers.

### Code Change Analysis

The change is extremely simple and contained:
- **4 lines added** (2 comment lines + 2 data entries) in
  `drivers/pci/quirks.c`
- Adds two new entries to the `pci_dev_acs_enabled` table
- Both entries use `PCI_VENDOR_ID_QCOM` with the existing
  `pci_quirk_qcom_rp_acs` handler
- The pattern is identical to the existing QCOM SA8775P, QDF2xxx, and
  HXT entries already in the table

### Classification: Hardware Quirk / Device ID Addition

This falls squarely into the **"QUIRKS and WORKAROUNDS"** exception
category for stable backports:

1. **It's a PCI quirk** for hardware with broken/missing ACS
   advertisement
2. **The infrastructure already exists** - `pci_quirk_qcom_rp_acs` is
   already in the kernel and used by other Qualcomm devices
3. **Only data table entries are added** - no new code logic whatsoever
4. **It enables correct IOMMU isolation** on these platforms

### Why This Matters

ACS quirks are important for:
- **VFIO/PCIe passthrough**: Without the ACS quirk, IOMMU groups may be
  incorrectly merged, preventing device assignment to VMs
- **Security isolation**: ACS ensures peer-to-peer transactions between
  devices go through the IOMMU, which is critical for DMA security
- **Functionality**: Users with Qualcomm Hamoa or Glymur platforms
  cannot properly use PCIe device passthrough without this quirk

### Risk Assessment

- **Risk: Extremely low** - This only adds entries to a static data
  table. The quirk function `pci_quirk_qcom_rp_acs` is already proven
  and used by other QCOM devices. The new entries will only match on the
  specific vendor:device combinations, so no other hardware is affected.
- **Benefit: Real** - Users with these Qualcomm platforms get correct
  IOMMU group isolation
- **Dependencies: None** - The `pci_quirk_qcom_rp_acs` function and
  `PCI_VENDOR_ID_QCOM` already exist in stable trees
- **Backport complexity: Trivial** - The patch should apply cleanly to
  any stable tree that has the QCOM SA8775P entry (or can be trivially
  adjusted)

### Scope and Stability

- 4 lines of change in a single file
- Pure data addition to an existing table
- No logic changes, no new functions, no new APIs
- Zero risk of regression for any other hardware
- Well-tested pattern (dozens of similar quirk entries exist)

This is a textbook example of a hardware quirk addition that is
appropriate for stable trees. It's small, obviously correct, uses
existing infrastructure, and enables real hardware to work properly.

**YES**

 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9100fd133a7ff..54c76ba9a767e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5117,6 +5117,10 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_QCOM, 0x0401, pci_quirk_qcom_rp_acs },
 	/* QCOM SA8775P root port */
 	{ PCI_VENDOR_ID_QCOM, 0x0115, pci_quirk_qcom_rp_acs },
+	/* QCOM Hamoa root port */
+	{ PCI_VENDOR_ID_QCOM, 0x0111, pci_quirk_qcom_rp_acs },
+	/* QCOM Glymur root port */
+	{ PCI_VENDOR_ID_QCOM, 0x0120, pci_quirk_qcom_rp_acs },
 	/* HXT SD4800 root ports. The ACS design is same as QCOM QDF2xxx */
 	{ PCI_VENDOR_ID_HXT, 0x0401, pci_quirk_qcom_rp_acs },
 	/* Intel PCH root ports */
-- 
2.51.0

