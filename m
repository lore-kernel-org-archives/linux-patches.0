Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626082;
	b=v0RShPkTyWo2Ar+36bBKJ0P/7aP8B1YvN9LCHWD+GUg3MpRWxeNi/os+H+W+IUHMdpW/
	 2bMt4/aGflLr5hTjIFEf9lmxZ83EcoYSUc6Ct6kmripdyVplSQthuGF8h4IDEAlBW8cvX
	 hvhKt7CTAj/Dgnj6QgNHkeYomAsOyShgI31tYUjDNZoHa06nQ2UJzfgJPSlyS5fq5y8Cf
	 tBhwlP6378Lq3MB7/RYhR/zJl74aMivT7TlDyq+f4gTPPlCk+Rt9Uja+n/QDZxwNWnTna
	 7fiGy2MSHUuid523tQUDPlPdgBVSRfKVdZ9yJLw5mnSGXT+GfpLx8YHxaVBzL1lSqXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LOKUZBcVaeTNxU1WFqv7AoaRfqL9Ccn3pZs9douZM3Y=;
	b=YOhicPDRRP/k5fRQFhGlar9s3t1ovHlCqOE2WT8sxcsKfG3CulkKNiCveHrBa57/uFZK
	 vsxEPWz7SkuHoO40fPbxuMwUjWQCcmU2kiNxLJ4UiCux1pSAqWvmo5PnCo7bJOEcF6ssi
	 edvgUFzBq8h8AY+DQy/h5ws/7ca9HkgP3/nb1ysell4E2NXu/7DlWWHT7ZiAun84N6QQQ
	 tV0hIgYIQgDyM8uy/5dDk0k7pt2DpIqcEXsilSQsDsSXko/8zPpa7eMhTEyFxjlrhElc7
	 BYOWmJytHk4RFdFV//7ZYLz/L2ii8+TYv6l4vYcW1abOmjSDG/HWE531UCljJOy7SGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBG+cn85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5D4606A31E;
	Wed, 25 Nov 2026 17:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBG+cn85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0701F000CA;
	Wed, 25 Nov 2026 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626082;
	bh=LOKUZBcVaeTNxU1WFqv7AoaRfqL9Ccn3pZs9douZM3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBG+cn85IZ8VZK58pd0J4QmLZZPNANCgtZpQh9OXEheDYHCPL5m36evo9JPfLQW0j
	 x/RxdzeTuDKJqF9oWDWL6ur0SmF+gvJmCIyysXsGuSmKIe92o4Qujfn1DFtBwd2Q4w
	 zYB61Xsqz42/KoZ2Zyk+k4d78/zg9XzTQJcchPSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 726/816] iio: addac: ad74413r: fix the values of set_multiple
Date: Wed, 25 Nov 2026 15:37:54 +0100
Message-ID: <20261125143905.985391775@linuxfoundation.org>
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

commit e6dfbd84b833ed595a5236b027357e917de28260 upstream.

ad74413r_gpio_set_multiple() walks over the lines in the mask and looks up
the new value of each with

	if (*bits & offset)

offset is the number of the line, not a bit mask.  Line 0 is always driven
low, line 1 gets the value meant for line 0, line 2 the one meant for line
1, and line 3 is driven high if either of these two is.

Test the bit which belongs to the line.

Fixes: fea251b6a5db ("iio: addac: add AD74413R driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/ad74413r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/addac/ad74413r.c
+++ b/drivers/iio/addac/ad74413r.c
@@ -312,7 +312,7 @@ static void ad74413r_gpio_set_multiple(s
 			return;
 
 		real_mask |= BIT(real_offset);
-		if (*bits & offset)
+		if (test_bit(offset, bits))
 			real_bits |= BIT(real_offset);
 	}
 


