Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574B918E05D;
	Mon, 28 Oct 2024 06:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098063; cv=none; b=sWc2T2mAdw1jUojfhgrh+yfvuWoO+0+zE1xx1RHlb50uCCtED9IceLeky0B5AST6x8mKkNPDwzf0vyWpMh625Ny8vnn1ra09F9C0CgAR6CPyDc7QnbdgTvFC6beScbFUfADOx79d9WiVElTwPpEW3TgvPKF3aUuFYcYzveb74DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098063; c=relaxed/simple;
	bh=Tl87WnvjTCrjDtuSg+0GsMWis9RfxDtVbYc2kH1OqiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDF7RNj0jZyc+R67N1Dwx8YudbkC8S3aaOOTIGTsT3UJ0zcDrq5OYZxsbexbCNWF9hzNDxUq5iDHibOKp70vUfPtpJo2rTuX9HmwnKzwYxonJw46wXzlPOs9oyTbChcZpcL4YNF7rrQD1H8FDFe/skhbr1d+xZvd7LvTcLzUb1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3ejup3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3ejup3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9188C4CEC3;
	Mon, 28 Oct 2024 06:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098063;
	bh=Tl87WnvjTCrjDtuSg+0GsMWis9RfxDtVbYc2kH1OqiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3ejup3dncl0xRnwOS2L3qZCubJh63DLLyAKokUHCvxcUYGyaQBuSFx7lmxn96mKz
	 TxmjDaWWiGGD/yB8s0reQ5hJhxhBIa1MYahVj6LchtRPcGnX6eg4K5sexo1Z1OcC0p
	 uCMsxCVfINUZ6Fe3GJ048PxznsCi3mQdGfG7Xp78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 024/261] iio: frequency: {admv4420,adrf6780}: format Kconfig entries
Date: Mon, 28 Oct 2024 07:22:46 +0100
Message-ID: <20241028062312.623032573@linuxfoundation.org>
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

[ Upstream commit 5c9644a683e1690387a476a4f5f6bd5cf9a1d695 ]

Format the entries of these drivers in the Kconfig, where spaces
instead of tabs were used.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241007-ad2s1210-select-v2-1-7345d228040f@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 6b8e9dbfaed4 ("iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/Kconfig | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/frequency/Kconfig b/drivers/iio/frequency/Kconfig
index 89ae09db5ca5f..7b1a7ed163ced 100644
--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -92,25 +92,25 @@ config ADMV1014
 	  module will be called admv1014.
 
 config ADMV4420
-       tristate "Analog Devices ADMV4420 K Band Downconverter"
-       depends on SPI
-       help
-         Say yes here to build support for Analog Devices K Band
-         Downconverter with integrated Fractional-N PLL and VCO.
+	tristate "Analog Devices ADMV4420 K Band Downconverter"
+	depends on SPI
+	help
+	  Say yes here to build support for Analog Devices K Band
+	  Downconverter with integrated Fractional-N PLL and VCO.
 
-         To compile this driver as a module, choose M here: the
-         module will be called admv4420.
+	  To compile this driver as a module, choose M here: the
+	  module will be called admv4420.
 
 config ADRF6780
-        tristate "Analog Devices ADRF6780 Microwave Upconverter"
-        depends on SPI
-        depends on COMMON_CLK
-        help
-          Say yes here to build support for Analog Devices ADRF6780
-          5.9 GHz to 23.6 GHz, Wideband, Microwave Upconverter.
-
-          To compile this driver as a module, choose M here: the
-          module will be called adrf6780.
+	tristate "Analog Devices ADRF6780 Microwave Upconverter"
+	depends on SPI
+	depends on COMMON_CLK
+	help
+	  Say yes here to build support for Analog Devices ADRF6780
+	  5.9 GHz to 23.6 GHz, Wideband, Microwave Upconverter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called adrf6780.
 
 endmenu
 endmenu
-- 
2.43.0



