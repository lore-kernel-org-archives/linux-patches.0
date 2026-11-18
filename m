Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033589;
	b=SYUo9Q0zGqVUWNiQ75JWXKR3ggAX/dXgTnXihHlvINiWCNqtozujOk/WrjJ8/PBiVdCP
	 1ifgi0si0zbOZu0NC16+vXRiN3Z5NfZMqIibqRvNsafA55Mpht78tlk5MV/3KGfCth8BZ
	 7wqGByrXSoTLKqrEPTX0dYQHbOWc1AchloWdAjZVOpLhbhK8++Zfbndh12xLGY8Xsix1T
	 lKgpjW/PQZaft6V1IEb2g2CSAysPeRwEdwWVbfV3CRgUgkfc5aQWriRNKu653XSbfLlZv
	 MNOw+y4ZvEioHrVfh+Ae3EbykrquRb4gGHYzHwRpdGEB3UEvw5uw9mB9d2KGCbwpk3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwynf8EsYPH5ZnpAyDu6rnsMWh70ZerrDF1zyH5iRtM=;
	b=o/QfVCaS9kqt+9X9CUnRV1E51V/isjyXG4axXM2D50pMsPWjkhW/vGlcCudOcF+PG3TQ
	 BnbQp9GiSoedZA+LnGA8T92wQsbHUtPF3pZNyrzx6zapaQaGjg2XmQntLMO/WA03EcqlY
	 +RjwJ+EukTaQANNZWGea4nKLGPaSoA1SGQYoqrHYc4qsqYHqbsH0gMbL06jBNJ1rF1RZN
	 YUEUaperukZUhoK9CDSeCNSF+Ie6ARup3DEZYoKMY4lyrbjhHttSV2TMs32n2I1Nfhcx0
	 tz/yztAW3Gv595nzMCBVBpUknt+xZIUJjw6QwwN+EUnWRBO7GyWYctLvu2sG5991jmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lid5Osew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17693606A320;
	Wed, 18 Nov 2026 20:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lid5Osew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7260A1F000C4;
	Wed, 18 Nov 2026 20:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033588;
	bh=kwynf8EsYPH5ZnpAyDu6rnsMWh70ZerrDF1zyH5iRtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lid5Osew8IoVLknnMPoSBxsBsXb/pFc8PLyDV4rY09iNnGekwiOe+77YQ1BX4yRYZ
	 Gb+XunW0EkVIHNcyZOr05z3BYZHGbQKX1K9wHzNdGUlLvfY8UXob4gqA23znkh/CSm
	 LUM45J4NL8awF6yryXl1n8xc2XiBPIVt43Cf4Ves=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0066/3318] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:11:28 +0100
Message-ID: <20261118150315.984104621@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 790a2080e0c9eabefea3561dec301172043de236 ]

The driver has a match table for the spi bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max1241.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index 500bb09ab19bc..4fa1461823099 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -179,6 +179,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{}
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0



