Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051006;
	b=AWuRjV4GHfhG6csPKqcf2BF9hBqJebm47bmoeHZ7W6dMcpZ+PDfSbw7AHEsuY60wE7My
	 Hl5IFYd6DZ4lpKlKVw74a2zP55T1giHzrpJPTR4i1A+kQUiNSn9y8jBycZ+qavAKH68LK
	 1DOLywX1CC6bHuOTIs873eGbP3QOf24uZajOdkvImM0uMZvU3mwMxW2/mREleQAKhVAMM
	 AKSr7XqYjc7hAbXpZO+VHsbL0LayMOFhui/PKiFXcR90Tj9p5F5bIKBShmocTSAr+RFaK
	 oRmWT5rlLHOgxq8o9TQg5yhrsGepJqeS4fPPUNCpFLn0zk6DIPMLIWUPy0JRQt+7uIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nav0nbQmNev/sKjUxnaQm2EmGRhJ/sqnSvX7+iJZ/8U=;
	b=Ip/ZgMxChbnpI8RqS8uqwjGpnB3iqNn/MQiKf0JtdCuF6c3cBDJH1ZwTe4bLR1eBQN/E
	 hhl6HOOUnHu/ISwULZ1hIQmwb38pe0EHSTKWJqu0yQz2jg3g4UWlNY1sWdE2UMkfDrDBL
	 vPGi2GHUk97MRz03oGLI2T7RwGanlzu80EntSEWMzCHBTdZho+FK4H0uFrl0T8D4O7tjX
	 0MBc10UCQ2q5/N1ps1j89lQk3/fscuHyCdqMBehkU9UVvYW6PS1dgSJe7/PrKTStBHkD5
	 N4ItJLRKUltTYFj4qNsGi+yf290OS0EvHbolG0oabanFJQpuwhW21E8F3XYleAQ4j+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+yNELT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E069606A31C;
	Thu, 19 Nov 2026 01:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+yNELT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902291F000C4;
	Thu, 19 Nov 2026 01:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051006;
	bh=nav0nbQmNev/sKjUxnaQm2EmGRhJ/sqnSvX7+iJZ/8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+yNELT69HZg8QPlU1qyGhaK7M8lEPt27goN01Nz9nrOESS0Fx3o2gSFakC/oD+Ye
	 qva1A7CinucBV6ozcgtsVO7SCpe9B8bkRCVzd8x18JW546024OTszg2M7ueoXQrlVp
	 gj1/evpr7EbEVZKt0lvtNnup/mwkuttziQwuKar8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0056/2214] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:28:52 +0100
Message-ID: <20261118150012.266801893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b60f8448f21a4..fb92a68e6827d 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -202,6 +202,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{}
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0



