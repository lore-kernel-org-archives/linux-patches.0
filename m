Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B73407570;
	Mon, 20 Apr 2026 13:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691629; cv=none; b=sKqLP+y+QiKz94kBpn8Lek+2xgtZwyy/HPgnzAk2b+2Yp32/4t9cTxFKX21s7x+6J+brAvW3sGUuVJ1j/G9hT4p1ZkS9Mv57Z7S2jJYaobypIGtz0NWbKYmsVH1WCvuhayf/iPKKYMflXIrOi3MayB1jlEO7PO8tnHrNQ46lGh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691629; c=relaxed/simple;
	bh=nAbsIGgmyyONm4jQimPirD+2ZbQr3SdslsuxV5gUrLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tY1YTPC7/smanZSI2UFIqHfPa5nnQ7c2CKiqBYnYkIoh82vLdQPZdDlzKbvD0IXumGl4ifiNV2FGN5we0Km5oP7n3exhceD/rzFjNNzh0SKByjheozFozNoOHkhNbvBiAFYWsRtqU7lXnqd03hyiSuAVy4HqqpBfoeLgJ04pnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYqQvM++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYqQvM++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BDDC2BCB7;
	Mon, 20 Apr 2026 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691629;
	bh=nAbsIGgmyyONm4jQimPirD+2ZbQr3SdslsuxV5gUrLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYqQvM++cNAGtoCP1+L0IjMeqM7bOYEww+LT1no7EV3REA6cD6gEx+RfxM6l1U+n2
	 Jw7u/CIXrZqGswiA/unI2Zk3HigWrgMiV3fyeY1i3rEONytjIkvWTe5U3DEwGR1l7D
	 2s8cI57T+MUNtMFZtg+YMTozXpAwfKGPnMTLPmMjoF/QkXvIj96mKOvUwBDS0fWBpf
	 obW9hkeoIw2hnt/STgfirxZhFyICpTa+FbVQwDZrm8g4b6n7NaGEYjSFOUXTFDp3i1
	 8MxNJXPuR/YEeX/eIZ6BlVrsx4eBhX/bZEGxSPCzifEUsbQKKrN8EZ/g8GALJE8V9q
	 mjMQs2VcPqLvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 7.0-6.1] Bluetooth: btmtk: improve mt79xx firmware setup retry flow
Date: Mon, 20 Apr 2026 09:18:55 -0400
Message-ID: <20260420132314.1023554-141-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 54f1f020e9f4a087779cc4d96a7c86f47d0c6797 ]

If retries are exhausted, driver should not do futher operation.
During mt79xx firmware download process, if the retry count reaches0,
driver will return an -EIO error and release the firmware resources.

Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [bluetooth/btmtk] [improve] Fix retry exhaustion handling in
mt79xx firmware setup - when retry count reaches 0, driver should return
error instead of continuing.

**Step 1.2: Tags**
- Signed-off-by: Chris Lu <chris.lu@mediatek.com> (author, regular
  MediaTek Bluetooth contributor)
- Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
  (Bluetooth maintainer, committed the patch)
- No Fixes: tag, no Reported-by, no Cc: stable - expected for manual
  review candidates.

**Step 1.3: Commit Body**
The body describes: "If retries are exhausted, driver should not do
further operation. During mt79xx firmware download process, if the retry
count reaches 0, driver will return an -EIO error and release the
firmware resources." Clear description of a missing error check.

