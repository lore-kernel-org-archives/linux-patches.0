Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024411;
	b=U3s360YbDcGVR+A58ErrWfmfMWJudTe1quNWo6rqKwn2nADoIQkDXq2l+uzMZ8RjiUQs
	 hyRd+pYACWyS+rYi8zQH0FHYZ52cOcursHh4VFaWJz/uXJBahaQF6C/6NAUR93pNkmcMg
	 fDFJixkxWdaDFGAJVhep8hWEO0uMfCQip9icjBi3FOloZ2lQRjoHFVt3zxIscgSGDXsC+
	 JufhvVA4BDVyx9jVhV4xT/njh9G8TfIN/MYXhNIPN8UHkp/X8cPxdXGgk8Ks+m1n/tFdG
	 z8PG60h9c4DgfJ/3mjPd+g49PuhHq5W2L6387DUguQA6ceMQsm5dPA3Zl3uBttkRiJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K4sGfBC0OQgaFdlVymF9yXS1l4pb/uJ9ja4mzw8joIg=;
	b=HrE5RZvEY+RK1ERQndslcliejQiCiz0cyFmxr98QaTlT1wtF05GObQmWD9uZK4N4piuk
	 X73au7S4qfu7/X+K+Lj6FZYDQHidsB3Xtw3aZpC/u5uzzrmzbLZA0MOwEQOsA+mMhPPjx
	 gWN/YIorHwNF5nlj8omAn5tky90Wz/VuTf4aSvA3kVmdndg43OTdqEAyYEsuN3Jy7Nt3x
	 fMXWeyz5GvaUyV2BH4B4qdsUNFDoJcNkZhvVUC+jd25828zfbye54biyraBGsG+ZAZHnp
	 6wuwfcfpSAlhH8AGB2Ndw+I0bDGbIC7WGvinAy02WmSthqiEGRZYpSoKlMh54jghMfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gfF6po/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A30C606A32A;
	Wed, 18 Nov 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfF6po/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACBB1F000C7;
	Wed, 18 Nov 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024411;
	bh=K4sGfBC0OQgaFdlVymF9yXS1l4pb/uJ9ja4mzw8joIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfF6po/hnbmtaCJIgtQ1ejl8I664f9eY18WLg2wc1Ygci3XQlrczFQBMpJJp2Z491
	 ryxL92H2myYaWsEFK3jg+BbJ98jsMSa9idImJyDuIUXv1NP6j24OatclADVDTY+g5k
	 HfEvchhoVUM0Slu372u9YbYGuUkz/4iTY74i0t6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0716/2151] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:40:51 +0100
Message-ID: <20261118150147.956396206@linuxfoundation.org>
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
index 01592eebf05bb..db85a4aed656c 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -307,12 +307,13 @@ static const struct spi_device_id bma220_spi_id[] = {
 	{"bma220", 0},
 	{ }
 };
+MODULE_DEVICE_TABLE(spi, bma220_spi_id);
 
 static const struct acpi_device_id bma220_acpi_id[] = {
 	{"BMA0220", 0},
 	{ }
 };
-MODULE_DEVICE_TABLE(spi, bma220_spi_id);
+MODULE_DEVICE_TABLE(acpi, bma220_acpi_id);
 
 static struct spi_driver bma220_driver = {
 	.driver = {
-- 
2.53.0



