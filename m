Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605332EA492;
	Tue, 22 Jul 2025 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193403; cv=none; b=MCcxmyZBAYywJnp/zTuZUVzYxxWU3hN0RJfs6ZUKz28amPDlOC66U1I/SX/1TkhMk4aE4qBPQFMnDT26lqMpOeteptqqqfF+uaGwI+w6S81pq6tKeQgGS5dm6gl5pcg1gIYh+iGw2hM0MGmFsuoh2z9xH/t8SL/E8329wxIsqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193403; c=relaxed/simple;
	bh=Ui0Dc9pHR1QuuPCplltj95P7zInh4C5cHuEYVjYobXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siQV8WaLvXm6fOB5X+NDhsEyzcb8vtlwFavr1qA03rrUrMK7eYeOASVvC17YIjSFdS7YiWYoluVBK75zjOOFWevrcSQ/7c2xn+zx+p0SBwNVJyeJ7ye4X+VZjLwRvUyCmNpc9r7qfgpwpcW4Nmd/kXobd9eCo18Q8o5A+yrallE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cORpeoT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cORpeoT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9944C4CEEB;
	Tue, 22 Jul 2025 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193403;
	bh=Ui0Dc9pHR1QuuPCplltj95P7zInh4C5cHuEYVjYobXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cORpeoT9sM2L+1P8ByPq3LQ24ik3Iut3Z7A27w6HDl24JBulVZw4IOL0vZfa1n/zT
	 +hVTp4BTZ5QqfEGRGh1llYSEfrAhOnt1tEnVwf9+OZg9GXfcLg8rLef5eq3h9zcZl1
	 rX0ZsNKYNea7ZsnNKyJ/dnG/BCJcKRxCrR2QCigw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 082/187] iio: adc: axp20x_adc: Add missing sentinel to AXP717 ADC channel maps
Date: Tue, 22 Jul 2025 15:44:12 +0200
Message-ID: <20250722134348.779575844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

commit 3281ddcea6429f7bc1fdb39d407752dd1371aba9 upstream.

The AXP717 ADC channel maps is missing a sentinel entry at the end. This
causes a KASAN warning.

Add the missing sentinel entry.

Fixes: 5ba0cb92584b ("iio: adc: axp20x_adc: add support for AXP717 ADC")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://patch.msgid.link/20250607135627.2086850-1-wens@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/axp20x_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/axp20x_adc.c
+++ b/drivers/iio/adc/axp20x_adc.c
@@ -187,6 +187,7 @@ static struct iio_map axp717_maps[] = {
 		.consumer_channel = "batt_chrg_i",
 		.adc_channel_label = "batt_chrg_i",
 	},
+	{ }
 };
 
 /*


