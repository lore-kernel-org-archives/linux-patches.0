Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C03C2D;
	Sat, 14 Feb 2026 21:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104358; cv=none; b=BGzTgSGWI4Ew8dX2pT08/t59QM4uIl2QSExVrtgFsi142o2r+Hm5PiZBmcaXdojgNwiju39bdTwoSBZB8//kYUs6AM56cW7ZtWiFsupzw8oyVpoogimImVeVicrEEouxlYHnMmE8297YgrgcyQO+ivv78807evmYGVgqL+04rpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104358; c=relaxed/simple;
	bh=wXXapwFeYVgtQZwgGByrjTAqhAfXkHTGrYtefsyZo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Khh8ZuNb7txcWadhWbM1jv0LvD391n+BoXtCH2RYCZ6rlD8XcpzSswiZFMP2ta7MBqD7KWBaTcr1i7W44BVO1cm5w0ZOQUvkMjZ5QUrg404FP8UOdrElB28SkatRek/kRj6XS2BnNV62xtP9bcZ6P3eJ8UoLBqRHLSMCZuD7ZG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkOcGjHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkOcGjHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0559C19422;
	Sat, 14 Feb 2026 21:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104356;
	bh=wXXapwFeYVgtQZwgGByrjTAqhAfXkHTGrYtefsyZo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkOcGjHS+MbvpM5d1YKV1UJ+L9uNRLis4jTZ6Yz6eHiEohtOmJlP05sEqhUIhXQZb
	 fP19pi33tJwsvTOFVUBSYIRQ3swen5FvPfnCfNvy8ZZHJU2Au3O4gj8g6uwxETv+u9
	 2z5gTIiRzv7+rlAI07jbnzf2RhzrnHN+GERNkymZ83lIuH+OGSpfanR+qE2VYHWq1x
	 eCp0bKyrVemD3G1LPjjGhvUS1fb/1eR4I//dUlPxKOEIFJX+NsCvmh/TIPYpPad6ty
	 8PA91dvf+4b5wQHpPDByY7EkICmF/A9FXD1QpUTR1n61Ri2mY5HyFcq4KXw6II7+dZ
	 i+ikxghzSluBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-5.10] PCI: Mark Nvidia GB10 to avoid bus reset
Date: Sat, 14 Feb 2026 16:23:02 -0500
Message-ID: <20260214212452.782265-37-sashal@kernel.org>
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

From: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>

[ Upstream commit c81a2ce6b6a844d1a57d2a69833a9d0f00403f00 ]

After asserting Secondary Bus Reset to downstream devices via a GB10 Root
Port, the link may not retrain correctly, e.g., the link may retrain with a
lower lane count or config accesses to downstream devices may fail.

Prevent use of Secondary Bus Reset for devices below GB10.

Signed-off-by: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>
[bhelgaas: drop pci_ids.h update (only used once), update commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251113084441.2124737-1-Johnny-CC.Chang@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of PCI Quirk for Nvidia GB10 Bus Reset

### Commit Message Analysis

The commit adds a PCI quirk to prevent Secondary Bus Reset (SBR) for
devices behind Nvidia GB10 Root Ports. The problem is clearly stated:
after asserting SBR, the link may not retrain correctly — leading to
reduced lane count or complete failure of config accesses to downstream
devices. This is a real hardware bug with concrete symptoms (link
degradation, device inaccessibility).

### Code Change Analysis

The change is minimal and surgical:
- Two `DECLARE_PCI_FIXUP_HEADER` lines are added for two specific Nvidia
  device IDs (`0x22CE` and `0x22D0`)
- Both call the existing `quirk_no_bus_reset()` function, which simply
  sets `PCI_DEV_FLAGS_NO_BUS_RESET` on the device
- A comment block explains why the quirk is needed, with a link to the
  mailing list discussion

The diff also shows context that there's already a similar quirk pattern
for other Nvidia GPU devices (`quirk_nvidia_no_bus_reset` matching
`0x2340` range), as well as Atheros devices. This is a well-established
pattern in the kernel.

### Classification: Hardware Quirk

This falls squarely into the **hardware quirk** category, which is
explicitly listed as a strong YES signal for stable backporting.
Hardware quirks:
- Fix real-world hardware issues
- Are trivial additions to existing infrastructure
- Have near-zero risk of regression (they only affect the specific
  hardware identified by the PCI IDs)

### Scope and Risk Assessment

- **Lines changed**: ~8 lines (2 macro invocations + comment block)
- **Files touched**: 1 (`drivers/pci/quirks.c`)
- **Complexity**: Minimal — uses existing `quirk_no_bus_reset()`
  function
- **Risk**: Extremely low — only affects devices with vendor ID
  `PCI_VENDOR_ID_NVIDIA` and device IDs `0x22CE` or `0x22D0`
- **No dependencies**: The `quirk_no_bus_reset()` function and
  `DECLARE_PCI_FIXUP_HEADER` macro have existed in the kernel for a very
  long time

### User Impact

- **Who is affected**: Users with Nvidia GB10 Root Ports (likely
  MediaTek platforms given the author's affiliation)
- **Severity without fix**: Bus reset can cause downstream devices to
  become inaccessible (config accesses fail) or degrade link performance
  (lower lane count). This can manifest as device failures, system
  hangs, or degraded performance
- **Severity with fix**: Bus reset is avoided for these specific root
  ports, preventing the link training failure

### Stability Indicators

- **Reviewed-by**: Manivannan Sadhasivam (PCI subsystem reviewer)
- **Committed by**: Bjorn Helgaas (PCI subsystem maintainer), who also
  edited the commit log
- **Mailing list link**: Provided for traceability
- The pattern is identical to many existing quirks in the same file

### Dependency Check

No dependencies. The `quirk_no_bus_reset()` function exists in all
stable trees. `DECLARE_PCI_FIXUP_HEADER` and `PCI_VENDOR_ID_NVIDIA` are
long-established. This will apply cleanly to any stable tree.

### Conclusion

This is a textbook hardware quirk addition — small, self-contained, zero
regression risk, fixes a real hardware issue (bus reset failure causing
device inaccessibility), uses existing well-tested infrastructure,
reviewed and committed by the PCI subsystem maintainer. It meets all
stable kernel criteria.

**YES**

 drivers/pci/quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 54c76ba9a767e..5782dfb863cad 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3748,6 +3748,14 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
 }
 
+/*
+ * After asserting Secondary Bus Reset to downstream devices via a GB10
+ * Root Port, the link may not retrain correctly.
+ * https://lore.kernel.org/r/20251113084441.2124737-1-Johnny-CC.Chang@mediatek.com
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x22CE, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x22D0, quirk_no_bus_reset);
+
 /*
  * Some NVIDIA GPU devices do not work with bus reset, SBR needs to be
  * prevented for those affected devices.
-- 
2.51.0

