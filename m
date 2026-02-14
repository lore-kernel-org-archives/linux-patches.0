Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AA931326A;
	Sat, 14 Feb 2026 21:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104443; cv=none; b=NpbQ2Giq5kNjBTBZENN1CCJ1HUB/otn4KuFymUBNwglT4wlyZZBVxlrpoHLAXM/SXZy18vmOCkuE5iGitiKd8agtTy19qcErHDZ26Rtqvx1fMwcgJoUCkEYWwk9U47smXIfVxZCwpTR9ihlrk6hf4MoF/FaZXKndHgJQHHXhhXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104443; c=relaxed/simple;
	bh=1HBs2a2Sv4TzcLTpnESr5wt7PsFTNkkZDOhNrRLFTz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FowKrVJTk9J3HMVjn9c4g7lmErRHiy2bPxZ2oZxA0LEw4AnRq0+b1xD+9U79cKYyPwINkZYNw6tksIJA6gajmpbgxNMPfB7hTT/kO2F8bM4gYD9ZeSZyQ43Wkz/0QnqpIeUbmACNosYyEF/CA+Fo2N5CP5MOxq2XPj4DO4cw358=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxupgQ7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxupgQ7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D01C19425;
	Sat, 14 Feb 2026 21:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104443;
	bh=1HBs2a2Sv4TzcLTpnESr5wt7PsFTNkkZDOhNrRLFTz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxupgQ7wxmaixK2TLBvHqjxGyK/5eoCCfaBGZPSlW2YUeDdlGkWaZxq1mVY9gTkrl
	 1/5HPLqKBF49lLEaRSWpp/hn0AgOZafUk3uMMfUiUeC6lQwVdqtKF6Hf0wph2oiW/S
	 Fq6l92xOY3r3g8TH0Z/3hiRStqLzIBJUgNKPCQQYxmJoqf/IWq/EhQqj1vcUYaSchm
	 BngSNJUmOAOQC3TYSDuRo4He7O5/4dF+7vsAcq/eagXWledcnoj+a/9vI1ysTGNDnW
	 NO8f4GqUYhdPLDT2lMmS99P1LfTdQTiMOYLRVkvqqZ0LLlVVn+zXkS/GPgCearb6NA
	 DoH38tW9V8bkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] PCI: Fix pci_slot_lock () device locking
Date: Sat, 14 Feb 2026 16:23:52 -0500
Message-ID: <20260214212452.782265-87-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 1f5e57c622b4dc9b8e7d291d560138d92cfbe5bf ]

Like pci_bus_lock(), pci_slot_lock() needs to lock the bridge device to
prevent warnings like:

  pcieport 0000:e2:05.0: unlocked secondary bus reset via: pciehp_reset_slot+0x55/0xa0

Take and release the lock for the bridge providing the slot for the
lock/trylock and unlock routines.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260130165953.751063-3-kbusch@meta.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The commit is not yet in this tree. That's fine - it's a candidate being
evaluated.

### SUMMARY

**What the commit fixes**: `pci_slot_lock()`, `pci_slot_unlock()`, and
`pci_slot_trylock()` don't lock the bridge device providing the slot,
unlike their `pci_bus_*()` counterparts which were fixed in v6.11
(commit `a4e772898f8bf`). This causes:
1. Warnings about "unlocked secondary bus reset" during PCIe hotplug
   slot reset
2. A real synchronization gap - the bridge device can be accessed
   concurrently during slot reset operations

**Why it matters for stable**:
- Fixes a real locking bug that triggers warnings and could lead to
  races during PCI hotplug operations
- PCIe hotplug is widely used (servers, Thunderbolt, NVMe)
- The fix follows an established, proven pattern (mirrors what
  `pci_bus_lock()` already does)
- Small, surgical change (~20 lines of logic in one file)
- Written by Keith Busch (PCI/NVMe expert), committed by Bjorn Helgaas
  (PCI maintainer), reviewed by Dan Williams
- No new features, no API changes

**Dependencies**: Requires commit `a4e772898f8bf` ("PCI: Add missing
bridge lock to pci_bus_lock()") which is in v6.11+. May also depend on
`f3efb9569b4a2` ("PCI: Fix lock symmetry in pci_slot_unlock()") from
v6.16-rc1. The backport would need to target only stable trees that
contain the prerequisite.

**Risk**: Very low. The change adds symmetric lock/unlock operations
following an identical pattern already proven in `pci_bus_lock()`. The
trylock path correctly handles contention (unlocks bridge on failure).

This is a clear bug fix - missing synchronization during PCI slot reset
operations - that is small, well-reviewed, follows a proven pattern, and
fixes a real locking issue. It meets all stable kernel criteria.

**YES**

 drivers/pci/pci.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 13dbb405dc31f..b99ad5f50f30d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5290,10 +5290,9 @@ static int pci_bus_trylock(struct pci_bus *bus)
 /* Do any devices on or below this slot prevent a bus reset? */
 static bool pci_slot_resettable(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
 
-	if (slot->bus->self &&
-	    (slot->bus->self->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
+	if (bridge && (bridge->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET))
 		return false;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
@@ -5310,7 +5309,10 @@ static bool pci_slot_resettable(struct pci_slot *slot)
 /* Lock devices from the top of the tree down */
 static void pci_slot_lock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
+
+	if (bridge)
+		pci_dev_lock(bridge);
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5325,7 +5327,7 @@ static void pci_slot_lock(struct pci_slot *slot)
 /* Unlock devices from the bottom of the tree up */
 static void pci_slot_unlock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5335,12 +5337,18 @@ static void pci_slot_unlock(struct pci_slot *slot)
 		else
 			pci_dev_unlock(dev);
 	}
+
+	if (bridge)
+		pci_dev_unlock(bridge);
 }
 
 /* Return 1 on successful lock, 0 on contention */
 static int pci_slot_trylock(struct pci_slot *slot)
 {
-	struct pci_dev *dev;
+	struct pci_dev *dev, *bridge = slot->bus->self;
+
+	if (bridge && !pci_dev_trylock(bridge))
+		return 0;
 
 	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
 		if (!dev->slot || dev->slot != slot)
@@ -5365,6 +5373,9 @@ static int pci_slot_trylock(struct pci_slot *slot)
 		else
 			pci_dev_unlock(dev);
 	}
+
+	if (bridge)
+		pci_dev_unlock(bridge);
 	return 0;
 }
 
-- 
2.51.0

