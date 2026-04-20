Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEFC3DFC6C;
	Mon, 20 Apr 2026 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691466; cv=none; b=qpnswFGK2u5SpceNF4XZpeQ5RVlkbggyHnf1knGwLbzSY9Gzb9EIprvnSSGWJlP2yMy4d0s4RUhhANTxZrJWJy08FqPGB3rjlLCtnX/8duQmZwgYwqIRNloPEG1Fkr5w9yg/Sw/xkQAerTnKONh3W6LC4LRy+OmMlvTGnrQ58WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691466; c=relaxed/simple;
	bh=lGgmgehFZKHkBWXmd+Y1CJyMp2bguwHqwvnoqatn6Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3e8zB/rjucjwhsL3H92gVgNYkMQQy4vOlnjcjPvTyzm1Q82Ju9cnnmU4ekVdL9KxZXMz8LKDXSkPLiFxBNF3wo6ssxszzb0/rjJoCTOokgGqPOQlOYPYCDio99GRpj4Js5FRMR1pbMkd9/e0/XXEYvJONAKzp03SahBQqk3pWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQpd9/aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQpd9/aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDCCC2BCB7;
	Mon, 20 Apr 2026 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691466;
	bh=lGgmgehFZKHkBWXmd+Y1CJyMp2bguwHqwvnoqatn6Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQpd9/aQwhaUAaa522RzmlrWW7HUxnbWfqVoBmvLAltJFYDP+P6dD0fnnOocaqPJS
	 b/JIAHcuwiqg+nU9wIVBhwouLs8d0rbX0srYpRmwnd9mO7UbWq59GHxcUEvSyyRrEL
	 QIaZx++wEb4fNaY6PxXAfCntz/U53z3pEQd6jYBarVoHD7W7/V6UnCjKdvaHWmIPLn
	 fiorBBF1ibqroymsazCCePSM/I/RAf8YscN6BS/3BggHHyCiZu1MD4Fp/xBMdh1g3P
	 lHhvX5jPLylcwvEsdYs3ii47GwCc0n10tif2PyYQycNMgfobwEawjnR3DIlDVIKYos
	 0bs/j7W+JkhbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kamiyama Chiaki <nercone@nercone.dev>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] Bluetooth: btusb: MediaTek MT7922: Add VID 0489 & PID e11d
Date: Mon, 20 Apr 2026 09:17:19 -0400
Message-ID: <20260420132314.1023554-45-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kamiyama Chiaki <nercone@nercone.dev>

[ Upstream commit 5e17010bfc7e6820a5004f1e06d08db886e3927e ]

Add VID 0489 & PID e11d for MediaTek MT7922 USB Bluetooth chip.
Found in Dynabook GA/ZY (W6GAZY5RCL).

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=03 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  3 Spd=480  MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0489 ProdID=e11d Rev= 1.00
S:  Manufacturer=MediaTek Inc.
S:  Product=Wireless_Device
S:  SerialNumber=000000000

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Kamiyama Chiaki <nercone@nercone.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now let me finalize the analysis. I have all the key facts.

---

## Complete Analysis: Bluetooth: btusb: MediaTek MT7922: Add VID 0489 &
PID e11d

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `Bluetooth: btusb`
- Action: "Add" (device ID addition)
- Summary: Adds USB Vendor ID 0489 and Product ID e11d for a MediaTek
  MT7922 Bluetooth chip.
- Record: [Bluetooth/btusb] [Add] [New USB device ID for MT7922 variant
  in Dynabook laptop]

**Step 1.2: Tags**
- Reviewed-by: Paul Menzel (well-known kernel reviewer)
- Signed-off-by: Kamiyama Chiaki (author)
- Signed-off-by: Luiz Augusto von Dentz (Bluetooth subsystem maintainer)
- No Fixes: tag (expected — this is a device ID, not a bug fix)
- No Reported-by / syzbot
- Record: Reviewed by Paul Menzel. Signed off by the Bluetooth
  maintainer (Luiz von Dentz). No Fixes/Cc: stable tags expected for
  device ID additions.

