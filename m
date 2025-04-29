Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCB4248878;
	Tue, 29 Apr 2025 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945684; cv=none; b=g4kukOxw+12x0KGvpuVAgvDIce/ciGqlOhPKyHnS3UGuYbMgqahhdXuyqR1IJQQ82i84fK68NFd/XuACWplK/sC8NTdImEv9RWh1Bt7YZEPaQz6vLthjatQ73wrl9bXxnKSfXvy21P0ACZOmjBU2nc9Ld4vrtNDEOyopvjprNWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945684; c=relaxed/simple;
	bh=Wzl/zi261nCO/d53sXatPOXwLjrGMj/xuQWszMVm4mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxkubDfZvcGnjwLv6ntgibR99P9lmoyzWEkeEzW/zxGXDJ0jcTmuog1As4bN8bzyZDTryfsMKSD/imwP3528BYgFOhEkgHXYDDvZo8O4ps38x/EaVo0LINcvKx/1RVt3GYf7n7W8FGG9X5XryrsxcVbicYj01HBecvqMoY47NWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlZTPR9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlZTPR9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA6C4CEE3;
	Tue, 29 Apr 2025 16:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945684;
	bh=Wzl/zi261nCO/d53sXatPOXwLjrGMj/xuQWszMVm4mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlZTPR9m6/1UHDY1qRGwHGsWweR16kKUOc8JQT+GSztZMWaxfyztCUZQ52WaRnX0J
	 plUbtrAtpz92GmOIIaxeQu60lDSaWpD+t7t2hN9gjhzJgd8OOGTgcUWc2CnU3hyCy9
	 uYfBGwFvcVfq3YkreEODaCX97Wvlmv+IpOIMl9LU=
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
Subject: [PATCH 6.14 015/311] iio: adc: ad7768-1: Fix conversion result sign
Date: Tue, 29 Apr 2025 18:37:32 +0200
Message-ID: <20250429161121.655922358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index c78243a68b6e0..157a0df97f971 100644
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



