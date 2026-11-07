Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064196;
	b=0t5DDfO9NOJkB5UChAVkvls2D2IjchnPdQY+k5WpYM2TJfyK7+L8JxSRVsNDycc87e8X
	 ovh5ysQzuOTSCpKoa14Ms7/WB5h9MH+CLtWsWwKhX/WhkYc8frHyviQY1/mRTgLFjKNvF
	 sQrBeL0BtMiPqVZ+vkxlUOeHMqo2Af5nLlSh9chZkj4erZr1INylz1uXs6V3oT9UaNwmt
	 cedB0x3nL37pHiR3T9G7YpcwbKGwQRR+BOBBhPZNIhZc71QhT7iAifmWPSyBJdYoK7quw
	 ptgbBlMgymbVr/Q8ft/LtU9+DGB+B7IvCvT4O+xtDhmTSBaPwh1AdN+rVvNyOGmgeeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3A9xJXdZHMl+OO/VK8FK0BaFdPHQtPrYDIvtbY7B9w4=;
	b=pM7mB4fOB4qxRy1LVnorRCdOUGdepQtvQxOdg4sNH/umlwfA/rGkT9MoTX1YeG+j90im
	 07PL7Op+w7PJA/Iew3MB/7k4X644i3eLPQEGRg8vfhX7ORILKHbsEncU4ZdyZd+PuMSRa
	 a0MVyuTGvfVdli3ydpNp/l8wG6+3BqW/kqbnA6ARqKpEY2tAWB+auMTaXSk45+dv+d0iJ
	 krY6ebn20KnOQWSlyUnDC0W0yU9IUIld5vZhmbKMesx5e7XKVnrKwRcOLeCgvwv/bKwA3
	 +I62SonIH83c+hJkzguQgr5CZXv30y4lD0cjGKWQPO0PVtWChtIo3bgUpZJ81FhUxYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bT8U8XeV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530E7606D829;
	Sat,  7 Nov 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bT8U8XeV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E91F0089F;
	Sat,  7 Nov 2026 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064196;
	bh=3A9xJXdZHMl+OO/VK8FK0BaFdPHQtPrYDIvtbY7B9w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bT8U8XeV8lKLOYZxBzuzwUnUPQQgKp0Sa0tkAarXM43wsQeRI7dOK/hssBpp0/j2V
	 0OFYZ/Cjye3UHrxnp1sZc2LDMSvedAYf5HUvNbqWQnfz5A455tcFCeSgmQqfvI60RU
	 AeSyMaalkz/GPmeKk/ngbbLeFJ0WsHzoUcjnFkvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0297/1257] hwmon: (lm95245) Fix negative temperature conversion
Date: Sat,  7 Nov 2026 08:43:13 -0500
Message-ID: <20261107134947.665081295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 11553391f54b1..925574b8b0ca4 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -96,9 +96,9 @@ static int temp_from_reg_unsigned(u8 val_h, u8 val_l)
 
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



