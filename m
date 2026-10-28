Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211078;
	b=30zf97BS3jfm0d20z6VfczAUIyVdt/OpTq/7gMAP9PYETloh58kh630z3oUeBCEe3BXK
	 9hRtYBfxFt2QRsSJoe1KbHeAK8NM3B5yTJflStYIp4ld/OHzl4KY19Nl1O1S8K7otQn4H
	 A5QQtJ5PVaDBhSuEXv4SCWqnTYCK6rn5Jvf0v1gfUJLNWxsotJ7kxNQXX+U8ckdRZUaqt
	 ILstKNje0W03oVnkCBciaXWBR3hi6txo/0ofhggTmbXQt+kjOlBaCidjnMzs/gqi6Lu4N
	 d/dRHWtcJYl2s5pej+s66oKsXLPKqF0gKyDMtqkdlYs2PISnOOKau4cXHI5X5W/rHrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlH3QaRIAdGFz0VrGKodlW95/utR7qyVg4PDH0Q1xpQ=;
	b=YcL7Fokz8iY+EGdodl9641NNZlhei0zr8oWEtZv0l9N/meuEbAnehjwirzKA66Ut//gB
	 7c3LxYNjDAWaoi5xtOWAVcagqBBfKLD37EmJEwM+eWWU3U7XhELH4/XLymNhDok/83q52
	 EdaSUFDDJzgBEWza1qSrETxl/+nBkfw12pPat0fjtD6ES9q/I9gpkijviRhuGwgHFUYJF
	 Sjh+0SU0t7nIjw2Gn+/cT32i5285Yyw59sVbPtNVrH5uqeSRThQNj+HJXfd7nbcEZCT2r
	 z+0x6HIMPfYGWzWVks9bOUoum37XO0jM7eS4w9vDl4PA48Q1FTeutBg0QuH6CpRJ8sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psEbUY8y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C72460A3803;
	Wed, 28 Oct 2026 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psEbUY8y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CBC1F01828;
	Wed, 28 Oct 2026 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211077;
	bh=tlH3QaRIAdGFz0VrGKodlW95/utR7qyVg4PDH0Q1xpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psEbUY8yVwxTSbI9ttdAQe4M6ofzVYo2K4NqKwFd6snjwUBW+SYtAvVXiqHOcUE2t
	 SrH1CdAZVa+DOl0NWRhlBSJh/skBhQnWwRRtNO161fsQsjaIwYgPjY1LFnZ6BR5++g
	 PoC+c6fnykWkC66XfmfwafuUUhAKoy9HCAlsLa48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 251/571] iio: accel: kxcjk-1013: reject duplicate event disable
Date: Wed, 28 Oct 2026 17:56:38 +0100
Message-ID: <20261028170013.960044508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit dd30c10ff60d2b30386c23bb7c61cc97f2385c97 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kxcjk1013_write_event_config() already ignores repeated
enable requests, but a repeated disable request still calls
kxcjk1013_set_power_state(data, false), dropping a runtime PM reference
that was not acquired for this request. This can underflow the runtime
PM usage count and trigger a "Runtime PM usage count underflow" warning.

Return early when the requested state already matches ev_enable_state.

Fixes: b4b491c0832e ("iio: accel: kxcjk-1013: Support thresholds")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxcjk-1013.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1050,7 +1050,7 @@ static int kxcjk1013_write_event_config(
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


