Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024094;
	b=PwNvg/ZK3AYXLsqwLNWW1ttjiJ9Nddr66GW9HKbJj4BKp7j+7jxh3jmonEPXO6yCCFB4
	 uy4qfKTGi3M26mdNLw2PScpKqavK+t0qLUuh8cjE4znMerAhdHZYgm4+r+38tOpT12GgP
	 b9K5g0DU7amC0gjPFEq5+VUxiVL4dr4Q+6ENV5qgMMTslZuATJsCHCHsgMFh2iwDUGpz6
	 rgAsHCUVvA1tBxcNbodqr8NcMMlaOuE7QS4p5JvWazmZ04dpeeORFP8hwinOY+t0NGAuB
	 YQTTKDCicj9LFGMvLvd+vxSOUno06kFwWz/Ibl0gTC+Pbte+YN3/whlvDsZcmgZia2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vBU80WulllO2x3+d4XC7OdGKOI89fhG3eVh9Z9d1PU=;
	b=ZNrMJfRPESy3BwkkeU1oMcHRONrOoD09qewoVLGgw7DkdbJblMczBKS0gFGxWGZb45qC
	 23HO6Gxut9Ffo541Qp6lm0W64i4ZieehFoANgAIGuv/HPHs7g9h3DL6WQtP03c3YAvRur
	 ANg7cB8J69xmvH6oJXPWBm2cGfPXQ5agUpVovpIY+cGdvnFJypapJxYMZ5yZzCQ01SeLl
	 M7DkkXIWuzYhg+3/Q3oiNCKRJS5mCpN7CVA439dwn1hnx2hdokb8qC5DhdtDLyLbYkI8i
	 92FxjrLDK456brK7BSPK3yU/xJ5u558mmdsAoprpO2dniARKB0AqpaaRWvSKw+f+Mww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiameLqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF5606A31C;
	Wed, 18 Nov 2026 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OiameLqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792291F000C4;
	Wed, 18 Nov 2026 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024094;
	bh=9vBU80WulllO2x3+d4XC7OdGKOI89fhG3eVh9Z9d1PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiameLqzpjcW7qSWu63wMfRuPWnlUNiLO15VbPqxX4QZWs74h4dSRK8t85JRCEsB5
	 lTCSbtkRslUimVMfJI/PEuhp9T1m+4m9Ogecva1at4yfIryxo+D2u+o4iVfNCPHn+Y
	 hvjjWeCuDT0DTUlnY92TLcZTtFg9xbHvRb2f3prw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0601/2151] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150143.838275793@linuxfoundation.org>
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



