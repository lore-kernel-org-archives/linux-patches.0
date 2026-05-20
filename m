Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08CD3E92B1;
	Wed, 20 May 2026 11:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276027; cv=none; b=ZhLF7QHPGjqFQuHkbvzH6EMxVWvr1qeenv4t8HvA2ABv+nWv9DovNMTX/7ArwfrKhUgN1KuQYyPjZWdV0v+Wp+E4p7tDtTNbW/0awG1fVyF3ojJaB4ucDdu2pIjjQRZwLhgFO+sqPZwd6xDdL2xCHRZPTRzaMWZeSTE0n0Llr5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276027; c=relaxed/simple;
	bh=Mbybqoe/DAcr0H/nDiwCoFO0HzCxS6CuRjqNYO8GzHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2H9XxpAsZS1dLMln+ZAmRvMPpNMGH/TJJe8oVTMnsds1Wy1JBO4ZapjVXA1AOzXus5tSrteXWCYxbxyj+Tnbw01hO63AAjzvezS/uDNTjH5F7arhEZUtmyD4QUDBufFnZdDuXR++C4OvVgr58lQR7fUoU45rHuvvjHBUPi26zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzVb2QT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzVb2QT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D836A1F00896;
	Wed, 20 May 2026 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276024;
	bh=qOUwqq2SuZrhRFe3GLopBTiqUYjaGIz7bg+xEkeYtAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzVb2QT7Wh7NvVJvQQOeY8ZqX4o6JSesZUGAadz9fSykuEuJ00ZltcxJVfyVXEu3d
	 g0OfJpjJfINNnM9zteJ0v1liqvhqdYsiPTHvHftJIKZo1i+A8I8ZZLr/5D4oC0mnsI
	 dyQVO/Cs7ZdX0/a8KDRZv+hczcqZFOj5+opJ1wBtuEPgZtCrH1Yk6hTKEVMmR6S7n4
	 V8R9JCCTn7LedPbkpPqtHwe/WNzR5nc1oAJQNoVOZUOjS4ubjYRcUJfJAbM+x5xwIb
	 H/AyFZWefg1hduzZOAAeYKYsJiAwLSajTpfF5dCakmu5ihePI8ibTlq6sZXn6JzE+8
	 zSmz0hW+DwARQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Dejean <damiendejean@google.com>,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] HID: elan: Add support for ELAN SB974D touchpad
Date: Wed, 20 May 2026 07:19:00 -0400
Message-ID: <20260520111944.3424570-28-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Damien Dejean <damiendejean@google.com>

[ Upstream commit 55ce1858848132ed074fe907f00b5ce1ccab0ce1 ]

Elan SB974D touchpad uses ELAN_MT_I2C format to send HID reports. Add an
entry to match for the device and parse its vendor specific format.

Signed-off-by: Damien Dejean <damiendejean@google.com>
Signed-off-by: Kornel Dulęba <korneld@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

Step 1.1 Record: subsystem `HID: elan`; action verb `Add support`;
intent is to add ELAN SB974D touchpad matching so the existing ELAN HID
driver parses its vendor-specific I2C multitouch reports.

