Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F51253F20;
	Mon, 23 Jun 2025 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685747; cv=none; b=DGPXwlGlFE672Md9Smtpizx+0V+f+ADNV8jFxoUJROW975t4mao8C+cNDOtQCL70aZpPq+rMfrDzJkBGqnlopgB4iZzAl/w83xWQHQgKKM0ygBuh0hGs4dEO1Kg0BVh91QxJ0fBHMZhtsOVkFI9MHqDuWfR22a4udZdr586rNsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685747; c=relaxed/simple;
	bh=RRCXfEprhEVtcpATvkLNC2zN7MM/jznvAmeCaX10BsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ek0N19s8SlxxkzS3zVJOUsl67cpWFC/cYoryFP1h8uhRdNrBSV2cxVCFL0q7rWxXZ2ideAe4sXBVCpqeEKPgUsFebFFm/lPNiNhd6BoJS6695yns5SWUpxsqfHPjm53WOBiBDbW8kbhXpUML5CCHLS+Qx5OoleA2y/ijFc/p4Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlaG3zzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlaG3zzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED60C4CEEA;
	Mon, 23 Jun 2025 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685746;
	bh=RRCXfEprhEVtcpATvkLNC2zN7MM/jznvAmeCaX10BsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlaG3zzzIJjc/9ta8ezEGXHujZYhIuGkcQYZ90QVprcXTHgZrwsQ1XDJoslcqOxp4
	 FSKpISHsEDE5jOKvcc6p1lxmPaROpKs21F+0a8jB1+NgzX/InDacH58GgUUMU2KR6z
	 Qb5z2oAghonFz2Zocnl8FkInVKBrdPZzYcHiYquw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/355] iio: adc: ad7124: Fix 3dB filter frequency reading
Date: Mon, 23 Jun 2025 15:04:53 +0200
Message-ID: <20250623130629.563496455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99d1288e66828..503814fca4dc0 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -320,9 +320,9 @@ static int ad7124_get_3db_filter_freq(struct ad7124_state *st,
 
 	switch (st->channel_config[channel].filter_type) {
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



