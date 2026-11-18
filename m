Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043089;
	b=ksLdwuQmkMbnO3gkG3wdkHDbsnlYBF+Q5StEXWtVGJGBO7V3fqFrxOi2VQB4cIcs7WVA
	 rhD6aDxPs7+MhPowwqJvXT7STz2fM/oaaMWXuVHVnmH256ZUYp/rJYIA+Oma+nvZnwjB+
	 bTxnkuQ5+3BkxE61B54ri9kspZFAz2hx3axT0m2fc/g4KNVxfufxOG7NSn3EVeOicsrEI
	 pwTeb6GNQE8L60EQ0bX5MzLH3G2FlZZ9sCq4Zjml5SUF5O2irbjpBw65SAcn5cILJtr+u
	 ypnQq0sTZr3429WAT2efcwLpSmU+KQieDwVe1PylEBZPaudgerl1/EHQFhtFpiZTBFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qe3uJy0r2lHcBB4DFU3CAH/yEYhy5eFpzs9e45luPLw=;
	b=ejd0YJ7yiF8nxZ8geXpnfPvdMVTCkuq1QeLzNKNbchngwBUYHwZ+EV6EUrHSLGpOp6yM
	 U9jQIff2qLRrk0i3AjAunNo5qUnJZwnxUlK2rCdy7QgqelWAK/vSgOkZKR+M+38YPWga+
	 ZBzXlOxUCrLaf6AThXzRpdyPFFPDiUhdhqzTqHo3ymjhn8FODpFtXZOAbsDcLJ6+qovsl
	 VxTHsTDlqYz1YhaxbmBqGidECoze5HfxL4hJieYgSchAo7I2y/RyV4mJ3r57rL04mC2K2
	 WSV7pR5N1VW4GJxgDsk6UqnEcyMMSmYi9iG71AgJIZmx2a+cx11wJnsL6q1Kd7mhXcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqalhWEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C983606A31C;
	Wed, 18 Nov 2026 23:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqalhWEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFF21F000C4;
	Wed, 18 Nov 2026 23:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043089;
	bh=qe3uJy0r2lHcBB4DFU3CAH/yEYhy5eFpzs9e45luPLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqalhWEZYJp5/l6ZhC15xqY5X28ukb218UdOwvfV/60D0Sx0nZKmLTr+F/XH/BEK0
	 dTrbNf/URbhj0V6Hu2tVtTFF+UMI0qJh+Fd4pnRN/EtmulPAwz2HaqCeQqzH2ol5zl
	 2/M6RphHZ2u7aVaiOMGj37YsGbJeyUTyxgQTVn64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0086/2857] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Wed, 18 Nov 2026 15:18:40 +0100
Message-ID: <20261118150204.382620613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jurison Murati <eng.juri@gmail.com>

[ Upstream commit 3fe797a12bfa9a49aa998ee722e5f25c957b9b15 ]

ov8865_s_stream() takes a runtime PM reference when enabling the
stream, but returns without releasing it if ov8865_sw_standby()
fails, leaving the reference unbalanced and the sensor powered
indefinitely. The same applies to a failure while disabling the
stream, in which case the reference acquired at stream start is
never dropped.

Drop the reference in a single place, both when disabling the
stream and on failure, and only update the streaming state on
success.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index cae1866134a03..498448b2ba2ab 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2629,15 +2629,13 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	ret = ov8865_sw_standby(sensor, !enable);
 	mutex_unlock(&sensor->mutex);
 
-	if (ret)
-		return ret;
-
-	state->streaming = !!enable;
-
-	if (!enable)
+	if (ret || !enable)
 		pm_runtime_put(sensor->dev);
 
-	return 0;
+	if (!ret)
+		state->streaming = enable;
+
+	return ret;
 }
 
 static int ov8865_g_frame_interval(struct v4l2_subdev *subdev,
-- 
2.53.0



