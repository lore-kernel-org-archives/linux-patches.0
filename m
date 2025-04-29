Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D32459C5;
	Tue, 29 Apr 2025 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950216; cv=none; b=k22rxwTqikDV6reUTfcHfI/FEC0sYLZiEwXiws7cnuWzK2wHdq82mX/qvoa0XDWX3e6QiuMactmk2xruIG2srPWAAsJQj9rpts7ELftoumEaqh1xOKM/+f5UPf4kkE0OtDFijYobeXkDkt3HHQGYPvrvtwFVmVayA+6cppVD4lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950216; c=relaxed/simple;
	bh=00o/Vm5kRQsvP++PsWdM4K//ErGW1umC1ISQ8enA1no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssjX7LZMcqOPYaS7S3Fiw12TJHukuK6hKoPRHJxRjMRQh5Z/4AWx47mDgMC6ZZDA3/3MkuCSlnOzUJaTXUVh0ZdnBDme9sdyNQFYHqrHfE3HG70zlTDkZslj2rSehGukAW/06Ysh/1QN92xLRyJePTVdlijTwoqkFjkAM32u9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StSl3uJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StSl3uJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00704C4CEE3;
	Tue, 29 Apr 2025 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950216;
	bh=00o/Vm5kRQsvP++PsWdM4K//ErGW1umC1ISQ8enA1no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StSl3uJeXccLA5tSmCZw/vVnv61/ATvKVA7n2FjCMqwTObCfiATmO7Lo+YNbYDB3t
	 FYGKoeXVQfuClH9077ezLR1S3rPUXyGgWsbcxLJrckll0xv3FAg3KCEK0jiLEUJuh4
	 0YdsrecNR+eCQvDuyKl0VqR+r3J41rCIomFEhLmM=
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
Subject: [PATCH 6.6 024/204] iio: adc: ad7768-1: Fix conversion result sign
Date: Tue, 29 Apr 2025 18:41:52 +0200
Message-ID: <20250429161100.410555674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19d604f5701d6..74b0c85944bd6 100644
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
@@ -374,7 +374,7 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
-		*val = ret;
+		*val = sign_extend32(ret, chan->scan_type.realbits - 1);
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



