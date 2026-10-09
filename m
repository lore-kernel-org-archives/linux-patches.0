Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE170342173;
	Fri,  9 Oct 2026 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557524; cv=none; b=gaV3l1heQZLumBb+0Iia9JZ75h6lYTDh5SYH5V2nWx/mNxjbqSFxh+d/r6ByiqdaNFzguoR1AUthilmN6+Yz0SB8y2ioMgNgH7eUQxk5gpNfdxNsv3xufHRYQ4UKtM1lQn+C8otVRj+sAJ3gRBRzj256IQSrPUdtRBnspZFZ5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557524; c=relaxed/simple;
	bh=dbtWYIw4x6n8+73fToayKLKf/xOsAw/JrxrEze/VqnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNxpWmVM4KJWEkRmw9wSlC8xD/Rm81NijvWVpDzTG9oBC5Rq5ezbP6W1Cpw+PNVBVF3+/zXmBegUgNZ6kt+1kVelprAQ8Oca9JnKNdsW6wh4beWypEzLvXOl3TGj65Jde8dbRne5ZQY+oo17Js7jw2HGnKKBMZPnwvH/c1maZic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPP4elVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPP4elVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203701F000FF;
	Fri,  9 Oct 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557523;
	bh=hBTuS0kHuwOvGgiRw1bESc8jBZTmRVkT0BcEBA6cF8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPP4elVlvAMVL428dbKL8egfg1G7+/U9GvczsMK+wY+NIUPrC7g4CEzQII2kfMjO+
	 9spD98qcSn0QDkea+lA/eE86kfPXubiSGT5P6KWL9jfWrjk+jZG43Sqt0fuY7MbMIv
	 9irnMDjXwsN/kid6DxybgEkQ3vBT7Z9Ie9L5iBCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 388/428] iio: adc: rohm-bd79124: Fix rising alarm
Date: Fri,  9 Oct 2026 16:12:05 +0200
Message-ID: <20261009140954.721616183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 0d3f6b5e639f0bca5c1466ec523a94ec4f9f4c24 upstream.

The rising alarm is using the cached falling alarm value causing wrong
value to be used.

Fix this by using the correct cached value for rising alarm.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -532,7 +532,7 @@ static int bd79124_enable_event(struct b
 		return ret;
 
 	if (dir == IIO_EV_DIR_RISING) {
-		limit = &data->alarm_f_limit[channel];
+		limit = &data->alarm_r_limit[channel];
 		reg = BD79124_GET_HIGH_LIMIT_REG(channel);
 	} else {
 		limit = &data->alarm_f_limit[channel];