Step 1.2 Record: tags are:
- `Signed-off-by: Damien Dejean <damiendejean@google.com>`
- `Signed-off-by: Kornel Dulęba <korneld@google.com>`
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`,
`Cc: stable`, or `Link:` tags are present.

Step 1.3 Record: the body says SB974D uses `ELAN_MT_I2C` report format
and needs an ID table entry so `hid-elan` handles and parses that
format. Symptom is unsupported or generic handling of this touchpad, not
a crash. No affected-version statement.

Step 1.4 Record: this is not a hidden memory/race/crash fix. It is a
hardware enablement/device-ID addition to an existing driver, which is a
stable exception category.

## Phase 2: Diff Analysis

Step 2.1 Record: two files changed, 2 insertions total:
- `drivers/hid/hid-elan.c`: adds one `HID_I2C_DEVICE()` entry to
  `elan_devices`.
- `drivers/hid/hid-ids.h`: adds `USB_DEVICE_ID_SB974D 0x0400`.
Modified data structure: `elan_devices[]`. Scope: single-driver,
surgical ID addition.

Step 2.2 Record: before, ELAN I2C product `0x0400` did not match `hid-
elan`; after, BUS_I2C vendor `0x04f3` product `0x0400` matches `hid-
elan` and uses existing probe/raw-event paths.

Step 2.3 Record: bug category is hardware support/device ID addition. No
new parser, locking, memory management, or API change. The fix works by
routing this specific I2C HID device to already-existing `ELAN_MT_I2C`
handling.

Step 2.4 Record: fix quality is high: two-line addition, localized,
mirrors the existing Toshiba I2C ELAN entry, and has very low regression
risk. Main possible risk is binding product `0x0400` to `hid-elan`, but
the commit message and external fwupd discussion verify `04f3:0400` is
an ELAN touchpad PID.

## Phase 3: Git History Investigation

Step 3.1 Record: `git blame` shows `elan_devices[]` was introduced by
`9a6a4193d65b` in v4.17-rc1 range; the existing I2C Toshiba entry was
introduced by `e7ad3dc9f4a2` in v4.19-rc1 range. This means the required
driver and I2C-format support are old and present in long-term stable
lines.

Step 3.2 Record: no `Fixes:` tag, so no introducing bug commit to
follow.

Step 3.3 Record: recent history shows this commit is standalone; only
later related file change found was unrelated `HID: i2c-hid: add reset
quirk for BLTP7853 touchpad`.

Step 3.4 Record: author Damien Dejean has only this HID commit in the
checked `origin/master` HID history. Jiri Kosina committed/applied it;
`MAINTAINERS` lists Jiri Kosina and Benjamin Tissoires as HID core
maintainers.

Step 3.5 Record: no prerequisite commits found beyond the existing `hid-
elan` driver and I2C parser, both already present in checked stable
branches.

## Phase 4: Mailing List And External Research

Step 4.1 Record: `b4 dig -c 55ce185884813` found the original patch at `
https://patch.msgid.link/20260414133858.3992799-1-
damiendejean@google.com`. `b4 dig -a` showed only v1, no later
revisions.

Step 4.2 Record: `b4 dig -w` showed recipients included Jiri Kosina,
Benjamin Tissoires, `linux-input@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, Damien Dejean, and Kornel Dulęba.

Step 4.3 Record: no `Reported-by` or bug-report `Link:`. The lore thread
mbox contains Jiri Kosina’s “Applied to hid.git#for-7.1/upstream-fixes,
thanks.” No NAKs or concerns in the saved thread.

Step 4.4 Record: no multi-patch series; standalone patch.

Step 4.5 Record: lore WebFetch hit Anubis, but `b4` successfully fetched
the mbox. Stable branch grep found no existing `SB974D` backport in
`stable/linux-7.0.y` or `stable/linux-6.19.y`.

## Phase 5: Code Semantic Analysis

Step 5.1 Record: modified table is `elan_devices[]`; functional paths
affected are existing callbacks `elan_probe`, `elan_input_mapping`,
`elan_input_configured`, and `elan_raw_event`.

Step 5.2 Record: `hid_match_device()` matches `hdrv->id_table`;
`hid_device_probe()` calls the matched driver’s `.probe`;
`hid_input_report()` calls `.raw_event`. Thus the new ID makes this
hardware reach existing `hid-elan` probe and report parsing.

Step 5.3 Record: relevant callees include `hid_parse`, `hid_hw_start`,
`elan_start_multitouch`, and for I2C reports `elan_i2c_report_input`.

Step 5.4 Record: reachability is hardware enumeration and HID input
report delivery. Users of the SB974D touchpad hit this during device
probe and normal touch input.

Step 5.5 Record: similar pattern exists in the same driver for
`USB_DEVICE_ID_TOSHIBA_CLICK_L9W`, also using `HID_I2C_DEVICE()` and the
existing `ELAN_MT_I2C` path.

## Phase 6: Stable Tree Analysis

Step 6.1 Record: checked stable branches `5.10.y`, `5.15.y`, `6.1.y`,
`6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`, and `7.0.y`; all contain
`CONFIG_HID_ELAN`, `drivers/hid/hid-elan.c`, and the existing
`TOSHIBA_CLICK_L9W` I2C ELAN entry.

Step 6.2 Record: `git apply --check` succeeded on current `7.0.y`,
`6.19.y`, and representative older stable worktrees `5.10.y`, `5.15.y`,
`6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`.

Step 6.3 Record: no related `SB974D` fix already present in checked
stable branches.

## Phase 7: Subsystem Context

Step 7.1 Record: subsystem is HID input driver support. Criticality is
driver-specific/peripheral, affecting users of this ELAN SB974D touchpad
hardware.

