Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FEF54BC3D;
	Mon, 19 Oct 2026 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418204; cv=none; b=bsP37zFyOl+0UsaXC7Za5/e2ho/FIVEwspUfGhCk9m2WcB9QgwqAKHxvmY+nILnico/gFiQVB7qjt8aJEU+W0l1X/SGSs0C5kYmTaB1djIbreFoq323c+IY5PEfbiP0Q5S0tLJP7uKh8HGMMkKtlhVbTerh63WiWieuzpe81NTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418204; c=relaxed/simple;
	bh=z4NsKVfjx8HGMVWk/IIhqNa/gJbtYgpUP5zTBFfc35A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VikyGUAyGyH+Ec7JcadcD0b3X1xeVGoyU5vtGGK66r21S0lmUt9J9gv2tLjT5pE19w9y/vD/z2/SojQvxAJ/+zN8pH5TPB3Sza2he2M+90DefcrbUe+Q6V4+fVa55/Kn57p+M7Dfs0ZdRqoCQIMOjwskp+8Ke/oIXnPbK+YDqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FI47pChF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FI47pChF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828A11F000C5;
	Mon, 19 Oct 2026 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418200;
	bh=eJSdATW2Qr1HPFuivwkn3fyU6QISohvpr1nA2CpokCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FI47pChF7k71f/Mi9+4T6VHhT5r0zXhXyZcqhHEEo8Ol0K12f3C/9inaJQ3jrchqS
	 pQwCWlgxWgQJKOjNeBJVm3y/UgGNMXPEj6JS7nvPIIJ5SnpG2oiNKtDIz9dAjgx5yw
	 XfjEJxgSaSTe04fRz8ho+5j5Gy5TqPXXwWUg3av9q2jdfHvmNFs5euL5DEK/MoeCpW
	 TX4yRjb5k+XJX4DIM0vEY59qG2Enf2Pa7ALja7JFYwZgYTEZMbwz/z10wpdo4OEYBQ
	 rX/2PsoI2dKsPgf69LUXdVk1yXfSKhqMzQ8F0P+LIlz7q1GKV+hr4YXH+tDwQv3dF9
	 FJhz9CqWMUwhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	oleg@makarenk.ooo,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: universal-pidff: Add support for Turtle Beach VelocityOne Race
Date: Mon, 19 Oct 2026 09:46:14 -0400
Message-ID: <20261019135441.1420968-83-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 53f7f7955a684e820bdd6bd6792c45c4b434f637 ]

Add usb VID and device PID to hid-ids.h

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[HID / universal-pidff] [Add] USB VID/PID so Turtle Beach
  VelocityOne Race binds to the existing hid-universal-pidff driver`

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>`
    (author; co-author of this driver)
  - `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer)
  - `[Upstream commit 53f7f7955a684e820bdd6bd6792c45c4b434f637]` and
    `Signed-off-by: Sasha Levin` ignored as pipeline markers
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, `Link:`, or `Cc: stable` (absence of the last two is expected)

**Step 1.3 — Body**
- Record: Body is one sentence: “Add usb VID and device PID to hid-
  ids.h”. No crash, leak, or corruption described. The claimed intent is
  hardware enablement for one USB HID device. No version range given.
  Root cause as stated: the IDs were missing from the existing driver’s
  table.

**Step 1.4 — Hidden bug fix?**
- Record: Not a disguised leak/race/UAF. It is a USB ID addition to an
  existing driver (stable exception category 1).

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record:
  - `drivers/hid/hid-ids.h`: +3 (two `#define`s plus a blank line)
  - `drivers/hid/hid-universal-pidff.c`: +1 in
    `universal_pidff_devices[]`
  - Net +4 lines, two files, one table plus ID macros
  - Classification: single-purpose, surgical device-ID add

**Step 2.2 — Code flow**
- Record:
  - Before: `0x10f5:0x7077` is unmatched by this driver and falls
    through to generic HID.
  - After: HID core matches `HID_USB_DEVICE(USB_VENDOR_ID_TURTLE_BEACH,
    USB_DEVICE_ID_TB_VELOCITYONE_RACE)` and calls
    `universal_pidff_probe()`.
  - Path: device enumeration / probe, not an error path. No
    `driver_data` quirks.

**Step 2.3 — Bug mechanism**
- Record: `[Hardware enablement / USB device ID]` — the driver already
  implements PID force-feedback wrapping; this only lists one more
  VID/PID. Not UAF, leak, race, overflow, or init-bug.

