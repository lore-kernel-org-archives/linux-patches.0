Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CBB3F8896;
	Wed, 20 May 2026 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276062; cv=none; b=uL8+S2qoB1omhTrqi6/na2LmWA6vBVoWd4hwkmRAS0im5bqbdXgDNQKTeCXvzAAv6DC2F+4UsV4rMUKpMBHz+z2APDp51csgpYrRZ7znCpw1p1a18cRv2aqzkqMyEFowRYVXKPvgQtuQzJ+0z073rzf5FNZU2PjUfxZIk9M8uyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276062; c=relaxed/simple;
	bh=7bG2LaLW5S3D7RFVsdj9HsqmpVA+4H+heSjNo+HHAUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rr8FNLsySocQcN40/Rsi44mNesszVIpRYAF8RtnEgCAOVkNAI3nVLWqKDDbnlhYSpl1p2Hu5z1o+K/j2/0vJpXiXYkKh0FYY+5L/OH2cHxSHJHODEC5bcjPd/nfqntoyUIJ9r21sfgoeN60EJpQV7osbEBzMnnj79E3wpBvrKPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/6pkiT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/6pkiT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F651F00896;
	Wed, 20 May 2026 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276060;
	bh=Exl5QkWaEPxGTQBd53MIR7zcxCQrQ2MMursm2F/UCeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/6pkiT6dKc415qVPlzzuuVgPITckBVZOgj/6stismRnm/FsVPKJZ3dq8H3iSBh8M
	 YIp9TBW0KboE1o61fi4ygUQaSU5EuJ+HMNKt6/UzBKribINpYnEUtofMR9hkBlqbVy
	 AUM0v8mR6TN7ClBu+atxpgjGbo16rUAv/zWvHwOlnoBXGHiTMAFtQpmy19KnFs9DuG
	 I8yg+BynENbcNapiKWy9vKK4OG6dw8SlsqCYkbM6XQXoovr4gqd1wd3fQonHL+SX64
	 f77OH1osFGs9S0EKhR8pplrggLR5xpPnMtrFgJ3FxYJ5kbOQuzcP+IbocWyexDrYEi
	 1JmuJQhoY6MJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosalie Wanders <rosalie@mailbox.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] HID: sony: add missing size validation for SMK-Link remotes
Date: Wed, 20 May 2026 07:19:25 -0400
Message-ID: <20260520111944.3424570-53-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
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

From: Rosalie Wanders <rosalie@mailbox.org>

[ Upstream commit a4170b63eda999d20ad6dc39ddc3ce5c1ac619e6 ]

This commit adds the missing size validation for SMK-Link remotes in
sony_raw_event(), this prevents a malicious device from allowing
hid-sony to read out of bounds of the provided buffer.

I do not own these devices so the size check only forces that the buffer
is large enough for nsg_mrxu_parse_report().

Signed-off-by: Rosalie Wanders <rosalie@mailbox.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

Phase 1, commit message forensics. Record: subsystem `HID: sony`; action
`add`; intent is missing size validation for SMK-Link remotes. Tags
present: `Signed-off-by: Rosalie Wanders`, `Signed-off-by: Jiri Kosina`;
no `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Link:`, or `Cc: stable`. Body says a malicious device can make `hid-
sony` read beyond the provided buffer in `sony_raw_event()`. This is a
direct memory-safety bug, not a hidden cleanup.

Phase 2, diff analysis. Record: one file, `drivers/hid/hid-sony.c`, 2
insertions and 3 deletions; only `sony_raw_event()` changes. Before: any
`NSG_MRXU_REMOTE` report with `rd[0] == 0x02` called
`nsg_mrxu_parse_report()`. After: it only does so when `size >= 12`.
`nsg_mrxu_parse_report()` reads through `rd[11]`, including `rd[offset +
10]` with `offset = 1`, so the minimum size is verified by code. Bug
category: bounds check / out-of-bounds read. Fix quality: surgical and
obviously correct; the only behavioral change is rejecting malformed
short reports before parsing.

Phase 3, git history. Record: upstream commit is
`a4170b63eda999d20ad6dc39ddc3ce5c1ac619e6`, authored by Rosalie Wanders
and committed by HID maintainer Jiri Kosina. Blame shows the NSG-MRxU
parser and unchecked call were introduced by `b7289cb1cf99d` (`HID:
sony: Add touchpad support for NSG-MR5U and NSG-MR7U remotes`), first
described by `git describe` as `v4.17-rc1~118^2~2^2`. No `Fixes:` tag to
follow. Recent history shows an adjacent independent HID Sony size-
validation fix for Rock Band 3 Pro instruments, but no dependency for
this patch. Author has multiple recent `hid-sony` commits.

Phase 4, mailing list and external research. Record: `b4 dig -c
a4170b63eda99` found the exact lore submission at
`https://patch.msgid.link/20260412010806.7997-2-rosalie@mailbox.org`.
`b4 dig -a` showed only v1, no later revision. `b4 dig -w` showed Jiri
Kosina, Benjamin Tissoires, `linux-input`, and `linux-kernel` were
included. Full thread mbox shows Jiri replied: “Applied to
hid.git#for-7.1/upstream-fixes, thanks.” No NAKs, objections, explicit
stable request, or reviewer-suggested changes found. Direct WebFetch to
lore was blocked by Anubis, but `b4` fetched the thread successfully.