Step 7.2 Record: HID is actively maintained; this patch was applied
through `hid.git#for-7.1/upstream-fixes` by HID maintainer Jiri Kosina.

## Phase 8: Impact And Risk

Step 8.1 Record: affected population is hardware-specific: systems with
ELAN SB974D I2C touchpad and `CONFIG_HID_ELAN`.

Step 8.2 Record: trigger is device enumeration and normal touchpad input
on that hardware. No evidence found that unprivileged users can trigger
a security issue; this is hardware functionality.

Step 8.3 Record: failure mode without the patch is lack of proper `hid-
elan` handling for this touchpad’s vendor-specific `ELAN_MT_I2C` report
format. Severity is medium for affected hardware because touchpad
functionality is user-visible, but not a crash/corruption/security
issue.

Step 8.4 Record: benefit is high for affected hardware and low globally.
Risk is very low: two lines, no behavior change for unrelated device
IDs, no API change, and clean apply to checked stable branches.

## Phase 9: Final Synthesis

Evidence for backporting: this is exactly the stable exception for
adding a new device ID to an existing driver; the driver and parser
already exist in stable; the patch is tiny, cleanly applies, and was
accepted by the HID maintainer. Evidence against: it is hardware
enablement rather than a conventional critical bug fix, and there is no
user bug report or `Tested-by` tag in the commit.

Stable rules:
1. Obviously correct and tested? Code is obviously correct by
   inspection; explicit testing tag absent.
2. Fixes a real user-visible issue? Yes for affected SB974D systems:
   proper touchpad driver binding/report parsing.
3. Important issue? Medium hardware functionality issue, not
   crash/corruption/security.
4. Small and contained? Yes, 2 insertions in HID.
5. No new APIs/features? No API; hardware ID addition only.
6. Can apply to stable? Yes, verified across representative active
   stable branches.

Exception category: new device ID added to an existing driver. This is
stable-suitable.

## Verification

- Phase 1: `git show --format=fuller 55ce185884813` verified subject,
  body, author, committer, and tags.
- Phase 2: `git show --stat` and full diff verified exactly 2 insertions
  in `hid-elan.c` and `hid-ids.h`.
- Phase 3: `git blame` verified table history; `git describe --contains`
  placed original driver support around v4.17-rc1 and I2C support around
  v4.19-rc1.
- Phase 3: `git log --oneline` checks found no dependent SB974D series
  and only this author’s HID commit in the checked range.
- Phase 4: `b4 dig`, `b4 dig -a`, and `b4 dig -w` verified original lore
  submission, single v1, recipients, and maintainer application.
- Phase 4: WebFetch to lore/stable was blocked by Anubis; the saved `b4`
  mbox was used instead.
- Phase 5: `ReadFile` and `rg` verified `elan_probe`, `elan_raw_event`,
  `elan_i2c_report_input`, `hid_match_device`, and `hid_input_report`
  call paths.
- Phase 6: `git grep` verified relevant stable branches contain
  `HID_ELAN` and the existing ELAN I2C entry.
- Phase 6: `git apply --check` verified clean application to `7.0.y`,
  `6.19.y`, `6.18.y`, `6.12.y`, `6.6.y`, `6.1.y`, `5.15.y`, and
  `5.10.y`.
- Phase 7: `MAINTAINERS` verified Jiri Kosina and Benjamin Tissoires as
  HID maintainers.
- Phase 8: no sanitizer report, crash report, or security impact was
  found; decision is driven by the verified device-ID stable exception.

**YES**

 drivers/hid/hid-elan.c | 1 +
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-elan.c b/drivers/hid/hid-elan.c
index 76d93fc48f6a2..0190ad567ce4d 100644
--- a/drivers/hid/hid-elan.c
+++ b/drivers/hid/hid-elan.c
@@ -513,6 +513,7 @@ static const struct hid_device_id elan_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_HP_X2_10_COVER),
 	  .driver_data = ELAN_HAS_LED },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_TOSHIBA_CLICK_L9W) },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_SB974D) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, elan_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c1e4a6ce96317..c371721826dcc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -455,6 +455,7 @@
 #define USB_DEVICE_ID_EDIFIER_QR30	0xa101	/* EDIFIER Hal0 2.0 SE */
 
 #define USB_VENDOR_ID_ELAN		0x04f3
+#define USB_DEVICE_ID_SB974D            0x0400
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
-- 
2.53.0

