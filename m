Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5B11E571E;
	Mon, 21 Oct 2024 10:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506672; cv=none; b=aXxi9BviSnErzkMdeMmw0fDX1dSedpgnmKCwqFBnz2u/+zGgC0sxi1ZCqSRhTJUCck3SBURiIHOfGmW0WvvgAi6o95VJe36AwwX+fLnqDVQjfdopkN02e4uNh74nXSMsVXHYNvV4wouy+yGRBOOPSNSzr/eZV9xhGKklJlcZJ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506672; c=relaxed/simple;
	bh=rqKhj1prLyQE39NCx5Lw27+MsB82G8tOub8Up7CaNQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCLlfZuj7fz/UIEDxDUSnGsX/bMzOMPqU1nXGi5iOa18IhNXkggB8/nsMAuAan2mKcbMOI9FZf8TBVIvt2BZXI4pVP3Wuf8qJFTFCJqIE60TRW9uQw1OIpmkwYVWO2W5ZHYHziCgtXw8a43F/CromskL5q0dR2kgPS9wxdUhmx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kezqS6nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kezqS6nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDFAC4CEC7;
	Mon, 21 Oct 2024 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506671;
	bh=rqKhj1prLyQE39NCx5Lw27+MsB82G8tOub8Up7CaNQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kezqS6nwP1WoKCYDcx21ot5ukwwnyJ0HP1wGZlIjaCLROm3M9LdMEwlfORwlxYv+C
	 HSW9wtrtUswLQZhuUasHQpBOsgNxiDg35uVLmkhZ4v870NuLbWl7TGmp52cA8+LVwO
	 yVx0VsvYiSAaZjlg9AjubifGSYMZqVQsykj/itLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 083/135] iio: resolver: ad2s1210 add missing select REGMAP in Kconfig
Date: Mon, 21 Oct 2024 12:23:59 +0200
Message-ID: <20241021102302.573087273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 17a99360184cf02b2b3bc3c1972e777326bfa63b upstream.

This driver makes use of regmap, but does not select the required
module.
Add the missing 'select REGMAP'.

Fixes: b3689e14415a ("staging: iio: resolver: ad2s1210: use regmap for config registers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-1-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/resolver/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/resolver/Kconfig b/drivers/iio/resolver/Kconfig
index 424529d36080..640aef3e5c94 100644
--- a/drivers/iio/resolver/Kconfig
+++ b/drivers/iio/resolver/Kconfig
@@ -31,6 +31,7 @@ config AD2S1210
 	depends on SPI
 	depends on COMMON_CLK
 	depends on GPIOLIB || COMPILE_TEST
+	select REGMAP
 	help
 	  Say yes here to build support for Analog Devices spi resolver
 	  to digital converters, ad2s1210, provides direct access via sysfs.
-- 
2.47.0



