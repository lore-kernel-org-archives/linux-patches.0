Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623658;
	b=AI+grXVo1BII2pwxCAfoE92nJuyua7jQHApVLWJ3klt5zlJD8zJTKliPmtQkhUNytbKO
	 WoYBBmRxGpG3HCH/sOXIOn5gWn+jUBtkufwzRZs71cc5BJQep/4sETfzRfCcKTHNNyCAA
	 m4bt6iWlPsFVyw168EcuvwxL/9VybsjNNEFxBKf7x5CTuOwqpItF1lpJ7XbJNg6SNRzEM
	 QHl6WfC8TZn6zVTJPRtO6PglXbMmwpt6dXxVebEyRN/BAr6wQ8bsFrJtsSU23K1KZ+Df2
	 ukzWLTGtdq6BDMCNw/b1JGCKYoXUlHE1TkQEstFp4BbL6HUNagfukCfrVdAf8aJkZ7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8borGf0UlJIbSzB5iST+1oBGYI6/AI13Ia8jLsDVrUE=;
	b=EpQgDcVGVBbc9C33ef7lsl+69gSSKc4ogmKkE4CVSARcf1Y26dXqzC/cPXF4ew+ivhT+
	 Pac8FRHi5oZVe0/Kq8GHLXtookKu3VqZsOA5LILlaNwhHfcQCsHYHAhhCnlapwgLUzq6q
	 owYZlWlnwIAfY8wuwe6q0bbTJNzWYyGnP8FeyPztNs2o5P4q2GLiaakiconFcW+oqrgzI
	 eC7BlwWBYiM+mBRuA+U2FD+h2K2epWzI0kV7CADmV0jUVqJYtJACjIXBI2EIwq107we/k
	 bOKyPtco4+Ep8zCN7+ZvpKKffp0AG+nByehYWwcLy1Fh2nLZRheNCKyLLthLZVGBPWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DeoWVs9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2FA606A684;
	Wed, 25 Nov 2026 16:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DeoWVs9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3131F000D3;
	Wed, 25 Nov 2026 16:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623658;
	bh=8borGf0UlJIbSzB5iST+1oBGYI6/AI13Ia8jLsDVrUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DeoWVs9EtbnXsAI2i95xq5lUMlLL8bWe6t+kdgdS97U0NQozNooz6yx4FqECVoFU
	 IwFfwNddygL3TotQ4XdksUqBdpyJzu3WNhb6Z7dLbP3fKHbyxKNSqbq193Av86gua2
	 WIkGypNOLNwdFO/x3L/duYIZYJnLvnDZSyEZtZys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 886/990] iio: accel: adxl380: dont stay in standby on -EINVAL
Date: Wed, 25 Nov 2026 15:37:33 +0100
Message-ID: <20261125143842.766287812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 4c56180167ea4d419a0578545bf62110494b563d upstream.

adxl380_set_act_inact_threshold() puts the sensor into standby, writes the
threshold and switches the measurement on again.  A threshold above 8191 is
refused in between, and the sensor stays in standby: no samples and no
events until the next write that succeeds.

adxl380_set_range() has the same problem and a worse one.  It rescales both
thresholds for the new range.  If one no longer fits it returns -EINVAL
with the sensor in standby, the new range in the chip, the old one in
st->range and rescaled thresholds in the driver's state: from the next
successful write on the samples are reported with the wrong scale.

Switch the measurement on again if the threshold is refused.  In
adxl380_set_range() see whether the thresholds fit before anything is
changed.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl380.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl380.c
+++ b/drivers/iio/accel/adxl380.c
@@ -341,8 +341,11 @@ static int adxl380_set_act_inact_thresho
 		return ret;
 
 	ret = adxl380_write_act_inact_threshold(st, act, th);
-	if (ret)
+	if (ret) {
+		/* Leave standby also if the value was refused */
+		adxl380_set_measure_en(st, true);
 		return ret;
+	}
 
 	return adxl380_set_measure_en(st, true);
 }
@@ -709,6 +712,12 @@ static int adxl380_set_range(struct adxl
 
 	guard(mutex)(&st->lock);
 
+	/* The thresholds are rescaled: see that they fit before any change */
+	if (mult_frac(max(st->act_threshold, st->inact_threshold),
+		      adxl380_range_scale_factor_tbl[st->range],
+		      adxl380_range_scale_factor_tbl[range]) > ADXL380_THRESH_MAX)
+		return -EINVAL;
+
 	ret = adxl380_set_measure_en(st, false);
 	if (ret)
 		return ret;