Phase 5, semantic analysis. Record: key functions are `sony_raw_event()`
and `nsg_mrxu_parse_report()`. `sony_raw_event()` is registered as the
HID driver `.raw_event` callback. HID core calls `.raw_event` from
`__hid_input_report()` before `hid_report_raw_event()`’s later report-
size validation, so driver-local parsing must validate `size` itself.
Lower HID layers such as USB HID call `hid_input_report()` with device-
provided lengths. `nsg_mrxu_parse_report()` is only called from
`sony_raw_event()` in this file. Similar pattern found: adjacent
upstream commit `12bd440b66ed8` adds a size check before another `rd[]`
access in the same function.

Phase 6, stable tree analysis. Record: the buggy NSG code exists in
checked stable branches `4.19.y`, `5.4.y`, `5.10.y`, `5.15.y`, `6.1.y`,
`6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`; `git merge-base
--is-ancestor b7289cb1cf99d4 <branch>` confirmed the introducing commit
is in each. Exact patch apply-check succeeded on `7.0.y`; older branches
failed exact context due file drift, but the required backport is a
trivial one-condition change at the same unchecked call site. No
existing stable branch log entry for this exact SMK-Link fix was found
in the checked branches.

Phase 7, subsystem context. Record: subsystem is HID input driver code,
specifically `drivers/hid/hid-sony.c`; criticality is driver-specific
but security-relevant for systems using or exposed to spoofed SMK-
Link/Sony HID devices. `MAINTAINERS` lists HID core as maintained by
Jiri Kosina and Benjamin Tissoires; Jiri committed and applied the
patch. The file has moderate recent activity, including HID Sony fixes
and device support work.

Phase 8, impact and risk. Record: affected users are `CONFIG_HID_SONY`
systems with SMK-Link NSG-MR5U/NSG-MR7U remote support, or systems that
accept a malicious/spoofed matching HID device. Trigger is a report with
ID byte `0x02` and length below 12. Failure mode is an out-of-bounds
read from the supplied report buffer; severity HIGH because it is
device-triggerable kernel memory-safety behavior. Benefit is high for
affected systems; risk is very low because valid reports of length >= 12
keep identical behavior and malformed short reports stop before unsafe
parsing.

Phase 9, synthesis. Evidence for backporting: real OOB read, malicious-
device trigger described in commit body, parser byte accesses verify the
needed bound, bug exists since v4.17-era code and is present in many
stable branches, fix is a one-line functional bounds check, maintainer
applied it to HID upstream fixes. Evidence against: no explicit `Tested-
by`, author says they do not own the hardware, and older stable trees
need a small context backport. Unresolved: no public crash report or
syzbot report found; no hardware test evidence found.

## Stable Rules

1. Obviously correct and tested: obviously correct by code inspection;
   no explicit `Tested-by` and no hardware ownership, but maintainer
   accepted it as an upstream fix.
2. Fixes a real bug: yes, verified unchecked parser reads up to
   `rd[11]`.
3. Important issue: yes, device-triggerable kernel out-of-bounds read.
4. Small and contained: yes, one function in one driver.
5. No new features/APIs: yes.
6. Can apply to stable: yes for `7.0.y` directly; older stable branches
   need trivial context adjustment.

No exception category is needed; this is a normal memory-safety fix.

## Verification

- Phase 1: parsed `git show a4170b63eda99`; confirmed tags and absence
  of `Fixes:`, reports, review, stable Cc.
- Phase 2: inspected diff and `nsg_mrxu_parse_report()`; confirmed
  `rd[11]` maximum access and added `size >= 12`.
- Phase 3: ran `git blame`, `git log -S`, `git show b7289cb1cf99d4`, and
  author history checks.
- Phase 4: ran `b4 dig -c`, `-a`, `-w`, `b4 am`, and full `b4 mbox`;
  confirmed v1-only thread and maintainer apply reply.
- Phase 5: used `rg` and `ReadFile` on HID core and `hid-sony`;
  confirmed `.raw_event` call path and lower-layer `hid_input_report()`
  entry.
- Phase 6: checked stable branch code, ancestry of `b7289cb1cf99d4`,
  exact apply-checks, and stable logs for this subject.
- Phase 7: checked `MAINTAINERS` for HID maintainers and subsystem
  ownership.
- Phase 8: mapped trigger and severity from verified parser accesses and
  HID input path.
- Unverified: actual hardware testing on SMK-Link remotes; exact clean
  application to older stable trees without a tiny backport adjustment.

**YES**

 drivers/hid/hid-sony.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index a89af14e4acc6..02baaf84e9792 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1035,10 +1035,9 @@ static int sony_raw_event(struct hid_device *hdev, struct hid_report *report,
 		sixaxis_parse_report(sc, rd, size);
 	} else if ((sc->quirks & MOTION_CONTROLLER_BT) && rd[0] == 0x01 && size == 49) {
 		sixaxis_parse_report(sc, rd, size);
-	} else if ((sc->quirks & NAVIGATION_CONTROLLER) && rd[0] == 0x01 &&
-			size == 49) {
+	} else if ((sc->quirks & NAVIGATION_CONTROLLER) && rd[0] == 0x01 && size == 49) {
 		sixaxis_parse_report(sc, rd, size);
-	} else if ((sc->quirks & NSG_MRXU_REMOTE) && rd[0] == 0x02) {
+	} else if ((sc->quirks & NSG_MRXU_REMOTE) && rd[0] == 0x02 && size >= 12) {
 		nsg_mrxu_parse_report(sc, rd, size);
 		return 1;
 	} else if ((sc->quirks & RB4_GUITAR_PS4_USB) && rd[0] == 0x01 && size == 64) {
-- 
2.53.0

