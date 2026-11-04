Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826767;
	b=tIcxElIVymE2o0Y7Pzn2GQBFXeyY24hIhcyTE6Em5VnxWDsM45dbQ1a2LdHX3RYL1Q17
	 9YzZs+n2/+a2epQjkDsa03IZNgzKxWxQFY+d/dF1OgqPfFzgLsEjtd5d+5NO1g0Eu2BnV
	 x9kLAHffxYnzUSdaJeELuqtxlh5P6LRz3NKs23Kim6oHEbl3kJp4J+ZSXtaLlhazCgpDD
	 JmjGGyy811q9DRocHYi3QfQFezx9/bulf9Sgw/RupQW8bwDAssoMB8xjDWjcCBoic5Gka
	 ZNSd7ExWI8tIIuSfxBcoCiTcvv3LaQ1/ot+GfPN1YHNyfWu5clWvDGy31s6CTcazRhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6AcD74564+fWzf4IXqI8I1hz+MAyZ2Bz7ijBF8gJ3DQ=;
	b=XTjPcL4UjIjzMDbpSdKC87AJ9luf1dYNbBi7aX/lguHJobGEEoVdi+rFSj7lnxG2bbRu
	 bMWWZ01P7hiUglMqyje1Jkltc4P1G+e6RuVnZIYihr4yUg7Dj2EJ7TIbBPM4cZLZRYIB/
	 dvasvlNo8+MkFbPzWsLmAf2bcTCqb/YRrC4Zts/aET5zhB2W4m3uwPaKUPJqGuxnJljKG
	 kWseMcXvYKGPEdSV5MzSG72/BsQGSA5cnyLb6s5i6eFAnZuFO2aj1xF7ppVeFPSi41oC5
	 R991HGFyZ3US3PLWP7NC0+P9i7W+C6RA09CPcbiLEn8qHCxV5EpDP3DNLhXIDRHbA0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYudBqEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2960A2608;
	Wed,  4 Nov 2026 21:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYudBqEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A111F0093A;
	Wed,  4 Nov 2026 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826766;
	bh=6AcD74564+fWzf4IXqI8I1hz+MAyZ2Bz7ijBF8gJ3DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYudBqEweMzZwXTXHEbRNRexxnxP2Uw/vk4gXeEAsDEG5N3MKvDvMpny+PJwiAoVd
	 v1n/REugf7w0srPqmMOtUrdAEkSMb3GfZS8/Re7Gfh6FcZK+fn6tbCfeNblBeZTCJz
	 ePMmjySA9EUTIfZ5Kp/IiDk4OwN85p4JC5MgNm74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Schaefer <dhs@frame.work>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Sven=20Vaink=C3=BCla?= <sven@xn--vainkla-r2a.ee>
Subject: [PATCH 6.18 0004/1005] iio: hid-sensor: als: scale each channel individually
Date: Wed,  4 Nov 2026 15:55:37 -0500
Message-ID: <20261104211043.649485430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit cad928dad9a4c26aa56b4223dc2a29bca517fb5f ]

Some sensors have multiple channels (not just brightness but color ALS
sensors) with different scaling factors.

Signed-off-by: Daniel Schaefer <dhs@frame.work>
Link: https://gitlab.freedesktop.org/hadess/iio-sensor-proxy/-/merge_requests/413
Tested-by: Sven Vainküla <sven@xn--vainkla-r2a.ee> #Asus ProArt PX13 laptop.
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/hid-sensor-als.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 384572844162c..232cb58e0a9ff 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -33,9 +33,9 @@ struct als_state {
 		u32 illum[CHANNEL_SCAN_INDEX_MAX];
 		aligned_s64 timestamp;
 	} scan;
-	int scale_pre_decml;
-	int scale_post_decml;
-	int scale_precision;
+	int scale_pre_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_post_decml[CHANNEL_SCAN_INDEX_MAX];
+	int scale_precision[CHANNEL_SCAN_INDEX_MAX];
 	int value_offset;
 	int num_channels;
 	s64 timestamp;
@@ -186,9 +186,11 @@ static int als_read_raw(struct iio_dev *indio_dev,
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = als_state->scale_pre_decml;
-		*val2 = als_state->scale_post_decml;
-		ret_type = als_state->scale_precision;
+		if (chan->scan_index >= CHANNEL_SCAN_INDEX_MAX)
+			return -EINVAL;
+		*val = als_state->scale_pre_decml[chan->scan_index];
+		*val2 = als_state->scale_post_decml[chan->scan_index];
+		ret_type = als_state->scale_precision[chan->scan_index];
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = als_state->value_offset;
@@ -338,6 +340,10 @@ static int als_parse_report(struct platform_device *pdev,
 		als_adjust_channel_bit_mask(channels, index, st->als[i].size);
 		++index;
 
+		st->scale_precision[i] = hid_sensor_format_scale(usage_id,
+					&st->als[i], &st->scale_pre_decml[i],
+					&st->scale_post_decml[i]);
+
 		dev_dbg(&pdev->dev, "als %x:%x\n", st->als[i].index,
 			st->als[i].report_id);
 	}
@@ -347,10 +353,6 @@ static int als_parse_report(struct platform_device *pdev,
 	if (index)
 		ret = 0;
 
-	st->scale_precision = hid_sensor_format_scale(usage_id,
-				&st->als[CHANNEL_SCAN_INDEX_INTENSITY],
-				&st->scale_pre_decml, &st->scale_post_decml);
-
 	return ret;
 }
 
-- 
2.53.0



