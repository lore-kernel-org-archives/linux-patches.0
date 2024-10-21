Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0621E1EABB6;
	Mon, 21 Oct 2024 10:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507730; cv=none; b=ntdcSRd5HiEMvdEN6VulgoK9+QfHHcj4DQPpqtypGy6TBB59kx7XJnwuhmh15Oi+O3ox9gBJ+VJZhEidGfKxoXAmCHyItaGcPM2uLdOjI5LRuR3K85iFKQeoBAPMB9Ea43XX/6wHGKTPJnNrvodnh6yTpMY2WuUdMBfwJstom48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507730; c=relaxed/simple;
	bh=eLHT3pIXZvy07cYF3Ogv2WCZvnT5pDNuEM0ou1tEtMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHbYmmlW8hhWnTiENRXHevzgZXCbCPffnEUF5bA2RpbJVqnqye7O+szrIOsVksWrnwLXNdq0T7nDUNzUJR1D9B9ng8uYxZpcF/QwZ9105v3wz78D2dEq81mluK8GmbGi5jR0xcGyhDqo0kUMiJIVsutzYAwM9LfauOUZW0ftVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fnz8/Aw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fnz8/Aw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA40C4CEC3;
	Mon, 21 Oct 2024 10:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507729;
	bh=eLHT3pIXZvy07cYF3Ogv2WCZvnT5pDNuEM0ou1tEtMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fnz8/Aw1bYA2TgmWLq/Tkl2KHXD5ACX1+iW2LZO/o64r6nozNcsq76u/RBL64pMbS
	 V6HYcZnPdsm6lwRlTlwAAD9AXVcu+acFqUt6cgHKJ7fpE7rE2ZsBaoVY6QXcmupM6I
	 TJYEn89FHyrKA/DjRHq8FJZMFst1IccGNQMqGquM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 51/82] iio: dac: ad5770r: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:32 +0200
Message-ID: <20241021102249.256823678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit bcdab6f74c91cda19714354fd4e9e3ef3c9a78b3 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-6-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -203,6 +203,7 @@ config AD5766
 config AD5770R
 	tristate "Analog Devices AD5770R IDAC driver"
 	depends on SPI_MASTER
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices AD5770R Digital to
 	  Analog Converter.


