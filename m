Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E648AE29;
	Mon, 20 Apr 2026 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691923; cv=none; b=cMnHFke9rIEjkmNYcxPpoQZSABikqL1ciuZsgOBtGXRWHvYmUwqf2ykD/QDOGDTGL3sJ3FH3rcnaubCNZbHDFE9hVZVTjzhdvSmxq643ZM6vCTq/vxINuJi2H0qnSOQwQYZXnAAb41KXVdepTBYrEXkOEXGGw+GgY3H4qdg9G2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691923; c=relaxed/simple;
	bh=sAeeCHmKP9SRQ2EKpCxXk/Hm5GZYYx7Fh4XT159vIY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gr/0J3XjoP9Wz8K+k1zdrb3HyPP1cklAqBlvw3CGp32TQg3AqOEyaJHKfN16M7xLZUVp4/m5tDaSeKMf8TCWIxLBm6mF/Z63d69q4tTduO4U8JVjizdO7d0DTU9jfUVnFP3SytmTZ0sJPeQ7Keb5JkEIF1K14Fu6UaU13DfXpWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPGEm8t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPGEm8t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B87AC2BCB6;
	Mon, 20 Apr 2026 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691923;
	bh=sAeeCHmKP9SRQ2EKpCxXk/Hm5GZYYx7Fh4XT159vIY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPGEm8t8fgTB47dQSHDtvN3GltZRcpHBof/MOFBlFkZ/nM14bweSfyFKJK2ZpfphX
	 91crwvPs3vFtoC58PrR4lwe5ZnG7+VogjQlRW7veo7sniOqz5hF44UWAhc67Q2NeCH
	 bvJ8hmUIJZYXf8deTdVGiym7ynC9LoAIyT07xLlPpdBhufaBuKPeH3WWnYp6Tm9rJ6
	 G68/SQLYx6Vd1W/nS9d0dDxGxnmjFhfDRo8jVNzPZVKPfU/oU/eJr5VKqDcNdGwBfu
	 x4cgtyG2g5yD6v6zEuuPbzl7wPRHeP0DtwAW6MYDmptdhbrwgniQ76Oanasp7Cb5A0
	 QIeKyMhfSTWMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marek Vasut <marex@nabladev.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] Bluetooth: btbcm: Add entry for BCM4343A2 UART Bluetooth
Date: Mon, 20 Apr 2026 09:21:05 -0400
Message-ID: <20260420132314.1023554-271-sashal@kernel.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 04c217a7fc8f23a1c99b014cb6a89cf77ac7a012 ]

This patch adds the device ID for the BCM4343A2 module, found e.g.
in the muRata 1YN WiFi+BT combined device. The required firmware
file is named 'BCM4343A2.hcd'.

Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The analysis is clear. Let me write it up.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `Bluetooth: btbcm:`
- Action verb: "Add entry"
- Summary: Adds a device ID for BCM4343A2 UART Bluetooth chip.
Record: [Bluetooth/btbcm] [Add] [Device ID for BCM4343A2 UART module]

**Step 1.2: Tags**
- `Signed-off-by: Marek Vasut <marex@nabladev.com>` — author
- `Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>` — reviewer
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>` —
  Bluetooth subsystem maintainer
- No Fixes: tag (expected — this is a device ID addition, not a bug fix
  per se)
- No Cc: stable tag (expected)
Record: Reviewed by Paul Menzel, committed by Bluetooth maintainer Luiz
von Dentz.

**Step 1.3: Commit Body**
The BCM4343A2 module is found in the muRata 1YN WiFi+BT combined device.
The required firmware file is `BCM4343A2.hcd`. Without this entry, the
driver cannot identify the chip variant and load the correct firmware.
Record: [Without this ID, users with muRata 1YN hardware cannot use
Bluetooth properly]

**Step 1.4: Hidden Bug Fix?**
Not a hidden bug fix — it's an explicit device ID addition to enable
hardware support.
Record: [Not a hidden fix — explicit hardware enablement via device ID]

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/bluetooth/btbcm.c`)
- Lines added: 1
- Lines removed: 0
- Function modified: none — change is in a static data table
  (`bcm_uart_subver_table[]`)
Record: [1 file, +1 line, data table only, zero code logic change]

**Step 2.2: Code Flow**
The `bcm_uart_subver_table[]` is iterated in `btbcm_setup()` (line 618)
to match a `subver` value from the hardware against known chip names. If
a match is found, `hw_name` is set, which is then used to construct the
firmware filename (e.g., `brcm/BCM4343A2.hcd`). Without the entry, the
chip gets a generic "BCM" name and firmware loading will likely fail.
Record: [Before: BCM4343A2 not recognized → generic fallback. After:
correct name and firmware path used]

**Step 2.3: Bug Mechanism**
Category: Hardware enablement / device ID addition. This is not fixing a
code bug — it enables a previously unsupported hardware variant.
Record: [Device ID addition — enables correct firmware loading for
BCM4343A2]

**Step 2.4: Fix Quality**
Trivially correct — a single static data table entry following an
established pattern used by dozens of other entries. Zero regression
risk.
Record: [Trivially correct, zero regression risk, follows established
pattern]

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The `bcm_uart_subver_table` was introduced in 2015 by Marcel Holtmann
(commit `9a0bb57d2d08f1`) and has been populated with additional entries
continuously ever since. The table and driver exist in all stable trees.
Record: [Table exists since 2015, present in all stable trees]

**Step 3.2: Fixes Tag**
No Fixes: tag — not applicable for device ID additions.

