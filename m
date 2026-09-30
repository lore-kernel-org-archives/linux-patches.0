Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FF151DB19;
	Wed, 30 Sep 2026 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794076; cv=none; b=XfEX4OnP748h5gI/gMOLGAMBLp9/59SS1f/DlshnYJDxr/PbD2xwHDaXzPXtFPJ4Qgi+WA2CdIaNm4Nwnxr/Kclc75KZ4I3Rn/0A4xLcynl9rujRcz5rHwdysHaYvsPEYAUs2fJo6Xph82v9pRVuzBKEg8gK1h/ZKjORhbc5/EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794076; c=relaxed/simple;
	bh=xNsSysLrnH5g2N/8vOH5LAe5ubj821gcKLMepwmwYBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXGdYF8p1S2hayFNzDDsYQ9UdzMWPtXAaRssKwMY2k86vq8NeI9Wx8G4t71B2AonTqBsSQ7ypeyHJKCBpJk0rJWdbfJGw2b6UmKDHDIcVuBLjC1thrsYoSrWOOW0w4S7w6brWLt2fy8i01qpIUq8Epo7KbuLkvIAXjLFmHlo2jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLZQKY2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLZQKY2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4790F1F000FF;
	Wed, 30 Sep 2026 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794074;
	bh=UDOyFy6YInScH7/f50RGPwpdg0VlC3lh+JuBprNKGlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLZQKY2SSN2S0jecKqvkamQGW0I6i3cRxiK6QV0YoQisWRzBE/ge4X5gGwnRhkMMM
	 CXLAjqB6HcNPSzwHaSphX4cegj/9oWrNGMb+RJzoJPFIjMHnbebXkBQ3pb+LEg+kdR
	 FPO1HlHQkhDslGW0eNhwK9ZO2Ju1LKFCxj5D+Q+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0056/1193] crypto: atmel-ecc - add support for atecc608b
Date: Wed, 30 Sep 2026 17:12:20 +0200
Message-ID: <20260930152435.524929304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



