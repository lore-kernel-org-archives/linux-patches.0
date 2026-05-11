Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B269A4DB557;
	Mon, 11 May 2026 22:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537984; cv=none; b=iLPA+XNwLavTHtS/n4ymlnpSuEI8MNY5RIZTuSuWnHLiMtqxisANULEQmCttHU1Z+P8A0AV1Fe3r5KbpoFLlSdlipMsOXLQGn+nQzSkIFoSX1Xp7vgwTAEbIfJtV9F0ILAvsFHxiJFroDE4UKoHPEOLBlQWaflK8U+qjXQcW4aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537984; c=relaxed/simple;
	bh=Zn4J0fHdy3xfzUz38tOmseZcZesPxgZvA1MCNOqyk+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwyW2wpa+yMp5Q0aTV+tysIlm4qDku3QJpQDMBp8Oc+qGZW5S3CXnsuOo5bS/Y5MOqLyQn4513SqdBqj+bwRPD3/K3N/sXRaMDqj5hx8apnD4twAmDe86qLH5HUmKQEDjjab1MwHljIEezDNetMJ35ZSKv4VSAogoF/jGZD0BwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8tvdxdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8tvdxdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E3BC2BCFB;
	Mon, 11 May 2026 22:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537984;
	bh=Zn4J0fHdy3xfzUz38tOmseZcZesPxgZvA1MCNOqyk+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8tvdxdCVE2sClqprOzZIp3rsxW2oGu1+aOkFWDgbJy1/0Pk0TarF2GjB6WjnzE10
	 k/udQWUWRE6qHpG8s67af7Z+m9V/Vw3RvQLFioBEwRx7osTnC8k7ahhg2Cd48yxT1v
	 MlUIhXPSZppTi/mzj5LfZxMRFk/8MY7Dr8CY+n3P0gS6wYQmICg6m656D10+QzSYHp
	 fIIVgaNvvRzOeI+Ivw69lPt3OiXXS/sSGGJREdxzGGJjuoyY4veijM1A1nhhA6nJ28
	 CtkMwGCAcK2oP2luiBzom4V1rS43pZyv+8vcdFRagLmAG9MGyjwzlml05OmnLgzpEz
	 JNjwqZuuPq9sA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Birger Koblitz <mail@birger-koblitz.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] net: usb: r8152: add TRENDnet TUC-ET2G v2.0
Date: Mon, 11 May 2026 18:19:07 -0400
Message-ID: <20260511221931.2370053-8-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit f93836b236773862e9ee268a82e3614caf77ea01 ]

The TRENDnet TUC-ET2G V2.0 is an RTL8156B based 2.5G Ethernet controller.

Add the vendor and product ID values to the driver. This makes Ethernet
work with the adapter.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Birger Koblitz <mail@birger-koblitz.de>
Link: https://patch.msgid.link/20260430213435.21821-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `net: usb: r8152`; action verb `add`; claimed
intent: add TRENDnet TUC-ET2G v2.0 USB device ID so the existing `r8152`
driver binds to the adapter.

Step 1.2 Record: Tags present:
- `Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>`
- `Reviewed-by: Andrew Lunn <andrew@lunn.ch>`
- `Reviewed-by: Birger Koblitz <mail@birger-koblitz.de>`
- `Link: https://patch.msgid.link/20260430213435.21821-1-olek2@wp.pl`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>`

No `Fixes:`, `Reported-by:`, `Tested-by:`, or `Cc:
stable@vger.kernel.org` tag was present. Absence of those tags is not a
negative signal here.

Step 1.3 Record: The body describes a real hardware support failure:
TRENDnet TUC-ET2G V2.0 is RTL8156B-based, but without its USB
vendor/product ID in `rtl8152_table`, Ethernet does not work with that
adapter. No affected kernel versions are named.

Step 1.4 Record: This is not a hidden memory/synchronization bug. It is
an explicit new USB device ID addition to an existing driver, which is a
stable exception category.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `drivers/net/usb/r8152.c`, `+1/-0`.
No function body changed. The modified object is `rtl8152_table`. Scope:
single-file surgical device-ID addition.

Step 2.2 Record: Before the change, the table contained TRENDnet
`0xe02b` but not `0xe02c`, so USB matching would not select `r8152` for
`20f4:e02c`. After the change, `USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02c)`
is matched by the driver table used by both `rtl8152_driver.id_table`
and `rtl8152_cfgselector_driver.id_table`.

Step 2.3 Record: Bug category is hardware enablement / USB device ID
addition. It does not touch error paths, locking, reference counts,
memory safety, or public APIs.

Step 2.4 Record: The fix is obviously correct if the ID maps to RTL8156B
hardware. I verified the device identity externally: WikiDevi lists TUC-
ET2G v2.0R as USB ID `20f4:e02c` with Realtek RTL8156B, and TRENDnet’s
own support page confirms the TUC-ET2G v2 product. Regression risk is
very low; existing devices are unaffected unless another incompatible
device uses the same exact USB ID.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` around the table showed the existing
TRENDnet `0xe02b` entry came from `15fba71533bc` and the new `0xe02c`
line comes from `f93836b23677`. The table terminator dates back to
`ac718b69301c`. The “bug” is not introduced by a code commit; it is the
absence of a product-specific ID for existing supported silicon.

