Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9CD2E40B;
	Mon,  4 Aug 2025 00:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267656; cv=none; b=IpIjJXeVAcQmn1vMjwuvyt9gMxZcJ69nuqr2M88pA5XrGpcKATldTemQTWieXtiSML9JLtSQ3fnBVbUwtMetkPlcD6rZ+PcepdMPUX7gwjoWK6F0GwbSzBgwpLVmGwcwpjt7Bj7kxPvJ1VfQCP/Ju7kJdMYfuNaU9eoGMnJ8Ujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267656; c=relaxed/simple;
	bh=t7x85OUppVhlJPVxsfQeW0DXiPwlcdMVvc5bzBRMzk8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gmi2l9UHkas3z2/aKGmCa6qdHmRYTMuu7wRcVQi29TwZVslxpSy/B+i0Ox/+t9YBrWdiYNBhM7VyAoWYkmpJMxe1wS2Bw3u/oFxLiy3dTbjb6eOF1dbBM0z0/rmX+CG9+Qzj4FtezSJxvpFGG2QE8j3XeILmPwKHZF04a+FQPm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jak014Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jak014Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A440C4CEEB;
	Mon,  4 Aug 2025 00:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267656;
	bh=t7x85OUppVhlJPVxsfQeW0DXiPwlcdMVvc5bzBRMzk8=;
	h=From:To:Cc:Subject:Date:From;
	b=jak014MfVYCW0gFu9MtOXNknVIZQ3rABmJLynOUj4giJE/S1xyWydOT5TPSm7RuNb
	 3Difg8GSFCCTIc1cLHTjY5/XaCOMYK1IQ1AxoFpzpxiPoLdHTopiSQzKkn4x+Hitsv
	 ZGMRgz4VZUrE8b6haGzyajPXirrT+PQR1j31liNPN2zoPf24xtN84yIIiLQU4jgT8Q
	 C2NGGxG1f/ZH4neAVCcju/PQFk8h2Iu61+NV7YFGymt29wGdhv2B5X43ADbSkNE7dV
	 6G+hY4H7fPusIQTxyP84Uylo8ZWUDuidiqpQg3dAlaXYw2pkydQyucrfkSYJPSNGOe
	 zjfA8JafLQ3Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Su Hui <suhui@nfschina.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/59] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Sun,  3 Aug 2025 20:33:15 -0400
Message-Id: <20250804003413.3622950-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 7919407eca2ef562fa6c98c41cfdf6f6cdd69d92 ]

When encounters some errors like these:
xhci_hcd 0000:4a:00.2: xHCI dying or halted, can't queue_command
xhci_hcd 0000:4a:00.2: FIXME: allocate a command ring segment
usb usb5-port6: couldn't allocate usb_device

It's hard to know whether xhc_state is dying or halted. So it's better
to print xhc_state's value which can help locate the resaon of the bug.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250725060117.1773770-1-suhui@nfschina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is suitable for backporting to stable kernel trees for the
following reasons:

1. **Enhanced Debugging for Real-World Issues**: The commit improves
   debugging of USB xHCI host controller failures by printing the actual
   `xhc_state` value when `queue_command` fails. The commit message
   shows real error messages users encounter ("xHCI dying or halted,
   can't queue_command"), demonstrating this is a real-world debugging
   problem.

2. **Minimal and Safe Change**: The change is extremely small and safe -
   it only modifies a debug print statement from:
  ```c
  xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
  ```
  to:
  ```c
  xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state:
  0x%x\n", xhci->xhc_state);
  ```

3. **No Functional Changes**: This is a pure diagnostic improvement. It
   doesn't change any logic, control flow, or data structures. It only
   adds the state value (0x%x format) to an existing debug message.

4. **Important for Troubleshooting**: The xHCI driver is critical for
   USB functionality, and when it fails with "dying or halted" states,
   knowing the exact state helps diagnose whether:
   - `XHCI_STATE_DYING` (0x1) - controller is dying
   - `XHCI_STATE_HALTED` (0x2) - controller is halted
   - Both states (0x3) - controller has both flags set

   This distinction is valuable for debugging hardware issues, driver
bugs, or system problems.

5. **Zero Risk of Regression**: Adding a parameter to a debug print
   statement has no risk of introducing regressions. The worst case is
   the debug message prints the state value.

6. **Follows Stable Rules**: This meets stable kernel criteria as it:
   - Fixes a real debugging limitation
   - Is obviously correct
   - Has been tested (signed-off and accepted by Greg KH)
   - Is small (single line change)
   - Doesn't add new features, just improves existing diagnostics

The commit helps system administrators and developers diagnose USB
issues more effectively by providing the actual state value rather than
just saying "dying or halted", making it a valuable debugging
enhancement for stable kernels.

 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 44352df58c9e..c6d89b51c678 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4454,7 +4454,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5

