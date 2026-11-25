Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626267;
	b=wN4YZ4wDf0BCXkaWgjDpF89nAaBvUD2ugQZWItz7e7k5I9/IpXSz39dTEqdH03V/PPLz
	 ycWdSJyafN41/Knv+S7JeRkg/+zfknAb37XmdFDbOud86rIgqExwxJskyVFthQjnwFQya
	 DKy2aloqvqseLIL7NeP52DkUEu34NsCsYtvooyeZimxswhgi2i5lAS8/aa8JMJXP9kEq5
	 WM0lekhcjp8hCbxuxpin27gc/54ZBdjjTvOImR++BKzR/bW0f0VQGtXINMBcepWyZLryX
	 +pxdu4Qdhu5FK+DTDia6y4oQ4YjwAQvtP4iB1BzeuFZ9At00bi5EG3Urf7g2EsENkIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lVZDOayoeYEimmb7Uq6mXEeALLY+THpPrOpkxGACOkU=;
	b=xB58AidSMPYXZIonwi9Kt9HN87c///VONDopBTeNxFA9zMTShk3W0CCBmlL9beoz80C6
	 R+YgF+6ZlPFJzaJMeNB7u4VF5Z/F7v8SSQ6s5yZ8KdRw8Rcq3Ma74upAx5qqwHWfw+CWU
	 HgQWuJFSDy1wZp3BO+ivVF0G/zCyAw8UqjSwEMeN1KOkpRF5faXiuitP44JRNxSczxqPe
	 sCgD1XuQnGbI6MFQ+4imwcUy5t8o6Awak7eW6vCSfXM8zgkbPpB+edtQkfo5rEjLs9q+e
	 QDogso7ALFPmrJK3I2SrtqQcP1ZnrdG+j/yn61XBu2dKz2xON3bwzlc51Xo8sBlHRDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFGCfd68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493E606A31E;
	Wed, 25 Nov 2026 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFGCfd68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF751F000C4;
	Wed, 25 Nov 2026 17:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626266;
	bh=lVZDOayoeYEimmb7Uq6mXEeALLY+THpPrOpkxGACOkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFGCfd68qVUzYbN9NelPcvOACvKdRpx9CLZc3LtnaZ5pokUNmiA8VHIrB82Ia35V2
	 hCt6U/R3bBzkzCyq1Tai2Ii/vtgNlP65yS9pv/1qvG2BhgcFM5fO1z58SsEph26KSi
	 u5/5mPOc1Iu7t0PakcnBE/x+n09SCwGt44H1Tfb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 786/816] iio: gyro: bmg160: reject duplicate event disable
Date: Wed, 25 Nov 2026 15:38:54 +0100
Message-ID: <20261125143907.366163247@linuxfoundation.org>
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
@@ -766,7 +766,7 @@ static int bmg160_write_event_config(str
 	struct bmg160_data *data = iio_priv(indio_dev);
 	int ret;
 
-	if (state && data->ev_enable_state)
+	if (state == data->ev_enable_state)
 		return 0;
 
 	mutex_lock(&data->mutex);