**Step 2.4 — Fix quality**
- Record: Obviously correct as an ID table add. Insertion sits
  alphabetically between TURBOX and TWINHAN. Vendor `0x10f5` already
  identifies Turtle Beach elsewhere (`drivers/input/joystick/xpad.c`
  uses `0x10f5` with other PIDs `0x7005`/`0x7008`/`0x7073`). PID
  `0x7077` does not collide with those. No public API change. Regression
  risk is low: only this VID:PID binds; probe returns 0 even if the PID
  usage page is absent.

---

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: New lines; they did not exist before this commit. Surrounding
  `hid-ids.h` TURBOX/TWINHAN macros date to 2008–2017. The device table
  terminator was last touched by `5b9cae8c6472e` (clang-format, 2025).
  The driver itself was added in `f06bf8d94fffb` (“HID: Add hid-
  universal-pidff driver and supported device ids”, 2025-02-03; `git
  describe` of that commit is `v6.13-4738-gf06bf8d94fffb`).

**Step 3.2 — Fixes: tag**
- Record: No `Fixes:` tag. Not applicable.

**Step 3.3 — File history**
- Record: Recent related commits on this driver: Asetek ID adds
  (`c385f61108d40`), spelling/format nits, and `01d9874e84d3a` (stop
  device on FF init failure). No prerequisite refactor is required for
  this ID. Standalone; not “patch X/Y”. No later follow-up on these
  files after this commit.

**Step 3.4 — Author**
- Record: Tomasz Pakuła is a listed `MODULE_AUTHOR` of `hid-universal-
  pidff.c` and a frequent hid-pidff contributor (overflow, NPD,
  playback, Asetek IDs). This is the subsystem’s own device-table
  maintainer, not a drive-by.

**Step 3.5 — Dependencies**
- Record: Needs `hid-universal-pidff.c`, `USB_VENDOR_ID_*` macros, and
  `hid_pidff_init_with_quirks`. All are in this tree. `git merge-base
  --is-ancestor f06bf8d94fffb HEAD` succeeds; `git merge-base --is-
  ancestor f06bf8d94fffb v6.18` also succeeds. Can apply standalone.

---

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 53f7f7955a684e820bdd6bd6792c45c4b434f637` → https:/
  /patch.msgid.link/20260922131758.1242755-1-
  tomasz.pakula.oficjalny@gmail.com
- `b4 dig -a`: single v1 series only; no v2/v3.
- LKML: https://lkml.iu.edu/2609.2/17309.html (submission),
  https://lkml.iu.edu/2609.2/21230.html (Jiri Kosina: “Applied,
  thanks.”)
- No NAK, no requested changes, no stable nomination in review.
  lore.kernel.org fetch returned 403; discussion confirmed via `b4 dig`
  + LKML/Patchew mirrors.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `jikos@kernel.org` (HID maintainer), `oleg@makarenk.ooo` (co-
  author), `linux-input@vger.kernel.org`, `linux-
  kernel@vger.kernel.org`. Right lists and maintainer were on Cc; Kosina
  applied it.

**Step 4.3 — Bug report**
- Record: No `Reported-by` / syzbot / bugzilla. Phoronix (secondary, not
  a kernel bug tracker) notes basic HID input already worked and this
  listing improves FF for the VelocityOne Race. That is consistent with
  an ID add, not a crash fix.

**Step 4.4 — Series context**
- Record: Standalone one-patch series. Same pattern as earlier Asetek ID
  adds in this driver.

**Step 4.5 — Stable list**
- Record: `WebFetch` of `https://lore.kernel.org/stable/?q=VelocityOne`
  returned 403. Web search did not show a stable-list thread about this
  patch. UNVERIFIED that nobody discussed it on stable@; no evidence of
  a NAK there either.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
- Record: No function body changed. Data only:
  `universal_pidff_devices[]` plus two macros. Probe path that becomes
  reachable: `universal_pidff_probe` → `universal_pidff_input_mapping` /
  `universal_pidff_input_configured`.

**Step 5.2 — Callers**
- Record: `universal_pidff_probe` is only the `.probe` of `struct
  hid_driver universal_pidff`, registered via `module_hid_driver`.
  Invoked by HID/USB enumeration when VID:PID matches. Not IRQ, not a
  syscall hot path.

