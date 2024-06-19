Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956E14BF89;
	Wed, 19 Jun 2024 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803642; cv=none; b=rmqO+/0PopPBcKhVcPuZO3VfQMpuVI6zfYi4yM5tmnGtSWjHx72jI7vOVYPgC+3jlB/bhopGrU4vmVgLOM7sZ0S7jxV+EeWUanL2DFTbbnUHs3vwONfYsMB/HXKPtnaauWiOZhLgV9Yyv7toqMzzE4zr0O5T/MX2YxoZrwZtk10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803642; c=relaxed/simple;
	bh=p/lDzNz77wvZEeuCAH73AjSlTvI10h5dmW9fWDF9GB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkX6T/D6iT8h98snRahjsWpgLqE3SCosEyVQoAKlhn/3r5m+SL1yP17T3c6CnXWJjeCVq6TfRouxnO1QVm4Z4SsVKYSrgSFtxU3+V0u1nLFbDgntOqOiGDpQ4L/6VIKF3aVowgpheaTOGf5wHLMAUj1qYsbMtL5+oM7TlnQTIdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp87ZZcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp87ZZcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09EAC2BBFC;
	Wed, 19 Jun 2024 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803642;
	bh=p/lDzNz77wvZEeuCAH73AjSlTvI10h5dmW9fWDF9GB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yp87ZZcb2sQQZ69YSWznCBStoadGDWXxIRkEWXhEp9UsVgZjAqJNmuIQDRjeUQhBG
	 U1w2gAuYwR4jGnXLd3O8JAXeBTwtE/KZc/s50/Ba4Mqy0sTuP4yNuDvdhHcqGmY0Iq
	 cjVoH9tGwYKMvMcx0Twfzwx0mwTcH3Ua7G4KA7Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/217] iio: accel: mxc4005: allow module autoloading via OF compatible
Date: Wed, 19 Jun 2024 14:54:57 +0200
Message-ID: <20240619125558.765493901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 4d7c16d08d248952c116f2eb9b7b5abc43a19688 ]

Add OF device table with compatible strings to allow automatic module
loading.

Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231004-mxc4005-device-tree-support-v1-2-e7c0faea72e4@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 6b8cffdc4a31 ("iio: accel: mxc4005: Reset chip on probe() and resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mxc4005.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index ffae30e5eb5be..b8dfdb571bf1f 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -487,6 +487,13 @@ static const struct acpi_device_id mxc4005_acpi_match[] = {
 };
 MODULE_DEVICE_TABLE(acpi, mxc4005_acpi_match);
 
+static const struct of_device_id mxc4005_of_match[] = {
+	{ .compatible = "memsic,mxc4005", },
+	{ .compatible = "memsic,mxc6655", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, mxc4005_of_match);
+
 static const struct i2c_device_id mxc4005_id[] = {
 	{"mxc4005",	0},
 	{"mxc6655",	0},
@@ -498,6 +505,7 @@ static struct i2c_driver mxc4005_driver = {
 	.driver = {
 		.name = MXC4005_DRV_NAME,
 		.acpi_match_table = ACPI_PTR(mxc4005_acpi_match),
+		.of_match_table = mxc4005_of_match,
 	},
 	.probe		= mxc4005_probe,
 	.id_table	= mxc4005_id,
-- 
2.43.0



