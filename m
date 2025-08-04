Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94094FBF6;
	Mon,  4 Aug 2025 00:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267270; cv=none; b=UkAX7QnyYrHJArEZEcJGpdp7S+zEz6TKoggmCmrjE/q65epccWH27vacne5kYdtFc0LRCPo7A8zDoEav4c/XS/VE4PL9wYiHqIYeHKvhnzBCKO/DBnzT6+9JaCcECqjvJ0o5EXUb7oG+Aia7sqLiym5zs8qJxzBcAXHO0Id/vE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267270; c=relaxed/simple;
	bh=+HCpAVEat2T3d65rIWOgNh1OBfxdsG0s2kPWd1t/rWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GaPFV018FbMI8MBZh9dWpk1M5cTcC1Oo/4Nyd9geTOf039V7lq0YqYObt446tSzpsxD0dmPZJ3S3RxUpz2Bwej4n1+HUuVBYHHlgIhgxkwJhITK6jlD3JD2IZZ2Z9TactX/+jGa7rZxpJh7QcwgouD7tWhgFtssLnC3yWlw6jgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/kdenOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/kdenOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C53DC4CEEB;
	Mon,  4 Aug 2025 00:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267270;
	bh=+HCpAVEat2T3d65rIWOgNh1OBfxdsG0s2kPWd1t/rWA=;
	h=From:To:Cc:Subject:Date:From;
	b=m/kdenOGdYGi4xFGAgR2oCbX54SvCJcij2uYmxm+STfXXqnvvtLcFt/tqKB7+Cqd6
	 qbVT1ojZOBoRWn7EsWvrPTK3SdIq8dZ3xF559mNfsawgiwFyQvILARimPYqxuBaIAP
	 TfiiwdVcHqPnK4rZSbvi1rBgkKYdg8SbxVwPGZSyARNKQ9WmjuOqyHQwxXNqsVRYTu
	 2+UYI9CbWxcgGwOennYmPEGuFW/VL2IVK5gq70CYTi4RKKxHOtswonCZY2aZx6K9C0
	 C/BRHInESLkBIkw56z4jJ5arjSY+VaPOlaa/xKBOPX5eF5Dpo6CFIr6oIbCx++bxsA
	 uB1vUgHW0ZzrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Su Hui <suhui@nfschina.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 01/80] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Sun,  3 Aug 2025 20:26:28 -0400
Message-Id: <20250804002747.3617039-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
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
index b720e04ce7d8..8be033f1877d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4337,7 +4337,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5

