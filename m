Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D804918A924;
	Mon, 28 Oct 2024 06:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098065; cv=none; b=OKB/cahVOSbxDJ/yEKxrprgNy+cOzJi/cjGeoQukyz2Nub3zZNquPxLhrn9MC6vMUl9jRLhybnB/1d6w0BiMQqqRzbU+S79IO8poHhWR9mQWyl417YjiNdH5ziA3Bx+YFq2UyfOB4rvHfA0Fs+F13geDHRt6k9XfR7q4uAhXCDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098065; c=relaxed/simple;
	bh=LzlJ5qS9jMpwOsp1l0y40OaE02+39/EYzKLECPOeWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZacX8ZEaggGN27u/6+58tufSVYqkD68UjKd1BDZqDDHSn9gRYbTIxeUk/ntPi8nmH526txwYXCx3MhSnKgfTa5BxEdlDcMoLVnSnXReVTS0r9XXGHMBfCN2tnfuTgNcxGwOnhKOCVtZ+RzE8TTnXVpd/NlI4kfPsH5MzIeT9jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/LWAG6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/LWAG6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71317C4CEC3;
	Mon, 28 Oct 2024 06:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098065;
	bh=LzlJ5qS9jMpwOsp1l0y40OaE02+39/EYzKLECPOeWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/LWAG6PsEiO4wwOfhVvkE3BVrE4G7sMj89VeJvoEUDCpdPV4PPDnYkgGsTs8z6F0
	 dOZBoXoKEVofkl3ON46qJgVdSkYXpDhCFKM4quN93oBvwZ0lvl62FmhOhbi05a1LBg
	 nyKGf6+St94PB1M6azkmfQBu9+FoFQ53TACgxBl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/261] iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig
Date: Mon, 28 Oct 2024 07:22:47 +0100
Message-ID: <20241028062312.648706788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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
index 7b1a7ed163ced..583cbdf4e8cda 100644
--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -94,6 +94,7 @@ config ADMV1014
 config ADMV4420
 	tristate "Analog Devices ADMV4420 K Band Downconverter"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices K Band
 	  Downconverter with integrated Fractional-N PLL and VCO.
-- 
2.43.0



