Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623726;
	b=uc6yhjdvtx305LrXvgOl2YE9xMbYDHy7Typ2KHilD1dTTgY1bnPbmLG09EDUrgjru4eB
	 oYG16fnO0qDm16UWA5PVKv0yhyqpeSNiGXyrcP/R1ctkEION1BN+EgXsOJ/t691DwQnMZ
	 4iPsfoNkvx3RDtlGdWPZ1MNYULbpE0PZPuW3yUA54icXzdNICjF0rPV2kr8fPvReKFDX0
	 wjnCwlZTZwt5N78cKoXeD8Fwjszl9itDzGzmmwBG08y2yiwDZDzZv0cP1rYI9Wrs7qgEq
	 t6lvTbZT0BFxkxuH42dBEC5ogtOzINnMWkcdrt9ddFgIOqhxFqkToV269xVOrvgEMnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzataA2LJkn88mvy44s2ZDkl1WpqojaBGEuqRFJDVu4=;
	b=b674gtqmAhb1qVk16/d0jDbCsFJikXM92uhsxSHfZC6NTZqGIXfnlltSR41T5oypJ3ap
	 rBMgEOv02B51PkcGTR5NQ1sPKjo6xaOiFbtp9kVEWG9wSyM1OcfjpKaxiLtmb/GDhjj1E
	 FgRS1LiCQp34xzj6dQvPLpUlI4o3Kss9Fe2G2LV146p/hQQtQ75pqTMUSIGalfT+gEOe3
	 b+JRZY8N3nGj2oha46x7HGhDOdDF6abaF8bINYeFacW3jBRYxabi+v8obtKRDIsi+Kof9
	 nXBnW0qm7VPK1uJQ3R4r33xF5PNJHIxD4KzD1IUkXZZCxNKXYvu7fIG2HBFPjPVVl9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCVMAWj5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F371606A321;
	Wed, 25 Nov 2026 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCVMAWj5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1424B1F000C0;
	Wed, 25 Nov 2026 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623725;
	bh=fzataA2LJkn88mvy44s2ZDkl1WpqojaBGEuqRFJDVu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCVMAWj5iAV25yhqBx4mBOWu4dp51iIzklHkzz8BL0I/YBO8OGCWvz+trMQKLClCC
	 KLtMPlam2LHsSxhlDuQMWagGydy0fjnrGWbjCPguMCYCTz8RIVf2y8mwIiMiq5YYzy
	 zVHJEo7H4QedqPYxHNBATaQXsNfAh72p4wRA5Veo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 951/990] iio: gyro: bmg160: reject duplicate event disable
Date: Wed, 25 Nov 2026 15:38:38 +0100
Message-ID: <20261125143844.265678780@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit d0c8bd5d18a492d64d05482f4b1700e14df7ff84 upstream.

The IIO core does not filter duplicate writes to the event enable
attribute. bmg160_write_event_config() already ignores repeated enable
requests, but a repeated disable request still calls
bmg160_set_power_state(data, false), dropping a runtime PM reference
that was not acquired for this request. This can underflow the runtime
PM usage count and trigger a "Runtime PM usage count underflow" warning.

Return early when the requested state already matches ev_enable_state.

Fixes: 22b46c45fb9b ("iio:gyro:bmg160 Gyro Sensor driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/bmg160_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -761,7 +761,7 @@ static int bmg160_write_event_config(str
 	struct bmg160_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


