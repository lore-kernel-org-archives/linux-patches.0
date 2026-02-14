Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461831D5ABA;
	Sat, 14 Feb 2026 01:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031140; cv=none; b=c7Mi+5LB7pTiVs3pnQ+R8hRu6TLGPcu2oS/ujAd0DuQqhB9gc5/F+Svi/5tEZrhU6lX0Oy20PcZgzveGw0BxQ7BHOYtWV/uPr1N3TWgzUSIaH+XgNXXXOfjI2I0Rd0+bHYBXtCJ4OQB5/2RrOpcHKfIQpRUKly/cveaD+yJjnzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031140; c=relaxed/simple;
	bh=/Z03jB1iwzLqTsCbH9tms1oGkhdUDjoezz4HCzMFyC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6xzZST6PyOZXZcgK0FeGKxImmrVrcwsmIUsgTph5rIndzqNQ1L1i3CTTyV4Tb3t39mdG2u2NhXct8tw3bUIuRw2rG575kPQeVdgRV1hymkC+uOVJwGp9WM82LWEb/Uzb499jlPd8+nEE6U0wghcOFauPaXnrUBtBBM9iTBA/3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnH+j+yk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnH+j+yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD08C19424;
	Sat, 14 Feb 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031140;
	bh=/Z03jB1iwzLqTsCbH9tms1oGkhdUDjoezz4HCzMFyC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnH+j+ykT37gMwCpVCRg2NSqXFzRn5A6LdWQJTUbI8AF+DEXhg2jTm0Hq1YhnxjZb
	 LMTCwhC4q2ISYv4qwjAn/+UHqKBWNA3rZbEnAsAaXwlmowmy2MJhM6lSBrs+PVUT08
	 cmfDK1bcTCHVRqW5yQGSo3ZBhoL1qN31xNsrmgW3wNbjU/zRff76AtbObfochLau3+
	 KPDvGvWTjeyoWTRFyIWUDDINt71xy9VYAEyuzTWjUOkndF8DkkWChmnKLf2pRxY7cG
	 TRIQhIGbvzeRW/KQGQHM3CueqlDGrIbAc9cHO46PAK2iPdexQScz16JC2OF5qJke5r
	 i1SehlSKbiAFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] hwmon: (f71882fg) Add F81968 support
Date: Fri, 13 Feb 2026 19:59:18 -0500
Message-ID: <20260214010245.3671907-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>

[ Upstream commit e4a3d6f79c9933fece64368168c46d6cf5fc2e52 ]

Add hardware monitoring support for the Fintek F81968 Super I/O chip.
It is fully compatible with F81866.

Several products share compatibility with the F81866. To better distinguish
between them, ensure that the Product ID is displayed when the device is
probed.

Signed-off-by: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Link: https://lore.kernel.org/r/20251223051040.10227-1-peter_hong@fintek.com.tw
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds hardware monitoring support for a new Fintek F81968
Super I/O chip to the existing f71882fg hwmon driver. The commit message
explicitly states "It is fully compatible with F81866." Additionally, it
enhances the probe log message to include the Product ID (devid) for
better distinguishing between compatible products.

### Code Change Analysis

The changes are minimal and straightforward:

1. **New chip ID definition** (1 line): `#define SIO_F81968_ID 0x1806` -
   adds the device ID constant.

2. **New case in switch statement** (1 line): `case SIO_F81968_ID:` is
   added as a fall-through alongside the existing `SIO_F81866_ID` and
   `SIO_F81966_ID` cases, all mapping to `sio_data->type = f81866a`.
   This follows the exact same pattern as the existing F81966 which was
   also added as F81866-compatible.

3. **Enhanced log message** (2 lines changed): The `pr_info` message now
   includes `devid: %04x` to display the product ID during probe. This
   is a minor informational enhancement.

### Classification

This falls squarely into the **"New Device IDs"** exception category for
stable backporting:
- It adds a new chip ID to an **existing, mature driver** (f71882fg)
- The new chip (F81968) is declared **fully compatible** with F81866,
  which is already supported
- The pattern is identical to how F81966 was added (also as
  F81866-compatible)
- No new code paths, no new functionality beyond recognizing the ID

### Scope and Risk Assessment

- **Lines changed**: ~5 lines (1 define, 1 case label, 2-line log
  message change)
- **Files touched**: 1 (drivers/hwmon/f71882fg.c)
- **Risk**: Extremely low. The new ID simply falls through to an
  existing, well-tested code path (f81866a). The only other change is
  adding `devid` to a log message, which is trivially safe.
- **Regression potential**: Near zero. Existing hardware is completely
  unaffected.

### User Impact

Without this patch, users with F81968-based hardware get no hwmon
support (the driver prints "Unsupported Fintek device: 1806" and returns
-ENODEV). With this patch, their hardware monitoring works using the
proven F81866 code path. This is a real-world hardware enablement fix.

### Stability Indicators

- The author is from Fintek (the chip manufacturer), who has direct
  knowledge of chip compatibility
- The maintainer (Guenter Roeck) accepted it, and he is well-known for
  the hwmon subsystem
- The pattern matches exactly how previous compatible chips (F81966)
  were added

### Dependencies

None. The patch is completely self-contained and applies to any kernel
version that has the f71882fg driver with F81866/F81966 support.

### Decision

This is a textbook device ID addition to an existing driver - one of the
explicitly listed exceptions for stable backporting. It's tiny, zero-
risk, enables real hardware, and follows an established pattern in the
driver.

**YES**

 drivers/hwmon/f71882fg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index df83f9866fbcf..204059d2de6cd 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -51,6 +51,7 @@
 #define SIO_F81866_ID		0x1010	/* Chipset ID */
 #define SIO_F71858AD_ID		0x0903	/* Chipset ID */
 #define SIO_F81966_ID		0x1502	/* Chipset ID */
+#define SIO_F81968_ID		0x1806	/* Chipset ID */
 
 #define REGION_LENGTH		8
 #define ADDR_REG_OFFSET		5
@@ -2570,6 +2571,7 @@ static int __init f71882fg_find(int sioaddr, struct f71882fg_sio_data *sio_data)
 		break;
 	case SIO_F81866_ID:
 	case SIO_F81966_ID:
+	case SIO_F81968_ID:
 		sio_data->type = f81866a;
 		break;
 	default:
@@ -2599,9 +2601,9 @@ static int __init f71882fg_find(int sioaddr, struct f71882fg_sio_data *sio_data)
 	address &= ~(REGION_LENGTH - 1);	/* Ignore 3 LSB */
 
 	err = address;
-	pr_info("Found %s chip at %#x, revision %d\n",
+	pr_info("Found %s chip at %#x, revision %d, devid: %04x\n",
 		f71882fg_names[sio_data->type],	(unsigned int)address,
-		(int)superio_inb(sioaddr, SIO_REG_DEVREV));
+		(int)superio_inb(sioaddr, SIO_REG_DEVREV), devid);
 exit:
 	superio_exit(sioaddr);
 	return err;
-- 
2.51.0

