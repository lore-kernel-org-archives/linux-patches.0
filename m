Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043069;
	b=zl7P1quoKEcE5JSxYUKbbfcW14DbYNf6puSfVnxd7+8I2wOOE3hpIJsZ7jiMSjuEVaFW
	 E35avuHdNUtKBpU5QkPktNMUZmtRbqgE+jUXtiN64jMJ+iOw4YDLp/TEhN2lX0adySL0X
	 ewrffIk3YptqFTRERjQwoZrn03gwE3S+GfAFqks0WgI+vJdIQXk+DnaGbbNN3QhnhX80t
	 hTqHlKMykcnQ67jXXwHq+7m+9D87p+ow5m2zghmp2ayhAPEoA200wZLkjT/eQpkKYBsFa
	 X1qCwx0VHrs+2zo7geW1ABRhO0mRanuPDM6Owb4g7I6dv7RqvW1dZ1pIDWKlGmiVpeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJMsc9744Xd4FgordPUwU/habBmOS9LclTolqVYp3IY=;
	b=n83+Ce5G/SNBfBcbNqO5eYDmRs0IXevC4fvqiWEYEw7l5LdfS3FQ1mJn8NSCJKszUQ1A
	 cOmWP22JBV5aY00AESfFxBL3NOe/TlYJ3pPTxssK8bQAUPoVuTGUPSZJHq9IVPRK86SHH
	 fdqY2gg7ChIaAWmn13wwWLUJaqRFqXwGfNuXnL0RER4MFH72DM7mxOZMvcpmWZ4AzEguu
	 raVWha85YMOvy6yd/E/80hlC8q7O624fJa6NV72ttf6wnes/97m7g948FUsHOhh1oe2eu
	 fmaTMYwxfAN0Nn3Cv2sjS1nG0YBw/BtPu2YgvBS4atxsCrlU6xvPov3WxmT9iRCuXnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lNB57Z5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2DB606A334;
	Wed, 18 Nov 2026 23:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lNB57Z5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B87E1F000C4;
	Wed, 18 Nov 2026 23:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043069;
	bh=nJMsc9744Xd4FgordPUwU/habBmOS9LclTolqVYp3IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNB57Z5bK/pY3nFbRAGBeYs57wJ5tBEYyhBo9yDT6CfkmaI3Y1M1dkvdIciFbfLTR
	 SzCwEfRanewMEwNrtLkXCQjESU4hTF9Xp4wtIyRFgVF+djtScfoef6zJFMTjltyfVB
	 gUhQ/vnvYJH7mylKWy62u/57maFR4WXzgkMnJL3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0079/2857] crypto: keembay - add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:18:33 +0100
Message-ID: <20261118150204.143756367@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit b73b71df4cb4ca241165ad31218c82dfe489147c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/keembay/keembay-ocs-ecc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/keembay/keembay-ocs-ecc.c b/drivers/crypto/keembay/keembay-ocs-ecc.c
index 2269df17514ce..8196e629896ce 100644
--- a/drivers/crypto/keembay/keembay-ocs-ecc.c
+++ b/drivers/crypto/keembay/keembay-ocs-ecc.c
@@ -996,6 +996,7 @@ static const struct of_device_id kmb_ocs_ecc_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_ecc_of_match);
 
 /* The OCS driver is a platform device. */
 static struct platform_driver kmb_ocs_ecc_driver = {
-- 
2.53.0