**Step 1.3: Commit Body**
- Identifies the specific laptop: Dynabook GA/ZY (W6GAZY5RCL)
- Provides full USB descriptor dump confirming MediaTek Inc. as
  manufacturer
- The device is a "Wireless_Device" at USB 2.0 speed (480 Mbps)
- Record: Clear real-world hardware identification. Without this ID,
  Bluetooth does not work on this specific laptop.

**Step 1.4: Hidden Bug Fix Detection**
- This is not a hidden bug fix — it's an explicit device ID addition.
  But it does fix a real user problem: Bluetooth doesn't work on
  Dynabook GA/ZY without this entry.
- Record: Not a hidden bug fix. Straightforward device enablement.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Changes Inventory**
- 1 file modified: `drivers/bluetooth/btusb.c`
- 2 lines added, 0 lines removed
- Change location: USB device ID quirks_table[] in the MT7922A section
- Record: Single file, +2 lines, one function (static table). Scope:
  trivially small.

**Step 2.2: Code Flow Change**
- Before: Device 0489:e11d is not recognized by btusb → generic USB
  handling, Bluetooth non-functional
- After: Device 0489:e11d is matched → BTUSB_MEDIATEK |
  BTUSB_WIDEBAND_SPEECH flags set → proper MediaTek initialization path
  used → Bluetooth works
- Record: Table entry addition only. No logic change.

**Step 2.3: Bug Mechanism**
- Category: Hardware enablement (device ID addition)
- The new entry `{ USB_DEVICE(0x0489, 0xe11d), .driver_info =
  BTUSB_MEDIATEK | BTUSB_WIDEBAND_SPEECH }` is identical in pattern to
  all other MT7922A entries in the table.
- Record: Device ID addition to existing driver table. Uses identical
  flags as all sibling entries.

**Step 2.4: Fix Quality**
- Obviously correct — exact same pattern as dozens of adjacent entries
- Minimal/surgical — 2 lines in a static table
- Zero regression risk — only affects the specific USB device 0489:e11d
- Record: Trivially correct. Zero regression risk.

### PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- MT7922A section created in commit 6932627425d6 (Dec 2021, v5.17 cycle)
- MT7922 support added in 8c0401b7308cb (Mar 2024)
- Both are ancestors of HEAD (v7.0)
- Many other device IDs have been added to this section over the years
- Record: MT7922A driver support has existed since Linux 5.17. Present
  in all active stable trees.

**Step 3.3: File History**
- `btusb.c` is actively maintained with frequent device ID additions
- Recent commits include other MT7922 ID additions (e170, e152, e153,
  3584, etc.)
- Record: Active file. Frequent device ID additions. No prerequisites
  needed.

**Step 3.4: Author Context**
- Author (Kamiyama Chiaki) appears to be a first-time contributor (no
  other commits found)
- Signed off by Bluetooth maintainer Luiz Augusto von Dentz
- Reviewed by Paul Menzel
- Record: New contributor, but patch reviewed and signed off by the
  subsystem maintainer.

**Step 3.5: Dependencies**
- The diff context shows `0xe174` and `0x04ca, 0x3807` in the
  surrounding lines, which are NOT present in the 7.0 tree. These are
  other device IDs added around the same time.
- However, this is a table entry addition — it has no code dependencies.
  The entry can be placed anywhere in the MT7922A section.
- Record: No functional dependencies. Minor context conflict expected
  (trivially resolvable by placing the entry adjacent to existing
  0489:e102 entry).

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** b4 dig could not find the commit (it hasn't been
applied to the tree under analysis). Web search did not find the
specific lore thread. However, the commit was reviewed by Paul Menzel
and signed off by the Bluetooth maintainer, which is sufficient vetting.

**Step 4.3-4.5:** No bug report — this is hardware enablement rather
than a bug fix. No stable discussion found.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** Not applicable in the traditional sense — this is a
static data table addition, not a function change. The `quirks_table[]`
is used by the USB core to match devices during enumeration. When a
device with VID 0489/PID e11d is connected, the `BTUSB_MEDIATEK` flag
triggers the MediaTek initialization path in btusb.

