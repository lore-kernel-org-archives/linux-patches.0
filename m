Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E68E1C84CB;
	Thu,  9 Oct 2025 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025610; cv=none; b=I8BiKjY+F8M/QyCWIGo3ZNujyQKmVNY5x3XDpPw0DU443vHWJwwz/JLeYkelGk6212fgE3o4xaee56ildD4tSSxgRPLILPt16JtDN5foEgJhP3hEY9fMzdjbNynnwd1hRI8mXz0d2QkjQ7O5ujDnZIexhoJqYPb7Ep6QMA81quU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025610; c=relaxed/simple;
	bh=PFQ0pWULKOnJS7MiNCPcj8bi1fB18R/7ZrXadRgKnG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WP89GwIgrNRHRa0EJvMmksOSgybCaMMTqG/KVQ1bPim40vlCYvek8bnjAG/XSfu1La8arjKzVzWZNvWw7OafwqsF6R2thpSs7CG6GOTDNPNnW8vKtxpbunieikyCxn55G2EStDLOe9Pm9UbnOzfAdn2/vX4A42zluIJNl5Deae0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WW34872i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WW34872i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69439C4CEE7;
	Thu,  9 Oct 2025 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025610;
	bh=PFQ0pWULKOnJS7MiNCPcj8bi1fB18R/7ZrXadRgKnG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW34872iSFr+jgVJFjfLqkyZYRI24MyRFr7TMmqjuIHb2GCWRgUUdyQA5ZzLHx71X
	 cdRslwtiAKlzUeY4mFcPSFiWOkInC0rmOtX3yQqR8/B9yIklUd9M3LfYzLbJbhVRdH
	 zhO1QOUzyhA9vB6vJBjbweLAVoYzuSnd7x7eaq6fMb/aqhkeWJUd52ytvh/1tpg17O
	 nnMO0QTlsrFQ/XtN6aUjIDfoonjoC7cRWKfdThk5XQ9ECrcpEGs3mMVzHIgMSmN4t2
	 wiTp0MI5XRnR8/nqL34Tp6ZJ50Rta6eVtRFzXxmnOGHMImQgWaJ3l6BZCb987Dmyot
	 Gsf+e1iUaMz4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] i3c: mipi-i3c-hci-pci: Add support for Intel Wildcat Lake-U I3C
Date: Thu,  9 Oct 2025 11:55:39 -0400
Message-ID: <20251009155752.773732-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit d515503f3c8a8475b2f78782534aad09722904e1 ]

Add I3C controller PCI IDs on Intel Wildcat Lake-U.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250808131732.1213227-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: Only two new PCI IDs were added to the Intel entry list
  in `drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c:126` to allow
  binding on Wildcat Lake-U:
  - `/* Wildcat Lake-U */` with `0x4d7c` and `0x4d6f` mapped to
    `intel_info` (`drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-
    pci.c:127-129`).
  - No probe/remove logic or resource handling changed; the rest of the
    table remains for Panther Lake-H/P
    (`drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c:130-136`).

- Binding behavior: The new IDs use the same `driver_data`
  (`intel_info`) as existing Panther Lake entries, which runs the Intel-
  specific init reset sequence (`mipi_i3c_hci_pci_intel_init`) that
  ioremaps a small private window and toggles the reset bit
  (`drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c:28-50`). This is
  a contained and proven path already used for Panther Lake.

- Scope and risk:
  - No functional changes, no API/ABI changes, no control flow changes;
    strictly a device-ID enablement in a leaf driver.
  - Risk of regression is minimal because the driver will only bind on
    systems with those exact Intel vendor/device IDs. Systems without
    this hardware are unaffected.
  - Architectural impact is nil; this does not touch core I3C, PCI, or
    shared subsystems—only the HCI PCI glue driver’s ID table.

- User impact: Without these IDs, Wildcat Lake-U systems with MIPI I3C
  HCI on PCI will not have the I3C controller bound by this driver,
  reducing functionality. Adding the IDs enables existing code paths for
  a new platform, which is a classic stable backport case.

- Stable policy alignment:
  - This is not a new feature; it’s device-ID enablement for existing
    support. Such ID additions are routinely accepted into stable as
    low-risk hardware enablement.
  - No “Fixes”/“Cc: stable” tags, but stable trees regularly take ID-
    only patches when they unlock existing drivers for shipping
    hardware.

- Dependencies/constraints:
  - Backport only to stable branches that already contain
    `MIPI_I3C_HCI_PCI` and this PCI glue driver (initially added with
    Panther Lake support). For branches older than that introduction,
    this would imply pulling in the entire driver, which exceeds
    minimal-risk backporting.
  - In branches where `intel_info` and the Intel init/reset sequence are
    present and in use for Panther Lake, these IDs integrate cleanly.

Conclusion: The patch is a small, contained, low-risk device-ID addition
enabling existing functionality on Wildcat Lake-U. It fits stable
backport criteria and should be backported to applicable stable trees
that already include the MIPI I3C HCI PCI driver.

 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index c6c3a3ec11eae..08e6cbdf89cea 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -124,6 +124,9 @@ static void mipi_i3c_hci_pci_remove(struct pci_dev *pci)
 }
 
 static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
+	/* Wildcat Lake-U */
+	{ PCI_VDEVICE(INTEL, 0x4d7c), (kernel_ulong_t)&intel_info},
+	{ PCI_VDEVICE(INTEL, 0x4d6f), (kernel_ulong_t)&intel_info},
 	/* Panther Lake-H */
 	{ PCI_VDEVICE(INTEL, 0xe37c), (kernel_ulong_t)&intel_info},
 	{ PCI_VDEVICE(INTEL, 0xe36f), (kernel_ulong_t)&intel_info},
-- 
2.51.0

