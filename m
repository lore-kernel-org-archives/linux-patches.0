Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2112FB31;
	Wed, 19 Jun 2024 13:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802379; cv=none; b=btQ7TF7709pGjnxNa/Ft6s5OrX/A+fmGJeqgWJ5LhHs6SXZr6zn/ky3+nxVO6O7bVArINgtVU2Zx2XcaPNioANrOMuHomhIyieoK4IX3jRVWRaX3h9FFHjP56AbmqGs5GgZ999flAUY+bhoZut9ZSTE5bvsfb5AyB6kDt1Zi/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802379; c=relaxed/simple;
	bh=1KPCmWVrC+SGKDijysGkBFkyytb7KFgcP9M7zTxA1lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVexaJ0D6COF7S/rUFyyCXcH1RN34VNkUVMkfvgV9AqRe06ZtHlKaNYnOi3CyHcCjbQYHsEk6qy+1ZHrty4+OXGa8krjqq+NNVnoM4B3IriCVBvXIzMx4To8y4Gkl1NnGPkp/hTnYlKsqy1cT0a+3oFSO5GYd2dFGEzJpeVsi34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKrVIRDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKrVIRDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF16C2BBFC;
	Wed, 19 Jun 2024 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802379;
	bh=1KPCmWVrC+SGKDijysGkBFkyytb7KFgcP9M7zTxA1lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKrVIRDachP1XK3cVibmQhOtKOdQEXIedNtf9s7EDDw5eBlNvLe6PnMWBJ0kf+nyG
	 cJJkt+tRnQ8Ycqc2FztGSB/xaIUEn+uKKlsZAX/H7j4cbazgXBMxGO82OIJLG0XX1+
	 xkFDZC/85eOtOnCR+mRMtRWpc/uVJIsznx0jZ3n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 176/267] iio: adc: ad9467: fix scan type sign
Date: Wed, 19 Jun 2024 14:55:27 +0200
Message-ID: <20240619125613.099364395@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit 8a01ef749b0a632f0e1f4ead0f08b3310d99fcb1 upstream.

According to the IIO documentation, the sign in the scan type should be
lower case. The ad9467 driver was incorrectly using upper case.

Fix by changing to lower case.

Fixes: 4606d0f4b05f ("iio: adc: ad9467: add support for AD9434 high-speed ADC")
Fixes: ad6797120238 ("iio: adc: ad9467: add support AD9467 ADC")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240503-ad9467-fix-scan-type-sign-v1-1-c7a1a066ebb9@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad9467.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad9467.c
+++ b/drivers/iio/adc/ad9467.c
@@ -225,11 +225,11 @@ static void __ad9467_get_scale(struct ad
 }
 
 static const struct iio_chan_spec ad9434_channels[] = {
-	AD9467_CHAN(0, 0, 12, 'S'),
+	AD9467_CHAN(0, 0, 12, 's'),
 };
 
 static const struct iio_chan_spec ad9467_channels[] = {
-	AD9467_CHAN(0, 0, 16, 'S'),
+	AD9467_CHAN(0, 0, 16, 's'),
 };
 
 static const struct ad9467_chip_info ad9467_chip_tbl = {


