Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A663F0777;
	Tue, 24 Mar 2026 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351194; cv=none; b=OVQAiNXQOHw9W2mVfbpP8JL8SgZDWH/5PGNrHChkkxhLRt57kdrCl43OV13zpkdBDdCwsc+/vAZOrxQYxWiwF1laEVcb1M6ELazzakk1sJrnESWsa7FMNKosG3VLlhs1sOsRZHWARn3MVsCN9Sc1zzj7FhKlenUIeX0QucWiWDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351194; c=relaxed/simple;
	bh=GOBR5zcQknbloOdl9XyMm1giMq6aOgWrahxWYxIRouk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VKaAavWcfO+rAdivoBBTaB0R6DUTjItH79qdcAEbZuPR1eB//9vYYEg0GumllnybRjdvpxha+IwwQE9QzqfGxJLHksezInB2kT5BDBrkMqCPGs6o/KFPVXNHPJcRGixtA9YE5RPBrQxSbey/k4kbijlKsiGPZYBssIcdWh4iflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pi2gcTZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pi2gcTZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67875C19424;
	Tue, 24 Mar 2026 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351193;
	bh=GOBR5zcQknbloOdl9XyMm1giMq6aOgWrahxWYxIRouk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pi2gcTZv9pc45miFWg+sH+3EJ7FtoqM6RMNOC9xZAIN54uKYYW98qGCEtWv8ye3BN
	 mCoD26gsqCHerBecKIlFgI41vg3R2kKGC6hir4MZzJtosQbBXz/xxgLPWElW92Ibag
	 eH2OjU/hhsnoxuDw/0shftcTebgiNp4TM20ufExY3gByi56IDgx0NJPc9na2/V+6Ou
	 uVmbNSwoodwqVpkEAr9meuRB82ztqUbiAcCV8DiFiFdMZzzHE9KHpi9pS6FiKvmFez
	 +n4morRtAjOaVB8KAvmVI+skF0+K8A1UWOghsuJzDOoF+VF8eLNhtEkAF0HIQ7KBj9
	 0sInMl1AVe+LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Freund <adrian@freund.io>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] HID: logitech-hidpp: Enable MX Master 4 over bluetooth
Date: Tue, 24 Mar 2026 07:19:24 -0400
Message-ID: <20260324111931.3257972-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Freund <adrian@freund.io>

[ Upstream commit 70031e70ca15ede6a39db4d978e53a6cc720d454 ]

The Logitech MX Master 4 can be connected over bluetooth or through a
Logitech Bolt receiver. This change adds support for non-standard HID
features, such as high resolution scrolling when the mouse is connected
over bluetooth.
Because no Logitech Bolt receiver driver exists yet those features
won't be available when the mouse is connected through the receiver.

Signed-off-by: Adrian Freund <adrian@freund.io>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The table has grown but the addition is at the end before the terminator
`{}`. It should apply cleanly or with trivial context adjustment to any
stable tree.

Record: [Clean apply expected — insertion point is at end of table
before terminator]

### Step 6.3: RELATED FIXES IN STABLE
No related fixes — this is new hardware support.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
- **Subsystem**: HID (Human Interface Devices) — input peripherals
- **Criticality**: IMPORTANT — mice are core input devices for desktop
  users

### Step 7.2
The HID subsystem and this driver specifically are actively maintained
with regular device ID additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users who own an MX Master 4 mouse and connect it via Bluetooth on
stable kernels. Without this patch, they don't get high-resolution
scrolling and other hidpp features.

### Step 8.2: TRIGGER CONDITIONS
Any user who connects an MX Master 4 over Bluetooth is affected.

### Step 8.3: FAILURE MODE
Without the patch: missing features (high-res scrolling). With the
patch: device works with full feature set. No crash, no security issue —
hardware enablement.

### Step 8.4: RISK-BENEFIT
- **Benefit**: MEDIUM — enables features for popular Logitech mouse (MX
  Master line is very popular)
- **Risk**: VERY LOW — 2-line device ID table addition, zero chance of
  regression
- **Ratio**: Favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE
**FOR backporting:**
- This is a NEW DEVICE ID addition — an explicit exception category for
  stable
- Trivially small (2 lines), obviously correct, follows exact pattern of
  dozens of prior entries
- Zero regression risk — only affects users who have this specific
  hardware
- MX Master 4 is a popular consumer mouse; users on stable kernels would
  benefit
- The same author successfully added MX Master 3 previously
- Merged by the HID subsystem maintainer (Jiri Kosina)

**AGAINST backporting:**
- This is not a bug fix — it's enabling new hardware support
- The mouse still works as a basic HID device without this; only
  advanced features are missing
- Strictly speaking, this adds new functionality rather than fixing a
  bug

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — trivial pattern match, merged
   by maintainer
2. Fixes a real bug? **NO** — enables hardware features, not a bug fix
3. Important issue? **N/A** — not a bug, but important for hardware
   support
4. Small and contained? **YES** — 2 lines
5. No new features? **This adds a device ID, which is an allowed
   exception**
6. Can apply to stable? **YES** — clean apply expected

### Step 9.3: EXCEPTION CATEGORIES
**YES — Device ID addition to existing driver.** This falls squarely
into the "NEW DEVICE IDs" exception category. Adding device IDs to
existing drivers is explicitly allowed in stable trees because they are
trivial additions that enable hardware support with zero risk.

### Step 9.4: DECISION
This is a textbook device ID addition — 2 lines adding a Bluetooth
product ID for the Logitech MX Master 4 to an existing, well-established
driver. The stable kernel rules explicitly allow this pattern. The risk
is essentially zero, and users with this popular mouse benefit from full
feature support.

## Verification
- [Phase 1] Parsed tags: Author Adrian Freund, merged by HID maintainer
  Jiri Kosina
- [Phase 2] Diff analysis: +2 lines adding HID_BLUETOOTH_DEVICE entry
  (0xb042) to hidpp_devices[] table
- [Phase 3] git blame: Device ID table exists since 2014, continuously
  expanded with similar entries
- [Phase 3] git log --author: Author previously added MX Master 3
  (commit 04bd68171e018)
- [Phase 3] git log: File actively maintained, 19+ changes since v6.6
- [Phase 5] No functions modified — pure data table addition
- [Phase 6] Driver exists in all active stable trees (since 2014)
- [Phase 7] HID subsystem, actively maintained, IMPORTANT criticality
- [Phase 8] Risk: VERY LOW (2-line table entry), Benefit: MEDIUM
  (popular hardware)

**YES**

 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 02d83c3bd73d4..c3d53250a7604 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4668,6 +4668,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
 	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
+	{ /* MX Master 4 mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb042) },
 	{}
 };
 
-- 
2.51.0

