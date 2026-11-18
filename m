Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024091;
	b=Z6PcNGdzc1MSCc99NcpjvlNl+NWmGPTLIu4BoYJBgxAxFv9AvB0UEOgfTMUt4YPIge+9
	 Zyn3fdKwWuOcyoPsJ4kH79AvcUloekoaDVI2/NrcoaC1JbiJaejn5ctFgRriOaMgLYMVp
	 JLxqu/99HZeG9NZMwJBuTW0TLOPuOefQjOMvU8uv7k0Bvs6nXkvr8zkRCVTefrp6Ojfbg
	 wJGWKo+JSV54BukMmGeg5VUMct7z8W4M8NUV9cKLu8N27ElDiDgWd2XzdvLFANQI+ThCd
	 kAeovHo4o5fWYAAr8WPr26FPaOzDCri0b7+pG8g5mU6RrOCWht6keSA7emT1U2YAs5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oNvsD+fPAZ15Z238TIn9d82xI2WaHPP/MDic7rkjQL8=;
	b=2VwQEUq6yhhktus1Q1QuLoCTyz8y8JSU2jdbjBUpk55YsZXrNo4On2nLeoJ2LPZ/X3Ka
	 lM4Oti1PknDMpJn4L4y0rYPP0JZ/Nyqe5FBwNQ20MVLne4JEOgBr8ctdY8WrAN6XJSn4L
	 QeXbgVSZ5T/8OVZjDXUHwLCB8DUBOHjEla7i2wLLseFHZGbmtRYgv0YMoGIxJITQxwse+
	 pkeCGmmQqjh751lDo7A6dkdmfhqdr1m+43yOfHjDucCN2xnfhn20HMNJ4SegV88leRbYg
	 SZDwrRxslC3dL6x9qFC81zg0/wfDriRd/jw9tq99DJW0VttkXjjJnkV103v2mD6n57A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15Bqoyja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C76606A32F;
	Wed, 18 Nov 2026 17:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=15Bqoyja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03991F000C6;
	Wed, 18 Nov 2026 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024091;
	bh=oNvsD+fPAZ15Z238TIn9d82xI2WaHPP/MDic7rkjQL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=15BqoyjalFPZJN8OCwbdPiFYo3jZAgzjO1Cdbr37TKU6H47spy2KoZIgkLNchkcrT
	 uDO5BwTPMN1o9JfKeembX/mwGAB6KUvsGEcTRUXTmvGt9U7PIPL78ukit4mI3a+p/U
	 LogEz13SRLBJkCj50yZ8G4DDiHNuO76633kySSV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0600/2151] leds: st1202: Cap the channel current in st1202_led_set()
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118150143.802646938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit ca81ea108502817e3841e98f0d3651398d9e1bd9 ]

st1202_led_set() writes the requested brightness straight into the 8-bit
channel current register. The LED core limits brightness to
max_brightness, which comes from the device tree max-brightness property
and has no upper bound, so on a board declaring more than 255 a
brightness of 256 reaches the register as 0 and turns the LED off, and
larger values wrap around.

Cap the value at U8_MAX, the width of the register, so anything above it
drives the channel at full current. The pattern and blink paths already
cap the current they program the same way.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB8497C60D1D2921DD0384926FC5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index aa334a7b2013b..b679c26780f0e 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -208,7 +208,8 @@ static int st1202_led_set(struct led_classdev *ldev, enum led_brightness value)
 			return ret;
 	}
 
-	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num,
+				min_t(unsigned int, value, U8_MAX));
 	if (ret)
 		return ret;
 
-- 
2.53.0



