Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8884F18EFF1;
	Mon, 28 Oct 2024 06:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097521; cv=none; b=sCJ8wj2sDYQQ3HTM/w6y7Rhpay4Sn71R+R0f5kdUEvlLraUsod5ayFsWZ740ajp4WGu/uOAZwioORA4yIF1XITyAwNZ3jSDQkFGVtS3w0zuJc7xKPEHAr/SJxXMnGRKEHSnSnDb3GfpakfKtOvc7a0nFWsgP+VVVSwrk97xEjH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097521; c=relaxed/simple;
	bh=64Xj7Bo1l3bIp9SKDolnWIU2HEXfvE1EwUXTxNFoexY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ilv7aSJqxZ4WDvu2s+33FSDqi7YwPWmvg6ki6249Fpz+V/feCRd+PepgEbxELpW43+px5HITCpKMM5+wH6SXldSHY/vCcT64+m0HWvC6MGVqrMSagZYdjup1JgLqfD1BLO+KcD97V+fLq7v+XffkRT/PKoXM4m+fZ0A7VH0fFL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbFMlBuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbFMlBuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EB9C4CEC3;
	Mon, 28 Oct 2024 06:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097521;
	bh=64Xj7Bo1l3bIp9SKDolnWIU2HEXfvE1EwUXTxNFoexY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbFMlBuPgml/Wg6qZhyCNrQTiFlg44OgoTjl+1sDqSxhdKTk/kC4HuNM//J/lKFsB
	 QtRmxNXdB+4LT/qr1Rk64lI0UdQk0PZryPxrPQ/PGGv8lfe/+zsQROWbpuayn347vk
	 ZTSbRdHQxvwVr5XhFLO6lzjWEvMQdL2qOSSv9gVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/208] iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig
Date: Mon, 28 Oct 2024 07:23:22 +0100
Message-ID: <20241028062307.203227559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 6b8e9dbfaed471627f7b863633b9937717df1d4d ]

This driver makes use of regmap_spi, but does not select the required
module.
Add the missing 'select REGMAP_SPI'.

Fixes: b59c04155901 ("iio: frequency: admv4420.c: Add support for ADMV4420")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241007-ad2s1210-select-v2-2-7345d228040f@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/frequency/Kconfig b/drivers/iio/frequency/Kconfig
index f7534dd8a8cae..036763d3e84c6 100644
--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -84,6 +84,7 @@ config ADMV1014
 config ADMV4420
 	tristate "Analog Devices ADMV4420 K Band Downconverter"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices K Band
 	  Downconverter with integrated Fractional-N PLL and VCO.
-- 
2.43.0



