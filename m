Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626287;
	b=gQZYivEoHjjEppZLL+P0JYYmg7RWPQjaNPSoacjOEUcfGcvalg1YR51+5Zvs0JhQ7ND7
	 3BIefyE3gzc9l0iIH3hcDjh7TifzZnF9CLEMwt0I8g56lmzH5kbSnVAaVNN6GZidCuRLo
	 ofxpD4hzL7lsxj6ZgzFiZolKDbfifp05KN4uqOFusHXw3g9Cc1lTUVVtH8/Dll26Xgf4W
	 hm1ABujKGjoisH4DrVb4eykKrWT9Jj7YhDNMFE0FnzfJeJzxh3QEWMVbUfJCKwVnnd2NZ
	 UJlVvHHqsQVUTMpkxebbZr1IJkpAHY8m0B8jNRcwrxb61NEdY7m2pO2RmiPx7/191lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jrFdrEs9BjpkTVaDoUSvezaGfKtFb1hNcDYoG2Hca28=;
	b=uu//vfnltT+3B7/G2/nQMpbGG+qAy0PpF5i0nBLUy44NYhBXGSNQQgLDKJgq1KFYOGzr
	 VNXt+Yhe2PTDlCOoBfVXsf9CzB1pii+xbIhrUfEJ3wEWDulrlZnoEwjONZdfReHrGtOSv
	 jYKdxf/wHtlD0byu1zlttOP9Ld8jEllP0V7zPDNfwSc0dGxE11P/YTWWWhA2HE2DBRVxv
	 mP0rdLKrDJT+EWFOWvxSw3a0ItrZywzWTCveND8uSItniKsEXSXai7o3bt9UFcQnCMG8x
	 +6exOZ6D98Gw4XyvKXp8rDJ1D6fgzm9ayYNeTjyU7q4XrrjZX5KSnlN4ygwKp1FG1oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DopcJnvd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61176606A31E;
	Wed, 25 Nov 2026 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DopcJnvd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD551F000C6;
	Wed, 25 Nov 2026 17:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626287;
	bh=jrFdrEs9BjpkTVaDoUSvezaGfKtFb1hNcDYoG2Hca28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DopcJnvd3QK6Bw71wXY7yVI7nH5YgsVxapDJG1PhR9iyGxPbpGX1DPgL0t0yEhk3c
	 s0gFFcWiUbxWd7P9jWYUvgCm6kCzJdYnBo18mRe93U9aR+fHUCWlmkeNiz1TiQOtTS
	 Q5+RlVPYHgJwsG1/OtvxRg1r6onlPD1vi059Xtk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 792/816] iio: imu: kmx61: reject duplicate event disable
Date: Wed, 25 Nov 2026 15:39:00 +0100
Message-ID: <20261125143907.504370715@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 9a60b35fe45801d45454e1efe90569c9cc6ea736 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. kmx61_write_event_config() already ignores repeated enable
requests, but a repeated disable request still calls
kmx61_set_power_state(data, false, KMX61_ACC), dropping a runtime PM
reference that was not acquired for this request. This can underflow the
runtime PM usage count and trigger a "Runtime PM usage count underflow"
warning.

Return early when the requested state already matches ev_enable_state.

Fixes: fd3ae7a9f21c ("iio: imu: kmx61: Add support for any motion trigger")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/kmx61.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -946,7 +946,7 @@ static int kmx61_write_event_config(stru
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 	int ret = 0;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->lock);


