Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786512AF07;
	Mon, 28 Oct 2024 06:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098191; cv=none; b=dk41tGSec0N7GOnnanrEfqflAdw45BSVehPZKRZhC0OIuGDI8jIpPHpYDMQx8sXI0rl4ICKW9yE7ALpWlpAztARJTsRKWqiNq2o52VkhhiYv/JoSpWTlTHwt9Ab4s7BMsRu9NGgx1QZoZgCAkvlTaZLFGC2A6kO8knCitTQgCqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098191; c=relaxed/simple;
	bh=sgdCx1knkQh6xtcdSJsuuCgcmS+GMja05BXeo6QrhfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO3iLRyirhZKZLhohM6KYuPCAungX8ouuLxg9jIHxg4nXCD/uGpq2AVzADXLOYKZA7eHE2Lg36DwbWufFQ58EahYCCrlEvXR0kHiiCaNCj5264304wUPSSFIKHZGS+fWIBzzB+WhrulmEw65JAm6g7AJ4Y4+BYArBcvUHKfIw6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UF7RC9m2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UF7RC9m2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174A6C4CEC3;
	Mon, 28 Oct 2024 06:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098191;
	bh=sgdCx1knkQh6xtcdSJsuuCgcmS+GMja05BXeo6QrhfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF7RC9m2RyykBNnWLplqNUY3TVwDOvmaRqaIA8bAiRlzi23/pCCt9v2xpt3o/UyaY
	 2daNGuunkk6/6xaJoZc4Ybuyjl0pB8C+mFTJs+tsdheHR4tu2GGpOmEPJV1UmOPN7E
	 jUYl4yqWrb/lVAgyy94b+CYW4pWU01HHTT4ue+uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 117/261] iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
Date: Mon, 28 Oct 2024 07:24:19 +0100
Message-ID: <20241028062314.962608507@linuxfoundation.org>
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

[ Upstream commit a985576af824426e33100554a5958a6beda60a13 ]

This driver makes use of triggered buffers, but does not select the
required modules.

Add the missing 'select IIO_BUFFER' and 'select IIO_TRIGGERED_BUFFER'.

Fixes: 6c7bc1d27bb2 ("iio: adc: ti-lmp92064: add buffering support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-iio-select-v1-6-67c0385197cd@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index cceac30e2bb9f..c16316664db38 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -1486,6 +1486,8 @@ config TI_LMP92064
 	tristate "Texas Instruments LMP92064 ADC driver"
 	depends on SPI
 	select REGMAP_SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for the LMP92064 Precision Current and Voltage
 	  sensor.
-- 
2.43.0



