Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312A94EB871;
	Fri,  9 Oct 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556915; cv=none; b=HtGLzO0MTeW/k5ujKfDKDUfXz3a4pVOmOVRZmDByiOcNDoXH6pn9R94MyvhzLOaTnLrNYC912jaU6AXGPGYDeO8PlvI6rHFzjglWebWi6THZulxkUumuVERpB+N6QXulnvyjtl8uARt5FbSM4Qje7twm+bhsf4zNiSFTeMKds2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556915; c=relaxed/simple;
	bh=nQ1Op7y6p1chB4SlUZKKV2HZN/7XZi6WJ1S3SH6P9WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIPZBJTIPOZRZbGgOUDIbCmMMEjnVDZfXK4gvRYzClW2CUbMrgvW1OAV4cawribdq/RcA1vOWgEACefC+mVofqzo++RwjVa8Yed/Ji8lKHj5MDJQXNK+5LgKu0EddTMPrks+xh+ISRlBYxzn1nFmH4HLXoSpYwDMxvVvmMT7+Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0KelhFl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0KelhFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CEB1F00893;
	Fri,  9 Oct 2026 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556913;
	bh=31ShUIT0+e/OOeo3MZEmNiE0B8h3dlnGkRYgQLcqlJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0KelhFlMZGRwegUXI5Kfk4cE5lD3nUrhu8lOyy8KlMG0rH9QHXpY85g6Ws1HC8b3
	 4EgaqRVL6st4XS+wXg19db6iVyTmLhsf4xsyfWr6f1n5xj6qs8sfKfarwy6mE0qw6R
	 ADUPV2qKvZTM2gQIANFVMqbmbtt61o4suL41Aw2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 313/403] iio: adc: rohm-bd79124: Fix rising alarm
Date: Fri,  9 Oct 2026 16:11:14 +0200
Message-ID: <20261009140959.540756596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -554,7 +554,7 @@ static int bd79124_enable_event(struct b
 		return ret;
 
 	if (dir == IIO_EV_DIR_RISING) {
-		limit = &data->alarm_f_limit[channel];
+		limit = &data->alarm_r_limit[channel];
 		reg = BD79124_GET_HIGH_LIMIT_REG(channel);
 	} else {
 		limit = &data->alarm_f_limit[channel];


