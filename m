Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058296;
	b=faQJ6/rQQ8XDxI9zfQgADbaJQLNQURz52jCmeXQszvYeJ2mVwkYX84sdXGaselShLBiT
	 lCyuddPdw5DDkq0j7nSF09/9AnPoVrOPX2rmMLIb9LgNCo+fc0GdN/4tVN5EOMG0QtjA2
	 r7EDke8wXoniBlB5k9pRGGdv0XNiT4mi3H2FfVoIVLvutoLOi3mnHu2WkGLTI5lmWno02
	 mdk+7P6tgQPz0E7AUV52wLGOdrfHvWwQn7GXsBwKbXDz00is9ZM+6MKk76o6I9+hOiV6F
	 MpkAAOikZb/MFaJ6k2jArjT0qRuI8WIvH57MfVL5S2D30zgbtQPQ45Aqsf/vhlnzfDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+EsnpJ907oWhXxEJRsWLuHjhzaYWc3SNrKP2kNupFU=;
	b=is4IbjtM/BjdIfveyouokJq/iFE4iW+bfLeFidudiLx0INd8yX3PxbPjyPvHin9cwxio
	 HZpGrv+maB5lIMphLoedzYDM+Uq0be6Yrt0U/x+C63XKmd/CGJnfCVkIdvcujnhkzQcxk
	 GmtAaFY5syBR/BvyYADjEZpo3ZKpkYqZBTkwH2xxTjXVaE0gfauP/gkkA9zrpbeGOp5ub
	 bWjwNDXDzjgPoWusWiUIAjY0aQdBS1YiMhS4ZU1kImyom2faA6k/Km2RDuhSIlVlF4NFp
	 9DiM12mJPWX8FmsQLClt9NLnwwW76S1UUhjo5PsCTS7lvqZL/QTlRtTTBWrzqRpnobQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnORxvE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19410606A32A;
	Thu, 19 Nov 2026 03:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnORxvE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696EE1F000C4;
	Thu, 19 Nov 2026 03:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058296;
	bh=z+EsnpJ907oWhXxEJRsWLuHjhzaYWc3SNrKP2kNupFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnORxvE9GY+/rCvA7VdeeRBDDhkTbhzv66muwhSGujoDZNAbOnK4hn2j72FP/CSdq
	 QrKnaBYVatnj8vdfEZRhoJJLfJOLSUyEHZUSEXDoAiqzXScKdu8GhRlgy/gT7UevSb
	 OosUUyzr7KP422TdY18lmPSCH4QtSM4NfRH7xAvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0434/1848] hwmon: (lm95245) Fix negative temperature conversion
Date: Wed, 18 Nov 2026 15:41:12 +0100
Message-ID: <20261118145932.294488067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



