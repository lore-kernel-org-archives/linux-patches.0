Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B7501292;
	Thu, 17 Sep 2026 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661357; cv=none; b=hR8qCxet9LlgUY+mIyAlCDUpUTGubQstVf6w0eAjU9aC/k7vgENKV7Lo4nVeNfApBOknCHu2NhPdF5Mo0ueYGgeefUOpSFSMzWk+Gfr6oV8JO6Jx55n1YTQ/sX2QFDwXSs9OaKUzBbb84fmUbPjDD3NZsoahq/Q00utMda7lzIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661357; c=relaxed/simple;
	bh=DCdFvx8kdagXsna5GhssK9+zXi6O9WkJYJMAjjZtV2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5Wie+YfPcPFbH3hADBwFjJwFF7m9VKyLjh4Od0MN88R917AaXN9TjIwzN2WWe4hJKERdQ49NCt/AllEH1HsD/m/Rii35kdF8iSfQUoEY7KjycLj/ohBlz/2uargIjk8oNdNa9cyuygfzjgKkp7IWEkkAY4PPQBpUbcXBH0VpPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNl/fTy6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNl/fTy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54BB1F00893;
	Thu, 17 Sep 2026 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661356;
	bh=8PMRJiwj/6xUFQNir6Cjiz4qKDma9TRRw4jDEx6Knuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNl/fTy6fecAQKaYr+J0R7NTn+70yXBF2lsax8vj9YMQFgk10sj8AwUBEq5M74ITi
	 tcM06yrZ/sLEBF0sX4eFoeYahUoMBhs3axiSwXMhqnSpxxdsqDnum52BOGUOLyw75f
	 uN7gFKrW49F1q1RLl0rmTSBi+PSFG5uvtz/1qTSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0122/1250] crypto: atmel-ecc - add support for atecc608b
Date: Thu, 17 Sep 2026 15:58:37 +0100
Message-ID: <20260917151555.327654156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 93e3513541c7d..3f384eb694f58 100644
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



