Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829473;
	b=5FJsEY+Lhu9kbHwoPz/gtomXLpC7p9V12yOxOiNdBcVi87BLYNqILsFqPho9Adr7ww9b
	 fnX8LfOvtrKoLhDYJKraXixnezziBC9YNxbBC6jwWTNIIt0RCGh8qwGhGkT4/ZzHgZc7h
	 0oNWCtzn3DwD415NWfQzaUEtjQGOTv+wfSVcPNQUaeSQ2iCWJKJtGG24BdK98Geyq8+SD
	 6mmaJ7mJ0LWQinAWiw5m8XVWWi2JYjcAiPx7BGeOjvS4i4djryS/AgbzhFIQNFeBe1UEY
	 g7B4S80eHnFqq2EyHJUf87oWU77vNz5tkl/PGblumZi7z3DP+hNYCcwsELhnOhk4Z6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9AmnxbV4ChP9JuKZNWvj+yauyKGyHeOJABie/zo/L7w=;
	b=K8QgnrJcYPvxT+99jTHXxMKPGw3tSqqkUobrl28gIOnRO2oVEQPf7a1pFmkFH3HbhZG7
	 V6XivBZqBFkvxsay8deOjGIdnHHCHxHT2vIp0tSMTJNQB8YEi6NANafezXWzvOEb1+Fyg
	 yhbQazrxV8M3dC9d3A4Vb2y2ubCcKjaEsy7pICW0g9Xndn/eG6OFwX4e0zMWEenUnQcUU
	 GdlhwdQ51ERbHLm2403JHGALWBv7nz6XWVFqv1E5Q9OOGfeGzyIN1d+ZwxuDOuXFDF0DK
	 8gU7PJ1OMmI7dlMZIOQ4cskPcl3TFuOsRk4BKYuBTYkG4sCGNlan820vXRaCElH8fhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7r+nhI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D78606AB15;
	Wed,  4 Nov 2026 21:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7r+nhI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39E11F000C1;
	Wed,  4 Nov 2026 21:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829473;
	bh=9AmnxbV4ChP9JuKZNWvj+yauyKGyHeOJABie/zo/L7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7r+nhI+ZyUER9J+BlI1r9VSpZBLqh8YMsZOTjtck/35vI3Y25ME3gyT2eMK+noyt
	 aHlD838ZmEjixro47J3g3m3ZHODGAN0Oyh2zhrPbsXWsKJeNp7CqbIvKaW3XPizkhk
	 wlxjaOof6Ie7usUgIHQeSQwcyk2owJl7rJu8Sjs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0148/1005] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Wed,  4 Nov 2026 15:58:01 -0500
Message-ID: <20261104211047.858287146@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a8586df14f777..5b909a8561287 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2621,15 +2621,13 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
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
 
 static const struct v4l2_subdev_video_ops ov8865_subdev_video_ops = {
-- 
2.53.0