**Step 5.3 — Callees**
- Record: `hid_parse`, `hid_hw_start`, `hid_pidff_init_with_quirks`,
  `hid_hw_stop`. Existing, already used by every other ID in the table.

**Step 5.4 — Reachability**
- Record: Reachable when a user plugs in `10f5:7077` and
  `CONFIG_HID_UNIVERSAL_PIDFF` is enabled (`depends on USB_HID &&
  HID_PID`). Userspace cannot trigger it without that hardware.

**Step 5.5 — Similar patterns**
- Record: Same table already lists Moza, Cammus, VRS, FFBeast, Lite
  Star/PXN, Asetek. This is the established way this driver gains
  devices. Turtle Beach VID `0x10f5` is already used in `xpad.c` for
  other products; PID `0x7077` is unique.

---

## Phase 6: Local tree (this checkout)

**Step 6.1 — Does the code exist here?**
- Record: Local tree is **6.18.57** (`make kernelversion`; `git describe
  HEAD` = `v6.18.57-155-gcdf239ca885b2`). `hid-universal-pidff.c`
  exists. Driver intro `f06bf8d94fffb` is an ancestor of both `HEAD` and
  `v6.18`. Parent of this candidate still has the Asetek rows and the
  empty terminator; the ID macros were absent (`git grep
  USB_VENDOR_ID_TURTLE` on the parent was empty). The hardware and
  driver this listing targets are in this tree.

**Step 6.2 — Backport difficulty**
- Record: Clean apply. Parent context matches the provided diff (TURBOX
  block, then TWINHAN; Asetek entries then `{}`). No refactor gap.

**Step 6.3 — Related fixes already here?**
- Record: No other VelocityOne Race HID listing. No alternate fix for
  `10f5:7077` in HID. `xpad.c` does not claim PID `0x7077`.

