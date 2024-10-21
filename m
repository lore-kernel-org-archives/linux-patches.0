Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017451EABB6;
	Mon, 21 Oct 2024 10:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507733; cv=none; b=dy+FMd2jjRDv6igENNgypZ+iJGQJOHERbWQ3RSLyten3QDYKWydlDlHp+O8WmQXmKpsh2yyLJqkgCmP81abQap8pfi/eiKA3qwWDUdvELp/rb+qx73U6zDhepm56hHrx1UFwkNGz1tnY8z6CdPO4jgrwqVZCEU3/jxHct8UUAvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507733; c=relaxed/simple;
	bh=mUVwBKl+f07PcEAIGfO2zSOkL6s0CAvHQ0JB1FOy6wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZ28Wo475mWZBWVV7nVl1LWHAwvRwb2xUw/salrr2HtZm3pPcnOweHj+8H+wg5622aE5fUT6WGYempuUjIsqxxTGMOASBocOj0iRVkgOT+PpLn94RcOjswJ3pKsEVl81hQqQjjt57JK6mFhZLDOuuZdjjSipAAcH22a1OtqSSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIer0lfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIer0lfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F59C4CEC3;
	Mon, 21 Oct 2024 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507732;
	bh=mUVwBKl+f07PcEAIGfO2zSOkL6s0CAvHQ0JB1FOy6wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIer0lfXR8IeYY803Im2+OK/32xyOv+H3d/llSdwnEW3xC7/I+7gSvh3rOe4obgaz
	 rF3yweeIEtDLAnwBbeIQyBAz0r9qRIutZ4H0KY+lHHWjDna92I1qilDjWzbCfA7aHX
	 BhGMbtD0w0f2JLbnLa7jBRNzwT6GrKa+kQxkC5u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 52/82] iio: dac: ltc1660: add missing select REGMAP_SPI in Kconfig
Date: Mon, 21 Oct 2024 12:25:33 +0200
Message-ID: <20241021102249.294565227@linuxfoundation.org>
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

commit 252ff06a4cb4e572cb3c7fcfa697db96b08a7781 upstream.

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: 8316cebd1e59 ("iio: dac: add support for ltc1660")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-7-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -284,6 +284,7 @@ config LPC18XX_DAC
 config LTC1660
 	tristate "Linear Technology LTC1660/LTC1665 DAC SPI driver"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Linear Technology
 	  LTC1660 and LTC1665 Digital to Analog Converters.


