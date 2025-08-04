Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DA61E9B3F;
	Mon,  4 Aug 2025 00:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268059; cv=none; b=k88UUZGg9R/mmVuEgmT5SNBLDbOAG9jJZrnGhsQBCABldAP1TW5xVI1YTekj7jR/TsQNu9LJgaUpD0sDwow8ch1D/elcDWl1G4ZuUnOIJg2T5irQ6YE97oJT6bnBiZEGJQdHPxVHUJaXglreceQ73YiAUl4ds9EPkSYZE96oty8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268059; c=relaxed/simple;
	bh=xN/CFO7YS3cRNmocO1U0b14CJAjKgKdpxG/SwYbFsQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ff6sTUqgfFX0kX6BW7PElTeBYtg9Ce+rXyZuMPZIctJIbg3hi8pqvOggWa7Mcni2bfI5ZgqgOL1uhItlef2MB7Iw1x9rYrwFb09hAgqpHZMU4Jj5DlD53pHjxVEewyj6YIgYgkS3TJPo4k+rHda4fYvd3KZaQ3ql+5wEBIzxiwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmFVWbq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmFVWbq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA616C4CEF9;
	Mon,  4 Aug 2025 00:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268059;
	bh=xN/CFO7YS3cRNmocO1U0b14CJAjKgKdpxG/SwYbFsQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmFVWbq6qt7mLevFVbvkC5Y/RR2+FEUDXnb1M063ht8JDANz1IRxnEi/rhXSDCOnd
	 +mxDCNUxKQoKdbjlZyT+lcYxeE4e8abzYcdF26/WjsgD3hbc9DmtgPtIChr6WLoXGt
	 CGoOxKCi97OlVTL2cTUAZE2YyRKyX1AbYm6QIZD7UaiNKkoBg9FB2b/jvI1bCcSYW4
	 Vd/Ap1VMsmEDKhv6uWlnqQyrIk8XqlmhyvLhZXse2Q/gZZYl4tJSealSGXHz0PASsg
	 wzHCrBqOcroJlHngY0n6N5PMaxQ7kOG+htH8BY74Bf5AVZd+UXPZLkPoiL6Tl2duCB
	 ZGH7Jco0ZYSfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/39] usb: xhci: Avoid showing warnings for dying controller
Date: Sun,  3 Aug 2025 20:40:08 -0400
Message-Id: <20250804004041.3628812-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 65fc0fc137b5da3ee1f4ca4f61050fcb203d7582 ]

When a USB4 dock is unplugged from a system it won't respond to ring
events. The PCI core handles the surprise removal event and notifies
all PCI drivers. The XHCI PCI driver sets a flag that the device is
being removed, and when the device stops responding a flag is also
added to indicate it's dying.

When that flag is set don't bother to show warnings about a missing
controller.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-visible bug**: The commit addresses spurious
   warning messages that appear when USB4 docks are unplugged. When a
   USB4 dock is removed, the controller becomes inaccessible (reads
   return 0xffffffff), but the driver still attempts operations and logs
   warnings that are misleading to users.

2. **Small and contained fix**: The changes are minimal - only adding
   conditional checks before logging warnings in two functions
   (`xhci_halt()` and `xhci_reset()`). The fix simply checks if the
   `XHCI_STATE_DYING` flag is set before printing warnings.

3. **Low risk of regression**: The changes only affect warning messages,
   not functional behavior. The actual error paths and return values
   remain unchanged. This is a purely cosmetic fix that improves the
   user experience by avoiding confusing warnings during expected
   hardware removal scenarios.

4. **Clear problem and solution**: The commit message clearly describes
   the issue (USB4 dock removal causes warnings) and the solution
   (suppress warnings when controller is dying). The code changes
   directly implement this solution.

5. **Affects common hardware scenarios**: USB4 docks are becoming
   increasingly common, and surprise removal is a normal use case that
   shouldn't generate alarming warnings in system logs.

6. **Follows stable tree criteria**: This is a bug fix that improves
   user experience without introducing new features or making
   architectural changes. It's exactly the type of fix that stable trees
   are meant to include.

The code changes show:
- In `xhci_halt()`: Added check `if (!(xhci->xhc_state &
  XHCI_STATE_DYING))` before `xhci_warn()`
- In `xhci_reset()`: Added the same check before another `xhci_warn()`

Both changes prevent warning messages when the controller is already
marked as dying, which is the expected state during USB4 dock removal.
This is a classic example of a stable-worthy fix that improves system
behavior without functional changes.

 drivers/usb/host/xhci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 908445cff24f..235824d1822a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -118,7 +118,8 @@ int xhci_halt(struct xhci_hcd *xhci)
 	ret = xhci_handshake(&xhci->op_regs->status,
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
 	if (ret) {
-		xhci_warn(xhci, "Host halt failed, %d\n", ret);
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host halt failed, %d\n", ret);
 		return ret;
 	}
 	xhci->xhc_state |= XHCI_STATE_HALTED;
@@ -175,7 +176,8 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 	state = readl(&xhci->op_regs->status);
 
 	if (state == ~(u32)0) {
-		xhci_warn(xhci, "Host not accessible, reset failed.\n");
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host not accessible, reset failed.\n");
 		return -ENODEV;
 	}
 
-- 
2.39.5

