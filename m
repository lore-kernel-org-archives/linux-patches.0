Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21C03126B2;
	Sat, 14 Feb 2026 21:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104447; cv=none; b=XZP+X6fi8EkWMQAg3cqdYuauFGCuFYmnBWjN+JrvUIbBf0SGU+3Uo842LMwJ7K2RLxlgN4m7uvAJ24mIFdwy0I9lu1yITB0b1m03HZLL9evj0lMTUeEfYzngVmJpdzlYQAMBzA0zMn4Ww+5Ut7jQSbIJRQZpdcSgbTHIAXUJv3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104447; c=relaxed/simple;
	bh=R+qX/dkrpBBCavbTroNjk+lNEn38yjTGaEYPb+S4W00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcHyXUljOhudpW/1T8E5YsZcZU0he2z8MP9DJ5T/gHV+6NDNxM2Lhnv8mxDvQaVPJIH4MTSxz2Ljb1a4Eu/EWeAGeS1wAzYktI4fxTGwPDKxVI1J2IkoAr5Z/HeD48XKPfSwvZUc9pCv+uoALxa2lKQdiGdlOUTSf8VnD2Wqh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LaF8n+Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LaF8n+Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01CAC16AAE;
	Sat, 14 Feb 2026 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104447;
	bh=R+qX/dkrpBBCavbTroNjk+lNEn38yjTGaEYPb+S4W00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaF8n+WdhwV4M+N/2/m80YrHiZ6MalvKhdJMln7I5ESUtEvOVr3BnbDe/p0lQ+RNG
	 BGr+KYHV/wDNU6rFYj20wFvzsgd9hL/ikUWJFmg7iiZUuLa0AXXUOm5RqRZg5T5QKW
	 ai5sX25Cv/xv6fNEiWFM0YvpqXT5U+lx4dvQU1XwoXEX9KtFzetYoznvEL6A1olYyW
	 075ieIqCcyTKE3G+UC1XW6yjX/Q7zFgQRNS4Kv7dj0LfEZHCvxz7n7l5NUoVQTuv2i
	 zLjZi3joRp8kAdZFdHpBAZqHiorSkEUHVk0IuUnr7BroS/LMuIJR12czs54I3LxLiA
	 OqHq5s0PoXKpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jacopo Scannella <code@charlie.cat>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] Bluetooth: btusb: Add device ID for Realtek RTL8761BU
Date: Sat, 14 Feb 2026 16:23:56 -0500
Message-ID: <20260214212452.782265-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jacopo Scannella <code@charlie.cat>

[ Upstream commit cc6383d4f0cf6127c0552f94cae517a06ccc6b17 ]

Add USB device ID 0x2c0a:0x8761 to the btusb driver fo the Realtek
RTL8761BU Bluetooth adapter.

Reference:
https://www.startech.com/en-us/networking-io/av53c1-usb-bluetooth

Signed-off-by: Jacopo Scannella <code@charlie.cat>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
The commit adds a USB device ID (0x2c0a:0x8761) for the Realtek
RTL8761BU Bluetooth adapter to the btusb driver. It references a
specific commercial product (StarTech USB Bluetooth adapter), confirming
this is real hardware that users need supported.

### Code Change Analysis
The change is a single line addition:
```c
{ USB_DEVICE(0x2c0a, 0x8761), .driver_info = BTUSB_REALTEK },
```

This adds a new USB vendor/product ID entry to the `quirks_table[]` in
`drivers/bluetooth/btusb.c`. The entry uses the `BTUSB_REALTEK`
driver_info flag, which routes the device through the existing Realtek
firmware loading and initialization path that is already well-tested for
many other Realtek Bluetooth adapters.

### Classification
This falls squarely into the **New Device IDs** exception category. The
stable kernel rules explicitly allow adding device IDs to existing
drivers:
- The btusb driver already exists in all stable trees
- The Realtek support code (`BTUSB_REALTEK`) is already present
- Only the ID mapping is new — no new code paths are exercised

### Scope and Risk Assessment
- **Lines changed:** 1 (single line addition)
- **Files touched:** 1 (`drivers/bluetooth/btusb.c`)
- **Risk:** Essentially zero. This only affects devices with USB ID
  0x2c0a:0x8761. It cannot affect any other hardware or code path. If
  the ID is wrong, the worst case is that this specific adapter doesn't
  work — no regression for anyone else.

### User Impact
Without this device ID, users with the Realtek RTL8761BU (StarTech
AV53C1) Bluetooth adapter simply cannot use it at all with Linux. The
device won't be recognized by the btusb driver. This is a complete
hardware enablement issue — the fix makes the difference between "device
works" and "device doesn't work."

### Dependency Check
No dependencies. The `BTUSB_REALTEK` flag and all associated Realtek
support code have been in the kernel for years and are present in all
actively maintained stable trees.

### Minor Note on Placement
The new entry is placed under the "Additional Realtek 8723BU Bluetooth
devices" comment section, while the subject says "RTL8761BU." This is a
minor organizational issue (it would fit better near the "Additional
Realtek 8761BUV" section), but it has zero functional impact — the
quirks_table is searched linearly and the position doesn't matter.

### Conclusion
This is a textbook example of a device ID addition that should be
backported. It's a single-line, zero-risk change that enables real
hardware for real users, using an existing well-tested driver path.

**YES**

 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 972139729e8fd..cbb6ab2fd5e45 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -779,6 +779,7 @@ static const struct usb_device_id quirks_table[] = {
 
 	/* Additional Realtek 8723BU Bluetooth devices */
 	{ USB_DEVICE(0x7392, 0xa611), .driver_info = BTUSB_REALTEK },
+	{ USB_DEVICE(0x2c0a, 0x8761), .driver_info = BTUSB_REALTEK },
 
 	/* Additional Realtek 8723DE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb009), .driver_info = BTUSB_REALTEK },
-- 
2.51.0

