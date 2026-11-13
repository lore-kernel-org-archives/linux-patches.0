Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590301;
	b=u0mN72varN4/6emO+T2GC7tgjUHfAPKRF2vg7it6i6INghEA/NZyVG1phTrfE8x2AgB0
	 kkNidq9tTUwOcBHzdIacnfu2LRgGjoGipx4BD6Zx9cZmC3pwKYguWoOv/3KqP3agtmUbE
	 UIcaWujFnskM8GFnWh4EwDdvVhuXAog2b2zyVV6SOpqPuZUYPUo1xskwfwPb8JeNhHgup
	 bAOrqW1xkv7Lh4lKrln+kKz6BMWQs/kB6ak/KXwSZKy0z827KLPy+ZvL9YTNRcQkNgnMy
	 zpyfl7x6KAqX8nWfcknbDI10tdKyopy1jgcNbSKrUPNuenAXkMhwvhGMnhjwoL/SDAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vScNuDu10gBEMaYsTRddlkU8HytzlXXJ1NGzeq6X+R0=;
	b=o9foXL+rPsqaIhk/jrlPQt63RtHn6qoMJzrB2MxPKTWb1Ur6H8I371JESP3XadN9Ivty
	 uoO2LD71tr+/B8ba3kZEj2o1yvNdDpCMuNLwz8Xg5v8ZBs0kxISlFE4YbkDuGu0hb7Ojt
	 kALcRmF244DmPen7UzawXjudsV/1qHer3vqOxqRSaIStkEbEZ0Flv6fxHC4L47PRrqseH
	 UaEbmrN8+s2969okbHgChP5fzZZ2j0FAUZUYRrM5bhSSHZB4XWJbOfnfajhIDrAO0OvhM
	 3kpKeYUhFAOU2E2S4dccIkBjqQaxEUb8ZSCBPapFYy6ko8ye+vwICfeqJv5fe0m263g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Spu/8RIW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F3E60A5BE6;
	Fri, 13 Nov 2026 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Spu/8RIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF91B1F000C9;
	Fri, 13 Nov 2026 17:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590301;
	bh=vScNuDu10gBEMaYsTRddlkU8HytzlXXJ1NGzeq6X+R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Spu/8RIW2jgxsjrmiQHNdlTRXJVoeJ7lJ16C1Mhc3YHfAd9aYX5EY6c1MbE9gilJ8
	 y6zijlhRuziPYLFs1/P+mxCZL35ksktEq8xtqBF/LfX4tZfu7ZaimrvxHXqkoo1p9B
	 eKmbyPP4w4jTOzNWMrvyQDZZUzscB1LjLG+vRYrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/686] hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error
Date: Fri, 13 Nov 2026 10:47:01 -0500
Message-ID: <20261113153830.741966238@linuxfoundation.org>
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
index 08702ee8105f4..3f310c8e97012 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1404,8 +1404,10 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



