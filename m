Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033699;
	b=lTSPNJAvGTuymTgQq9YeHXTEhgVM+JN3RzVcinCMGdJnrmBsToPAW9O0C6p67u1nl9JA
	 woOjoUJfTbFgP981xX/8fZkuvIucCZEarfjj1VEpi08V0PZsNFJbuZUj8L9yFHJAxIH35
	 I5pIw9P2QPuAaYcEWf6K3oBEsWDZqi9AO9Fyoc5GBtjqMGr3RXlTwviWHvi1uDEy3YCcm
	 KfL1e8bLyCSPooCl8+/r2/erkWNmNnosjjp3XpN/7up04ojNTBT+NeWxTRlo1k0kmBV4A
	 Yb65Pv7F0fTaKESMg0JN4m9n7PTP+P0ohVuzBQHF5AzWlqYWh7xmWsDT75xwKM/xT5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsgaEUpCrxxpRb3wgp0UqBoBTeVZ52zLih3gAXAYKd0=;
	b=Og3Z+8vym4h0syDeb1AlxCLyXsA2ttDiMU4SoWGvfa/SXWwFlQihzuYvp/joOPce1BA7
	 SIvfB6Slm0K3Q9VQwxJoujB5BWVP7DyK+H+Pzq8Wku8h/ERms8POylVf4q2JpxRfhDdz/
	 nQ8FPjWjbc5UjeUPisltDn3aloLVJTdpxd83+jAFMDM3d3OjqAPqnviXdgwoOyhN/vHmB
	 zOXnceD+zVSASrbbSaQGzmbhnTJumpSa16Yy9Ogt8RP2hQHJimymdiM7WvIPxBAFk7gyu
	 oIxu2xkdVdEUO5OtAiBy7fFrqBiamipoSBnsBpxOhvBn4Dc9EkU4KjyC0BLTSw2oVsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIx6Fkep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AA0606A32A;
	Wed, 18 Nov 2026 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIx6Fkep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA661F000C4;
	Wed, 18 Nov 2026 20:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033699;
	bh=IsgaEUpCrxxpRb3wgp0UqBoBTeVZ52zLih3gAXAYKd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIx6FkepnUC34posh+uDo4j7rtConS5ZVk19U5Ug2RylD2g9/+lUAh/eoVyhZHMsE
	 LFsNTW/J2A/LjGKhqFidpif352wV5VUI8hceB3+jb9IhjNgbYz7CkyIk3iylDrJzJc
	 6S1hVR24SbeJXOYUbUW/4h4Xkr/uHNvCbargyCvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0106/3318] media: i2c: ov8865: Program the sensor on stream start
Date: Wed, 18 Nov 2026 15:12:08 +0100
Message-ID: <20261118150317.433420010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jurison Murati <eng.juri@gmail.com>

[ Upstream commit 4e1446ac169a1a621ba90502ab8db3be821fe726 ]

The sensor registers are only written in the runtime PM resume
handler; ov8865_set_fmt() merely stores the requested mode, relying on
the sensor being runtime suspended between uses so that the next
resume applies it.

That assumption breaks when something keeps the sensor powered. On
IPU3 platforms, ipu_bridge instantiates the VCM device with a
DL_FLAG_PM_RUNTIME device link to the sensor, so a userspace process
holding the VCM subdev open (e.g. wireplumber's camera monitor) pins
the sensor runtime-active. A subsequent set_fmt() then never reaches
the hardware: the sensor keeps streaming the mode programmed on the
last resume while the CSI-2 receiver expects the newly negotiated
format.

On a Surface Book 2 (IPU3, ov8865 + dw9719 VCM), requesting the
3264x2448 mode while the hardware was left programmed for the
1632x1224 binned mode makes ipu3-cio2 report "frame sync error" and
"payload length is 10340352, received 2585088" (exactly one binned
frame) for every frame, and the inverse case stalls the stream after
a single frame. Camera applications end up displaying one bogus frame
forever.

Program the sensor configuration and apply the control values on
stream start instead, where the negotiated mode is always current,
and only write the configuration in the runtime PM resume handler
when resuming with the stream already started.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index 1ef3358669a3c..fd0c471234096 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2617,7 +2617,7 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct ov8865_sensor *sensor = ov8865_subdev_sensor(subdev);
 	struct ov8865_state *state = &sensor->state;
-	int ret;
+	int ret = 0;
 
 	if (enable) {
 		ret = pm_runtime_resume_and_get(sensor->dev);
@@ -2626,7 +2626,23 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	}
 
 	mutex_lock(&sensor->mutex);
-	ret = ov8865_sw_standby(sensor, !enable);
+
+	/*
+	 * The sensor may have been kept powered by something else (e.g. the
+	 * VCM's runtime PM device link on IPU3 platforms), in which case
+	 * runtime resume did not run and the hardware may still be
+	 * configured for a previous mode. Always program the negotiated
+	 * configuration on stream start.
+	 */
+	if (enable) {
+		ret = ov8865_sensor_init(sensor);
+		if (!ret)
+			ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
+	}
+
+	if (!ret)
+		ret = ov8865_sw_standby(sensor, !enable);
+
 	mutex_unlock(&sensor->mutex);
 
 	if (ret || !enable)
@@ -2914,15 +2930,15 @@ static int ov8865_resume(struct device *dev)
 	if (ret)
 		goto complete;
 
-	ret = ov8865_sensor_init(sensor);
-	if (ret)
-		goto error_power;
+	if (state->streaming) {
+		ret = ov8865_sensor_init(sensor);
+		if (ret)
+			goto error_power;
 
-	ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
-	if (ret)
-		goto error_power;
+		ret = __v4l2_ctrl_handler_setup(&sensor->ctrls.handler);
+		if (ret)
+			goto error_power;
 
-	if (state->streaming) {
 		ret = ov8865_sw_standby(sensor, false);
 		if (ret)
 			goto error_power;
-- 
2.53.0



