Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC84E2FDC20;
	Sat, 14 Feb 2026 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104434; cv=none; b=HGHuRtvUBYLtLmE4LZTU/PlptpBvJ08RtPASSRNqmF1+5+btliuXcJtlrVTUbAid4yueBlKlYBMDHEH7JmombxEhIkuJZtoz4vPdwKLJIQQXbRUK0wb/MiRyysN6+D3MPB0iaujQANrreZR96ewdnB9Gz7L1d3bg6WfkCkV6bbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104434; c=relaxed/simple;
	bh=ADDlhnTR7cwcVMYUjdmYp8M6NLsPPm/L7no9GKVAU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAyXpZAzyqk0p4305fFVFF3F/UriJfX9zBS/eYtboxQc7IU8vYy4fvVJa+Eho/2m0bH2bTbT7hSJg3vwfBZa5Ugq/RQ+P2DY1uS7fiCZKkTVI+i1fHjNg1J5Rb2GMTTXuRv/vQwZOXEObCg/0Uaos3k/dicL31IBNNpZewroHVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XPhVEB9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XPhVEB9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94471C19425;
	Sat, 14 Feb 2026 21:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104434;
	bh=ADDlhnTR7cwcVMYUjdmYp8M6NLsPPm/L7no9GKVAU3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPhVEB9EY9hlgoTQrCp9pDWs8KCbKjDS8aAcgT1LDe1x6Kb/3awTG+UzmVaTPFJqK
	 l8MQ3OWRyJ+AC0RJZhOd2uzNi+qKUVEj/WXzPivKIwgM+iacjzDGROIxhf6KAF/Jw8
	 we/mxI4SGaFOxf9hPVJ+BpcCJ2ds4nz31ef/8oZPHjD+mdf2naJpSF1oibebo+bUii
	 6WGS48Wn7wQJkKDPCbJNRjxuFMgpJrB2MAPUYVzf4G4td2GfdejVBsLoSSWCHwXpXS
	 w/1TZmywFBU8z1OG/KlnfADUTWRTbj/+IJtugLg/ndRBYXk2YaDyNCQMep4h1r3ymJ
	 4TtZ6rGxBEryQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@nvidia.com>,
	Patrick Bianchi <patrick.w.bianchi@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] PCI: Mark ASM1164 SATA controller to avoid bus reset
Date: Sat, 14 Feb 2026 16:23:46 -0500
Message-ID: <20260214212452.782265-81-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit beb2f81792a8a619e5122b6b24a374861309c54b ]

User forums report issues when assigning ASM1164 SATA controllers to VMs,
especially in configurations with multiple controllers.  Logs show the
device fails to retrain after bus reset.  Reports suggest this is an issue
across multiple platforms.  The device indicates support for PM reset,
therefore the device still has a viable function level reset mechanism.
The reporting user confirms the device is well behaved in this use case
with bus reset disabled.

Reported-by: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Link: https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-identical-devices.149003/
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260109000211.398300-1-alex.williamson@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of PCI: Mark ASM1164 SATA controller to avoid bus reset

### Commit Message Analysis

The commit adds a PCI quirk for the ASMedia ASM1164 SATA controller to
disable bus reset. The problem is clearly described: when assigning
these controllers to VMs via VFIO/PCI passthrough, the device fails to
retrain after a bus reset. This is particularly problematic in
configurations with multiple controllers. The device still supports PM
reset (power management reset) as an alternative reset mechanism, so
disabling bus reset doesn't leave the device without any reset
capability.

Key indicators:
- **Reported-by** tag from a real user (Patrick Bianchi)
- **Link** to a Proxmox forum thread documenting the issue across
  multiple platforms
- Author is Alex Williamson, the VFIO maintainer at NVIDIA — a highly
  authoritative source for PCI passthrough quirks
- Reviewed/committed by Bjorn Helgaas, the PCI subsystem maintainer

### Code Change Analysis

The change is a single `DECLARE_PCI_FIXUP_HEADER` macro invocation with
an accompanying comment:

```c
DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1164,
quirk_no_bus_reset);
```

This calls the existing `quirk_no_bus_reset()` function, which sets the
`PCI_DEV_FLAGS_NO_BUS_RESET` flag on the device. The function already
exists and is used by multiple other devices (Atheros, Cavium, TI
KeyStone) in the same file. This is purely a data addition — matching a
specific vendor:device ID pair to an existing quirk handler.

### Classification: Hardware Quirk

This falls squarely into the **PCI Quirks** exception category for
stable backporting:

- It's a hardware-specific workaround for a broken/buggy device
- It uses an existing, well-tested mechanism (`quirk_no_bus_reset`)
- It only affects the specific ASMedia ASM1164 device (vendor ID
  ASMEDIA, device ID 0x1164)
- Zero risk to any other hardware or code path

### Scope and Risk Assessment

- **Lines changed**: ~10 (comment + 1 functional line)
- **Files touched**: 1 (`drivers/pci/quirks.c`)
- **Risk**: Extremely low — this only affects the specific PCI device
  ID, and only when bus reset is attempted (primarily VFIO passthrough
  scenarios)
- **Dependencies**: None — `PCI_VENDOR_ID_ASMEDIA` and
  `quirk_no_bus_reset` already exist in stable kernels

### User Impact

- **Who is affected**: Users doing PCI passthrough of ASM1164 SATA
  controllers to VMs (Proxmox, QEMU/KVM, etc.)
- **Severity without fix**: Device fails to retrain after bus reset,
  making VM assignment of these controllers unreliable or non-
  functional, especially with multiple controllers
- **The forum thread** indicates this affects multiple users across
  multiple platforms — it's a real, reproducible issue
- ASMedia SATA controllers are very common consumer/prosumer hardware

### Stability Indicators

- Alex Williamson (VFIO maintainer) authored it — he's the authority on
  PCI passthrough issues
- Bjorn Helgaas (PCI maintainer) committed it — reviewed and approved by
  the subsystem maintainer
- The pattern is identical to existing quirks for Atheros, Cavium, and
  TI devices that are already in stable trees
- User confirmed the fix resolves the issue

### Dependency Check

No dependencies. The `quirk_no_bus_reset` function,
`DECLARE_PCI_FIXUP_HEADER` macro, and `PCI_VENDOR_ID_ASMEDIA` all exist
in stable kernels. This will apply cleanly to any stable tree.

### Conclusion

This is a textbook example of a PCI quirk that belongs in stable trees.
It's a minimal, zero-risk, single-device-ID addition that uses an
existing well-tested mechanism to fix a real hardware issue reported by
real users. It was authored and reviewed by the relevant subsystem
maintainers. The pattern is identical to many existing quirks already in
stable.

**YES**

 drivers/pci/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 280cd50d693bd..9100fd133a7ff 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3791,6 +3791,16 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CAVIUM, 0xa100, quirk_no_bus_reset);
  */
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TI, 0xb005, quirk_no_bus_reset);
 
+/*
+ * Reports from users making use of PCI device assignment with ASM1164
+ * controllers indicate an issue with bus reset where the device fails to
+ * retrain.  The issue appears more common in configurations with multiple
+ * controllers.  The device does indicate PM reset support (NoSoftRst-),
+ * therefore this still leaves a viable reset method.
+ * https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-identical-devices.149003/
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1164, quirk_no_bus_reset);
+
 static void quirk_no_pm_reset(struct pci_dev *dev)
 {
 	/*
-- 
2.51.0

