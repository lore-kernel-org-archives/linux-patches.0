Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D8EC2E0;
	Mon, 23 Jun 2025 21:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714272; cv=none; b=OusAT7m3nDa1iNBvIg9cbL4gDnlL0v8mC/Wg1kqtVamVsy2Hgl4hwCwjBULcFLHVVYGybNncqSWVAnYhbNW9Mn41XgQ+OE4F+Mon6OpNKnZRAEF0zgtfBY/8jLCZ1WYMGPAayZHSZa7b900p6HYVh5gZ4LzGRDp2OvqaUpciicE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714272; c=relaxed/simple;
	bh=DJnBrbLInMZN9z4rT+cprh+xDwGaHLnGrM1zGUj+Y/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gv/yhsGQ67eVWdWPaXIBjrUkt/2YnHw2mUlsFTXMOStjT2xqA+jHzSZCR5OCmV1e9E5jXoP/r5LinXKIzFQPx5xdzswdsjLevfTWdznpcOYATYRKFIkzoIIK0E8GWFKiJ/VPp9Hu5YrMM9Do8U8ZGuaO18YKF6yizgI2YrJwUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PMsCFvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PMsCFvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD18C4CEEA;
	Mon, 23 Jun 2025 21:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714272;
	bh=DJnBrbLInMZN9z4rT+cprh+xDwGaHLnGrM1zGUj+Y/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PMsCFvn22+Ei0zSfMBxoz1NtpRJyhmO5SuAi7ptg5r2PcT7C3niYUnXl5Uax6NjP
	 go8zBIe8Unk7tq1qTnY/7MgS2NRHM9NNayVwI4eUmx8GsAaUw8WEgnqd4u6FooMwID
	 btKA2xZe+kUladUwGHz0j5p5cXqnEaqrS7j7RxlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/508] iio: adc: ad7124: Fix 3dB filter frequency reading
Date: Mon, 23 Jun 2025 15:03:27 +0200
Message-ID: <20250623130649.263151419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 8712e4986e7ce42a14c762c4c350f290989986a5 ]

The sinc4 filter has a factor 0.23 between Output Data Rate and f_{3dB}
and for sinc3 the factor is 0.272 according to the data sheets for
ad7124-4 (Rev. E.) and ad7124-8 (Rev. F).

Fixes: cef2760954cf ("iio: adc: ad7124: add 3db filter")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://patch.msgid.link/20250317115247.3735016-6-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 307a607bf56c7..1e0af424f34f6 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -299,9 +299,9 @@ static int ad7124_get_3db_filter_freq(struct ad7124_state *st,
 
 	switch (st->channels[channel].cfg.filter_type) {
 	case AD7124_SINC3_FILTER:
-		return DIV_ROUND_CLOSEST(fadc * 230, 1000);
+		return DIV_ROUND_CLOSEST(fadc * 272, 1000);
 	case AD7124_SINC4_FILTER:
-		return DIV_ROUND_CLOSEST(fadc * 262, 1000);
+		return DIV_ROUND_CLOSEST(fadc * 230, 1000);
 	default:
 		return -EINVAL;
 	}
-- 
2.39.5



