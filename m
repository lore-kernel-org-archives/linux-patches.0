Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016801;
	b=CMpTH+WfCCyVcobDeP1rKRcQjqMG2urnep4wl56COYZcGPHh1/EogY737jfht9ZC9upL
	 spUQhbPTDLBCwXpKwCxTc3UN3ra8QeeuCV5MfY1a/DVOWQ2PVJa7rQHBuXvTtuyWpKz/c
	 +gm57mzcrcyy9gMKt+nsOLjLmpmrM2XXj1BscKNW9oh5netmtRcI0cfXRl6zhh3bGV9mJ
	 HF7E5Kirdn2s+9485de21cv0wR+3PwsY79AP9PFqhbS2x/h1t19ISeHrd2GD/thR8PGYR
	 4MYsj7d/8l5A8QqQ9oK6WlJt7RXjpkY5gWaiTOezhQdngJN07+NTOBfnQOV5ybfEUvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ShtvuQHj3yQpg30OHMdt4/ic7VUirNI0ObAyan8syUM=;
	b=LZXTDYquvYo1Zi3utb0uU5l5n01eTxkEq8PiQQSxBZ8LVxxG4ZApiw0EwhNTavO9MfvC
	 iUC5DQzSTH7Pql2e5n2ZDYR2OqrGmRHg7ccne8ePpsHBKldC4p7spHpoNI3gGcnf2L8tL
	 slPLT2KllUj/2Ygt39K4v+i/88PHOfgzbKw7Nxsa9Z+TKNw9FLM7CJxrAsfIXX86tOHkd
	 mtc6eDPNXlIHINy1gLkKqRpx1RwH0/wITe0Iq9z8jbkAeEgJfiWrDLHCrVgXQAoYSsul3
	 cWRncN0WpkJL8TR7vVBxRLf/vnr5DGlTLUe7qdjXeuSse7gAF3mUFmketsOtsB/vo/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qywIAlWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61023606A31C;
	Wed, 18 Nov 2026 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qywIAlWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B925D1F000C5;
	Wed, 18 Nov 2026 15:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016801;
	bh=ShtvuQHj3yQpg30OHMdt4/ic7VUirNI0ObAyan8syUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qywIAlWl5WnLSOwXwU88wQnMkvlA+ST88XtXS8HKeTHoBlkqp7Ybvn+nc+s+zn+4+
	 CWrFE0sTr/j/c4N9qvCbXVrNAglIJWKi3LxX6dfNocXBz0ZA9w3idlO6f+8dax1Ww6
	 z3SQBwdnHBEdIZTpUP45i3qOQueTmaXDJf7ljjBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0659/2651] leds: st1202: Honour max_brightness when blinking
Date: Wed, 18 Nov 2026 15:31:39 +0100
Message-ID: <20261118150311.600375653@linuxfoundation.org>
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

[ Upstream commit 865d81a98602c828515fa6ac3c530efc4205f9f6 ]

st1202_blink_set() drives the channel current register to U8_MAX, the
full scale of the part, regardless of the ceiling the board declared.
led_classdev_register_ext() takes max_brightness from the device tree
max-brightness property. The driver does not implement led-max-microamp,
so that is the only way a board can ask for less than 20 mA.

The brightness and pattern paths both respect it. Blinking is the one
that does not, so a board that declares a lower ceiling holds it until
something enables the timer trigger.

Program the same value the other paths use, capped at the width of the
current register so an out of range property cannot wrap it to zero.

Fixes: 35cbd34a6a05 ("leds: st1202: Add hardware-accelerated blink support")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB84979A5D536C71D319A06808C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index c4eb5ec0fc313..305452acd0df7 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -382,7 +382,8 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 	if (ret)
 		return ret;
 
-	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, U8_MAX);
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num,
+				min_t(unsigned int, led_cdev->max_brightness, U8_MAX));
 	if (ret)
 		return ret;
 
-- 
2.53.0



