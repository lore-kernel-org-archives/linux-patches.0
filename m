Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705746;
	b=gb55h8UxCWqYmWFcEfNYSoEFjTuwEOgyKQ2zdRI0OjCucBRZmhyqC2QW/f9D7PGV9yN3
	 1M1pjOa4HvHxALJEmaW0702Up+3+Hp7SKrpnT+wjFB5LnIXY0vWQTIVVnGFvg8nBYudVW
	 Ju2Td4VsTuJltJ8dW5d7fDn7nHinQTESaD27sdDtBXFT37etOfKyuu2LiGC8pCldctZ9w
	 gO1QXCBW52uuIXxVr/e0dnMZJb7/LYuLbIJIKi1XmJqQRV8yO37y9VUmHZeRa/3jNpyoX
	 gPyrbRZG2umncBz1GEbG9Ti0AW71ut5wFd4uE4eLWYXGUD0roBMCe1VqOUSV0sreknw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMm9UtxHqqZt/D/0hwjBhbHdiZbUZhoGme9Bt77tcvY=;
	b=fjgBG4QIfDYSSV+oRp0r3OOa8W03aMY+0KiljGRbHqE1sxQBAxeqETsqK2oaW/Wm3RoE
	 UC9pVDoPp5qn0KBdc/HA0LGkjUSjEi1AtEJCv/7QTl20JxEKL5j4H8ejLsSWJjifOkJVk
	 Au/diSmJJsBOcYHMOA4M89jRMyf7zMUgqt83S2iXgdQ8EftmsZWu0cuosyXOhpT+OcSSo
	 nLQad2Qye/BYaKFK7kagolbLgQGsZwQ6WggGe0wX/4rXgMkSHq0BZ6UU53Y/+tdBD2KJG
	 EB/lcT9QxqPIaUqzGOtc2q1p2HCmdsjxnd2d8NnCQSozo673GEzZPKALTEPsWeHN3QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ctynb51x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4316606A683;
	Thu, 26 Nov 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ctynb51x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B3E1F000F4;
	Thu, 26 Nov 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705746;
	bh=wMm9UtxHqqZt/D/0hwjBhbHdiZbUZhoGme9Bt77tcvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctynb51x2rL2qRMLb/hEqUwFWzeIdQLxdBGsbbzQswvVJui9mZ0aNhTbilsaFo6xu
	 z1f17WtLz74V3dPpHZeubk8Un8wTI1BJt4ISQhbKCs/E8Q6TrVAG6FiX2sHucy1sQO
	 RUg93fDvv1fgpxMNGCYkTof8DAYQmyO5vRpjx+Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 300/319] iio: gyro: bmg160: reject duplicate event disable
Date: Thu, 26 Nov 2026 15:41:08 +0100
Message-ID: <20261126144013.529394116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
@@ -767,7 +767,7 @@ static int bmg160_write_event_config(str
 	struct bmg160_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


