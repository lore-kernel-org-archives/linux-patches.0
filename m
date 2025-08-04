Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9ED15A8;
	Mon,  4 Aug 2025 00:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268064; cv=none; b=CxCyW/Yd2NdX2dhMmRzXH34Puwrk6PnHhnZ5WbZKuG3p0bmL0FoGW81eVUA1gCOCrhcylRC7ARbin3JjGdz1FKfhXNxk38xSgBP32y1wMYLlXaHcKlxPbJbEjDhrt+odFOafmn+1XdSyHpDf2clMYdV6MlhTVnSP+WwGGWx3dDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268064; c=relaxed/simple;
	bh=J/ngk57hXStMcfGQXWXwkEmgkvtTPIa5P6zI/zNPAxk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2S8Ib8YlxeMRwYCct4lcTIVwQL2hJKTwFEn0m+2fHQSS//f60ISuZXIlbzVV7OSe38hJ71t2N7A1048okelf9Sn4IQT7J1Cc82eyjUeWA52mk+Jv2BtXa15IZ5avhk0hQSvPtMcDSCo3AqdWZ5tREJNZgObmVs0hYt9oxSG+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xei7GVOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xei7GVOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5C7C4CEF0;
	Mon,  4 Aug 2025 00:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268064;
	bh=J/ngk57hXStMcfGQXWXwkEmgkvtTPIa5P6zI/zNPAxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xei7GVOH8V/HLIWPhGKtA+7ZMaPFCKwO3ur9dcaONlotqbzyHFMsYxdAq5y7G6dhB
	 9p+Wn8lthmY3VW2yszqhniNHGrl0Vty4nNm6NvFGZ7r6dgryTECv0zDSE9O39NoBCW
	 k/OOImFFKtLzZpz3/E8jCF9mAHQUAu4Lx/S+9P03olyDGvCw8sPR+H6hFYtdEP8xKq
	 rkTqYfIWbVi5iHnlJXX3k4eupjZxk6VPxF3AVw+yPcZlhQ3WFO1tJ0xijqHel4JUDP
	 zybuotVzU0jtMth8mhJqCa4YIWMSsg06nFkWs0px1UwfJ89JNIwtZPFOr7cBkKZ6mk
	 tfcRS6QcjI2Jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/39] usb: xhci: Avoid showing errors during surprise removal
Date: Sun,  3 Aug 2025 20:40:10 -0400
Message-Id: <20250804004041.3628812-8-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4b9c60e440525b729ac5f071e00bcee12e0a7e84 ]

When a USB4 dock is unplugged from a system it won't respond to ring
events. The PCI core handles the surprise removal event and notifies
all PCI drivers. The XHCI PCI driver sets a flag that the device is
being removed as well.

When that flag is set don't show messages in the cleanup path for
marking the controller dead.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250717073107.488599-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me analyze this commit properly:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a user-visible issue**: The commit addresses spurious error
   messages that appear when USB4 docks are unplugged. The original code
   shows `xhci_err(xhci, "xHCI host controller not responding, assume
   dead\n")` even during expected surprise removals, which can confuse
   users and fill system logs unnecessarily.

2. **Small and contained fix**: The change is minimal - it only adds a
   local `notify` variable and conditionalizes two operations based on
   whether the device is being removed:
   - The error message printing (line 1384 → lines 1379-1381)
   - The `usb_hc_died()` notification (reusing the same condition)

3. **No architectural changes**: This is a simple behavioral fix that
   doesn't modify any data structures, APIs, or core functionality. It
   merely suppresses error messages during an expected removal scenario.

4. **Clear bug fix**: The commit clearly fixes an issue where error
   messages are shown during normal USB4 dock removal operations. When
   `XHCI_STATE_REMOVING` is set (indicating PCI removal is in progress),
   the error message is now suppressed since it's an expected condition.

5. **Low risk of regression**: The change only affects logging behavior
   and maintains the same functional flow. The `usb_hc_died()` call was
   already conditional on `!XHCI_STATE_REMOVING`, so this commit just
   applies the same logic to the error message.

6. **Improves user experience**: USB4/Thunderbolt docks are increasingly
   common, and users frequently unplug them. Avoiding spurious error
   messages during normal operations is important for user experience
   and log clarity.

The commit follows stable tree rules by being a minimal fix for a real
issue that affects users, without introducing new features or making
risky changes to core functionality.

 drivers/usb/host/xhci-ring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index c026e7cc0af1..a65ad8e760d0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1094,12 +1094,15 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
  */
 void xhci_hc_died(struct xhci_hcd *xhci)
 {
+	bool notify;
 	int i, j;
 
 	if (xhci->xhc_state & XHCI_STATE_DYING)
 		return;
 
-	xhci_err(xhci, "xHCI host controller not responding, assume dead\n");
+	notify = !(xhci->xhc_state & XHCI_STATE_REMOVING);
+	if (notify)
+		xhci_err(xhci, "xHCI host controller not responding, assume dead\n");
 	xhci->xhc_state |= XHCI_STATE_DYING;
 
 	xhci_cleanup_command_queue(xhci);
@@ -1113,7 +1116,7 @@ void xhci_hc_died(struct xhci_hcd *xhci)
 	}
 
 	/* inform usb core hc died if PCI remove isn't already handling it */
-	if (!(xhci->xhc_state & XHCI_STATE_REMOVING))
+	if (notify)
 		usb_hc_died(xhci_to_hcd(xhci));
 }
 
-- 
2.39.5

