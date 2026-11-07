Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064197;
	b=nBqN7DpLQpwJIq0VD4jT26X8feGDRCvnAHP0aaXrFIfRVY/skuyEyLYr24P8Ca2TZiLg
	 YsP82bg2TCe3KwyYKVnUGtAH1w8BqVs3+gntPaZaSSw6fU2T+gAijtmNIZgNy5WudfhAf
	 rgjEpaBdstyMTVE8cd9o2xgj3kiMDhImUuQcmJHiuiIKDpsk8AXy+yZGN4ORKWk6b23G1
	 pgOr32zSL2gubLkMSRk8srs/yAjco7IfXwzfi5pyx5P3szK/RmkGu3gDkLvTYdeJfQu6w
	 Tlt1ijxySCc9rqGbPgbZf6IKaR9bouJZRflAV0mG3Yl9c3h12dKfy3xdrE1fuUXQXrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5i+hfX3wkmpMCkk7aZsb200AAP/mG7F7a/3OoGSMCTE=;
	b=qRw5pO/GCOdMNO/g3QGVjnf6kFxtZeVNkLuF+2yAA1/AGToMeWmbCYCKOj5GtIBfNCki
	 4EmKbTkKyac6oNSmRDMpYRgvl9O9haLnQ8dzD0AiJ80aXXrjEk6no9R99zWGwAx3J44Y0
	 JrgepkUsG4u5f/cQXb9St7CiW5dfHy8CwiAqkaNj+/Jgewl++ErYbjTQDMy+Gqg9EKmrV
	 Uq5hLnNF0CDaDNNErB5pHVMtuqlmC5MwSzKUzo0jxY8YBJjTKAFJx3/hSdC/Z9VBr78TS
	 9WYhfbNHKFw4I3e8G+bl+0r+XXqS8CkMM68Z0oC/v5xUkaVpIak0vMHFVb0Ez0w0nHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdjTS7Jp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1A9606EEB2;
	Sat,  7 Nov 2026 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RdjTS7Jp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8821F008A1;
	Sat,  7 Nov 2026 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064197;
	bh=5i+hfX3wkmpMCkk7aZsb200AAP/mG7F7a/3OoGSMCTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RdjTS7JptKkuPmxv1i2chBjUfhUO8GQKl1OedAI9BjbYCSRqj0IUsKot/uMXE9M2T
	 2ccDhyvc9URhB/66Q4jQUNZg/rLUvISgBddbeE8aE1GGi+z7iib89+X/oUIBS/hA/F
	 fW54fyVWoSrLd2SFKLE2zXAsj++9GFLaLqSjo7M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0298/1257] hwmon: (lm70) Fix rounding of negative temperatures
Date: Sat,  7 Nov 2026 08:43:14 -0500
Message-ID: <20261107134947.691581317@linuxfoundation.org>
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

[ Upstream commit eddb0aaacce4baa9d8176eb2f4bd9e99e867f8fc ]

temp1_input_show() drops the low bits of the temperature register by
dividing the raw value (raw / 32 on the LM70). These bits are not part
of the temperature: the LM70, LM71, LM74 and TMP122/TMP124 always
return some of them as 1, and the TMP125 fills them with copies of the
temperature LSB. Division rounds toward zero, so a negative temperature
with any of these bits set is reported one LSB too high.

For example, the TMP122 returns 0xffff for -0.0625 degrees C, which the
driver reports as 0. The LM70 returns 0xf39f for -25 degrees C, which
the driver reports as -24750.

Use an arithmetic right shift instead, which drops the low bits and
rounds down.

Fixes: e1a8e913f97e ("[PATCH] lm70: New hardware monitoring driver")
Fixes: a86e94dc946d ("hwmon: (lm70) Add support for LM71 and LM74")
Fixes: cd929672a9ef ("hwmon: (lm70) Add ti,tmp125 support")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260924205326.1739229-1-khurana.ridham222@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index 8b525725fef4f..b29bac7a4cc14 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -96,21 +96,21 @@ static ssize_t temp1_input_show(struct device *dev,
 	 */
 	switch (p_lm70->chip) {
 	case LM70_CHIP_LM70:
-		val = ((int)raw / 32) * 250;
+		val = ((int)raw >> 5) * 250;
 		break;
 
 	case LM70_CHIP_TMP121:
 	case LM70_CHIP_TMP122:
 	case LM70_CHIP_LM74:
-		val = ((int)raw / 8) * 625 / 10;
+		val = ((int)raw >> 3) * 625 / 10;
 		break;
 
 	case LM70_CHIP_LM71:
-		val = ((int)raw / 4) * 3125 / 100;
+		val = ((int)raw >> 2) * 3125 / 100;
 		break;
 
 	case LM70_CHIP_TMP125:
-		val = (sign_extend32(raw, 14) / 32) * 250;
+		val = (sign_extend32(raw, 14) >> 5) * 250;
 		break;
 	}
 
-- 
2.53.0



