Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618412253FE;
	Mon, 10 Mar 2025 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627850; cv=none; b=WAuJTX07x3h6Pd3klh7zmG7JD+7+8UjjAh4RriqUw7ldFkpV2NCyiGfY+AiHnQKgC6g9VatRRpZ5BwYcTlSPuuQsl0WuswOcjuXc9P2NAv7tKqurd4DdFECWijHtFV8YPKY7LWmpT5iYOdxBGgVpKQ/JMOeWGkbMWJRTua8h19k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627850; c=relaxed/simple;
	bh=qCv9ySk0Xeg3zVanPCdtUqEwPzmGpOVAIu+vMLUtkfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQ1UNHHumIWcYunLz/7JNVFnbnPQRYThr+mms+Q8CHSk1rZBTy1xGdyO8f8mwPMchm4IjgKdg8bpOExbciWtrXK9xP/ZiTciEYtNMJvAYcHeJm3AkR2tjvZB6bOF0hT8iMPeOTULaD7gwQN6uV3OyYZkdfkEWXdhkHfzl061otU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1nBvElP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1nBvElP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D942BC4CEE5;
	Mon, 10 Mar 2025 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627850;
	bh=qCv9ySk0Xeg3zVanPCdtUqEwPzmGpOVAIu+vMLUtkfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1nBvElPXaBspmZJsnq4R9+u8EShjjj1kVGs+JijulekQtwqBxqj18runHUMZRKL7
	 ePJaokyE5PMZsHhdULIxFm7WHftbqOzjPlI81qVIVfNyJZZ/HEo/g+VxrxAwT/kGBL
	 moR+CMVLkOxe9ag+jeMNNyv/4+7aWvW1DGp8CTwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Burri <markus.burri@mt.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 252/269] iio: adc: ad7192: fix channel select
Date: Mon, 10 Mar 2025 18:06:45 +0100
Message-ID: <20250310170507.840808819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Burri <markus.burri@mt.com>

commit 21d7241faf406e8aee3ce348451cc362d5db6a02 upstream.

Channel configuration doesn't work as expected.
For FIELD_PREP the bit mask is needed and not the bit number.

Fixes: 874bbd1219c7 ("iio: adc: ad7192: Use bitfield access macros")
Signed-off-by: Markus Burri <markus.burri@mt.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250124150703.97848-1-markus.burri@mt.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -1082,7 +1082,7 @@ static int ad7192_update_scan_mode(struc
 
 	conf &= ~AD7192_CONF_CHAN_MASK;
 	for_each_set_bit(i, scan_mask, 8)
-		conf |= FIELD_PREP(AD7192_CONF_CHAN_MASK, i);
+		conf |= FIELD_PREP(AD7192_CONF_CHAN_MASK, BIT(i));
 
 	ret = ad_sd_write_reg(&st->sd, AD7192_REG_CONF, 3, conf);
 	if (ret < 0)


