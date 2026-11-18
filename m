Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037635;
	b=n1vENUfqmMBCQLn5YECRwrdEkpyPqLx9pAZxzo4rIKJi6Zyf4HHCCzycPaPrlxYNJWUg
	 n07VkSJ4ri37o/3oi7tZyiSgYAuFbu2QavHR7ZdrZ2KTnKRRm4QfYoNE6hDHUiqKbJzhn
	 Cz0nTrBknHQbcF3cm0VNVurEBVFl6RZJCVD4M26/JTz/RucBjVDKKsJ2Riaa8OsBVpnmv
	 fnQmuawqRZ1mKbrYiaA2EaQpTA97xDSHlIOYlrD/zRnt8ZrotQZwupPG5OMb7A5tK9RA0
	 C4+KHV+vHQM6IM1tOWmV4Oxp+xPtXqpHNt6hLOybBrXtQMa9PvsPLSLHGPuOVmbnC3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6VR3eY8kspZ0p7t1azwb6R1sBy6RgPIM6IwKCgAlyYs=;
	b=I50Kmtg3ts4YiqHOR8oYDFiyMTE9QVWNtyHrqKqXqihmcnslMyzkDMSL/BUbpempTz+5
	 cEyYF1mpknEJ7H0yv9fk/AVBOZfj9I5XlBLB9ZFTjkn/5neKj+g8RGK6VYUupfAGnVQ6b
	 dadv6cwywZhbEULGcMqcmwLFkuqFCeOBtrN3K07zFFMvN3qvnNm31fFNMosWtbjJRyiBm
	 R9PtBPY75aJWACn1P6zBVM1TbR/eP0tn1clTMwD+6lKsJuV6OwI65jLj4BVrmksRtOkaK
	 gQNNfY9F1LVdQGoN+m4TcViTy8iKj0vai2tNlip3dIzQ/3I9ekJsbygMVQD8BlpnyVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkxjtk+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D55606A31C;
	Wed, 18 Nov 2026 21:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkxjtk+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4D41F000C4;
	Wed, 18 Nov 2026 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037635;
	bh=6VR3eY8kspZ0p7t1azwb6R1sBy6RgPIM6IwKCgAlyYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wkxjtk+4JJ1mwlTaTHE6GkqX2N0bWlOGcFgjWJ7f2SaGn7Rt6EbVXUE02TKa238Sm
	 p/Ne1l/kAxXnU2Kvssxx5vdfYAVLBi0toFq9fJ7/CAPEddvW/d2qxy0RWR7Ssr/3sL
	 AzonYZiOUYZW6JAJmOidR+gfVi+jJaBz3YkH2F0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1464/3318] hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118150404.812751049@linuxfoundation.org>
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
index 45720413e4099..4212fbd63e7bd 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1355,8 +1355,10 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



