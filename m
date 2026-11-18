Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033516;
	b=onavsFtgyckQdBYMs4rEVRerIBQqe+N0qzd6NTHM+ER844S+TXjefikHgTMOuzuF6H1j
	 jA8/991NA6ntFkIHZRwVfuXLZmRQYda+SMlogWJ0D4dOE+hSfAs/8QfDjv1noem6sWj5t
	 aI3MCrNRCrB2PBdckG+aAZXJoBLKpYwZmrHNYjVB/U8DhsYlCRSSiStYeKhJIoxWjjoZt
	 /ikA94bFd0yxFuKUczpg8MgNRYJBHpXhdtkazTfehWE2GEF/lO702R+evt8N84iux1vvo
	 UpjsoHUJwQVpOEwQpdP2I9kZ16otw4HE9TK7Ej4y5evjvGeeI2U2SHyKQtvmOkc4GXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L81afZFa+zSEDRWfTVwUTQ7lMhCsp6oY3hLSnDF00uw=;
	b=kpjmtbEXKsq+qupJD0NUzjXY9bT2ni7X2kju+SxIVc47/BEnu5NYtOCeA42+qGxG8Wie
	 /9SjmH5ejmfV2giN3MNGunlc4I48241CRem5FSgNmoOoN1SnKduUWWIt7m2P3FuPsa+cJ
	 r7ToA70OJNFeQXi52bSVPLZ988VAPou6rIWVHIsqrYYxkXO18AbhICP3rbIGTQDhMBloH
	 mWd/lYxRCdqF2vy1Hd9Um75BlcrEBmUCRxhm0BB1BwU3r4Gd/kI7wsvsBaTmsqL8IV1cO
	 guMJQvs5heyHrmjIWFcRrzc97fHugRqESpdU7CKiomzPLWTFyahUuCVHqPtkP0YOBRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sO9F+Wl8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37039606A31C;
	Wed, 18 Nov 2026 20:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sO9F+Wl8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13E1F000C4;
	Wed, 18 Nov 2026 20:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033516;
	bh=L81afZFa+zSEDRWfTVwUTQ7lMhCsp6oY3hLSnDF00uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sO9F+Wl8wrSnWEZcIVZCx9dtE3nVgIo9Tm7IbaSn7fZP+RGEZ+ByIllWmBrYnviNG
	 IIOwNtCSv7DHg1oMuMP/Ax/yz/I0BFWa6iPJAlv7s4eUGri3fFGkoxDiro1E/LrM1U
	 o/+ljkfS772Zr/LCeWFrOyTAupuNVMnAOMxddpNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0043/3318] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Wed, 18 Nov 2026 15:11:05 +0100
Message-ID: <20261118150315.168060768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhijeeth Babu <babu.jeeth@gmail.com>

[ Upstream commit 9e9762e578db7556bea644bb5a8a2435f63544d1 ]

The ELAN1300 touchpad with HID ID 04F3:3104 on the ASUS VivoBook
X513UA_KM513UA exhibits severe pointer jumps and erratic movement when
the I2C bus operates at 400 kHz.

The system DSDT describes the touchpad using an I2cSerialBusV2 resource
with a speed of 0x00061A80, corresponding to 400 kHz, on the
AMDI0010:03 controller.

At this speed, libinput repeatedly reports:

kernel bug: Touch jump detected and discarded

Add ELAN1300 to i2c_acpi_force_100khz_device_ids so that it operates at
100 kHz.

Before the change, nine touch-jump events were recorded, with additional
messages suppressed by libinput's rate limiter. With the bus forced to
100 kHz, no touch-jump events have been observed and the touchpad operates
normally.

The affected system uses BIOS X513UA.319 dated 2023-05-09.

Signed-off-by: Abhijeeth Babu <babu.jeeth@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260617192611.125513-1-babu.jeeth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index f43067f6797e9..b74f41b9515ae 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -372,6 +372,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 */
 	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
+	{ "ELAN1300", 0 },
 	{}
 };
 
-- 
2.53.0



