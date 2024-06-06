Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0F719DF7D;
	Thu,  6 Jun 2024 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683504; cv=none; b=hygeRFMyLOlpEPFWKroWnWIemzGJaY5bANaPcDBzmpp1qnQVaxkKcw3aUTIhAsDEZiwqNsyeBNCeWFqLC5GJKmANG+hdS3j6DVP2yTENbhO9T3Na+/uFLqhB1OYY5PEKpGqIOz5S65BszwnbPnnEVXTrXsjoZIdxvL6wCw/Yg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683504; c=relaxed/simple;
	bh=F6sNsDb1JwHIJKbLCL3H1fpZsNNQzZJdSTPxKz3hQic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV6ixq2MBcLuH3FCjT2N2Ssw8eI9N2yOwPygWwJoCoCq+P6ekCEpFdEEaj3kZJNIJcypsFAvT7io9cbNvAeZayfvGs8uGhD8gcr62H+VEAUPqgqee5HPfL1KLgIDHuJsGYjpeTINK2fZ+WkAdw8kFHK5EPvCE3LSmSgA5wkH94A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c6QQg2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c6QQg2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FBAC2BD10;
	Thu,  6 Jun 2024 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683504;
	bh=F6sNsDb1JwHIJKbLCL3H1fpZsNNQzZJdSTPxKz3hQic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c6QQg2SH6YLJEmwcUFY1mHppvQj3ebfoD5AbqXCrWSRbXP2PrI9+VcSkpsoWYYQu
	 9AkhX8fDgYgqTXXHGZM1avBbzBNn8w72CTRepVRz/Kb3CT0nF8Y36HQ8q82q5I1fmo
	 n6wDcGj86yktvye494bN2VUDtFVwvcqoEeGD85u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 446/744] iio: adc: ad9467: use spi_get_device_match_data()
Date: Thu,  6 Jun 2024 16:01:58 +0200
Message-ID: <20240606131746.805672006@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit b67cc85d45d5d2894d0e2812bba27d7b23befbe6 ]

Make use of spi_get_device_match_data() to simplify things.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20231207-iio-backend-prep-v2-5-a4a33bc4d70e@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: cf1c833f89e7 ("iio: adc: adi-axi-adc: only error out in major version mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad9467.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad9467.c b/drivers/iio/adc/ad9467.c
index f668313730cb6..b16d28c1adcb0 100644
--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -454,9 +454,7 @@ static int ad9467_probe(struct spi_device *spi)
 	unsigned int id;
 	int ret;
 
-	info = of_device_get_match_data(&spi->dev);
-	if (!info)
-		info = (void *)spi_get_device_id(spi)->driver_data;
+	info = spi_get_device_match_data(spi);
 	if (!info)
 		return -ENODEV;
 
-- 
2.43.0



