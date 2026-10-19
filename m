Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46165AB8F9;
	Mon, 19 Oct 2026 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418405; cv=none; b=hogiAOxxIJVvzL0FiiSFVx9iv3ds2Ogf16fvaU7aXId7V8x468CKAdABVF8FzlnXH2JwzIVSPIMSxKbuffW9yzgCszbCjENRG6kJZHFBmc0RbOOQeR3nM5XPuJhNSIdBvHH0vA/fiKDZJMffaMXydvimtt+urV7lnamvuhPh+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418405; c=relaxed/simple;
	bh=Ib6bj0VMriK567dGbYrjsTVRlbDOe4/N/WvCmrcH/hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYOrHhPfa7GjPJeTQNpCXmBDQ0/cpHm50Oc61VCbkO/RQL76L9dJC6VKOQvi4RtVMP3OqPF4Tq45nA5mtjzC651NDW0E1s9DDIwrFSP//BoK3yZtBHj29QNsQdqotn+jnpa2bhxUgIwxXetJD6sbB3Gj+wSEABc0hgOLucAb8Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJpOgJsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJpOgJsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212731F000C4;
	Mon, 19 Oct 2026 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418403;
	bh=onmk7xy9JhoEUkcKbibCdG2aJuH6B0VUAIPiInLCYz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJpOgJsgsU9esfAgYVwv69fZr9NLwOXsH8Pb2/149znTSUazYJ7M8pQcAtJg5X88W
	 2mLI8HyjIvfRvH1uXyEtVqC+Eq95TyJf+lknEE1d2+j9bEJcdDwi5YlCv2M+p6DC9o
	 ETwolojFc/Lhto1HIihKEeyZ1/qv+/0nQOzxLwbn9A8bmaZuu3FlepYFr2gEG9W7P+
	 2MIsRIdU6wc+I7j1QYcdM3o42WM8StkkRSm697B0SyBUOumluWldJ+ATlek/4oiaVB
	 UBrYWGB0qHBHlqBKHlap2FZAIC94D64BSOmdvqxu5bdVjyg71U6xU+VJbc/1Kh8lKT
	 QpMWhrThR28kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: hci_nokia: validate firmware packet bounds
Date: Mon, 19 Oct 2026 09:48:36 -0400
Message-ID: <20261019135441.1420968-225-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45640627e3ddc5f4d3a0d08618a596a8c65d48a5 ]

nokia_setup_fw() walks a length-prefixed firmware stream and
decodes HCI command packets from each record.

Check that each record fits in the remaining firmware image, that command
records contain the HCI command header, and that the payload length is
covered before submitting the command.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`pending-6.18`). The buggy firmware
parser is in this checkout and the bounds checks are not. This is a real
out-of-bounds firmware walk, not a feature or cleanup.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[Bluetooth / hci_nokia] [validate] [bounds-check length-
prefixed firmware records before decoding HCI commands]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- **Signed-off-by:** Luiz Augusto von Dentz \<luiz.von.dentz@intel.com\>
  (Bluetooth maintainer; applied the patch)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link**
