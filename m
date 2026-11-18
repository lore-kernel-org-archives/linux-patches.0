Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040246;
	b=H68CAXst1taTWh10KYfEy5eqszFzEU4jlpXJNm789wm0ekTcK+W68GsKuY58/Z/UVItj
	 J+QfaLocvUSRmSReaE0MU6qqajKFMHeh4E67gHqpCwJAwAmHUL2eozmSSwJ6uYuZMGV5+
	 JDpTFbQ/QUkmgFMFLc3CBaDzOUpnfF2fC8bQyGxnAA70ukpt+XWmRFUpRX0DLen5W5NQa
	 ZRDb8jlXmCo5UJEY/zhW8ecRabYTxUVSsfGNR/W3K4lJ/paSTdw/zUe/rOoV8j9kPisS5
	 JkDwN7PfHQXLe5GQSsYrH+lmJU95oo38LfqE9/JmSbxYAxAPgG9nDVCvGF00NvRBFnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cm3SDbptigIhrGxRVs6zH1MhJvXs56Aid7MbxNuGuNc=;
	b=4RJAIJnJpERgWKE8nvDGoEfsy9T0C4azZnIlq6RraZt3UkF8M7IxUXMxAZ7wyIyRpN01
	 wAh9hn4uNWP5Ij1fEbwoH72EWKIieGIcW1zdHQrNFR6pGXCoqpGnqfNsniE0Pnw9cngPX
	 YDpQ6bxOQ+fXr7d+pUT/97OqI8ejq8a5X5c8RG+DPnsbArlVqnmHh1354N5VE2/VYTEvk
	 zuZy3PWd65aYwRKmmob81qPrUOqLb0L2qdsq6Z+Xy2W19Nd5E7p9pJQoGMzkWhA3dcydC
	 paHLrhQZcImEDrcvB6ZmUMazT+RWtuowXpac7JnuISXqSQHC82tTp+jYnzc/FQApsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxkN3egO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEA9606A31C;
	Wed, 18 Nov 2026 22:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxkN3egO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A471F000C4;
	Wed, 18 Nov 2026 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040246;
	bh=Cm3SDbptigIhrGxRVs6zH1MhJvXs56Aid7MbxNuGuNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxkN3egOHbK8r2QTInmQXGo5jCalc+Bk2I+s+CSHbowxwLSfkn1A0HnJha9vxFhrf
	 DlwY5FNfnPwLKMEU0QnWsvmMsb1LMHFOesgsdbe1QCR2033LgJ6uFVsxbuOcGY6Okr
	 y58Fcor/JbPJevBy1CQdP40XwhJeN7mhodACKZjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2362/3318] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:49:44 +0100
Message-ID: <20261118150432.443460854@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit cdc7d3dd101251a6373332726b8d6fad35e83b8a ]

The SPI driver advertises an ACPI match for BMA0220 but does not export
that table. A modular build therefore lacks the ACPI alias used to load
the driver when the device is enumerated through ACPI.

Export the ACPI table. Move the existing SPI export next to its SPI ID
table so each export is adjacent to the table it describes.

The issue was found by our static-analysis tool.

Fixes: bf2a5600a3eb ("iio: accel: Add support for Bosch BMA220")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index fcbd695e46549..e6d1e91ed62c1 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -308,12 +308,13 @@ static const struct spi_device_id bma220_spi_id[] = {
 	{"bma220", 0},
 	{}
 };
+MODULE_DEVICE_TABLE(spi, bma220_spi_id);
 
 static const struct acpi_device_id bma220_acpi_id[] = {
 	{"BMA0220", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(spi, bma220_spi_id);
+MODULE_DEVICE_TABLE(acpi, bma220_acpi_id);
 
 static struct spi_driver bma220_driver = {
 	.driver = {
-- 
2.53.0



