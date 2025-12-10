Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3B1305058;
	Wed, 10 Dec 2025 06:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348518; cv=none; b=Rc8er4PaA6jIPH46Hj9rkzk9qcbcqp+DQ8XkdgfXPsBAC1gpol0x8eER6dAcM6I3MjrQa94sSkGnrpTOQTcEhfr6xtkJ7A88lnniVJDaL4lhvtsM8wz7wbjc+0SxG8SevwuF92XSag319fIC2HUrijNQfxWysxaAIpDZbhphl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348518; c=relaxed/simple;
	bh=fA+B30h0YeaX0w+Bbx8pzkya4tRo/QUCwnmrtws7R5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pe2HB60wQluh5tB4wr5Yehj2mvj0HD4zxzyZWFe9d+ppU15J2JfMkrkcE99wRkRzLi18q8bBlv0TQQWvYBGRyp6rQI7KF7t1GC5p7KF6ljGZ9P/y6a2cjrqN1JmsgBA3WVC4Z34JtAV5qgtNhlSW/WFp6EELozDyFXDhNeP1nO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lfEU8ZKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lfEU8ZKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89205C19422;
	Wed, 10 Dec 2025 06:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348517;
	bh=fA+B30h0YeaX0w+Bbx8pzkya4tRo/QUCwnmrtws7R5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfEU8ZKRs6WzzaKDzwrPBW5FP2hpJoyCdtGWhp5O/cgbRtTZ6Cn/3gZf0tZDsJxPL
	 ZlsJyJUzSbmtM/QyhI3azONWjElRwkx/DBcpAzKouCQNqWS3QTCcb6nZ/Q1hpVn4Px
	 C4IOsSMBy5AsFUrbjLs7hfctk2xzv2yjjGKk5zyIW5t1dgZ5kjqBiwSSvFQ38Z7ps8
	 S/AbuzqnaZzRG5aNQ1PswZZFBd0stYu3Joy+IxZNBpi0hkMt1OwyGnmBRNB2y25J+e
	 +alTTxvSIoijMm49SnyzeGcPMTnUuPp3mNbFnHz2Y9Px+++4qoSx1LztcH47oE9MDS
	 uvzqjdcSE0WUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Changcheng <chenchangcheng@kylinos.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stern@rowland.harvard.edu,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH AUTOSEL 6.18-5.10] usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.
Date: Wed, 10 Dec 2025 01:34:37 -0500
Message-ID: <20251210063446.2513466-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 955a48a5353f4fe009704a9a4272a3adf627cd35 ]

The optical drive of EL-R12 has the same vid and pid as INIC-3069,
as follows:
T:  Bus=02 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
P:  Vendor=13fd ProdID=3940 Rev= 3.10
S:  Manufacturer=HL-DT-ST
S:  Product= DVD+-RW GT80N
S:  SerialNumber=423349524E4E38303338323439202020
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=144mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=02 Prot=50 Driver=usb-storage
E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms

This will result in the optical drive device also adding
the quirks of US_FL_NO_ATA_1X. When performing an erase operation,
it will fail, and the reason for the failure is as follows:
[  388.967742] sr 5:0:0:0: [sr0] tag#0 Send: scmd 0x00000000d20c33a7
[  388.967742] sr 5:0:0:0: [sr0] tag#0 CDB: ATA command pass through(12)/Blank a1 11 00 00 00 00 00 00 00 00 00 00
[  388.967773] sr 5:0:0:0: [sr0] tag#0 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK cmd_age=0s
[  388.967773] sr 5:0:0:0: [sr0] tag#0 CDB: ATA command pass through(12)/Blank a1 11 00 00 00 00 00 00 00 00 00 00
[  388.967803] sr 5:0:0:0: [sr0] tag#0 Sense Key : Illegal Request [current]
[  388.967803] sr 5:0:0:0: [sr0] tag#0 Add. Sense: Invalid field in cdb
[  388.967803] sr 5:0:0:0: [sr0] tag#0 scsi host busy 1 failed 0
[  388.967803] sr 5:0:0:0: Notifying upper driver of completion (result 8100002)
[  388.967834] sr 5:0:0:0: [sr0] tag#0 0 sectors total, 0 bytes done.

For the EL-R12 standard optical drive, all operational commands
and usage scenarios were tested without adding the IGNORE_RESIDUE quirks,
and no issues were encountered. It can be reasonably concluded
that removing the IGNORE_RESIDUE quirks has no impact.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251121064020.29332-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary

**What the commit does:**
This commit fixes a device conflict where the EL-R12 optical drive (HL-
DT-ST DVD+-RW GT80N) with firmware revision 3.10 incorrectly receives
USB quirks intended for the INIC-3069 controller because they share the
same VID:PID (0x13fd:0x3940). The fix narrows the firmware revision
range from "all revisions" (0x0000-0x9999) to only revision 3.09
(0x0309-0x0309).

**History context:**
- Original quirk added in 2015 (commit bda13e35d584d) - was marked `Cc:
  stable@vger.kernel.org # 3.16`
- IGNORE_RESIDUE added in 2017 (commit 89f23d51defcb) - also marked for
  stable
- The quirk entry has existed in stable trees for years

## Meets Stable Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ Yes - simple revision range narrowing |
| Fixes real bug | ✅ Yes - disc erase operations fail completely |
| Small and contained | ✅ Yes - 1 line change |
| No new features | ✅ Yes - just fixes quirk scope |
| Important issue | ✅ Yes - device operations completely fail |

## Risk vs Benefit

**Benefits:**
- Fixes real functional failure (disc erase operations)
- Users with EL-R12 optical drives can use them properly
- Minimal change, low regression risk

**Risks:**
- Could theoretically affect INIC-3069 devices with firmware versions
  other than 3.09 if they exist and need these quirks
- However, the original report was from a specific device/tester, and no
  evidence suggests other firmware versions need the quirks

**Mitigating factors:**
- The quirk was originally based on a single reporter's device (Benjamin
  Tissoires)
- If multiple firmware versions needed quirks, we'd likely have seen
  additional reports over the ~10 years since the original quirk was
  added
- The commit author thoroughly tested the EL-R12 without the quirks

## Concerns

1. **No explicit Cc: stable tag** - The maintainer didn't explicitly
   request stable backport
2. **No Fixes: tag** - No specific commit is pointed to as introducing
   the bug
3. **Revision specificity** - We don't have absolute confirmation that
   0x0309 was the original reporter's exact firmware revision

## Conclusion

This is a standard USB quirk adjustment that fixes a real user-facing
bug (optical drive operations failing). USB device quirks are routinely
backported to stable. The change is minimal (single line), surgical, and
addresses documented hardware compatibility issues. The risk of
regression is low since the original quirk was based on a single
reporter's device, and narrowing the scope shouldn't affect other users.

While the lack of a Cc: stable tag is notable, USB quirk fixes of this
nature are commonly backported because they enable proper hardware
operation. The fix allows the EL-R12 optical drive to work correctly
without impacting the original INIC-3069 devices that need the quirks.

**YES**

 drivers/usb/storage/unusual_uas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 1477e31d77632..b695f5ba9a409 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x0160,
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-- 
2.51.0

