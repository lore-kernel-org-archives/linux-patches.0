Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590344;
	b=gYoZR/dnpqtSATu0XiTcIfgOY2ZO8vpFUmOkjBeF2EUuUCqzdeIh7VQkEpghkbJmI2KD
	 gQFQTd5RyUjgmK41yGd/aAOyGAAPHUdeOu1TgZlknTd7gh2Y+4j/7T1/1oNu2+CdpMAT3
	 zB7LQN/R0QPhwSslZYq4TWYojP/PK59aPpl5FSapdkndHwwfxtzrNzo5OJXqMnK0yqz1S
	 2/P1FbARGRiLWnNusgIvGmpyFbtLQ+MIt93ksuwsmkA1NFi59SHNB7k/aGzsSfeyUOzEl
	 b0GJ99AiF/FkmvYuISDRB3xLReu/t0JmjXIabQ/VrPN4Tq9fdaGDjfRq6Wk1JSzkHrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wlmxAKc42sa1+Ow8xwWE6erWAcwu7RyC3TeZaLflITk=;
	b=jC/PalCZtYHQ80GlTTRcb8RvF7o2YBwAqpMXSwa+eLtC8ln/vUwGAB+nCSHoJOrWtcB3
	 89PaqynzkhnGmFPPHF+ZGKNF7Bh9aLBkSLF98s3zApDDm+a+wwUkg88sbOG4de9dvT6wm
	 OxpCmddAdDYuqbd21+0sUpVMHp9MnXTS4A1KJUn/I0J7EMB43fAPMON1nNTZ3xx6Eazkh
	 vMIwrgRYX2S2WdNG9uyPFQgKcWr4as8E6jXxCuB3owpwJ7yPmZzPIpgR+2IAmTI50eISY
	 mhOx5/7C70TuNaJQxxOOOVAzRF/3NQuPr8/ayurfpAzVNrUxS2ryOOEtqkc5Rr64kzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvJVBz5r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C603606D871;
	Fri, 13 Nov 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvJVBz5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BEC1F000C6;
	Fri, 13 Nov 2026 17:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590344;
	bh=wlmxAKc42sa1+Ow8xwWE6erWAcwu7RyC3TeZaLflITk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvJVBz5rGME/CzAIE92Pbb+m3UNdg/lU1aTumLplfknYbmKTOMwdEHtkB6OqTV10y
	 T3RIq/Ds2WW3FY2jAebOdz7/8ghjWpkBZPyGfASjNJHcHoqHYraohibpeobytWYcBE
	 l3V/A9PloceXUYMszo51PDjAGJEGDYgmMXXbAyPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Jack Doan <me@jackdoan.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/686] hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices
Date: Fri, 13 Nov 2026 10:46:52 -0500
Message-ID: <20261113153830.444387154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b7743c6dbe3ab94045164ef298f65cfb9b0b450a ]

When a USB HID device matching USB_PRODUCT_ID_AQUAERO presents a
malformed report descriptor, an out-of-bounds array access occurs in
aqc_probe() due to an unchecked index into the parsed collections array.
During device initialization, the driver distinguishes between the
multiple logical interfaces exposed by the Aquaero device by evaluating
the type of the second element in the collection array. The driver
unconditionally accesses hdev->collection[1] without verifying that
hdev->maxcollection is greater than 1. Because the collection array is
dynamically allocated by the HID core based on the number of collections
found in the report descriptor, a crafted device exposing fewer than two
collections causes an immediate heap out-of-bounds read or NULL pointer
dereference. This leads to a kernel panic during the device probe phase.

Add the missing check to fix the problem.

Fixes: 2c55211104b4 ("hwmon: (aquacomputer_d5next) Support sensors for Aquacomputer Aquaero")
Cc: stable@vger.kernel.org
Cc: Aleksa Savic <savicaleksa83@gmail.com>
Cc: Jack Doan <me@jackdoan.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 1f0e71d3b52e4..e0052ba4702c6 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -1593,7 +1593,7 @@ static int aqc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		 * they present. The two other devices have the type of the second element in
 		 * their respective collections set to 1, while the real device has it set to 0.
 		 */
-		if (hdev->collection[1].type != 0) {
+		if (hdev->maxcollection < 2 || hdev->collection[1].type != 0) {
 			ret = -ENODEV;
 			goto fail_and_close;
 		}
-- 
2.53.0



