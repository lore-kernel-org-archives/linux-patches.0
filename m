Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877F21E3DDB;
	Mon,  4 Aug 2025 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267820; cv=none; b=C74GFJ6mdIDY8u98xXBRh/d9f1cdC/cpBZc9s4ime69eCnWXDoxTWNDFj7lxIG5fALhIjf/YiiwawYc51bUq8mB9ksPTLdp3VdjqBD3Mzg8P0+Z/id/Qh1umyF/Zp/PJNcli6KuIAuTsXI+KGxbx7trxT+l31A8hqTkSqf1cs8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267820; c=relaxed/simple;
	bh=oxrRgR24U0DWwxWmGwZ6SuPhwDrR9JD5xhg1QzVdBDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IqnENOWW7CilQSjrKbtzyPTJia/SROBM0TPwT5GA+60oYfqvAnCWLwqWjO9q7ANgC9DMnz1aaAnLD7BeCCI7K6rrCeBJZlWOlHC0K6dgQhhLtDfe56daVv0HHsLDDiSeIDxMdBAmyuyL2PikAu1V7Mv1StEnQJjfXRaSOpQSA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZUR945K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZUR945K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4BDC4CEEB;
	Mon,  4 Aug 2025 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267820;
	bh=oxrRgR24U0DWwxWmGwZ6SuPhwDrR9JD5xhg1QzVdBDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZUR945KrBsT4K7flPFXDYVHKRtLjUa0+DX6KctufiG5eduITK4hdMZnHvDOYeqqq
	 601BH1oqUaL88sYYBJ268JNnmW7WkzMWWVCgvu24dV0NJfFSVbB+GNyqJsNcEe1maW
	 ym6JgTHJpeTVOL2QeAIoZFyDQpXEpzgq5hdg9OsRWoStgj3ctmkZt17MFzUQdT9Hpm
	 Eu3TdGFuczlT858NoaVN0l7cGkyRRSA3U1ida9cr2Y12gsKbPeDtJwccBQc664GWC9
	 uFLBZDB7mEV7pPfeY7I5z2kB1ZqrYAoX3XBY2+12b4KjQNZAhJmI3v6z6vlHdOEMni
	 ZGk6BjR3zdWDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/51] usb: xhci: Avoid showing warnings for dying controller
Date: Sun,  3 Aug 2025 20:35:58 -0400
Message-Id: <20250804003643.3625204-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003643.3625204-1-sashal@kernel.org>
References: <20250804003643.3625204-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
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
index e726c5edee03..a5ce544860b8 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -119,7 +119,8 @@ int xhci_halt(struct xhci_hcd *xhci)
 	ret = xhci_handshake(&xhci->op_regs->status,
 			STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC);
 	if (ret) {
-		xhci_warn(xhci, "Host halt failed, %d\n", ret);
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host halt failed, %d\n", ret);
 		return ret;
 	}
 
@@ -178,7 +179,8 @@ int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 	state = readl(&xhci->op_regs->status);
 
 	if (state == ~(u32)0) {
-		xhci_warn(xhci, "Host not accessible, reset failed.\n");
+		if (!(xhci->xhc_state & XHCI_STATE_DYING))
+			xhci_warn(xhci, "Host not accessible, reset failed.\n");
 		return -ENODEV;
 	}
 
-- 
2.39.5

