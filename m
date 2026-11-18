Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045150;
	b=0daLrKDj+wVZoy939neORJeJx5xUj6KntVxfZ2Sx0nFCJFqUVnGQQvNFG/nJ+YMPh83c
	 oOgk263H5ZM6+B9qni5E0V4I18HkdwmoOE8onKDw46Jq4e26yXgGGVaLh5JddVpJ4WeV9
	 HJe8azrz5GMvnRJ0SSrOO4G37/Yy4wRjX3WjRTJfnH+zSCkHNfLkk+vZ1JAuaLgO/JQAC
	 E9AQgJ6pbH2V4x/lwq1MyNO6J5kY3G+1SZRgmbrJk8Y/vcc2Ty4bHimDSWAATnjzf9PYg
	 7+2uvqDiwccfoS0qYHe4xyI8kv/42zAxXP06tuCm/LkRrBeaYjbmgjBeBQR2rK0upZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOMdLkqNoonzWzPl5PDz8GB9PfYMr9Hw05lTDmwt8uE=;
	b=ejqRooVVLy/yjXTxgiaeCRZ+Mf1yjqZ004ARQUw6MFQ4jEUI+PhC6Eboev1USmhORbpS
	 iVsiTrN5PRNftChYNc3UMS8qDsgFGQ3pFRkSCT+pCriGCHdezI1za51oGcEhpuxifIuTV
	 Wn+6AkoFHTxtrhWKUZ9pmoC7qIQJuZvlSq5dwYzEscFdPhd/IEzAkrJuZUscu8sPUOcub
	 Lft+shFWluKeE4ysRBq/K+aqk2ZdRmpjuNbqfXxaJvC5ePcXN7hIjROurrIM5xWmxmIAx
	 SJBO1M8zuGoH7PkM47JqcMzFrKNC0DMpxZpof9fT+V3Av4ijRZTB7xGf/nk2FZYl5bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EonTIJYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809A606A320;
	Wed, 18 Nov 2026 23:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EonTIJYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C2D1F000C4;
	Wed, 18 Nov 2026 23:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045150;
	bh=nOMdLkqNoonzWzPl5PDz8GB9PfYMr9Hw05lTDmwt8uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EonTIJYsI+ds7WZ9xLwybWjtwXeWwXg56ZhlPYwhn4SnKtEp3BFpSRPxLKZm82i9g
	 WgsonTbkbanYhUeiDkbeRVNlt52niZKt1LUwZ9yXjiKa1/zCZuYWFdkX86VHTlYbz6
	 sFBm8JgS9asuCD1iZ7ecf7y6SR1Qpb4IPWTNI1s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0820/2857] hwmon: (lm95245) Fix negative temperature conversion
Date: Wed, 18 Nov 2026 15:30:54 +0100
Message-ID: <20261118150231.100632721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c433f0af2d318..e7695dc751718 100644
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