- Ignore pipeline markers if present (none on the upstream commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `nokia_setup_fw()` walks a length-prefixed firmware blob and
  treats each record as an HCI command without checking that `pkt_size`,
  the command header, or `cmd->plen` fit in the remaining image.
- **Symptom / failure mode:** out-of-bounds read of firmware (`memcpy`
  of `cmd->plen` bytes; pointer walk past `fw->data`), and `size_t`
  underflow of `fw_size` if `pkt_size + 2 > fw_size`, which can turn the
  loop into an unbounded walk.
- **Version info in message:** none. Introducer is the original driver
  (v4.12-rc1).
- **Root cause (author):** missing bounds checks on a length-prefixed
  stream before `__hci_cmd_sync()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** Subject and body are an explicit bounds-
validation fix. Same class as firmware OOB checks already in this tree
for `btrtl` and `hci_aml`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/bluetooth/hci_nokia.c` — **+20 / −0**
- **Function:** `nokia_setup_fw()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Current loop in this tree:

```350:381:drivers/bluetooth/hci_nokia.c
        while (fw_size >= 4) {
                u16 pkt_size = get_unaligned_le16(fw_ptr);
                u8 pkt_type = fw_ptr[2];
                const struct hci_command_hdr *cmd;
                u16 opcode;
                struct sk_buff *skb;

                switch (pkt_type) {
                case HCI_COMMAND_PKT:
                        cmd = (struct hci_command_hdr *)(fw_ptr + 3);
                        opcode = le16_to_cpu(cmd->opcode);

                        skb = __hci_cmd_sync(hu->hdev, opcode,
cmd->plen,
                                             fw_ptr + 3 +
HCI_COMMAND_HDR_SIZE,
                                             HCI_INIT_TIMEOUT);
                        // ...
                }
                fw_ptr += pkt_size + 2;
                fw_size -= pkt_size + 2;
        }
```

Record, per hunk:
1. **Record size vs remaining image:** before, a huge `pkt_size` was
   trusted; after, `pkt_size > fw_size - 2` → `-EINVAL` / `goto done`.
2. **Command header present:** before, `fw_ptr + 3` was cast to
   `hci_command_hdr` with only `fw_size >= 4`; after, `pkt_size < 1 +
   HCI_COMMAND_HDR_SIZE` is rejected (`HCI_COMMAND_HDR_SIZE` is 3).
3. **Payload vs `cmd->plen`:** before, `__hci_cmd_sync()` copied
   `cmd->plen` bytes from `fw_ptr + 6` with no check; after, `cmd->plen
   > pkt_size - 1 - HCI_COMMAND_HDR_SIZE` is rejected.

Error path only for malformed images. Valid firmware is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Memory safety / OOB + size_t underflow]**
- `hci_cmd_sync_alloc()` does `skb_put_data(skb, param, plen)` →
  `memcpy` of `cmd->plen` (up to 255) from the firmware pointer with no
  source-size check.
- `fw_size` is `size_t`. `fw_size -= pkt_size + 2` underflows if the
  record is larger than the remaining blob, so the `while (fw_size >=
  4)` loop can continue with `fw_ptr` past the buffer.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct and minimal.** Arithmetic is sound: the loop
already requires `fw_size >= 4`, so `fw_size - 2` does not underflow;
the header check makes `pkt_size - 1 - HCI_COMMAND_HDR_SIZE` non-
negative. Regression risk is low: only malformed images that already
caused OOB are rejected. No API, locking, or data-structure changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Entire parser is **7bb318680e868c** (“Bluetooth: add nokia
driver”, Sebastian Reichel, 2017-04-13). **`git describe --contains` →
`v4.12-rc1~129^2~175^2~4`.** Unchanged since then in this area.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Introducer is the original driver commit
above. That commit is in this tree (the driver file exists and matches
the pre-image).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `hci_nokia.c` history in this tree is unrelated
(h4_recv_buf, quirk_flags, SPDX, unused struct). **Standalone, not patch
X/Y.** No later `hci_nokia.c` commits on `origin/master` after the fix.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou has other Bluetooth bounds-check commits in this
tree (`btusb` Realtek vendor event length, SCO altsetting clamp).
Maintainer SOB is Luiz von Dentz.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses existing `HCI_COMMAND_HDR_SIZE`, `goto done`,
`request_firmware`. **`git apply --check` of 45640627e3ddc succeeded on
this tree.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260706091701.77562-1-pengpeng@iscas.ac.cn
- **v1 only** (no v2/v3)
- Applied to bluetooth-next as **a392bd47c5e0** by Luiz on 2026-07-07;
  mainline **45640627e3ddc** (same patch-id
  `6d5cdd79755cd7e3d221355fefd1165392e0381a`)
- **No NAKs.** BlueZ CI: CheckPatch/BuildKernel/Sparse/32-bit all PASS
  (Patchwork series 1122167)
- No reviewer “Cc: stable” in the thread (CI + patchwork-bot only)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (**b4 dig -w**): Marcel Holtmann, Luiz von Dentz, linux-
bluetooth, linux-kernel. Applied by the Bluetooth maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No syzbot/bugzilla/user report.** Bug is from code inspection
of the parser.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Same class of firmware-bounds fixes landed in
mainline around the same time:
- `Bluetooth: btrtl: validate firmware patch bounds`
- `Bluetooth: hci_aml: validate firmware segment lengths`
Both are **already in this 6.18 tree** (6744ab60dfac5, e1534d49a7b8b)
via stable (they had `Cc: stable`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned **403**. Keyword search
found **no** stable-list discussion of this subject. **UNVERIFIED**
beyond that.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: **`nokia_setup_fw()`** only.

**Step 5.2: TRACE CALLERS**
Record:
- `nokia_setup()` → `nokia_setup_fw()` (step “3. send firmware”)
- `nokia_proto.setup = nokia_setup`
- `hci_uart_setup()` in `hci_serdev.c` / `hci_ldisc.c` calls
  `hu->proto->setup(hu)`

**Step 5.3: TRACE CALLEES**
Record: `request_firmware()`, `get_unaligned_le16()`, `__hci_cmd_sync()`
→ `hci_cmd_sync_alloc()` → `skb_put_data()`/`memcpy()`,
`release_firmware()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Triggered when the HCI UART Nokia device is set up (HCI bring-up
after serdev probe of `nokia,h4p-bluetooth`). **Reachable from userspace
HCI up**, not from arbitrary syscalls without the device. Firmware comes
from `nokia/bcmfw.bin` or `nokia/ti1273.bin` via the firmware loader
(including the userspace helper).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `btintel_legacy_rom_patching()` already validates `remain <
cmd->plen`. This tree already backported the same class for **btrtl**
and **hci_aml**. `hci_nokia` was the missing parser.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes**, `drivers/bluetooth/hci_nokia.c` `nokia_setup_fw()`,
lines 350–381. Introduced **v4.12**.
Local tree: **`p-6.18-1-g03b85e06ca9bf`, kernelversion 6.18.53, branch
`pending-6.18`.**
`git merge-base --is-ancestor 45640627e3ddc HEAD` → **not an ancestor**
(fix not in this tree).
`git merge-base --is-ancestor 45640627e3ddc v6.18` → **not in v6.18**.
Mainline describe: **v7.2-rc6-1358-g45640627e3ddc**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (`git apply --check` exit 0). Surrounding code
matches the pre-image.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: **No** `Malformed firmware` / this subject in this tree. Sibling
firmware OOB fixes for other BT drivers **are** already here; they do
not cover `hci_nokia`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **Bluetooth HCI UART Nokia H4+ driver**
(`CONFIG_BT_HCIUART_NOKIA`). **PERIPHERAL** (Nokia N9/N900/N950-class
UART Bluetooth), but the bug class is kernel memory safety during device
setup.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Bluetooth core is active; `hci_nokia.c` itself is mature (parser
unchanged since 2017).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG_BT_HCIUART_NOKIA`
and DT `nokia,h4p-bluetooth`, firmware `nokia/bcmfw.bin` or
`nokia/ti1273.bin`.

**Step 8.2: TRIGGER CONDITIONS**
Record: HCI setup with a firmware image whose length prefix, header, or
`plen` does not fit the blob. **Not every boot with good linux-
firmware.** Can be hit by truncated/corrupt firmware or a userspace
firmware loader. Unprivileged network clients cannot trigger it without
the device and a bad firmware file.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Kernel OOB read** (`memcpy` past `fw->data`) and possible
**unbounded buffer walk** after `fw_size` underflow. **Severity: HIGH**
(oops / KASAN / infoleak potential). Not a remote unauth exploit by
itself.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH for affected hardware** (prevents OOB/crash on bad
  firmware); **MEDIUM overall** (niche driver, but same bug class
  already taken for other BT firmware parsers in this tree).
- **Risk: VERY LOW** (20 lines, error-path only, clean apply).
- **Ratio: backport.**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB: trusted `pkt_size`/`cmd->plen` without remaining-size
  checks; `__hci_cmd_sync` copies `plen` bytes; `fw_size` can underflow.
- Present in this 6.18.53 tree since v4.12; fix is not in HEAD.
- Small (+20), obviously correct, applies cleanly.
- No new APIs; valid firmware behavior unchanged.
- Applied by the Bluetooth maintainer; BlueZ CI passed.
- Same class already backported here for `btrtl` and `hci_aml`.

**AGAINST:**
- Niche Nokia UART hardware.
- No syzbot/user report; trigger needs malformed firmware.
- No `Fixes:` / `Cc: stable` (not a negative under these rules).

**UNRESOLVED:**
- Stable list 403; no evidence it was NAK’d for stable.
- No public crash report with a stack trace.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** (logic + maintainer apply +
   CI)
2. Fixes a real bug that affects users? **PASS** (OOB on malformed Nokia
   firmware at HCI setup)
3. Important (crash/security/corruption/deadlock)? **PASS** — HIGH
   memory-safety OOB
4. Small and contained? **PASS** — +20 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
**memory-safety bug fix**.

**Step 9.4: DECISION**
This tree still has the unbounded firmware walk. The patch is a 20-line
guard that this 6.18 branch already accepted for sibling Bluetooth
firmware parsers. Backport it.

---

### What the commit solves for this tree

`nokia_setup_fw()` still trusts a LE16 length and `cmd->plen` from
`nokia/bcmfw.bin` / `nokia/ti1273.bin`. A truncated or hostile image can
make `__hci_cmd_sync()` `memcpy` past the firmware buffer and can wrap
`fw_size` so the loop walks off the end. The patch rejects those records
with `-EINVAL` before the copy/advance.

### Risk vs benefit

Benefit is preventing a kernel OOB during HCI setup on Nokia H4+ UART
Bluetooth. Risk is negligible: checks only fire on records that already
overflowed, and the hunk applies without context changes.

---

### Verification
- **[Phase 1]** Parsed tags on `45640627e3ddc` / `a392bd47c5e0`: author
  + Luiz SOB only; no Fixes/Cc/Reported-by
- **[Phase 2]** Diff: +20 in `nokia_setup_fw()`; three `-EINVAL` checks;
  `__hci_cmd_sync` / `skb_put_data` confirmed as `memcpy(param, plen)`
- **[Phase 2]** `HCI_COMMAND_HDR_SIZE` is 3; `struct hci_command_hdr {
  __le16 opcode; __u8 plen; }`
- **[Phase 3]** `git blame` 350–381: all `7bb318680e868c` (v4.12-rc1)
- **[Phase 3]** No Fixes tag; introducer is original driver
- **[Phase 3]** `git apply --check` of 45640627e3ddc: **exit 0**
- **[Phase 4]** `b4 dig -c a392bd47c5e0` / `-a` / `-w`: v1 only; lore
  msgid 20260706091701.77562-1; CC Holtmann + von Dentz + linux-
  bluetooth
- **[Phase 4]** mbox: BlueZ CI PASS; patchwork-bot applied to bluetooth-
  next `a392bd47c5e0`; no NAK
- **[Phase 4]** lore.kernel.org WebFetch 403; stable-list discussion
  **UNVERIFIED** (search did not show a hit)
- **[Phase 5]** Callers: `nokia_setup` ← `hci_uart_setup` in
  `hci_serdev.c`/`hci_ldisc.c`
- **[Phase 6]** `git describe HEAD` → `p-6.18-1-g03b85e06ca9bf`; `make
  kernelversion` → **6.18.53**
- **[Phase 6]** Buggy loop present; `merge-base --is-ancestor
  45640627e3ddc HEAD` failed; not in v6.18; mainline is v7.2-rc6-1358
- **[Phase 6]** Sibling firmware OOB fixes **are** in this tree:
  6744ab60dfac5 (btrtl), e1534d49a7b8b (hci_aml)
- **[Phase 8]** Failure mode: OOB read / possible unbounded walk → HIGH
- **UNVERIFIED:** whether a specific production `nokia/*.bin` is
  malformed (not required; the parser is still unchecked)

**YES**

 drivers/bluetooth/hci_nokia.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/bluetooth/hci_nokia.c b/drivers/bluetooth/hci_nokia.c
index 1e65b541f8ade..be2923231e712 100644
--- a/drivers/bluetooth/hci_nokia.c
+++ b/drivers/bluetooth/hci_nokia.c
@@ -354,9 +354,29 @@ static int nokia_setup_fw(struct hci_uart *hu)
 		u16 opcode;
 		struct sk_buff *skb;
 
+		if (pkt_size > fw_size - 2) {
+			err = -EINVAL;
+			dev_err(dev, "%s: Malformed firmware packet\n",
+				hu->hdev->name);
+			goto done;
+		}
+
 		switch (pkt_type) {
 		case HCI_COMMAND_PKT:
+			if (pkt_size < 1 + HCI_COMMAND_HDR_SIZE) {
+				err = -EINVAL;
+				dev_err(dev, "%s: Malformed firmware command\n",
+					hu->hdev->name);
+				goto done;
+			}
+
 			cmd = (struct hci_command_hdr *)(fw_ptr + 3);
+			if (cmd->plen > pkt_size - 1 - HCI_COMMAND_HDR_SIZE) {
+				err = -EINVAL;
+				dev_err(dev, "%s: Truncated firmware command\n",
+					hu->hdev->name);
+				goto done;
+			}
 			opcode = le16_to_cpu(cmd->opcode);
 
 			skb = __hci_cmd_sync(hu->hdev, opcode, cmd->plen,
-- 
2.53.0

