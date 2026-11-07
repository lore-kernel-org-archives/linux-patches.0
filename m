Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063972;
	b=Qk4keYG1Q5pVVgL8eEQU86yH4OHc7Su/jfUYp9mwOR6l+lXKon/fLO5yobOqxhX+hpPg
	 c6nxWEcx4MHg10v2MWtrCMrTyA2qrOoC6TJmJOVAF4lp97NDNvQ/VvGINGhxYj9wkE653
	 k0iAxhuw87+QQ6yACoTnbay28CHAbbFhKrLqKev9ZCTMPk/GL6o3epscZBKAQ5XuCMiUx
	 STJztxyReCUutsLjWkQjS+a6EAu8nTufcTU5uMz0jDOHWOndjs198xeMnFK/jAK+C4mmY
	 uX5SVSOKyRsUYXaRGUiyPomUoW1fwXmattoHDSOUTVwcTYlKAWhxWFFsZez9gP91SyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3h20XRtfTqnYKuwVT4auRbGGKGKSEjWqesZinv3IrSw=;
	b=bq3Ld1IsGnuy3ki0rZwCKiQVORJzlmteWlc+kuW6ajxTGGIVU8++Ve1uOenBzdlnqfPQ
	 /u7072vRgxligltL37njmFxxepLDMgMnvviDnsyfABGaz05HOfshUYPgUbejeIxTmaJH5
	 FTopxdvUlRhjoZrnEQnW7LovnjxnbaDm6uWaligAPkOCxH6C7ribXrB/PKbP18Gg60L1v
	 7ImejIqFiUSp5RgO7N9ykejfTLtBDdKNic5yRAXq7nwmdV16qvhE3fD7GZ7E8afQh3dYt
	 VRY87d8KjeUyyRir5/LgZqBeesvVMt/5d9AJQBexbRqTvXbnYkQh84rE0dGaeKYZ1jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/rysDZ2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA4606EE97;
	Sat,  7 Nov 2026 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/rysDZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBD1F008A6;
	Sat,  7 Nov 2026 15:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063971;
	bh=3h20XRtfTqnYKuwVT4auRbGGKGKSEjWqesZinv3IrSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/rysDZ2MMoX/dlu7UpExV9+pFefmTHHcme7Ygth4RIqZ1Mm/WTdUI2kyo8Z6Oxml
	 RvANyn2yqpzZyc2c2hOuRQG3uJchpO/A/XXgZwnWpbJv2evxnM1BYpMZ5eSFZqRyG/
	 Gt1Zlx371p3lxyFVYQu4yrwgVWnZItr1DeBH408g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0156/1257] iio: adc: max14001: add missing MODULE_DEVICE_TABLE macro
Date: Sat,  7 Nov 2026 08:40:52 -0500
Message-ID: <20261107134943.628905580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit ed6179c3c2b2545fa1c7174604ecfed55c9ddd6e ]

The MAX14001 has an SPI ID table, but does not export it with the
MODULE_DEVICE_TABLE(spi, ...) macro. Because of this, SPI-based module
autoloading fails on systems that don't use devicetree (e.g. via
spi_board_info).

Add the missing macro to export the alias information.

Fixes: 59795109fa67 ("iio: adc: max14001: New driver")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/max14001.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max14001.c b/drivers/iio/adc/max14001.c
index 58adeac62dde4..7694fbb6a9fd4 100644
--- a/drivers/iio/adc/max14001.c
+++ b/drivers/iio/adc/max14001.c
@@ -366,6 +366,7 @@ static const struct spi_device_id max14001_id_table[] = {
 	{ .name = "max14002", .driver_data = (kernel_ulong_t)&max14002_chip_info },
 	{ }
 };
+MODULE_DEVICE_TABLE(spi, max14001_id_table);
 
 static const struct of_device_id max14001_of_match[] = {
 	{ .compatible = "adi,max14001", .data = &max14001_chip_info },
-- 
2.53.0



