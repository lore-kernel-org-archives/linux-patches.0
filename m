Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5543E9C5;
	Tue, 10 Mar 2026 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133354; cv=none; b=GRLrd6FmDpALb/MK3ut1XyVRBAxMZvTCuwqChBaKSwzgIf+U/CqC2nd2fG60JV7JjQ+Pf8aWeF+x59EK3TJuJtigrprn2jqwBCPguTBSM3uLFRHPM7gWW/XCHVOWsaIKteUFoS2ve1UVmMzhOcLfBhwcDyevxcDl6kLxSgQAGBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133354; c=relaxed/simple;
	bh=dyZoKH8XDotOwtrxv1ftKGKj6+/9NDQwSTPynUEi6wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9quCxnuZPEP8j8fmkzk7OX1mwXdhyK/yM4a8GGnDqn51D1upJt+kdf03ZXQRIkEZ7LDymoYYjX5e+9sD1q8zvnAQ4bzI60jaMhtqHfrJmUm0uG/uNrkdL4ZjY9WBAXKAAW1IFG7LwcxGACkecLQZlJhp7ZHe/tiV1Yhukfi6Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7Wl+Wt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7Wl+Wt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE0C19423;
	Tue, 10 Mar 2026 09:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133354;
	bh=dyZoKH8XDotOwtrxv1ftKGKj6+/9NDQwSTPynUEi6wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7Wl+Wt+VvjrSQxXCnMiOg9eFoexHeAJCd9CBue3j/Xm20VQ7OrVrOgLExrUWVt4+
	 Bxgd4XoH49SGxgcLJA4R28P/ymZl0WJfW+i9ZQCJ94gpF1r5/IF+I0luzFJEYigUph
	 EFrWeE0I1JHQyMC+3hsIa72BS6kwe4YNgqKeNxxHkI3X7uV9O5Fa/V0K6itA1Sjy7U
	 n8pW2QZPW/ksl0nGUAQbxiuVOBpY375Uf93DtNZ9ER1nWfXBgTqOZbSmefu/IZYPaa
	 NL+whxGsACY76k5ni9twbvqhtDLOqdcmhnbDTb17t/gWMm/5sS98d9vgTg0OsW4BTZ
	 Dy7E5ek3BS47g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Valentin Spreckels <valentin@spreckels.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] net: usb: r8152: add TRENDnet TUC-ET2G
Date: Tue, 10 Mar 2026 05:01:33 -0400
Message-ID: <20260310090145.2709021-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentin Spreckels <valentin@spreckels.dev>

[ Upstream commit 15fba71533bcdfaa8eeba69a5a5a2927afdf664a ]

The TRENDnet TUC-ET2G is a RTL8156 based usb ethernet adapter. Add its
vendor and product IDs.

Signed-off-by: Valentin Spreckels <valentin@spreckels.dev>
Link: https://patch.msgid.link/20260226195409.7891-2-valentin@spreckels.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does

This commit adds USB vendor and product IDs for the TRENDnet TUC-ET2G
USB ethernet adapter (vendor ID `0x20f4`, product ID `0xe02b`) to the
existing `r8152` driver. The device uses the RTL8156 chipset, which is
already fully supported by the driver.

### Changes

1. **`include/linux/usb/r8152.h`**: Adds `#define VENDOR_ID_TRENDNET
   0x20f4`
2. **`drivers/net/usb/r8152.c`**: Adds `{ USB_DEVICE(VENDOR_ID_TRENDNET,
   0xe02b) }` to the device table

### Stable kernel criteria

- **New device ID to existing driver**: This is a textbook example of
  the "NEW DEVICE IDs" exception explicitly listed in stable kernel
  rules. The r8152 driver already exists in all stable trees, and the
  RTL8156 chipset is already supported.
- **Obviously correct**: Two lines — a vendor ID define and a device
  table entry.
- **No risk of regression**: Adding a USB device ID cannot break
  existing functionality. It only enables matching for a new device.
- **Small and contained**: 2 lines of actual change across 2 files.
- **Fixes a real problem**: Without this, users with TRENDnet TUC-ET2G
  adapters cannot use them with the r8152 driver (the device won't be
  claimed).

### Risk assessment

**Zero risk.** This is the most minimal possible change — adding
identifiers so the kernel recognizes a device. No code paths are
changed, no logic is modified.

### Verification

- Confirmed `VENDOR_ID_TRENDNET` is a new define not previously in the
  header by examining the diff context showing the existing vendor IDs.
- The RTL8156 chipset support already exists in the r8152 driver (the
  driver handles RTL8152/8153/8156 variants).
- The change pattern matches dozens of similar device ID additions that
  are routinely backported to stable (e.g., other vendor IDs already in
  the table: Lenovo, Linksys, NVIDIA, TP-Link, D-Link, Dell, ASUS).
- No dependencies on other commits — this is fully self-contained.

**YES**

 drivers/net/usb/r8152.c   | 1 +
 include/linux/usb/r8152.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 6b107cf5f37bd..9eda892beb1f8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10062,6 +10062,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_DLINK,   0xb301) },
 	{ USB_DEVICE(VENDOR_ID_DELL,    0xb097) },
 	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
+	{ USB_DEVICE(VENDOR_ID_TRENDNET, 0xe02b) },
 	{}
 };
 
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
index 2ca60828f28bb..1502b2a355f98 100644
--- a/include/linux/usb/r8152.h
+++ b/include/linux/usb/r8152.h
@@ -32,6 +32,7 @@
 #define VENDOR_ID_DLINK			0x2001
 #define VENDOR_ID_DELL			0x413c
 #define VENDOR_ID_ASUS			0x0b05
+#define VENDOR_ID_TRENDNET		0x20f4
 
 #if IS_REACHABLE(CONFIG_USB_RTL8152)
 extern u8 rtl8152_get_version(struct usb_interface *intf);
-- 
2.51.0