**Step 3.3: Related Changes**
Multiple identical-pattern commits exist: BCM4343A0 (`d456f678a074b`),
BCM43430A1 (`feb16722b5d5f`), BCM43430B0 (`27f4d1f214ae4`), BCM4373A0
(`0d37ddfc50d9a`). This commit is entirely standalone.
Record: [Standalone, follows well-established pattern of prior device ID
additions]

**Step 3.4: Author**
Marek Vasut is a well-known Linux kernel developer, primarily in
embedded/ARM. This is a straightforward hardware enablement patch from a
board vendor.
Record: [Established kernel contributor]

**Step 3.5: Dependencies**
None. The change is a single table entry addition. The data structure
and all surrounding code are unchanged.
Record: [No dependencies, standalone patch]

## PHASE 4: MAILING LIST

**Step 4.1: Discussion**
Found the original submission on patchew.org. Paul Menzel reviewed it,
asking about firmware availability. Marek pointed to the muRata firmware
repository. Paul gave `Reviewed-by`. No objections or NAKs.
Record: [Clean review, no concerns raised, Reviewed-by given]

**Step 4.2: Reviewers**
The Bluetooth maintainer (Luiz von Dentz) committed the patch. Paul
Menzel reviewed.
Record: [Committed by subsystem maintainer]

**Step 4.3-4.5:** No bug report (this is hardware enablement), no series
context needed, no stable discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4:** The modified data is consumed by `btbcm_setup()` which
iterates the table to match a subver ID from hardware. This function is
called during Bluetooth device initialization — a standard, well-tested
code path. Adding an entry to the lookup table does not change any code
flow.
Record: [Consumed by btbcm_setup(), standard init path, no code flow
change]

**Step 5.5:** Many similar entries exist (20+ in UART table alone). This
is an established pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `bcm_uart_subver_table` has existed since 2015. The
file and table structure are present in all active stable trees.
Record: [Present in all stable trees]

**Step 6.2:** The patch applies cleanly — it's a single line insertion
into a data table. Even if surrounding entries differ slightly between
trees, this adds a new entry after the BCM4356A2 line (`0x230f`), which
has been in the table since 2017.
Record: [Clean apply expected]

**Step 6.3:** No related fix exists in stable for BCM4343A2.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** Bluetooth driver — IMPORTANT subsystem. Bluetooth is
widely used, and BCM chips are common in embedded/IoT platforms.
Record: [Bluetooth/driver, IMPORTANT criticality]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Users with muRata 1YN WiFi+BT hardware (BCM4343A2 chip)
are affected.
Record: [Driver-specific: users of BCM4343A2/muRata 1YN hardware]

**Step 8.2:** Triggered on every boot/device init for users with this
hardware.
Record: [Triggered on device init — blocking for affected users]

**Step 8.3:** Without this ID, the Bluetooth chip cannot be properly
identified and firmware cannot be loaded — Bluetooth is non-functional
for this hardware.
Record: [Bluetooth non-functional for affected hardware, severity
MEDIUM-HIGH]

**Step 8.4:**
- Benefit: HIGH — enables Bluetooth for specific hardware that otherwise
  doesn't work
- Risk: VERY LOW — 1 line data table addition, zero code change, follows
  established pattern
Record: [Excellent risk-benefit ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence FOR backporting:**
- Classic device ID addition to existing driver (explicit exception
  category)
- 1-line change, trivially correct, zero code logic change
- Follows established pattern (20+ prior similar entries)
- Reviewed by Paul Menzel, committed by Bluetooth maintainer
- Enables real hardware (muRata 1YN) for real users
- Table exists in all stable trees since 2015

**Evidence AGAINST backporting:**
- None identified.

**Step 9.2: Stable Rules Checklist:**
1. Obviously correct and tested? YES — single static data entry
2. Fixes a real bug? YES — enables broken-without-it hardware
3. Important issue? YES for affected users (no Bluetooth at all)
4. Small and contained? YES — 1 line
5. No new features/APIs? YES — just a data table entry
6. Applies to stable? YES — table unchanged across trees

**Step 9.3: Exception Category:**
This is a **Device ID addition to an existing driver** — an explicit
exception category that is automatically YES for stable.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Paul Menzel, SOB by Bluetooth
  maintainer Luiz von Dentz
- [Phase 2] Diff analysis: exactly 1 line added to static
  `bcm_uart_subver_table[]` data table
- [Phase 3] git blame: table introduced in 2015 (commit
  `9a0bb57d2d08f1`), present in all stable trees
- [Phase 3] git log for related entries: confirmed 5+ prior identical-
  pattern device ID additions
- [Phase 4] Patchew/lore: found original submission, clean review, no
  objections
- [Phase 5] Code tracing: table consumed by `btbcm_setup()` at line
  615-622, standard init path
- [Phase 6] Table structure unchanged since 2015, clean apply expected
- [Phase 8] Without entry, BCM4343A2 Bluetooth is non-functional for
  muRata 1YN users

**YES**

 drivers/bluetooth/btbcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index d33cc70eec662..975b73cd04e67 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -507,6 +507,7 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x6119, "BCM4345C0"	},	/* 003.001.025 */
 	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
+	{ 0x2310, "BCM4343A2"	},	/* 001.003.016 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
 	{ 0x420d, "BCM4349B1"	},	/* 002.002.013 */
 	{ 0x420e, "BCM4349B1"	},	/* 002.002.014 */
-- 
2.53.0

