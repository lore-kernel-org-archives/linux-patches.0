Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052355;
	b=TYe2wdQn7ZNXHtUiII7dYM4pKyMs1clBQho8yD/8oeMzstJulrJOCedJnSm+JV6VD170
	 MvcHCE6gVQvsxMK2NGtmVC8FwBonzsjn99xL8LJB1UFWv00fhqr8KVkVJPENSNju/i+kp
	 Nyi3QZVR9PgmvqPqYcbw+WUx+EnQ7A2VX8sHDkROq82Wnf6TYZUFvb/WPO4N5BQqRXCQh
	 fHdttTN/5jXm9ryj3A9nn5feLmdSzHYCt9+4ufOrgpTZl8UYFYSy3Q2iE3fNXDwCYYRX1
	 D8cQQ1x/bKvFxf/QpwYInB+/RT9D2qWBMiDs72e63SkhTzgnOJiTzY+OHleTAyNiIng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wqy9iTQdupSIKDtrlQhApkDeJFGRtv3ThB94ImJ8GLw=;
	b=5oYU3cWupBS89wj2WwR9hnyHfd4GNxABba9G9q9nbHTwSRAF1jvvU9kZmrzC7RuGKYdK
	 FnEE8R5hCYcmWaDvgxlVPFc67CBVZLFzu2q/GNxc71Uom5G0bmY4lgKVaHmBFAWDxFocc
	 kbqqpz/8/KTtOjjYl6/8/G9q4lNxRTs8SDX9ORilzUDj/Y7mfFF5AU0QSZwLrJlHCiIIH
	 q+NfUQJTiVhoYmw9Z9lNWVDvDb7Bwou8Rmz4xLdXXLRG72FbzuoK4muCu2N0eOX2si3iJ
	 IBGJ1kJn0g9EmrD/Q2mmXK7n/qtmJHCrpbDFJ3zI+YKAPZ/xqrI86Qa4Yh1/fY9E0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpFuk2MC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B860A2630;
	Thu, 19 Nov 2026 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpFuk2MC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F63B1F000C9;
	Thu, 19 Nov 2026 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052355;
	bh=Wqy9iTQdupSIKDtrlQhApkDeJFGRtv3ThB94ImJ8GLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpFuk2MCNo+AFFMbtLIG350cEWeUYujjXXG3cbTJRXT3KelhkRLE2lcP5vpGRRWC0
	 gbtKgCibmY+s6DNpCQ7jGIYXKesDwenRJaIL1fJ8Ah1drQzu5eSWhRKRyGGklg6WOG
	 88VqOmy9MS/5fJ1SpOKwF5DD2zO+GJNmpEmL/+1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0535/2214] hwmon: (lm95245) Fix negative temperature conversion
Date: Wed, 18 Nov 2026 15:36:51 +0100
Message-ID: <20261118150032.443399195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridham Khurana <khurana.ridham222@gmail.com>

[ Upstream commit f58c16056f8585ebafb0f1f5d90c23085443a4b9 ]

temp_from_reg_signed() uses only the high byte when the sign bit is set
and drops the fractional bits in the low byte. Writing -500 to
temp2_offset stores 0xff80 (-0.5 degrees C) in the offset registers,
but reading temp2_offset back returns -1000.

Negative temp1_input and temp2_input values are rounded down to the
next whole degree the same way. The chip reports -0.125 degrees C as
0xffe0, which the driver returns as -1000.

Treat the register pair as a single 16-bit two's complement value.

Fixes: fffd80ccc1e6 ("hwmon: LM95245 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260923172551.1593798-1-khurana.ridham222@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm95245.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index 29388fcf5f74d..bda71be0e1415 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -98,9 +98,9 @@ static int temp_from_reg_unsigned(u8 val_h, u8 val_l)
 
 static int temp_from_reg_signed(u8 val_h, u8 val_l)
 {
-	if (val_h & 0x80)
-		return (val_h - 0x100) * 1000;
-	return temp_from_reg_unsigned(val_h, val_l);
+	s16 val_hl = (val_h << 8) | val_l;
+
+	return val_hl * 1000 / 256;
 }
 
 static int lm95245_read_conversion_rate(struct lm95245_data *data)
-- 
2.53.0