**Step 1.4: Hidden Bug Fix Detection**
Despite the word "improve" in the subject, this IS a bug fix. The word
"improve" masks a clear logic error: the retry loop can exhaust without
any error return, causing the driver to silently proceed with firmware
download on a device in an abnormal state.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/bluetooth/btmtk.c`
- +6 lines added (1 comment, 5 code lines)
- Function modified: `btmtk_setup_firmware_79xx()`
- Scope: single-file surgical fix

**Step 2.2: Code Flow Change**
The retry loop at line 171 (`while (retry > 0)`) handles
`BTMTK_WMT_PATCH_PROGRESS` by decrementing `retry`. BEFORE: if retry
hits 0, the loop exits normally and code falls through to `fw_ptr +=
section_offset`, proceeding with firmware download. AFTER: a check for
`retry == 0` returns `-EIO` and jumps to `err_release_fw`.

**Step 2.3: Bug Mechanism**
This is a **logic/correctness fix** - missing error check after retry
exhaustion. The `while (retry > 0)` loop can exit via:
1. `break` when status == `BTMTK_WMT_PATCH_UNDONE` (normal path -
   proceed to download)
2. `goto next_section` when status == `BTMTK_WMT_PATCH_DONE` (skip
   section)
3. `goto err_release_fw` on command error or unexpected status
4. Loop exhaustion when retry reaches 0 (BUG: falls through to download
   path)

Case 4 is the bug - the code proceeds as if the device is ready when
it's not.

**Step 2.4: Fix Quality**
Obviously correct. The check `if (retry == 0)` can only be true if the
loop exhausted, meaning the device never left `PATCH_PROGRESS` state.
Returning `-EIO` and cleaning up is the correct behavior. No regression
risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code was introduced in commit `8c0d17b6b06c5b` "Bluetooth:
mediatek: add BT_MTK module" by Sean Wang on 2021-10-19. This was the
initial creation of the BT_MTK module.

**Step 3.2: No Fixes: tag** - expected.

**Step 3.3: File History**
The function `btmtk_setup_firmware_79xx` has been stable since 2021 in
the retry loop area. The surrounding code has only had one minor change
(commit `995d948cf2e458` adding `err = -EIO` in the else branch).

**Step 3.4: Author**
Chris Lu is a regular MediaTek Bluetooth contributor with 28+ commits
touching `drivers/bluetooth/`, including many device ID additions and
critical fixes.

**Step 3.5: Dependencies**
This commit is patch 1/3 of a series, but it is **standalone**. Patches
2/3 and 3/3 add additional improvements (status checking and reset
mechanism) that build on this but are not required. The fix applies
cleanly without dependencies.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
Found via `b4 dig -c 54f1f020e9f4`: Submitted as `[PATCH v1 1/3]` on
2026-02-03. The cover letter explains: "When the device unexpectedly
restarts during previous firmware download process, it can cause mt79xx
firmware status to be abnormal in the next attempt." Series applied to
bluetooth-next by Luiz Augusto von Dentz on 2026-04-10.

**Step 4.2: Review**
Only v1 was submitted (no revisions needed). The Bluetooth maintainer
(Luiz Augusto von Dentz) applied the series directly, indicating
confidence in the fix quality.

**Step 4.3: Bug Report**
No specific bug report link. The cover letter describes a real-world
scenario where the device unexpectedly restarts during firmware
download.

**Step 4.4: Series Context**
Part of 3-patch series, but this patch is standalone. Patches 2 and 3
are independent improvements that enhance the error recovery further.

**Step 4.5: Stable Discussion**
No existing stable nomination or discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Function**
`btmtk_setup_firmware_79xx()` - firmware setup for MT79xx series.

**Step 5.2: Callers**
- `btmtk_usb_setup()` in `btmtk.c` line 1332 - USB path for MT7922,
  MT7925, MT7961
- `mt79xx_setup()` in `btmtksdio.c` line 873 - SDIO path

Both are called during device initialization/setup.

**Step 5.3-5.4: Reachability**
Called during HCI device setup, triggered when a MT79xx Bluetooth device
is initialized. This is a common code path for all MT792x Bluetooth
device users.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code exists in stable**
The buggy code was introduced in October 2021 (commit `8c0d17b6b06c5b`).
Tags show it's in p-6.1, p-6.6, and all newer stable trees. The bug
affects ALL active stable trees.

**Step 6.2: Backport Complexity**
The patch should apply cleanly - the retry loop code hasn't changed
since the original 2021 commit.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
Bluetooth driver (drivers/bluetooth/) - IMPORTANT criticality.
MT7921/MT7922/MT7925 are extremely popular WiFi/BT combo chips found in
many laptops (Lenovo, ASUS, Dell, etc.).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users of MediaTek MT7921, MT7922, MT7925 Bluetooth devices (very large
population).

**Step 8.2: Trigger Conditions**
Triggered when the device reports `BTMTK_WMT_PATCH_PROGRESS`
continuously for 2+ seconds during firmware download. The cover letter
describes this happening after an unexpected device restart during a
previous firmware download attempt.

**Step 8.3: Failure Mode**
Without fix: firmware download proceeds on a device in an abnormal
state, potentially leading to device malfunction, failed bluetooth
initialization, or undefined behavior. Severity: MEDIUM-HIGH.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents firmware download to a device in an abnormal state
  for widely-used hardware
- RISK: Extremely low - 5 lines, obviously correct, only affects an
  already-failed case
- Ratio: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real logic error (missing error check after retry exhaustion)
- Very small and surgical (5 lines of code)
- Obviously correct
- Affects widely-used hardware (MT792x family)
- Standalone fix with no dependencies
- Applied by subsystem maintainer without revisions needed
- Buggy code exists in all active stable trees since 2021
- Clean apply expected

**Evidence AGAINST backporting:**
- Not a crash/panic fix - the immediate impact is proceeding with
  firmware download in an abnormal state
- No specific user-reported bug linked
- Commit message uses "improve" rather than "fix"

**Stable Rules Checklist:**
1. Obviously correct and tested? YES - trivially verifiable, applied to
   bluetooth-next
2. Fixes a real bug? YES - missing error handling after retry exhaustion
3. Important issue? MEDIUM-HIGH - prevents undefined device behavior
   during firmware setup for popular hardware
4. Small and contained? YES - 5 lines, one file, one function
5. No new features? CORRECT - pure error handling fix
6. Can apply to stable? YES - clean apply expected

## Verification

- [Phase 1] Parsed tags: Signed-off-by from Chris Lu (author) and Luiz
  Augusto von Dentz (maintainer/committer)
- [Phase 2] Diff analysis: 5 lines added after retry loop in
  `btmtk_setup_firmware_79xx()`, adds `retry == 0` check returning -EIO
- [Phase 3] git blame: buggy code introduced in commit 8c0d17b6b06c5b
  (2021-10-19, Sean Wang), present in all stable trees
- [Phase 3] git tag --contains: confirmed present in p-6.1, p-6.6, and
  all newer stable tags
- [Phase 3] git log --author="Chris Lu": confirmed Chris Lu is a regular
  MediaTek BT contributor with 28+ commits
- [Phase 4] b4 dig -c 54f1f020e9f4: found original submission at
  https://patch.msgid.link/20260203062510.848761-2-chris.lu@mediatek.com
- [Phase 4] b4 dig -a: only v1, no revisions needed, applied directly by
  maintainer
- [Phase 4] Thread mbox: series was applied to bluetooth-next,
  patchwork-bot confirmed
- [Phase 4] Cover letter: describes real-world scenario (device restart
  during firmware download)
- [Phase 5] Grep callers: btmtk_usb_setup() (USB path) and
  mt79xx_setup() (SDIO path) both call this function
- [Phase 6] Code unchanged in retry loop since 2021 - clean apply
  expected
- [Phase 8] Failure mode: proceeds with firmware download on abnormal
  device state, severity MEDIUM-HIGH

**YES**

 drivers/bluetooth/btmtk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index fa7533578f85c..0ada5a12130dc 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -205,6 +205,12 @@ int btmtk_setup_firmware_79xx(struct hci_dev *hdev, const char *fwname,
 				}
 			}
 
+			/* If retry exhausted goto err_release_fw */
+			if (retry == 0) {
+				err = -EIO;
+				goto err_release_fw;
+			}
+
 			fw_ptr += section_offset;
 			wmt_params.op = BTMTK_WMT_PATCH_DWNLD;
 			wmt_params.status = NULL;
-- 
2.53.0

