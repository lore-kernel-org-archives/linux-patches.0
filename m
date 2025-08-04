Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CFF1519A0;
	Mon,  4 Aug 2025 00:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268164; cv=none; b=jScDeS6q8FFeoJbPI4fY7mcY8RiI1bMd8Lsyn2CKeeMkrt1Jh64eRlf6IDMVntgBEU+HBEVhoiGoercfuEaZqff5+9FspznY7LNwOmlo9Sag9CRFxLGe1G2v8RWs/YSGx1pVpQJ1UsxYbKhB3RH1K/pyMOzfagUQOb/o4dK4O7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268164; c=relaxed/simple;
	bh=wlvN4G6THNBJauj78AKnpFuRQ1tqa6N0fpjk14w/vKI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqy2bglW0Zm5f3ckp1S3ja+qA0eJ/ADPFVXIVH3r5FVabEXrdHUU+U/A1rqpD0Vu50rcV+F5zX9LF+O3zb8VecgPFaktm0ovEqiXeKcr0+W17N1CM45Yq8lx59Zwjs6/SFasmwX5kbg2sxudTMaD/y4N3OXRgVy6J+N93scXIGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhmk+El5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhmk+El5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30216C4CEEB;
	Mon,  4 Aug 2025 00:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268164;
	bh=wlvN4G6THNBJauj78AKnpFuRQ1tqa6N0fpjk14w/vKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhmk+El5DR2wrp1NiFVUQkfNb0kJE24Vw1HlZKtk6iYdGtz20v69YmpzBZylrh/2u
	 OzaPUZZG9oJsgxlzaXfTyR9lYOKiIBlbmvSm845vQZ+KGba4EDfeKbo7g05Nb2js1D
	 spuZA/8pfZGc2rYlVD6Kj8sHzwcGy9yBN+fnBdEWg+57tiz6e1CKGrS1p77oVoggC1
	 01Ev3Lxj14KL+Api179OBRAsV7H/vSVFeW3F0vu+L0aVcEGeepPLHQnnOMj3coAPeh
	 JEgpV7BJuHk1fkPyyli7BF0YlFkGfvQBU6NAvvYS5DB22xpg2yjazRVj+JWNv4YKVi
	 1aw+cCAhwedXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/28] usb: xhci: Avoid showing errors during surprise removal
Date: Sun,  3 Aug 2025 20:42:06 -0400
Message-Id: <20250804004227.3630243-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004227.3630243-1-sashal@kernel.org>
References: <20250804004227.3630243-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
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
index 71b17a00d3ed..47326fb8b1fc 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -973,12 +973,15 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
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
@@ -992,7 +995,7 @@ void xhci_hc_died(struct xhci_hcd *xhci)
 	}
 
 	/* inform usb core hc died if PCI remove isn't already handling it */
-	if (!(xhci->xhc_state & XHCI_STATE_REMOVING))
+	if (notify)
 		usb_hc_died(xhci_to_hcd(xhci));
 }
 
-- 
2.39.5

