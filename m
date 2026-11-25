Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626079;
	b=kJiztjI4TzJdlkgQOEBz+CNSQ+viB9G+vRJhgJUf5yCbftjLW5WcBUNra0+268KX5v2s
	 yE3Jlp6uX+Ue3Ai5m5LTF9362q5uCLSurXraSMET7yPaSgylqCCb/QjTNfkFzAXVa559n
	 2Wkde4XM74oDV/r9OYrimQ0JSrz87ScRX9Id+qMLnvrqbDSm27qNOC3D4GS2XpB26MTwu
	 C4cLzJO5Py/rWneTmf7vhLbZIdaygCMfbSrYnpCkEibw2J5QKFBFswXNmwCrqWOwvJaK4
	 fk84zY48RuOKSO+YOq+EaUuP71Ung2QsFCAnYeiye4+el1Gi9mQ9YPjKJNgeAzXc/xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Gmquu17EhftoPK0jXDLX9mH9DXD9jKGiwBeW4NLl2bw=;
	b=OpPd12HNAnHnlj9JE9M6Tft5tEWw1hPHOGodvCHOv2XivBXC8I6CbfEdtwkCO5S88XiL
	 FFLRu10pLNnafh7gmm2FuUQRaLfdRXujtldLWS4xcgYIfSsdwCKkmjn3sGuSdJ//ADQ6x
	 h2KvYC7+cQ6w/HO7YluXqLRCI+YK6OFv7G4Mvz0uYIi6hVirYFmPDe0JHMMEt17sNL8CC
	 9W6j5GsI7ibNgZMxUoqPnDf6qG9deygEu1sCJzvZ6YngA9Jzvv+NIE2XSoKzXTAs5SBfD
	 ErFZ2uI6f7baaDUQYFuSbc9EwlKSJDIH79bSgqlI39T0tLGeB4Z68wwR7pagLTqHOgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYDqKbse;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930BB606A323;
	Wed, 25 Nov 2026 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYDqKbse
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852351F000CA;
	Wed, 25 Nov 2026 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626079;
	bh=Gmquu17EhftoPK0jXDLX9mH9DXD9jKGiwBeW4NLl2bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYDqKbse+yfdyUDqOUS9cvzBy5wxhBxR9Xm49May/gPDzKDgW8Q+F3F1PGo3/6KnZ
	 gqp6b2rjoAXVFtKD8JJwnNqsBBa8mr27PPEFFW2JywOeobOzlUs7z6KKQgebeW3vwe
	 hNrx2xlmo/43v6Wuu0Q+KG7QhIiPbad6flyb0aaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 725/816] iio: accel: adxl380: dont stay in standby on -EINVAL
Date: Wed, 25 Nov 2026 15:37:53 +0100
Message-ID: <20261125143905.961248050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


