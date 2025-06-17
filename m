Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054F38F54;
	Tue, 17 Jun 2025 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178682; cv=none; b=L4zX+w8ZhHa/pAJrU/b4wEWMlt5gnQ6bwwTyJfLoBZt1t1KEA/TsuBqzFQYzG/qOokuUIxs31QZxKcHM3/xCcvDYQp5y0+x26YZ5JWT1NMuBHr/x8qdnFfUyeX549LeuG87N2EjJ+rAVQ9ozixF8iru6bGFJP0FtlBMe/VfCmWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178682; c=relaxed/simple;
	bh=9Z+XW2vy53Qr1Sj7gucB5nEwTNxkm6KIJ0UemzABZwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnZlfo/FyNtirU1X+seQIRf53z0etAOSkLkB/QbzoikAuup3L6uPaTK4ulXWa3QQOY2jCi7cBS+ogkNfKZqFM55YOeHsDD1+iKL2KlXlI2ugOFh+HPtT66/ORWiseWvODQ0Ez3X27XjmS51Z7hBcIFlYYz2TVIarP7a7jTifzdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqZkWvOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqZkWvOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FE2C4CEE3;
	Tue, 17 Jun 2025 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178681;
	bh=9Z+XW2vy53Qr1Sj7gucB5nEwTNxkm6KIJ0UemzABZwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqZkWvOs8IqHgmswqYGWJouMb2PSI93vlbaQmc6Uti/oonCirExreERjePEbsA7Gv
	 ArI/iZvUeQJAus4hxKcC4LBJ3+6UIoh+fOOABOe5r6swoOGWPV91Gr5dfsoxQSy882
	 xynzaxxYu5EFtT4PPEr3tsOXHU+A30A4tHg2xwTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 522/780] iio: adc: ad7124: Fix 3dB filter frequency reading
Date: Tue, 17 Jun 2025 17:23:50 +0200
Message-ID: <20250617152512.772837592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 3ea81a98e4553..7d5d84a07cae1 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -301,9 +301,9 @@ static int ad7124_get_3db_filter_freq(struct ad7124_state *st,
 
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



