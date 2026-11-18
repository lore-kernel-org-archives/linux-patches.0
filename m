Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046893;
	b=hA/X5u6kUEd+Y3p7uW5RrF+eMcJLeOmmtEWCVRSu9iWZyyphqAGr5ob+aSXngpSakN78
	 udYju90H88SIBSoNxe9E3SGQ2wwbanb6/Am2KO09z2ILgXQWfeu7ej9Y56yIBsodh+uEs
	 shziQbb3KcnD302BJvSPyEy5HfgyAxwTT4i9L3jt90nti457CmerFYgdThZEqtRD9H9Qg
	 DcD84X6xumjku0tjDJX5M1j2iQKxnrxmctsX/fVD8j7WUnfaNOMdwrL3abXlEPtNbF/EO
	 88UOY1zbJyVPHlRkTeb0u8N9V2MWo3HCWubkVRXae4mYT6O0P2UJlB+hgE+VAUa5Pyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhSaIfC0LdERxy6AMMKwA3f30Gq1AihELmN5NVRfZLQ=;
	b=S72IJ4c5s5w7Vwmo+7awl7JAlw0ivb/Pir6sc9sPuSCiDtRvWPtRy2W4vCVHPIDPTWt/
	 6mZ5y6Rw42cqcYHqlLV2qLw7yKPmr0byIi/Xxq6RFGByt264CBn1koCvp094AfbCPHBX1
	 gzdf/kytdYtYSi0leYpWdO5skDaEEz06D3CtRMMCTOK10ef9vfdDeY7LnMCBQEAwq8RM1
	 9ZTGzoMluCgnQQPBUgZnOaglAtyaOTIpHtCL8f//17UI0X9BZS6ElZfLCBDxgeaMMAX7z
	 Y5O7Jyo/MIuwOksRFm3f5H6QvUGLk6SSiNL4CHwQuvizuWDxAAc0OwRiNE4yv66z1Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuwoL9Sh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4CD606A31C;
	Thu, 19 Nov 2026 00:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuwoL9Sh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19031F000C4;
	Thu, 19 Nov 2026 00:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046893;
	bh=YhSaIfC0LdERxy6AMMKwA3f30Gq1AihELmN5NVRfZLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuwoL9ShZPGuwP14rh/CmwzESUUPQuHvC8fs4GZECElzKtJi5qzGQJCdjlOx/z4RX
	 nJojubYzAdY0U/4yLHWu7u/dpS96fOF2iVVDHqr824VpmLK30iI4wygRze9vWbEmAM
	 EHIgULxt2LElkBrNHCXHwyqkj08PobSS6PO59GQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1444/2857] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Wed, 18 Nov 2026 15:41:18 +0100
Message-ID: <20261118150253.305342903@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 7ee4fa2674e51a0d100b9240cd8a50355141362f ]

i2c_check_functionality() returns a boolean status rather than an error
code - directly use it as a boolean value.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260505114543.159381-2-thorsten.blum@linux.dev
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 3c5c55d979dd ("mfd: twl-core: Unregister the auxiliary platform device on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index f6b4b9d94bbd3..6c589d71df2a9 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -786,7 +786,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