---

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[HID USB force-feedback helper] [IMPORTANT for owners of
  listed wheels; PERIPHERAL vs core kernel]`. Not mm/fs/net core.
  Optional `CONFIG_HID_UNIVERSAL_PIDFF`.

**Step 7.2**
- Record: Actively maintained in 2025–2026 (quirks, Asetek IDs, pidff
  correctness fixes). Mature enough that ID adds are the normal
  extension mechanism.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Driver-specific / config-specific: users who own a Turtle
  Beach VelocityOne Race and enable this HID driver. Everyone else is
  unchanged.

**Step 8.2 — Trigger**
- Record: Plug in that USB wheel. Not a race. Unprivileged user can plug
  hardware; no syscall exploit surface beyond normal HID.

**Step 8.3 — Failure mode without the patch**
- Record: Device stays on hid-generic: basic input, missing this
  driver’s PID FF init and button-range mapping. Not
  oops/deadlock/corruption. Severity for those users: functional
  hardware gap (FF), **MEDIUM** as a bug, but it is the documented
  device-ID exception.

**Step 8.4 — Risk vs benefit**
- Record: Benefit: FF/PID support for this wheel on 6.18.y without a
  full kernel upgrade. Risk: very low (4 lines, match is VID+PID, no
  quirk, probe already tolerates missing PID page). Ratio: favorable for
  a device-ID add.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- USB ID add to a driver that already exists in this 6.18 tree (stable
  exception 1).
- +4 lines, no new APIs, no new driver, no new sysfs/module params.
- HID maintainer applied v1 with no objections.
- Author maintains this driver.
- VID `0x10f5` is already Turtle Beach in-tree; PID does not clash with
  xpad entries.
- Applies cleanly here.

Against:
- Not a crash/security/corruption fix.
- Short commit message; no `Reported-by`.
- Niche ~$650 sim-racing hardware.
- Improves FF rather than repairing a generic HID oops.

Unresolved:
- lore.kernel.org HTTP 403; stable@ thread not confirmed.
- No in-tree test that this exact PID speaks USB PID FF (same as other
  IDs in this table).

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — mechanical ID add;
   maintainer applied it. No in-tree Tested-by, but the change is the
   same class as prior IDs in this file.
2. Real issue affecting users? **PASS** — without the ID, this wheel
   does not get the existing PID FF path.
3. Important (crash/security/deadlock) **or** listed exception? **PASS**
   — USB device ID on an existing driver.
4. Small and contained? **PASS** — 4 lines, two files.
5. No new features/APIs? **PASS** — no new driver, ioctl, or userspace
   ABI; only an ID in an existing table.
6. Applies to this tree? **PASS** — driver and insertion point are
   present on 6.18.57.

**Step 9.3 — Exception**
- Record: **NEW DEVICE ID** (USB VID/PID) on existing `hid-universal-
  pidff`.

**Step 9.4 — Decision**
This is exactly the device-ID class stable trees take. The driver is in
6.18; the patch is tiny and isolated to `10f5:7077`. Benefit is real for
owners of that wheel; risk to everyone else is negligible.

---

### What the commit does for this tree
It lists Turtle Beach VelocityOne Race (`USB 10f5:7077`) in `hid-
universal-pidff` so 6.18 systems can use the PID force-feedback path
already in this kernel, instead of generic HID only.

### Stable-rules fit
Meets the device-ID exception: existing driver, IDs only, clean apply,
no new API.

### Risk vs benefit
Very low risk, localized hardware enablement. No locking or error-path
change.

### Concerns
None that block backport. No extra quirks or follow-up commits required
in this tree. Stable-list discussion could not be fetched (403).

---

Verification:
- [Phase 1] Parsed tags: author SOB + Jiri Kosina SOB; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body is a one-line ID add, not a crash write-up
- [Phase 2] Diff: +3 `hid-ids.h`, +1 table row; no function logic change
- [Phase 2] No `driver_data` quirk on the new entry
- [Phase 3] `git blame` on new macros → this commit; surrounding IDs
  from 2008–2017
- [Phase 3] Driver intro `f06bf8d94fffb` (`v6.13-4738-gf06bf8d94fffb`);
  ancestor of HEAD and of `v6.18`
- [Phase 3] `git log --oneline --author="Tomasz Pakuła" --
  drivers/hid/`: driver co-maintainer, many pidff commits
- [Phase 3] No later commits on these files after this ID add
- [Phase 4] `b4 dig -c 53f7f7955a684e820bdd6bd6792c45c4b434f637`: lore
  msgid `20260922131758.1242755-1-tomasz.pakula.oficjalny@gmail.com`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: jikos@kernel.org, linux-input, co-author Oleg
- [Phase 4] LKML: Kosina “Applied, thanks.”
  (https://lkml.iu.edu/2609.2/21230.html)
- [Phase 4] lore.kernel.org WebFetch: 403; used LKML/Patchew/`b4`
  instead
- [Phase 5] Probe only via `module_hid_driver`; callees
  `hid_parse`/`hid_hw_start`/`hid_pidff_init_with_quirks` exist here
- [Phase 5] `0x10f5` in `xpad.c` for other PIDs; `0x7077` not used there
- [Phase 6] `make kernelversion` → 6.18.57; `git describe HEAD` →
  `v6.18.57-155-gcdf239ca885b2`
- [Phase 6] Parent of candidate: no `USB_VENDOR_ID_TURTLE`; Asetek rows
  present; apply context matches
- [Phase 8] Failure mode: missing FF/mapping for one USB wheel, not oops
- UNVERIFIED: stable@ archive (HTTP 403); no in-kernel confirmation the
  device implements USB PID (same as other table IDs)

**YES**

 drivers/hid/hid-ids.h             | 3 +++
 drivers/hid/hid-universal-pidff.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ca5c62f29aebe..69b1b0f98c99d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1415,6 +1415,9 @@
 #define USB_DEVICE_ID_ASUS_MD_5110	0x5110
 #define USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART	0x7100
 
+#define USB_VENDOR_ID_TURTLE_BEACH	0x10f5
+#define USB_DEVICE_ID_TB_VELOCITYONE_RACE	0x7077
+
 #define USB_VENDOR_ID_TWINHAN		0x6253
 #define USB_DEVICE_ID_TWINHAN_IR_REMOTE	0x0100
 
diff --git a/drivers/hid/hid-universal-pidff.c b/drivers/hid/hid-universal-pidff.c
index 60180467a0bfd..f1854cfe42d0d 100644
--- a/drivers/hid/hid-universal-pidff.c
+++ b/drivers/hid/hid-universal-pidff.c
@@ -187,6 +187,7 @@ static const struct hid_device_id universal_pidff_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_FORTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_LA_PRIMA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASETEK, USB_DEVICE_ID_ASETEK_TONY_KANAAN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TURTLE_BEACH, USB_DEVICE_ID_TB_VELOCITYONE_RACE)},
 	{}
 };
 MODULE_DEVICE_TABLE(hid, universal_pidff_devices);
-- 
2.53.0

