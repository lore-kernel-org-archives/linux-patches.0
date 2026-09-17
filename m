Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FED33DDAF6;
	Thu, 17 Sep 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667472; cv=none; b=cOvMBG6rp5lZZy0AcN/bcHHMsDYZUTWwVaGolOZIaRAp58E3tg8xyf1V3Cp8RFU62a2pFgA81i+gutmG9bMOyVkO4l8ma6EmuN8KdNs79t+I+quFqMXn2+PB5X0oJfVTRpZdMxcdd1v3gIWGcK8qcWSRFbKab3QjJMtA6B0VccA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667472; c=relaxed/simple;
	bh=QEB9teKbsQS4JtdC22N9RE4dDXRyZ5NnaifCxulxKUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXWtC1Tj8frkTcG94hB/bcWyUdqLUkcZ7SeK3Bp9tF9/3BYX409qjCH5FoVUdH1eV1+LgPaJ/QVIK5zQMTmmyieQ80Gin8Fuz/ts8vdIaGEGd4U5FSzsts40IDU+F96+n0aktO3hrw6dmQBDCgLPXxe+L1aNDSW7d0yTH/XkE8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+z6+qEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+z6+qEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591441F000FF;
	Thu, 17 Sep 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667470;
	bh=oVyl5u/LFcZMF0dFg/LA/AFVlHkBnqiKHmPaEt8pDO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+z6+qEJPO6iUIs43NdH91oUN0r63AEOSKfSyQJNPsO+YsLqLPKBX9vSHZzW1A10F
	 CIar2Z8Ft8WfxgxRTYfo9ZBIXkrKGbWqfj2s+H6Pm9YbS6khTL3YOvE5Gzq+mNGp4N
	 ho0gY4di6Xm4ziGBX2AU1OIXSpNWO2+36do0MF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0087/1102] crypto: atmel-ecc - add support for atecc608b
Date: Thu, 17 Sep 2026 16:00:30 +0100
Message-ID: <20260917151541.662274021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b668edaf8dcc8d09f6f1e71797422b44d4bd22a3 ]

Tested on hardware with an ATECC608B at 0x60. The device binds
successfully, passes the driver's sanity check, and registers the
ecdh-nist-p256 KPP algorithm.

The hardware ECDH path was also exercised using a minimal KPP test
module, covering private key generation, public key derivation, and
shared secret computation.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index c64431380d303..9a4b8fa9ef7de 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -365,6 +365,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 static const struct of_device_id atmel_ecc_dt_ids[] = {
 	{
 		.compatible = "atmel,atecc508a",
+	}, {
+		.compatible = "atmel,atecc608b",
 	}, {
 		/* sentinel */
 	}
@@ -374,6 +376,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 
 static const struct i2c_device_id atmel_ecc_id[] = {
 	{ "atecc508a" },
+	{ "atecc608b" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
-- 
2.53.0



