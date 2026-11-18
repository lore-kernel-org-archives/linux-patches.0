Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022487;
	b=cg4PJfkDKtT8Db9rU/ThOccR6LL1UJBX2BESl9n/ge78fxXXjqmeODzzCzsjfA1PUGid
	 MQL7GuzLX3KZFE2mtiP74kRfPPtqrAgYDpgToswzUAqzoFvMsSQYF2ZpVi65RWpskrCE1
	 QcZAMm9hLqXhc0m+BmV0coV75js8lfxSrdNsPrrPJ9H7WFEN8IwiMExI9OLmtPgdJKAHi
	 wznrha0o2SNVcbq1ga4oMdn+m+yn4BND5d4SUETN0DJ9ID++VjrAUDTnKYs/uIZWggel9
	 dtLOMNg5ZceqOLLybBpXKbxlIbsdhfbBRAdnyVLoLr8IV4KwfnoEB3mj/4lEN8QdOmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TrVN0la+fJTpsZiNf9V0UOTIFsqIJ96Y86rTl28Elj4=;
	b=KDEidcQi1F6Fz/14ZuO9/geEXU7WWpZLP5uocd0qtrCTrA3Il/o7F8+wL4dyXydY4z3J
	 Vusm1sXm1afhy0m2qEP4FHk6LZy2KJ0/tt16cRlp/CILECjDD2snnsEFf7TS2Q6ek24Ni
	 wnUcZknyVQ9efgGlycP+zVzluPAQkaap+9eIa0utcwUTdG7hEUTxSTTvGimmXS/SDcQwk
	 cQIAIRa3bSlfV9Bt27DgGuOiOFkBcfejK+NQpXRJ1c0x1VETVUSRYqL9uuw3tr48vNV5f
	 CuWoBWXhzHN8DPycpm0EQ1hGQzW5dwY8saCy6PlURfgnuNJhWLZiBzapKMihkGKmP8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqfaCoUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80A2606A331;
	Wed, 18 Nov 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqfaCoUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D141F000C6;
	Wed, 18 Nov 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022486;
	bh=TrVN0la+fJTpsZiNf9V0UOTIFsqIJ96Y86rTl28Elj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqfaCoUZvbMAQtLJEDYBRkW2UsdXTaLd18VYOLZJK8rVuswnPBHvZw5Mfxu+lfMJC
	 SvUfAxUmm4Ne3RPhFxaSJXbC1+u7FqJgUIUQsGdgtjdCZ6nBgnAUL7i0nRHbNgO5lv
	 TUIhIjwz0E89CMJ6iFe0cY30piNzuXE8gR6S2FO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0030/2151] hwmon: chipcap2: disable device after hwmon teardown
Date: Wed, 18 Nov 2026 15:29:25 +0100
Message-ID: <20261118150122.753369099@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 4724ac5556ce63f01a3f5d61fc7fcc20f4ddef3f ]

cc2_remove() disables the device while the device-managed hwmon device is
still registered. A concurrent sysfs callback can then enable the device
after it has been disabled during removal.

Register a device-managed disable action before registering the hwmon
device, so devres unregisters the hwmon device before disabling the
physical device.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-6-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 8ba706ecd4012..6026514a763d1 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -167,6 +167,11 @@ static void cc2_disable(struct cc2_data *data)
 	data->regulator_enabled = false;
 }
 
+static void cc2_disable_action(void *data)
+{
+	cc2_disable(data);
+}
+
 static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 {
 	int resp;
@@ -720,6 +725,10 @@ static int cc2_probe(struct i2c_client *client)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to get IRQs\n");
 
+	ret = devm_add_action_or_reset(dev, cc2_disable_action, data);
+	if (ret)
+		return ret;
+
 	ret = cc2_request_data_ready(data, dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
@@ -754,13 +763,6 @@ static int cc2_probe(struct i2c_client *client)
 	return 0;
 }
 
-static void cc2_remove(struct i2c_client *client)
-{
-	struct cc2_data *data = i2c_get_clientdata(client);
-
-	cc2_disable(data);
-}
-
 static const struct i2c_device_id cc2_id[] = {
 	{ "cc2d23" },
 	{ "cc2d23s" },
@@ -793,7 +795,6 @@ static struct i2c_driver cc2_driver = {
 		.of_match_table = cc2_of_match,
 	},
 	.probe		= cc2_probe,
-	.remove		= cc2_remove,
 	.id_table = cc2_id,
 };
 module_i2c_driver(cc2_driver);
-- 
2.53.0



