Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5888D39A7F9;
	Wed,  7 Jan 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801219; cv=none; b=BKH2FtRQxri0M5UQzryeBy7WS3Eu5FsNR07pxwJw92YKL7k9o6T5nnN6M1d0gEftR9Ia83JIni/M0RuBbcdQsc6BmLfF3AOXHBbj4Auqg2VdcPmJdyvss7r0CRBPIGWrP60R8ooVeh1YPfSYefeX71Uig57Q1H2yMOA8bLx6vFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801219; c=relaxed/simple;
	bh=wdMvfSJWGFav7L/E7nCk3KbVSxk4Vh8tBkpPa3X7OJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jy9nOYul1IUcE6dLVxfDtCQeDN4UV9e5fdLPNADHcDrhQZhxykgK87vGPChd3s9U1cm1+8iaSLEivrg/SM3HnYrSzjPSpZezDwMioO1TWfJmPQGQBvP4TdNzGt7mHbdIPwcm86zjwMrQZHKMyEwlig68QOK1Veqyz/vqnNfG61Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWsw4rN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWsw4rN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9466C4CEF1;
	Wed,  7 Jan 2026 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767801217;
	bh=wdMvfSJWGFav7L/E7nCk3KbVSxk4Vh8tBkpPa3X7OJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWsw4rN90FF58SpdPWPw351Zo29UHf1psFRMlL+voC1010tUq1lc9/zQxw0OZ2XB8
	 BYDoXnPuDQekMHWokwWiwAQbS4vGLGmvVKVpoY80EwWn3ekZ0xQy0OMUT6ooDvwXme
	 tbv1npfULPb8QYT2gQwT+GHpT6QeFwLnalTTTNP4n5tAgt/Dt0VwCHmFrkukyLiOas
	 CvrVhCuQbfLjBE93S4b+eauk+WQt2a4/2LSmgSLyp/9bv5wnfMTTk+J5gTGqJFsDSf
	 38ClIgiQqO6JjDakKM7pWD/+U5Aoalm0w9N3JdwX9HlpMCgsAiX/eZEL62qmAkwS/C
	 pr7+xqj203U7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: usb: sr9700: support devices with virtual driver CD
Date: Wed,  7 Jan 2026 10:53:07 -0500
Message-ID: <20260107155329.4063936-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260107155329.4063936-1-sashal@kernel.org>
References: <20260107155329.4063936-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit bf4172bd870c3a34d3065cbb39192c22cbd7b18d ]

Some SR9700 devices have an SPI flash chip containing a virtual driver
CD, in which case they appear as a device with two interfaces and
product ID 0x9702. Interface 0 is the driver CD and interface 1 is the
Ethernet device.

Link: https://github.com/name-kurniawan/usb-lan
Link: https://www.draisberghof.de/usb_modeswitch/bb/viewtopic.php?t=2185
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20251211062451.139036-1-enelsonmoore@gmail.com
[pabeni@redhat.com: fixes link tags]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: net: usb: sr9700: support devices with virtual
driver CD

### 1. COMMIT MESSAGE ANALYSIS

The commit adds support for SR9700 USB Ethernet devices that include a
virtual driver CD-ROM. These devices use product ID 0x9702 (vs the
standard 0x9700) and present two interfaces: interface 0 is the CD-ROM,
interface 1 is the actual Ethernet device.

External links reference real-world user issues with these devices
(usb_modeswitch discussions, GitHub repo), confirming this addresses
actual hardware in the field.

### 2. CODE CHANGE ANALYSIS

The change is minimal and straightforward:
```c
{
    /* SR9700 with virtual driver CD-ROM - interface 0 is the CD-ROM
device */
    USB_DEVICE_INTERFACE_NUMBER(0x0fe6, 0x9702, 1),
    .driver_info = (unsigned long)&sr9700_driver_info,
},
```

This adds a single entry to the USB device ID table:
- Same vendor ID (0x0fe6) as existing SR9700
- New product ID (0x9702) for devices with virtual CD-ROM
- Matches only interface 1 (the Ethernet interface, avoiding the CD-ROM
  on interface 0)
- Uses the exact same `sr9700_driver_info` - no driver code changes

### 3. CLASSIFICATION

**This is a NEW DEVICE ID addition** - one of the explicitly allowed
exceptions for stable backports.

- NOT a new feature in the traditional sense
- NOT adding a new driver
- NOT changing any APIs or driver logic
- Simply adding a USB ID to enable hardware on an existing, mature
  driver

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | +5 lines |
| Files touched | 1 |
| Code complexity | Trivial - USB ID table entry only |
| Risk level | **Very Low** |

The sr9700 driver is mature and unchanged. The only "new" aspect is
using `USB_DEVICE_INTERFACE_NUMBER()` instead of `USB_DEVICE()` to
specifically bind to interface 1, which is correct behavior for this
dual-interface device.

### 5. USER IMPACT

- **Affected users**: Anyone with SR9700 USB Ethernet adapters that have
  the virtual CD-ROM feature (product ID 0x9702)
- **Current state**: Device is completely non-functional without this
  patch - the driver doesn't recognize it
- **Severity**: Hardware unusable - users cannot access their network
  adapter
- **Evidence**: External links show real users encountering this issue

### 6. STABILITY INDICATORS

- Signed-off-by Paolo Abeni (Red Hat networking maintainer)
- Clean, follows established patterns for USB device ID additions
- Uses standard kernel macros (`USB_DEVICE_INTERFACE_NUMBER`)

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The sr9700 driver exists in all maintained stable kernels (driver
  added in 2013)
- Patch applies cleanly with no modifications needed

---

## Verdict

This commit is a **textbook example** of what should be backported to
stable:

**Meets stable criteria:**
- ✅ Obviously correct - simple USB ID table entry
- ✅ Fixes real bug - hardware completely unusable without it
- ✅ Small and contained - 5 lines, single file, no logic changes
- ✅ No new features - enables existing driver for device variant
- ✅ Falls into Device ID exception - explicitly allowed for stable

**Risk assessment:**
- Minimal risk - cannot affect existing 0x9700 device users
- Worst case if wrong: only affects users with 0x9702 devices who
  already can't use them

**Benefit:**
- Clear user benefit - enables hardware that otherwise doesn't work at
  all

**NO** concerns:
- No backport adjustments needed
- No dependencies
- Driver code is identical across stable versions

**YES**

 drivers/net/usb/sr9700.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 091bc2aca7e8..d8ffb59eaf34 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -539,6 +539,11 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE(0x0fe6, 0x9700),	/* SR9700 device */
 		.driver_info = (unsigned long)&sr9700_driver_info,
 	},
+	{
+		/* SR9700 with virtual driver CD-ROM - interface 0 is the CD-ROM device */
+		USB_DEVICE_INTERFACE_NUMBER(0x0fe6, 0x9702, 1),
+		.driver_info = (unsigned long)&sr9700_driver_info,
+	},
 	{},			/* END */
 };
 
-- 
2.51.0

