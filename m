Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016804;
	b=PJE8Q4+xL2EjpKeGfAIdSo88uUz4wRDC5U2eKf6BffJ1DJ4kscobGcEQroA/D6JxCWw/
	 Tocwzzgzn0B852Uy0px6GTVNydqnowaSLvMNfexHvPHmL0pe+xYLgFLSijO3eIp5ndvFm
	 qJRJE8kGhV2dftn9CiJ3dZ4+fpDgpWf1+YsHcERXA/2pKqRqsbR0WglqtkAzrXpe1IKXe
	 M7OOC1ltGM5ZPnXoZJeJbAL2u5WxEF5aHHmirqxGssypafraCD+2TpI54UTa737B3HV0y
	 c0x67nf1W+KtC0XFqwQqq0pGMq4S8qqm6q/BIbRBkgRdUooapxP/jGl6bc6t3p+psRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3/aVCDuPdZMAnCG9W5k/ZoEXoyLPvaCWbCtdb+6qIA=;
	b=B3sUDFAzgBgM5xSSiLqiFrHSZUjutvawfotLMMGoPgVgt+/e+vQftS5Ajz3WM52u2JwU
	 v7tjxCCcQRGyMbQ0awfcBUgrB9UBcRPQVW6F88FCO5a/OU0Gm/9aqvAlozsZj1ZbIRGM2
	 ByTJjyWxCcBcg5gvDbl7hLLlmm6dORwQV1Qdoy8ZkevA/P+7BzKvsXPnC4fYwDGGn8yFI
	 M9KbYfXfREnNGN9oWg9vBYLAkvi4FEN+GnDuN3XeptJkMxMZWw5GHOghh4ynVwajAR0ZI
	 W4AW+xHFB4EPvYNHw6I9HAKfBTwC2e5wuAwrERtQmU9QEfwLRGm7GjA4DrzODNxl/gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smtydTTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E27606A31C;
	Wed, 18 Nov 2026 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=smtydTTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FF51F000C4;
	Wed, 18 Nov 2026 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016804;
	bh=Y3/aVCDuPdZMAnCG9W5k/ZoEXoyLPvaCWbCtdb+6qIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smtydTTBGrWIciL8iFSS/KNlk9+oP8ZKyg5qDg02RDRX2p6RkMN9N7XAzTp8gsX+E
	 Ncc4HfJpwTa+L5nWrWnqf9yyCj/Z5Mt0wohfsTpBcvvmLzXRH0lJKNdySnlEoBZdpX
	 u4Z0NSDrWsY62p+xB6e73M7A1u6kDnt/LAjs8X7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0660/2651] leds: st1202: Cap the channel current in st1202_led_set()
Date: Wed, 18 Nov 2026 15:31:40 +0100
Message-ID: <20261118150311.636994800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 305452acd0df7..2d34f9d06f607 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -207,7 +207,8 @@ static int st1202_led_set(struct led_classdev *ldev, enum led_brightness value)
 			return ret;
 	}
 
-	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num,
+				min_t(unsigned int, value, U8_MAX));
 	if (ret)
 		return ret;
 
-- 
2.53.0



