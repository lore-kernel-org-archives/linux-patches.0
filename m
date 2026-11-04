Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829478;
	b=kypHe8tuhlWM6shntTa2y9iJlTGnlog+cp66LwA3negQqVn8uNGTpxZR/i6tG7BqI5wK
	 WTE+vm46mPIXicicf6PT9JwyF4U+1HcXrZv7DPSwjbyEkhhF+m9LxTGiGLZJuI8L0Q6Hh
	 /JiGYClz+iEUoKqVr8lnH8RGT6vbpsf1JcfbnIGzAngFhmDut3S9UYcJkaiAj6RbOs84Y
	 Uu1gDruqFb6tb8kw6A3L38+m0QcSbFDebuo5wiyAXkV7MX8A//DQ7gy0Laf1sPSfR6tB8
	 /A+hBzc7apAuITeSjkrmwHuBB4zR8TV6K0RbPRB6PC9NwZKCQboVUL4FkrpRWwt4wpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z6NsjAdgm0cUg30Vteimyf29LN+ANWPZ112G0KLWO9E=;
	b=3xK2xwNyC+09J9wtHYA6mdthwnWefr5Lz9rmsIUSpdi6XM2wd5g7U1CKJUGL1tvtrK/6
	 xsiP10UcEEERBrXVx64rFzf7N6hlGxnqE71wMQO+5AsVvsl6ADEsl4iC8Hno0uxAVClh9
	 +2s0DniC0abnbg/qQBv33nTmF4G4dTboc/tAv8NC6cHsaRl9wlgC3wOSMXdxriyGVM7wf
	 O+vdFiNkRvfGisY4N4sgMGm/aXizWc1fLlph4LDjzPoMiAX4tSxgwrDGS6rCTGwGpRfnw
	 wYOFBEYL2fGDHQ9/V3a+Ym9uftliZnJ0yP2QWIS/dSiyfLf18gBhHIjMhpdisLHNwBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGRbrWMB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE4B6082BEA;
	Wed,  4 Nov 2026 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGRbrWMB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0831F000C1;
	Wed,  4 Nov 2026 21:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829477;
	bh=Z6NsjAdgm0cUg30Vteimyf29LN+ANWPZ112G0KLWO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGRbrWMBnPCG53HX640vnrdpypR6pHVRRaPlSvdkL/D//Z7KVxq8JlHUjEq9uQyVV
	 ZWZfI40ZSFWHFLDu/bCLtshBiPslwIakQA1AtyYRyCRtCCPbo+vQM82bVv6OLwYEuD
	 Qml+v/MILzAXR2gEAVJb8jfmi5KiWUypXloZTHJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0151/1005] media: i2c: ov8865: Program the sensor on stream start
Date: Wed,  4 Nov 2026 15:58:04 -0500
Message-ID: <20261104211047.951482049@linuxfoundation.org>
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
index 5b909a8561287..c6d53c3d55caa 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2609,7 +2609,7 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct ov8865_sensor *sensor = ov8865_subdev_sensor(subdev);
 	struct ov8865_state *state = &sensor->state;
-	int ret;
+	int ret = 0;
 
 	if (enable) {
 		ret = pm_runtime_resume_and_get(sensor->dev);
@@ -2618,7 +2618,23 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
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



