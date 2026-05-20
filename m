Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DED371063;
	Wed, 20 May 2026 11:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779275988; cv=none; b=SCFr5ysT6gYv8Y5jeMlde7ExmmP/d4r6mZYZS9HR52RUOLCKk3vJiwcYzCs1aSAoPG8DC5zJxMbiDFNlZa2grlHr0LQAb2qFmQ7Z6YB/hhzGkoGoVcieHKRnJzPx+cTTs0F6kfDJ7/Z4FlnwxLSTSyDvHqdW/3Gs558rAyFjxAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779275988; c=relaxed/simple;
	bh=6wbf9BF3q/xIesg8TeBxP9DqAnvxK+OoEyV0GT1IuAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RNKTdgBhQJFNvDT6/3Ltf9nNJIWRnsLxYkwOtezQRU4AX0hmA5wuJfEYXPu+/T1WxfYS0FHB0tOvtHjujhaPFoWZrnbQCFZ22KxDOzlQi1G+hgjt4ys6jT/yDRu34aSAnZ0FFkVMStIuEPx9cCyfv/jahaeBhKuZmjomA1AbKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEPi/6dY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEPi/6dY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5987B1F000E9;
	Wed, 20 May 2026 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275986;
	bh=1WFl4Cx4mIXHKcZn7CPnQGIKVMWkC9ofmYZI9SNyt6k=;
	h=From:To:Cc:Subject:Date;
	b=nEPi/6dY5F4aDTDMwymmYw4R9WNJnIH5NiKwhCzxJUx3njeU1S+x7Yf8Eh+pJm9z+
	 ahpe4VNs5Mj1JvhDj/R23x1z1Gqo5OuFA+oKMz6qVl1vD/4xUyJpaB5vSH/zptp3ZD
	 jlS2pTgsfWGorJjZSZ5mfNAqNlSwyPVCG6ssfhqhUiWA+DjJCAU2LUcL9f5qmCbxHp
	 IZ9Ge7ZpfDVGRV/gXPIXMXE1t6Z68u7SMK/LBrGhEDP1C5l8f/E/7YP4U9a0/ZnfDX
	 jXeUrRGPC0Lhn5t3wM5uOkP3RB8YzYEmveSvmGQ8y5ex3znO2PdhmXd6ZtfwaKOyrK
	 OHHcyv/1sHDGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alain Michaud <alainmichaud@google.com>,
	Olivier Gay <ogay@logitech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] HID: logitech-hidpp: Add support for newer Bluetooth keyboards
Date: Wed, 20 May 2026 07:18:33 -0400
Message-ID: <20260520111944.3424570-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alain Michaud <alainmichaud@google.com>

[ Upstream commit 64ffa2e5e02ff54b23221d0282155f37283fabea ]

Add product IDs (PIDs) for several newer Logitech Bluetooth keyboards
to the hidpp_devices matching table, enabling full HID++ support for
them.

The added keyboards are:
- Logitech Signature K650 & B2B
- Logitech Pebble Keys 2 K380S
- Logitech Casa Pop-Up Desk & B2B
- Logitech Wave Keys & B2B
- Logitech Signature Slim K950 & B2B
- Logitech MX Keys S & B2B
- Logitech Keys-To-Go 2
- Logitech Pop Icon Keys
- Logitech MX Keys Mini & B2B
- Logitech Signature Slim Solar+ K980 B2B
- Logitech Bluetooth Keyboard K250/K251
- Logitech Signature Comfort K880 & B2B

Signed-off-by: Alain Michaud <alainmichaud@google.com>
Reviewed-by: Olivier Gay <ogay@logitech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough
**Phase 1 Record:** Subsystem `HID: logitech-hidpp`; action `Add`;
intent is to add Bluetooth PIDs so newer Logitech keyboards bind to
`hid-logitech-hidpp`. Tags: `Signed-off-by: Alain Michaud`, `Reviewed-
by: Olivier Gay <ogay@logitech.com>`, `Signed-off-by: Jiri Kosina`; no
`Fixes`, `Reported-by`, `Tested-by`, `Link`, or stable Cc. Body
describes hardware enablement, not crash/security. Hidden bug fix: no,
this is explicit device-ID enablement.

**Phase 2 Record:** One file changed: `drivers/hid/hid-logitech-
hidpp.c`, 38 insertions, all in `hidpp_devices[]`. Before: listed
Logitech Bluetooth devices stopped at existing IDs such as
`0xb391`/`0xb042`. After: adds 19
`HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, pid)` entries. Bug
category: hardware enablement/device IDs. Fix quality: mechanically
simple, no code flow, locking, allocation, ABI, or API changes.

**Phase 3 Record:** Upstream commit is
`64ffa2e5e02ff54b23221d0282155f37283fabea`, contained by
`v7.1-rc4~28^2`. Blame shows the new entries are from this commit;
surrounding table entries are established prior HID++ Bluetooth IDs. No
`Fixes:` tag to follow. Related history shows repeated prior Logitech
HID++ Bluetooth ID additions, plus a prior broad “match all Logitech
Bluetooth” approach that was reverted because it could bind unsupported
mice and leave them dead. This supports the narrow-ID approach. Author
has only this HID/HIDPP commit locally; reviewer/maintainer path is
through HID maintainers.

**Phase 4 Record:** `b4 dig -c 64ffa2e5e02f` found the original
submission at `https://patch.msgid.link/20260512132244.2194556-1-
alainmichaud@google.com`. `b4 dig -a` showed only v1. `b4 dig -w` showed
Jiri Kosina, Benjamin Tissoires, HID++/Logitech reviewers, `linux-
input`, and `linux-kernel` were included. Saved mbox shows Jiri replied
“Applied, thanks.” No objections or stable nomination found in that
mbox. WebFetch to lore/stable was blocked by Anubis, so stable-list
search could not be verified externally.

