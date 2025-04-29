Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C223C8D6;
	Tue, 29 Apr 2025 16:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945505; cv=none; b=mnS79DNlU0myy7nEbw0DUOqKFN1kZUFYKEnphufE0aleENtxprnM4vElLBSxjtWfLNF6qbVyjf4Bcvhf+osAB8mnWjHfw1w4GDGZwfdxc6N4R34wuPRNMRpWhoSJgHpvFRsFajyoil85RZFfQVmjyoU2cVG3R30RAl8fo4+HI1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945505; c=relaxed/simple;
	bh=11hC+VpcsSdNix8oF3wYi5wrGYm9U0T1ZuekGajUkFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR35956B44u+jBomlnToMHf3v9H63SqevPBlZWmaeBOUnXYArpjKNj1CvhABTNDmJIsR4Whfd8r4iJ1H1QPL2OgtIQHcTgc4zJYbjdsHnKiQQqDZ+ogQWlX9LxY5/9BccstbimcRZfeZXu2prxSNTfwv7NSR38H7GcY4eRcCdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjoKnjpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjoKnjpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA75C4CEE3;
	Tue, 29 Apr 2025 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945505;
	bh=11hC+VpcsSdNix8oF3wYi5wrGYm9U0T1ZuekGajUkFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjoKnjpVgz7xmxp8MLgI7EbUqqjNDOD0QRiBiGTC7ytEU5rXua91OoUF+QPwWjOsm
	 riw3Inrn0ioq03RNvGprASyghgy8Y+BR1g33egubJHl3ftiCT1styn6D49t3+j2YUO
	 o2pwFWgUvGfpnwZSuBOuFqtFskGcm0mG8quo+XDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Sergiu Cuciurean <sergiu.cuciurean@analog.com>,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/179] iio: adc: ad7768-1: Fix conversion result sign
Date: Tue, 29 Apr 2025 18:41:17 +0200
Message-ID: <20250429161054.898844349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergiu Cuciurean <sergiu.cuciurean@analog.com>

[ Upstream commit 8236644f5ecb180e80ad92d691c22bc509b747bb ]

The ad7768-1 ADC output code is two's complement, meaning that the voltage
conversion result is a signed value.. Since the value is a 24 bit one,
stored in a 32 bit variable, the sign should be extended in order to get
the correct representation.

Also the channel description has been updated to signed representation,
to match the ADC specifications.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Signed-off-by: Sergiu Cuciurean <sergiu.cuciurean@analog.com>
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://patch.msgid.link/505994d3b71c2aa38ba714d909a68e021f12124c.1741268122.git.Jonathan.Santos@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 9b9956c0b076f..c1adb95f2a464 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -142,7 +142,7 @@ static const struct iio_chan_spec ad7768_channels[] = {
 		.channel = 0,
 		.scan_index = 0,
 		.scan_type = {
-			.sign = 'u',
+			.sign = 's',
 			.realbits = 24,
 			.storagebits = 32,
 			.shift = 8,
@@ -373,7 +373,7 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
-		*val = ret;
+		*val = sign_extend32(ret, chan->scan_type.realbits - 1);
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