Step 3.2 Record: No `Fixes:` tag, so there is no introducing commit to
follow.

Step 3.3 Record: Recent related history includes `15fba71533bc` adding
the first TRENDnet TUC-ET2G ID and `dc9c67820f81` adding a TP-Link ID.
The candidate is standalone on trees that already have
`VENDOR_ID_TRENDNET`.

Step 3.4 Record: The author has at least one prior `r8152` device-ID
commit, `848b09d53d92` for Dell Alienware AW1022z. The patch was
reviewed by Andrew Lunn and Birger Koblitz and applied by Jakub
Kicinski.

Step 3.5 Record: Dependency found: `VENDOR_ID_TRENDNET` was introduced
by `15fba71533bc`, and `git merge-base --is-ancestor` confirms that
commit is an ancestor of `f93836b23677`. Mainline release tags `v5.15`,
`v6.1`, `v6.6`, `v6.12`, and `v6.19` lack `VENDOR_ID_TRENDNET`, while
`v7.0-rc3` has it. Older stable backports therefore need either
`15fba71533bc` first or a small backport adjustment adding `#define
VENDOR_ID_TRENDNET 0x20f4`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c f93836b23677` found the original patch
submission by patch-id. `b4 dig -a` reported the accepted one-patch
submission at `20260430213435.21821-1-olek2@wp.pl`; `b4` also found an
earlier identical submission from
`20260426214909.3426105-1-olek2@wp.pl`. The earlier thread had Andrew
Lunn asking for repost after netdev opened and giving his `Reviewed-by`.
No NAK or technical objection found.

Step 4.2 Record: `b4 dig -w` showed the patch was sent to netdev
maintainers/lists and USB networking lists, including Andrew Lunn, David
Miller, Eric Dumazet, Jakub Kicinski, Paolo Abeni, Realtek contacts,
`linux-usb`, `netdev`, and `linux-kernel`. `MAINTAINERS` confirms those
netdev maintainers for `NETWORKING DRIVERS`, and `drivers/net/usb/` is
under `USB NETWORKING DRIVERS`.

Step 4.3 Record: No separate bug report or `Reported-by` tag. External
hardware verification found TUC-ET2G v2.0R as `20f4:e02c` / RTL8156B.

Step 4.4 Record: This is a single-patch submission, not a multi-patch
fix series. The only practical dependency for older trees is the
TRENDnet vendor define from the prior TUC-ET2G ID commit.

Step 4.5 Record: WebFetch to lore was blocked by Anubis. WebSearch did
not find stable-specific discussion for `f93836b23677` or the patch
message ID. No stable objection found.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: No functions modified. Modified data structure:
`rtl8152_table`.

Step 5.2 Record: `rtl8152_table` is referenced by
`MODULE_DEVICE_TABLE(usb, rtl8152_table)`, `rtl8152_driver.id_table`,
and `rtl8152_cfgselector_driver.id_table`. Matching devices enter the
normal USB probe path via `rtl8152_probe`.

Step 5.3 Record: The relevant probe path checks vendor-specific
interface class, `rtl_check_vendor_ok`, `rtl8152_get_version`, then
calls `rtl8152_probe_once`. The config selector uses `__rtl_get_hw_ver`.
This patch adds no new calls.

Step 5.4 Record: Reachability is USB device enumeration: plugging in or
booting with the adapter attached. It is not a remote or syscall-
triggered security issue.

Step 5.5 Record: Similar pattern exists throughout the same table for
Realtek, Lenovo, TP-Link, D-Link, Dell, ASUS, and earlier TRENDnet IDs.
`git log -S'0xe02c'` found no prior `0xe02c` entry in the checked
history.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: Checked mainline release tags `v5.15`, `v6.1`, `v6.6`,
`v6.12`, and `v6.19`: all contain `0x8156` and RTL8156B version
handling, but not the TRENDnet `0xe02c` ID. This means the supported
chipset path exists in those releases, but the product-specific match is
missing.

Step 6.2 Record: Backport difficulty is low. It applies cleanly to trees
with `VENDOR_ID_TRENDNET` / `0xe02b`; older bases need a minor
context/define adjustment or the prior TRENDnet ID patch.

Step 6.3 Record: No alternate local fix for `0xe02c` was found. No
stable-specific replacement fix was verified.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is `drivers/net/usb`, USB Ethernet networking
driver. Criticality: driver-specific, important for users of this
hardware, not core-kernel-wide.

Step 7.2 Record: The file is active, with recent `r8152` feature and fix
commits, but this change is isolated to the USB ID table and does not
depend on recent functional refactoring except the vendor
define/backport context noted above.

## Phase 8: Impact And Risk
Step 8.1 Record: Affected users are systems with TRENDnet TUC-ET2G V2.0
and `CONFIG_USB_RTL8152`.

Step 8.2 Record: Trigger is common for affected users: adapter insertion
or boot with the adapter connected. Not remotely triggerable; physical
USB access is needed.

Step 8.3 Record: Failure mode is device non-binding / Ethernet
unavailable. Severity is not crash/security-critical, but it is a real
user-visible hardware functionality failure.

Step 8.4 Record: Benefit is high for affected stable users because it
makes the adapter work with an already-supported RTL8156B driver. Risk
is very low: one table entry, no behavior change for existing IDs.

## Phase 9: Final Synthesis
Evidence for backporting:
- New USB device ID for existing driver and already-supported RTL8156B
  silicon.
- Fixes a real user-visible failure: Ethernet does not work with this
  adapter.
- One-line, single-file, no API or behavior change for existing
  hardware.
- Reviewed by Andrew Lunn and Birger Koblitz; applied by Jakub Kicinski.
- Hardware identity verified as TRENDnet `20f4:e02c` / RTL8156B.

Evidence against backporting:
- Not a crash, data corruption, security, or deadlock fix.
- Older stable bases may need the prior `VENDOR_ID_TRENDNET` definition
  or a tiny backport adjustment.

Unresolved:
- I did not verify every active stable branch state directly; I verified
  mainline release tags and the dependency relationship. Lore WebFetch
  was blocked, but `b4` successfully fetched the thread.

Stable rules checklist:
1. Obviously correct and tested? Yes, one matching-table entry;
   reviewed; hardware ID verified.
2. Fixes a real bug affecting users? Yes, adapter does not bind/work
   without the ID.
3. Important issue? Yes under the stable “new device IDs” exception,
   though not crash/security.
4. Small and contained? Yes, one insertion in one file.
5. No new features/APIs? Yes, no API or behavioral change except
   matching this USB device.
6. Can apply to stable trees? Yes with low difficulty; older trees may
   need `VENDOR_ID_TRENDNET`.

Exception category: New USB device ID for an existing driver. This is a
standard stable-appropriate exception.

## Verification
- [Phase 1] Parsed commit `f93836b236773862e9ee268a82e3614caf77ea01`
  with `git show`; confirmed subject, body, tags, and `+1/-0` diff.
- [Phase 2] Compared `git diff f938^..f938`; confirmed only `{
  USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02c) }` is added.
- [Phase 3] Ran `git blame` around `rtl8152_table`; confirmed existing
  `0xe02b` from `15fba71533bc` and new `0xe02c` from `f93836b23677`.
- [Phase 3] Ran `git merge-base --is-ancestor 15fba71533bc
  f93836b23677`; confirmed the vendor define dependency is in the
  candidate’s ancestry.
- [Phase 3] Checked release tags `v5.15`, `v6.1`, `v6.6`, `v6.12`,
  `v6.19`, `v7.0-rc3`, `v7.1-rc3`; confirmed older release tags have
  RTL8156/RTL_VER_13 support but lack TRENDnet IDs until `v7.0-rc3`.
- [Phase 4] Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; confirmed
  patch-id match, one-patch submission, recipients, and
  review/application thread.
- [Phase 4] Read full `b4 mbox` threads; confirmed Andrew Lunn review on
  repost request, Birger Koblitz review, and patchwork notification that
  Jakub applied it.
- [Phase 4] WebFetch to lore was blocked by Anubis; external GitHub
  commit fetch confirmed the commit metadata and diff.
- [Phase 4] WebFetch of WikiDevi and TRENDnet pages verified TUC-ET2G v2
  hardware identity; WikiDevi specifically listed USB ID `20f4:e02c` and
  RTL8156B.
- [Phase 5] Searched `rtl8152_table` references; confirmed use by
  `MODULE_DEVICE_TABLE`, `rtl8152_driver.id_table`, and
  `rtl8152_cfgselector_driver.id_table`.
- [Phase 5] Read `rtl8152_probe` and config selector code; confirmed
  affected path is USB enumeration/probe, with no changed runtime logic.
- [Phase 7] Checked `MAINTAINERS`; confirmed netdev maintainers and
  `drivers/net/usb/` list coverage.
- [Phase 8] Checked `drivers/net/usb/Kconfig`; confirmed affected
  configuration is `CONFIG_USB_RTL8152`.

This is exactly the kind of low-risk new USB ID addition stable trees
normally take.

**YES**

 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0c83bbbea2e7c..0ac2b079e435c 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10055,6 +10055,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_DELL,    0xb097) },
 	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
 	{ USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02b) },
+	{ USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02c) },
 	{}
 };
 
-- 
2.53.0

