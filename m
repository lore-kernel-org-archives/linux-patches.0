Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585540;
	b=nWGU213OvA70DrOrUy9+xqEwSkSHukrtpCQpzv2gCAKBJPNkSx3G3l7cBqih/t44Kj1M
	 QVsIhsmz8GrlDFelQWbqWkQnXXw20IunaNVQ0mJeMNgGgmQt6gggrspV0gTRoh5kuQqkb
	 qEMmJBqywVFyCqjY1WBBhABEiqc3IznhzcsjO9yx/6JdYUIgVjohlNhelpo+Bx0NC4Ic/
	 R3bwFVv6UHvn/f49xLtl8fvH8EOUH/pH6y7P6AzCg058ANGpvk6/KplJUe8r6D2aYpgdM
	 4PE9RxBbpTfp2s2/Hvweg7BBeqXVHt5J1VU1K32DMdos8JQ+7UUw4s4Enmtc5SC/snQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u03aTbjzxMHGmYDC8Gwkjll0gsbPSXUImC95w9YYKTw=;
	b=qJ3VrKQvhf9P6fa76Ic5ciWzPCtBF17g2l32HZdl+hkCdHCOLN14O7gJ3//rqUFrUDw/
	 DtQwZmDExTsPkS4S5XQEFPqJqylEViBbhBtOVkBmOhi91OIZ/RaZbyosXkzoxY2CMeu5M
	 A+jATZ1uuRjDWiXRXW+9CG2NibzBdfxIuur3+KpVHo3bUBL33zNG4mVkLBmimS8RoX1EM
	 v1r+PxS9GoZXz6QVdyvZfJGYF4CFcKih7jy5jo2HxgvuD2zBwZpWtBT4Oa2At8Q1djzmm
	 tzjJHk6KQ3v44IbSXRUkoDbFrr4vyMywrLpROTH9EuI2HsRBx+ukT18jyDJThqikjdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvx71wtR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2676606D466;
	Fri, 13 Nov 2026 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pvx71wtR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4B31F000C4;
	Fri, 13 Nov 2026 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585540;
	bh=u03aTbjzxMHGmYDC8Gwkjll0gsbPSXUImC95w9YYKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvx71wtRyfgqzjW1pnWOb/FQrHiCbqcBY9id8cMgJP//Afj7dxhtaiKG+I7iWL+hc
	 wzUq6A9Ze7aF09IPy1VblJ7J/mEV+EF6wuzgi/YiOjIrYHkMIUrZD2EaShwuahem3g
	 9gwOPEJ0HtnbbSIZ7EyqV89W+O0L6g8w4HjoSWvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 179/507] hwmon: chipcap2: enable IRQ processing when regulator is already enabled
Date: Fri, 13 Nov 2026 10:48:03 -0500
Message-ID: <20261113153800.545585177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d1ce827a9cc11ffdfec77b7fec9b73a8020a308d ]

cc2_enable() returns early when the regulator is already enabled.
This can happen if a previous regulator_disable() failed or if the
regulator was configured as always-on.

In this case, process_irqs remains false, causing the ready interrupt
to be ignored. Subsequent operations waiting for the ready completion
then time out.

Set process_irqs before returning when the regulator is already
enabled, so that the driver continues to process ready interrupts.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-7-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 654f6420da7ab..837b1830f2e4e 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -120,8 +120,10 @@ static int cc2_enable(struct cc2_data *data)
 	int ret;
 
 	/* exclusive regulator, check in case a disable failed */
-	if (regulator_is_enabled(data->regulator))
+	if (regulator_is_enabled(data->regulator)) {
+		data->process_irqs = true;
 		return 0;
+	}
 
 	/* clear any pending completion */
 	try_wait_for_completion(&data->complete);
-- 
2.53.0



