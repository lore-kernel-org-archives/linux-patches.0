Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1838F1FF5E3;
	Tue,  9 Dec 2025 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239411; cv=none; b=UgvowpAQ4LveU7y1/Wz6VIIWHrEncCNsm555KQzgPNOSFB+pFMHcveuSDgjp04GBe1YGwOcfzSjqT/gVG/+ahkVRyLh1Ijihh5ArT2BqBhQUrv7KyANTtMr/eDIgr4r/9CxStCY1JPFHplG8FGDA6E+mSG5y1MdKbbwZPZeJmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239411; c=relaxed/simple;
	bh=xv6Cu0U7vsA5sFTybvJeaOcOWgd+Wt5iJGmQdax558c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZK73ARb7swWx3iik12QFNz/J3YFsmvVZ0l7buq5/EBTxSv45Za+sC0C6cm5gt85zwJGFHEG9egZWKEC1xHxLsziQOsRhC7BDZi92Yyqr6nOJQ+c2M+/sy1klacF98/atToEKrrF+vZfLQc6uCHzh7I2J6O7Lexaohfwwi6iE3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fdk2JZAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fdk2JZAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B41FC113D0;
	Tue,  9 Dec 2025 00:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239411;
	bh=xv6Cu0U7vsA5sFTybvJeaOcOWgd+Wt5iJGmQdax558c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fdk2JZAvE2iInBrosnWQW6peCGj8NAczTSIo2mlU19iCT5jfhre3WI7YZcFCHutbe
	 RUEoxs6Pbj9Ep0uMBJcaCQZjr9tjucNiBBg8kX7Gote6tqB4+HSoDevOtsZcNIbwkT
	 3WWyunXcSVaEuCNOizRz1I/U7Rv6YuKJl5MvVWuDO7IOpog68UJhOahIoErYO20kGg
	 AX/yC/apLy3HikCQ4myc265WhIwRY1HZ6Q0li9JhXeoD6o2cOvYOB5ma69dsKarL/e
	 YJfo4VOOH0fnYHD0jF6gncmJIHAx5XjIPzqy8THV76r3gzVm2e0oYYqx3qpDoGoIcz
	 uVn0ADLBKT5qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gongwei Li <ligongwei@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: btusb: Add new VID/PID 13d3/3533 for RTL8821CE
Date: Mon,  8 Dec 2025 19:15:01 -0500
Message-ID: <20251209001610.611575-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Gongwei Li <ligongwei@kylinos.cn>

[ Upstream commit 525459da4bd62a81142fea3f3d52188ceb4d8907 ]

Add VID 13d3 & PID 3533 for Realtek RTL8821CE USB Bluetooth chip.

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below.

T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3533 Rev= 1.10
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: Bluetooth: btusb: Add new VID/PID 13d3/3533 for
RTL8821CE

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** Adding a new USB Vendor ID (0x13d3) and Product ID (0x3533)
for a Realtek RTL8821CE Bluetooth chip.

**Tags present:**
- No "Fixes:" tag
- No "Cc: stable@vger.kernel.org" tag
- Signed-off-by from contributor and Bluetooth maintainer (Luiz Augusto
  von Dentz)

**Key content:** The commit includes detailed USB device information
showing this is a real, tested device from the
`/sys/kernel/debug/usb/devices` output.

### 2. CODE CHANGE ANALYSIS

The diff shows a simple 2-line addition:

```c
/* Realtek 8821CE Bluetooth devices */
{ USB_DEVICE(0x13d3, 0x3529), .driver_info = BTUSB_REALTEK |
                                             BTUSB_WIDEBAND_SPEECH },
+{ USB_DEVICE(0x13d3, 0x3533), .driver_info = BTUSB_REALTEK |
+                                            BTUSB_WIDEBAND_SPEECH },
```

- Adds USB device entry with VID 0x13d3, PID 0x3533
- Uses **identical** flags as the existing RTL8821CE entry (0x13d3,
  0x3529)
- Placed directly under the "Realtek 8821CE Bluetooth devices" comment
- Follows established table pattern exactly

### 3. CLASSIFICATION

This is a **NEW DEVICE ID** addition - one of the explicit exceptions
for stable backports:

> "Adding PCI IDs, USB IDs, ACPI IDs, etc. to existing drivers. These
are trivial one-line additions that enable hardware support."

The btusb driver already fully supports RTL8821CE devices; this just
adds a new variant's USB ID to the match table.

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 2 lines added |
| Files touched | 1 file (drivers/bluetooth/btusb.c) |
| Complexity | Trivial - table entry only |
| Risk | **Extremely low** - purely additive |

**Risk analysis:**
- Cannot break existing functionality (new table entry only)
- Uses same driver_info flags as sibling device
- Only affects users with this specific USB hardware
- If somehow wrong, worst case is Bluetooth doesn't work for this device
  (no worse than before)

### 5. USER IMPACT

- **Affected users:** Those with laptops/devices containing this
  Bluetooth chip variant
- **Current behavior:** Bluetooth device not recognized by btusb driver
- **Fixed behavior:** Bluetooth works normally
- **Severity:** Hardware enablement - critical for affected users
- **Evidence of real use:** Detailed USB device tree dump proves this is
  real, tested hardware

### 6. STABILITY INDICATORS

- Proper maintainer sign-off (Luiz Augusto von Dentz, Intel Bluetooth
  maintainer)
- Matches exact pattern of existing entries
- Same flags as the sibling 8821CE entry (0x13d3/0x3529)

### 7. DEPENDENCY CHECK

- **Dependencies:** None - completely standalone table entry
- **Prerequisite code:** RTL8821CE support (BTUSB_REALTEK,
  BTUSB_WIDEBAND_SPEECH) already exists in stable trees
- **Applies cleanly:** The quirks_table structure has been stable for a
  long time

## Summary

This commit is a textbook example of the "NEW DEVICE ID" exception for
stable backports:

**Reasons to backport:**
1. Trivial 2-line USB ID table addition
2. Zero risk of regression to existing functionality
3. Enables Bluetooth for users with this specific hardware variant
4. Follows established, well-tested patterns exactly
5. No dependencies on other commits
6. Driver already fully supports this chip family

**Minor consideration:**
- No explicit "Cc: stable" tag, but device ID additions are routinely
  backported without it

The fix is small, surgical, and follows an explicit exception in stable
kernel rules for device ID additions.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9a923918bf741..b92bfd131567e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -504,6 +504,8 @@ static const struct usb_device_id quirks_table[] = {
 	/* Realtek 8821CE Bluetooth devices */
 	{ USB_DEVICE(0x13d3, 0x3529), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x13d3, 0x3533), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
-- 
2.51.0