Record: Static table entry. The MediaTek code path is well-tested and
used by dozens of other device IDs.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The MT7922A device ID section exists in all stable trees
from 5.17 onward. The `BTUSB_MEDIATEK` and `BTUSB_WIDEBAND_SPEECH` flags
exist in all active stable trees.

**Step 6.2:** Minor context conflict expected due to other device IDs
added in the same section. Trivial to resolve — just add the 2-line
entry in the correct position.

**Step 6.3:** No related fixes already in stable for this specific
device ID.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Bluetooth (drivers/bluetooth/) — IMPORTANT subsystem.
Bluetooth is critical for laptops and mobile devices.

**Step 7.2:** btusb.c is actively developed with frequent device ID
additions. This is a well-established pattern.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of Dynabook GA/ZY (W6GAZY5RCL) and any other
device using the Foxconn/MediaTek 0489:e11d Bluetooth adapter.

**Step 8.2:** Trigger: any user who has this hardware and plugs it in or
boots with it. Without this entry, Bluetooth is completely non-
functional.

**Step 8.3:** Without the fix: Bluetooth does not work at all. Severity:
HIGH for affected users (complete loss of functionality).

**Step 8.4:**
- Benefit: HIGH — enables Bluetooth on real hardware
- Risk: VERY LOW — 2-line static table entry, affects only this specific
  USB device
- Ratio: Excellent benefit-to-risk ratio

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence FOR backporting:**
- Textbook USB device ID addition — the #1 most common exception
  category for stable
- 2 lines added to a static table — minimal possible change
- Zero regression risk — only affects the specific 0489:e11d device
- MT7922 driver support exists in all active stable trees (since 5.17)
- Reviewed and signed off by the Bluetooth subsystem maintainer
- Enables hardware for a real product (Dynabook GA/ZY)

**Evidence AGAINST backporting:**
- None identified. Minor context conflict is trivially resolvable.

**Step 9.2: Stable Rules Checklist:**
1. Obviously correct? YES — identical pattern to 20+ adjacent entries
2. Fixes a real problem? YES — Bluetooth non-functional without it
3. Important issue? YES — complete loss of Bluetooth functionality
4. Small and contained? YES — 2 lines in one file
5. No new features or APIs? CORRECT — just a device ID
6. Can apply to stable? YES — with trivial context adjustment

**Step 9.3: Exception Category:** YES — This is a **NEW DEVICE ID**
addition to an existing driver. This is explicitly listed as an allowed
exception to stable rules.

### Verification

- [Phase 1] Parsed tags: Reviewed-by Paul Menzel, Signed-off-by Luiz von
  Dentz (Bluetooth maintainer)
- [Phase 2] Diff analysis: +2 lines in static USB device ID table,
  identical pattern to adjacent entries
- [Phase 3] git blame: MT7922A section created in 6932627425d6 (Dec
  2021), present in tree since v5.17
- [Phase 3] git merge-base: Confirmed 6932627425d6 and 8c0401b7308cb are
  ancestors of HEAD
- [Phase 3] Grep for 0xe11d: Confirmed device ID not yet present in v7.0
  tree
- [Phase 5] Grep for MT7922: Confirmed MT7922/MT7922A sections exist
  with many similar entries at lines 675-719
- [Phase 6] MT7922A support exists in all active stable trees
  (introduced in 5.17 cycle)
- [Phase 6] Context conflict: 0xe174 and 0x04ca:3807 in diff context
  don't exist in 7.0 — trivial conflict
- [Phase 8] Impact: Complete Bluetooth failure on Dynabook GA/ZY without
  this ID
- UNVERIFIED: Could not access lore.kernel.org discussion thread due to
  anti-bot protection

This is a textbook device ID addition — the most common and safest type
of stable backport. Two lines in a static table, zero regression risk,
enables real hardware for real users.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1acc07d0dc061..5672f0ac27557 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -699,6 +699,8 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe102), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe11d), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe152), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe153), .driver_info = BTUSB_MEDIATEK |
-- 
2.53.0

