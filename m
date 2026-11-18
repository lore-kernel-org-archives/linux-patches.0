Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059727;
	b=ywLscl86rCjmoNDIMtriAS68fEEtAkyQ3GyQvX3n+VjZ1pKYz1Iq8cz4tlSv5P4YTnvH
	 gaQjJXnVsZukSbfs0KpFOYWU/zMNfB+DplG8vytrWLMilGLxbjR0wp/f+Tz3mYe1SLFAz
	 t7CYTBGf2IQG5oNcTvBnPMRsdv9e3qysu0fW9UFQpGn9y/tX1OXym3Mi+BRvd34Gac8Fd
	 nLSRYLOv8P/GQyHv8kw/KiI0M0Tgd9XRkrH5MYaMMp6rXaaTj7C0PpDJSA59aD7Yc9/7F
	 ZlEw2YMiIuWv1tLUQtvrHrO1DTBN2il3qxOa2PIKVZQpSa3jg0TaUlCz8XqtN1J6UPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mn0+FeR7sUqalp7p9loHAkEVmRgWZlUcVJ4MRyEb6EU=;
	b=h0bcOAbrSeYpbqPV8Ks1uHko8wJGWw9diEZ81S9wOgA5W5oV/xtuqz6iHFu8rwon+XEo
	 trHzNWuO/Cp65rYf+JxlyzP1oIrazNp9Pr+IMnoz3ayayUWj55k4HBD5GldyKfKZFU4Bf
	 daiwpeJ8QrfltVgJsnPdPv60ETC2NjlGePWJsxoBh+Ah5ioDfY74sfD8rFot0ZJh2gSJs
	 OCqImPyHliREEmlVNA7OB0UYbKsdQvZt55IMBEyVnfk7VYlgbrwDNiLHR4AQb861ZkMEs
	 2D3iAt6PTyJQKmTWLvL2D5/GUUJdmKC7xYqrjoA+2KIrAfcUbZaGEdace2joURz7A3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yP0PIOR3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8C4606A320;
	Thu, 19 Nov 2026 03:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yP0PIOR3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9D71F000C4;
	Thu, 19 Nov 2026 03:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059727;
	bh=mn0+FeR7sUqalp7p9loHAkEVmRgWZlUcVJ4MRyEb6EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yP0PIOR3fnAURxMZJ0LBQM8IS8MTzFOKos6gYZhigNR+4gBBwinPFjA3o+w3R+Cnl
	 zq22bwYb3Dkz7ZJBf1Shi9aQ6/tVcffMdEG2/VIjgjK/5Q03r6/BmlloJKge3IqDmp
	 G7+8824H1dNwhCo3yXodFTsHbb3pMWhRrCVZ6rUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0946/1848] hwmon: (lm70) Fix rounding of negative temperatures
Date: Wed, 18 Nov 2026 15:49:44 +0100
Message-ID: <20261118145956.655756203@linuxfoundation.org>
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
[ sashal: omitted the change to the absent LM70_CHIP_TMP125 case ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm70.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lm70.c b/drivers/hwmon/lm70.c
index 6b884ea009877..a9e3b69075d64 100644
--- a/drivers/hwmon/lm70.c
+++ b/drivers/hwmon/lm70.c
@@ -90,17 +90,17 @@ static ssize_t temp1_input_show(struct device *dev,
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
 	}
 
-- 
2.53.0



