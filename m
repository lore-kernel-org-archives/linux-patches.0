Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585610;
	b=EXQutwzsT/U6MpUgPwwgiT4J8rpj+JjIWbNRv5mw6M16vow1aRRbEXMzmyH3yMOkSiT7
	 L0dfafdrYIvq4lua3urHE2YTpsqOt8kuhFsXvruaGFBuPPiiQ+m77z1dwIZRUpYlg2eSU
	 oUBt9s67ikJgcm6WaboUBxaqXu2DaHf4jELaGxzzb42E571+G7+IsN/K4Q6GXjQsIe0ko
	 f21Eq98c7Y/wC9IBRy5GOx2NYuPQEFMo/WcTj0AhxUaxq4RMW85dJ6ggmlVOy53pLFfBB
	 poTkYi66BWbmrwL4jTZdqsMvnfAus/AW6VE0E4aA4PNdljvIZdGz5OkBDFb5xVEpuqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKyKH3whUHxi63PzNDbLw1dQMNGcjKV/wHWVJoVTBKI=;
	b=WwXgJtDVG1ajdfNpR3SYtbxzJ3+FDxnHN8CN2joPQHPz53/jQkSM9rH56zMzTd9LgERL
	 qnjKavwuP09h404FkR0gO1zMcaxaWeRWqsq8cOip3OCSXRHsR0g2DHVnP32P45iVsUmF2
	 DmSpG+t76p21LSFzAVozsa1c3aXmcuxRD00+y2lZhl70M50fRibOcox0QjpnVkD5mmcCO
	 tIG9GcmgTbVKpYvHS4PGB4eKii2Q4u0wppSdBXCtMqEPXpCr2T8/DWKE1z6nk0EK8l/sX
	 1jIs3YWfAztwgk1z8Ulmy4OfWj/Rhk7SOIe+d8zS6VFPewTQ54d3rHiSf7VQ4CMO4Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WYF/76qx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D16070221;
	Fri, 13 Nov 2026 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYF/76qx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6402B1F000C5;
	Fri, 13 Nov 2026 16:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585610;
	bh=XKyKH3whUHxi63PzNDbLw1dQMNGcjKV/wHWVJoVTBKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYF/76qxqpDnw9Y8o9KOpc4163d0xeqovf7q0HpLh1CRlWgrj/YhjC1zYIyoQoSnK
	 bB8N2DCU5oGX1R1mbr/qOrtR8GlhGvw3aw//A7v+zpvfgjxxdpzGfcv/RVWrNaaTKx
	 RS6RmpcH9CHeIbQVuVHPsolHnyBBpCN3em+G94QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 193/507] hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error
Date: Fri, 13 Nov 2026 10:48:17 -0500
Message-ID: <20261113153801.037624334@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9aa6cc563e881c3cad96ea36926cadceee151f32 ]

In pmbus_thermal_add_sensor(), a devres memory leak occurs when a PMBus
temperature sensor is initialized but no thermal zone is configured for
it.
The function allocates a pmbus_thermal_data structure using
devm_kzalloc(). It then attempts to register the sensor with the thermal
subsystem via devm_thermal_of_zone_register(). If this registration
returns -ENODEV (e.g., when no thermal zone is mapped in the Device Tree
or CONFIG_THERMAL_OF is disabled), the function intentionally catches the
error and returns 0 to allow device probing to continue.

Because devm_kfree() is not called on the -ENODEV path, the unused tdata
structure remains allocated on the device's managed resource list. Since
most PMBus temperature sensors are not attached to thermal zones, this
results in an accumulation of unused objects that needlessly consume kernel
memory for the lifetime of the PMBus device.

Add the missing call to devm_kfree() to fix the problem.

Fixes: 3aa74796cfd0 ("hwmon: (pmbus) Register with thermal for PSC_TEMPERATURE")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index ba1ce0dccfc1a..5534717ba5f7a 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1510,8 +1510,10 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
 	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
 	 * so ignore that error but forward any other error.
 	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV))
+	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV)) {
+		devm_kfree(dev, tdata);
 		return PTR_ERR(tzd);
+	}
 
 	return 0;
 }
-- 
2.53.0



