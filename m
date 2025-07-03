Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183522EAB95;
	Thu,  3 Jul 2025 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554715; cv=none; b=rYs7XqP5epg4oAwh7C4/Dub9wgo7tc0AmxI7MAC8PqKcpjAa1v6/bhPasNX1GZwx7cn+wS1zturfnq9vfBkd0fEdq7cuJ31c0EtC/t+BRc0aJ+A2HMJN/S5Zq8oj2PqOZNY5vXcFpk2pho15QyGY3K2QUbcgwb4uQraO/XyLooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554715; c=relaxed/simple;
	bh=d1/GGTt/42HEa7nP3z1AFDgmBSs3GtFeX+uG0+mbcQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A34wUoTwEpvCWmNjej+pk2GOqHJHJY7Dd7PlUnkybPbR9tkqMIkXw+YGproJPM50mRmNnO25Kvidgq1U9v57AYclELRkWwEwJVqoazXtBP9HpNrAWmQq7f3COiRmjo6KtctQvynovW2f3BQh720E0NQfmudK3vfF1YyG4qq3zzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0I/5zT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0I/5zT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E91C4CEE3;
	Thu,  3 Jul 2025 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554714;
	bh=d1/GGTt/42HEa7nP3z1AFDgmBSs3GtFeX+uG0+mbcQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0I/5zT0YS8ViErgJibyrQRYEZX3iZ2/Mxl9CtN2s0CGM6NxUl65Zvex2dZnUPwrm
	 3ZWPBt4xh7T1+kHpYO+VaGO7/nXbGxT4dC5P3C5L9dbG1uUzMLNKVMZ6UV52rSBUNj
	 Co9y4rUMDbAj32vLciio2tFRa+NL/lTs08OgNSNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 054/263] iio: adc: ad7606_spi: check error in ad7606B_sw_mode_config()
Date: Thu,  3 Jul 2025 16:39:34 +0200
Message-ID: <20250703144006.473405892@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 4d71bf6021818a039a534c5954acefdfc4d6962c ]

Add missing error check in ad7606B_sw_mode_config().

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250318-iio-adc-ad7606-improvements-v2-2-4b605427774c@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606_spi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7606_spi.c b/drivers/iio/adc/ad7606_spi.c
index b37458ce3c708..5553a44ff83bc 100644
--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -174,11 +174,13 @@ static int ad7616_sw_mode_config(struct iio_dev *indio_dev)
 static int ad7606B_sw_mode_config(struct iio_dev *indio_dev)
 {
 	struct ad7606_state *st = iio_priv(indio_dev);
+	int ret;
 
 	/* Configure device spi to output on a single channel */
-	st->bops->reg_write(st,
-			    AD7606_CONFIGURATION_REGISTER,
-			    AD7606_SINGLE_DOUT);
+	ret = st->bops->reg_write(st, AD7606_CONFIGURATION_REGISTER,
+				  AD7606_SINGLE_DOUT);
+	if (ret)
+		return ret;
 
 	/*
 	 * Scale can be configured individually for each channel
-- 
2.39.5



