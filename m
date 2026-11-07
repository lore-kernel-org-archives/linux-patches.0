Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062090;
	b=IGnLWEpaateOxrUgT5DHH4Ka4wwRZvFmCE3aBlvZwezYO+9+gIV7LqJEH+uLDYSv7dFm
	 DTZ4KNM4PxDLbMsWM5IySQFlJbFPgCeVIKpFebH7p3WdxolxXvajr5daiVhP0+O4bdQ+S
	 BRAlI87KOHdgD7BfzDacrj6UXoFFEzwu4W0IXl3d1TmvxTId3kNHiBDNIuZwx5lVzbRa4
	 GcASejCwqCYQyB56IVvobczhZCPFdYlwdH/+juaxIdfewuDp7lDhKXpU/2iwaQi3NOKj+
	 0yag6qlTujVdz4ahFJQ5Ou2i4vlQtU6geFb2Ts/xwwzi51FmwaO9clVkfQ3OBH1aoIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ynuVOh7XeM6I9pE9MjWxRBxBuIbho0hILwmvIvQCdMk=;
	b=oIO5qUnz+GzuQjEPaYAsweV3U9PHWuWKzVpwL1dqDa67GeuMJG8uRxKGd6kNaEvRUmMl
	 d7pvtGcBiHzh3ywpMG85WyM94vjpcFw//tQSrHGw+i+EkthrZDjbHz+XIH8SLhF8Ll1Mp
	 k16+jzy+87v11nj/qwrHZWIW0C8yY5/Tsst8GO02gkv57UD2lvU+BkRy2kmd0CsXfzqTU
	 Ox7QBBuZU5UxjF07T5OUp1gDA7unYuRpSxGnJwu0pINKaaiCMHBASDTvXmFfGSxC1C2zv
	 BCcpccQDYT4egVe7d5oMNDI5m3mj1iPQrBI2J0i5OWqClE7FdTl6xCqoyoa4yVkw3AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvZytM9J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785AA608360D;
	Sat,  7 Nov 2026 14:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvZytM9J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256641F008A5;
	Sat,  7 Nov 2026 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062090;
	bh=ynuVOh7XeM6I9pE9MjWxRBxBuIbho0hILwmvIvQCdMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvZytM9Jv3Z54X1UuUwc8mZf1dXHI1SSoxQaC0TP/bouaKkPr/Bz0V53kSMI7Cw3D
	 6RunUTyE26Ab6gX4YPCu33YY/QNwYlj7760z85glQLUq241je7aObpOiFVkF0seFfk
	 MFS3ZhhXcKG0alyv2U+hxvRNTYBKsqoamQG1ykto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1064/1536] hwmon: (lm95245) Fix negative temperature conversion
Date: Sat,  7 Nov 2026 08:51:20 -0500
Message-ID: <20261107135027.569596612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3bdc305308479..9c977d2820f9c 100644
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



