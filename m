Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036089;
	b=2cdmUtog0YDfHU/j6G4a+GXXGvOCRAProN4J1CmkuCd7hpkWG7YlN1NZV2eVUaAe0Obt
	 X22SiK1BLnq1NSKwJleq5wFijTROGFAjSJBFvyFea/PanntNw5V1oiS8thV7PynZoS61z
	 xv1JfFWb1H9Iv+7be0MiR8U9ptPpjRaTdTz6uXTNGC8ppPmwED27HpqZMWj9R63asmdNQ
	 RJCpPxjDAO1vZeooGn3sR5eZ+MTyqfl6Mt3lQ8KhZE10yZCFrdCMFXxmEoZODKOSiX0cs
	 DyR52U+tnBlMmb4sd8ESHZn5U/KXVDwUm0iQgdxD17OhIS4hcM+VGCFBpch3guSj3Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mac0zLy72ixsVRSCnhXCA4IGKsPIa/hrgOrLxFNLpHQ=;
	b=UY+3KhFJT+koGBq94L5nJCmPuUWJrxS4nqpi1KFHvFcXjmqvVCUQ6BU24zuv+mSo+ivZ
	 iHK1R2jDNFZamhjBiBw5/5QWY54aAYsNyoRJeYzAgq52Cje8ZIPr0VR/CDp9KwmnSSbMq
	 BNbiqhj2ZHia2QAU/YwOE/mDBiB4K6xm0KDuMMWUCZtk4OM81HpQps/Zfl/QvWlgCfzjr
	 tsi0XCRvmzAjb2ByRxqRlJ54C13mxV8wlt6iMshNd3htpQ6M0WkcOEsVUZvI7mxt9N9TN
	 q0srMD31ujQiDL7kxbhXH3bNHztonbKJ6PMEAKTORvn/sPJf/+k56P3YY3ItsT53YzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMQjGfVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBDC606A320;
	Wed, 18 Nov 2026 21:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMQjGfVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4EF1F000C4;
	Wed, 18 Nov 2026 21:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036089;
	bh=Mac0zLy72ixsVRSCnhXCA4IGKsPIa/hrgOrLxFNLpHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMQjGfVBMQ22CWppdVN3KrT9G8PJYoqdYjBHsamL40bYugyq6lqqadWtbmZLlHLZa
	 +OBv4MYKvNslGuLVpJvPQG811l7BB482do6d16Kw4GPrBD/LbwBQoBfiTzGUKswlK3
	 zv0zEWifZPwP/AulDy2wxlB/wadnlCWu36T19AQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0936/3318] hwmon: (lm95245) Fix negative temperature conversion
Date: Wed, 18 Nov 2026 15:25:58 +0100
Message-ID: <20261118150347.640464576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 17ff54bd40151..2302a3d839dd4 100644
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



