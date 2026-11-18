Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016807;
	b=L4k7ymTl8VXmjYZbCYg9YGcYCFaLN+/wSbvEj0UcpdM6e5Ic80+ALnkMIeul+HqV5BlQ
	 hqVVVbPkdW11uSUk/dTR+wrvJ6Q8gLXBItt3Wop8zg3Mb5KN9P6c8kDSHUfVXqrCApHAT
	 LdTebZCwg0FXf6yMrnA/CJpGrDG9TYX+3C93QhYGquA8Ct4r4FqzLlUohW4Eee4nbomac
	 C946K9HEF81+AsJeMq0eH9Df7zwdnn5p+OmnIvumC5yFLwrFxof8iXbA59mYBLakOBrd5
	 riztcgDuSaepfJAbLXZBnELfANnxtWZtwrSDz9LfjTUoxqi9ESlKN5LT24gi2LgdGiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0nGKjeTpkfpP//h5fD/YwM6+vhVcWWd7pzwDKB/f7A=;
	b=0rP3kMxzwkDr3axQcvG7fBNAcswgUAE1kTFKZjJN7M5XMEfbZ6+tM9SVYYmIziAdeOea
	 ilAFUb1WS2DtV5BO8JCfPvv6DzZFMDdETXpXRC6iuIQbDdaSYvCOyUGZMhbMhzSjvpS0Z
	 mzMtmab9ruUC4e9CwAAsmdBo+FjO0ZEKKoFxA4YwMauM2Leg3lWPZW4bblTjwTzqvdfCg
	 lOUIqz4ex3zxxmiHSNsta7FhFJDg2o7t/9cvqYbppchHgJyFIInwtFPfFDPvaBLcCYtjA
	 Ug1gdT6IjNnNjrQ3E3PD5mVKJTsypVd7vdK+Z7BgBTNni+s0trgz7QbM0YWkaJAbCGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfNOBkLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B3606A31C;
	Wed, 18 Nov 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfNOBkLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D92F1F000C5;
	Wed, 18 Nov 2026 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016806;
	bh=j0nGKjeTpkfpP//h5fD/YwM6+vhVcWWd7pzwDKB/f7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfNOBkLkAkQs0/iD1aO954IlJ4g2mt/diPnz0hnRZoUDMPK45I5ll0hJ4BTiBh/6v
	 Pcnl9U8pzjpSHS/dK7X6d6OUjcMnTm/yi7cSkCxjnk3EMpukCuHOcJzhN4jKrlq/rh
	 juUpHP0hQm6CWXcl5YvlQaC34XyW6Up7rJheiXSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0661/2651] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:31:41 +0100
Message-ID: <20261118150311.672142289@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d229695f2162a41bfa614f175798fa56a5f1c969 ]

In flash_fault_show(), address of uninitialized 'fault' variable is
passed to device-specific .fault_get callbacks. This is not a problem
if such a callback directly assigns the value like rt4505_fault_get(),
but results in an undefined behavior if callback just performs bitwise
ORs like as3645a_get_fault(). So just initialize 'fault' with zero.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260904054437.461706-1-dmantipov@yandex.ru?part=1
Fixes: 7aea8389a77ab ("leds: Add LED Flash class extension to the LED subsystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20260916161607.90106-1-dmantipov@yandex.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 165035a8826ca..3bb90823de1a8 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -187,7 +187,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



