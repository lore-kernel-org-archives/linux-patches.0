Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF361A76B1;
	Tue, 30 Jul 2024 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360002; cv=none; b=smp0VlRGhXOA/jp3irVu6J5Q8Zh8YsDudZJqv+tyEekMk0znak9t4pYSa34hr8tJHabv82pRdKNHvKqznhZddp1X9L4lYcKvuiohQaZE7n4znsbHiH7pB6x4bhTO3W+WD+Aju40bMXme6jkTjROepZOuZWALE2/NlVdhhSZw3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360002; c=relaxed/simple;
	bh=qHbr7UclzThp6Z5l8qmw2WBg1vF2kHat96YEPrCu3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzSB3Mim2wBCqJRdTlqY1oxllmNr0IcRYZkZzxDLARUYTAe1kbnYw2Cz78SCwlCBfYAjMq/aUJ7Y4z0gIAljvTsJ1B0JhtQAyNtuFqDm2R57EAvXXvgLZbnWQrneRYcm/krsghNqlBbjL2MTMFwxkJq00F4rYh+m+MBo5TOE6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwVNJn8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwVNJn8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9023AC32782;
	Tue, 30 Jul 2024 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360002;
	bh=qHbr7UclzThp6Z5l8qmw2WBg1vF2kHat96YEPrCu3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwVNJn8R+fKfCfi36659vebVTAsBzVStwl4bK2U1Kc06al2qm6W1Cauuqt2Jujrqf
	 ls21cnO3L3L5HfGTrUf54dPXirQlGsMJk3DFGso0HGfrSlb4VZgk69EtnR03XVn7ZV
	 abpL99hywji3VcpPrIuYltTiX/rW2TbDnyNDlHno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitor Soares <vitor.soares@toradex.com>,
	Lukas Wunner <lukas@wunner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.10 567/809] tpm_tis_spi: add missing attpm20p SPI device ID entry
Date: Tue, 30 Jul 2024 17:47:23 +0200
Message-ID: <20240730151747.167505811@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitor Soares <vitor.soares@toradex.com>

commit 0543f29408a151c1c4a12e5da07ec45c2779b9b8 upstream.

"atmel,attpm20p" DT compatible is missing its SPI device ID entry, not
allowing module autoloading and leading to the following message:

  "SPI driver tpm_tis_spi has no spi_device_id for atmel,attpm20p"

Based on:
  commit 7eba41fe8c7b ("tpm_tis_spi: Add missing SPI ID")

Fix this by adding the corresponding "attpm20p" spi_device_id entry.

Fixes: 3c45308c44ed ("tpm_tis_spi: Add compatible string atmel,attpm20p")
Cc: stable@vger.kernel.org # +v6.9
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_spi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_tis_spi_main.c b/drivers/char/tpm/tpm_tis_spi_main.c
index c9eca24bbad4..61b42c83ced8 100644
--- a/drivers/char/tpm/tpm_tis_spi_main.c
+++ b/drivers/char/tpm/tpm_tis_spi_main.c
@@ -318,6 +318,7 @@ static void tpm_tis_spi_remove(struct spi_device *dev)
 }
 
 static const struct spi_device_id tpm_tis_spi_id[] = {
+	{ "attpm20p", (unsigned long)tpm_tis_spi_probe },
 	{ "st33htpm-spi", (unsigned long)tpm_tis_spi_probe },
 	{ "slb9670", (unsigned long)tpm_tis_spi_probe },
 	{ "tpm_tis_spi", (unsigned long)tpm_tis_spi_probe },
-- 
2.45.2



