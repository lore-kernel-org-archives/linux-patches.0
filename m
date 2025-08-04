Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4611DD0C7;
	Mon,  4 Aug 2025 00:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268151; cv=none; b=k5ccB20ACq7fTeulllPhu8LeJbV7FRREw7PBLYuSyyAovNclHicqM8LiGP2S5Y+HL/OXv6a6dB/39veVueQ1TNd46+N/opjgneA1c73LR8NB0anzbZBjQ3x+I7ikaVSHDI9250NvmvZuIpWR/1SHYC9fsFIktVaJZGF8cq0WStQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268151; c=relaxed/simple;
	bh=sOddPdmHfivoFyLH6XAGx+lEAz4oL3dAM+y1XTk/vQs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GJMj0YOqSwpisbW9nEz5/Uk/rLT+wka/7dsx0ne+GRz0mZI7fDkzjHTAwMi64WEHCuMHTP9d1u16gfCHI2o5NiiC8077AiLY1izY4+R4sEfjJ1INtNK9s1kMKiSJ6AzwC+YK2nN0c+JXE8NDEIk9OTN8358AVFMWBQ9iRhf3vGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfJLbrYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfJLbrYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6A3C4CEEB;
	Mon,  4 Aug 2025 00:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268151;
	bh=sOddPdmHfivoFyLH6XAGx+lEAz4oL3dAM+y1XTk/vQs=;
	h=From:To:Cc:Subject:Date:From;
	b=qfJLbrYGJHg1Ol1VvraWiedJpe/u2xamWRMsdNTx1WVbmQEgGooa82S4d/slB6PZi
	 Nn63ZP3BKzJhvTXzX+FOJJ0MH9CAWw77Z8gYLInoyY9/QpRzisVj3yjtazOwYyezwi
	 J6D2cuYCHI809Q294kgYFkz+zVMGtJ9iO6jMpx3ogC4oXvqGPGoT8kQ+e3ZM2cZvGq
	 pCVpxAem5zvTLdOpcCDL0/Q53qTP29KSMGATjVLWOL+hVaMTryn36yIATFDrVxNMdB
	 JhpsflfNWk1PfuVFLF6MLpUN9V0sxuB/8y+F5tHK6kHsZfRt/mXHnXHrYLDwU6+Oqf
	 eemccu3Mubc+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Su Hui <suhui@nfschina.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/28] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Sun,  3 Aug 2025 20:42:00 -0400
Message-Id: <20250804004227.3630243-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
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
index 08b016864fc0..71b17a00d3ed 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4076,7 +4076,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5

