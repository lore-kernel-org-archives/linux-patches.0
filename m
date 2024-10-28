Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BEF18C03D;
	Mon, 28 Oct 2024 06:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097168; cv=none; b=H42j1FtM9+urDqhVf1/2/YGOkwwQ/aNw9mPtmcw4UysAkmANl2O6/Becl4l/qDXqJLq55qPL6Vq0yxSKcIYNuqgki8sJcSOUuIuuuL4NuD65ue80rU2EsdHV+PlM1eHU7zphLlAbjLHi+bBamPI21JoFCaLndBm3yHmj/0y9gfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097168; c=relaxed/simple;
	bh=If3yIy8T4riHXSnvPnA+DvaTxnAJunfxDvttWY0EjFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOh5Rs1kBSFO//zJ+B6srOL0hPxmqbgsWi6ncgn6q77k9tH/0m+Cq50bGu0PEBePKpIgbLy23q6EWP0JxCxjOKV9N9DFnj1zmhGHH96r3fi7qzDqLCV6lyN+XFpogdyb8dH0QVR8IKjPR3T7dWi+C0K8PsMoe0zTzQBtncmMPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj99BN9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj99BN9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F624C4CEC7;
	Mon, 28 Oct 2024 06:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097167;
	bh=If3yIy8T4riHXSnvPnA+DvaTxnAJunfxDvttWY0EjFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oj99BN9SAIH4IDH6sgK3qNgKdqftrdc9c4sAg9ruGVHsFC/Cojnwc2Sjfo3nEMTep
	 wd/63LKxpStkkG7a8QAWnymjTZSqUO8wSNVbMeKdTCjWhhkGyciJqeuFoyi135EoXm
	 WSqn+GgDanniu9+h95J6KaCeM+hEpZAzPB+97rog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/137] iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig
Date: Mon, 28 Oct 2024 07:24:10 +0100
Message-ID: <20241028062259.091771242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 599a5f67fe11a..023997786ce0a 100644
--- a/drivers/iio/frequency/Kconfig
+++ b/drivers/iio/frequency/Kconfig
@@ -73,6 +73,7 @@ config ADMV1014
 config ADMV4420
 	tristate "Analog Devices ADMV4420 K Band Downconverter"
 	depends on SPI
+	select REGMAP_SPI
 	help
 	  Say yes here to build support for Analog Devices K Band
 	  Downconverter with integrated Fractional-N PLL and VCO.
-- 
2.43.0



