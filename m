Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046337;
	b=3n35d7F3fc83an6MTiRd27Z2LIDITmahX6RFqO4VIE+DfPoV4273yaOEsUWXdwW32s2S
	 z5ThizZxZz6U4CGjzKbMfCz48ym/dU/MYRNUX46K6SxDHL3ZoLhikBkKYABXzgcxugZHn
	 rX4irBBZoQlw3Nib7LusXmgvxTjxD/yQyZr0tCnmjdSxHLspeEKP0ESXCWobYv29lEOT5
	 LdSVQjYr7xlnUI5IA5J0wJRGyE3iGbztosdmTxHDOeL1fUCaggj43hlG7vZ4jPO4m+NWw
	 QUnlnTvevwEjqpSxQAaw2zk5uAAD19BZwclaHExOtCKcY5A9j02/qMn7DKRe1VMsHdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=drLRx7xkz+M12rafK+5lprHjWrm1sLsH4t+wUp5ZF2s=;
	b=Jmt8+8ByeA9rdFqX132F2wkW5dNL8kBDcMfP9BZifGsUbSkFB/rPUI+AVPdnammx6OQK
	 GVK5ORwPbT2u6WmCxCKSipRxtfhrkp9dV5fWbJltUmyZgyEyxiOV+n5ZymNKjkaqR2CSW
	 AseQa1hqwVP65gqz+fac2q92Nk0a/CdhDEUhiyes6JD+QyXycyF85wPyYAhkM0CyMDwJm
	 iJji5yxm7d0j0yH5oxbKbpUB2Jk8Jd8YKCz3KKntLmK+rXH2tSwfPlcyaHnxWWGIw6iA5
	 Lp1r5HY6+7Zoq8U5RCWzEzCVtscN2FSv0F0D8uR3X0BR4oYRI2xyd/yYNSaNWVyYuxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixMb1ZKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6D4606A320;
	Wed, 18 Nov 2026 23:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixMb1ZKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AF41F000C4;
	Wed, 18 Nov 2026 23:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046336;
	bh=drLRx7xkz+M12rafK+5lprHjWrm1sLsH4t+wUp5ZF2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixMb1ZKLFB4wNrievp2CKmVxgcCh57QoWVRsyZCQ5D3cJQLPyXToSIWyxq8b4ByWC
	 HtXdO2wEfmkTQ94AGZP6NSN7KXhJqfExPVU6FgkzdREHshr5xL6rg/SaE7sxnsyi8k
	 yGgYNU0Y9MdpvDOC4MXCvPbZxLBFd2kqOlyc9Ky4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1243/2857] hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error
Date: Wed, 18 Nov 2026 15:37:57 +0100
Message-ID: <20261118150246.304089201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 44e4d47372a6f..fd7d353e99762 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1328,8 +1328,10 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