**Phase 5 Record:** Key changed object is `hidpp_devices[]`. It is
assigned to `hidpp_driver.id_table`, exported via `MODULE_DEVICE_TABLE`,
and registered by `module_hid_driver(hidpp_driver)`. HID core uses
`hid_match_device()` -> `hid_match_id()` against `hdrv->id_table`,
matching bus/vendor/product. `HID_BLUETOOTH_DEVICE` expands to
`BUS_BLUETOOTH` plus vendor/product. Reachability: Bluetooth HID device
enumeration/driver matching. Similar pattern: many existing Logitech
Bluetooth HID++ IDs in the same table.

**Phase 6 Record:** Checked tags `v5.10`, `v5.15`, `v6.1`, `v6.6`,
`v6.12`, `v6.18`, `v6.19`, and `v7.0`: all have `hidpp_devices[]`,
`MODULE_DEVICE_TABLE(hid, hidpp_devices)`, and `HID_BLUETOOTH_DEVICE`;
all lack the candidate PIDs. Patch applies cleanly to current
`stable/linux-7.0.y`; older trees likely need trivial context placement
because some newer adjacent IDs are absent.

**Phase 7 Record:** Subsystem is HID Logitech HID++ driver, under
maintained HID/Input. Criticality: driver-specific, but for affected
Logitech keyboard users it controls full HID++ support. Subsystem is
active; recent history includes HIDPP fixes and other device-ID
additions.

**Phase 8 Record:** Affected users are owners of the listed Logitech
Bluetooth keyboards on stable kernels. Trigger is pairing/using those
devices over Bluetooth. Failure mode is missing enhanced HID++ driver
support, not a crash; severity medium for affected hardware
functionality. Benefit is high for those users and low system-wide risk.
Risk is very low: data-only ID table entries, no behavioral change for
non-matching devices.

**Phase 9 Record:** Evidence for backporting: classic stable exception
for adding device IDs to an existing driver; small and contained;
reviewed by Logitech contact; applied by HID maintainer; code exists in
active stable trees; prior history favors explicit IDs over broad
matching. Evidence against: not a crash/security/data-corruption fix;
product ID correctness is verified only by commit review, not an
external public spec. Stable checklist: obviously correct yes; real
user-visible hardware support issue yes; important under device-ID
exception yes; small/contained yes; no new API yes; applies cleanly to
7.0 and should be trivial elsewhere.

## Verification
- [Phase 1] Parsed commit metadata with `git show --format=fuller`:
  confirmed tags and no `Fixes`/`Reported-by`.
- [Phase 2] Inspected full diff: 38 insertions only in
  `hidpp_devices[]`.
- [Phase 3] Used `git blame` around the table and `git log` on the file:
  confirmed surrounding HID++ Bluetooth ID history and related revert of
  broad Bluetooth matching.
- [Phase 4] Used `b4 dig -c/-a/-w` and saved/read mbox: confirmed v1
  thread, recipients, and maintainer “Applied, thanks.”
- [Phase 5] Used code search/read of `hid-core.c`,
  `include/linux/hid.h`, and `hid-logitech-hidpp.c`: confirmed driver
  table matching path.
- [Phase 6] Checked stable tags for table/macro/PID presence and ran
  `git apply --check` on current 7.0 tree.
- [Phase 7] Checked `MAINTAINERS` and recent HID/HIDPP logs.
- [Phase 8] Impact/risk derived from verified diff and HID matching
  path.
- UNVERIFIED: lore stable-search results, because WebFetch was blocked
  by Anubis.
- UNVERIFIED: independent public confirmation of every Logitech PID
  beyond the patch author/reviewer/maintainer record.

This should be backported under the stable device-ID exception. It
enables existing HID++ driver support for specific hardware with minimal
regression risk.

**YES**

 drivers/hid/hid-logitech-hidpp.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d1dea7297712d..68f055ef1f444 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4672,6 +4672,44 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
 	{ /* MX Master 4 mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb042) },
+	{ /* Logitech Signature K650 over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb36f) },
+	{ /* Logitech Signature K650 B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb370) },
+	{ /* Logitech Pebble Keys 2 K380S over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb377) },
+	{ /* Logitech Casa Pop-Up Desk over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb371) },
+	{ /* Logitech Casa Pop-Up Desk B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb374) },
+	{ /* Logitech Wave Keys over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb383) },
+	{ /* Logitech Wave Keys B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb384) },
+	{ /* Logitech Signature Slim K950 over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb386) },
+	{ /* Logitech Signature Slim K950 B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb388) },
+	{ /* Logitech MX Keys S over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb378) },
+	{ /* Logitech MX Keys S B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb380) },
+	{ /* Logitech Keys-To-Go 2 over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb38c) },
+	{ /* Logitech Pop Icon Keys over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb38f) },
+	{ /* Logitech MX Keys Mini over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb369) },
+	{ /* Logitech MX Keys Mini B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb36e) },
+	{ /* Logitech Signature Slim Solar+ K980 B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb394) },
+	{ /* Logitech Bluetooth Keyboard K250/K251 over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb397) },
+	{ /* Logitech Signature Comfort K880 over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb39c) },
+	{ /* Logitech Signature Comfort K880 B2B over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb39d) },
 	{}
 };
 
-- 
2.53.0

