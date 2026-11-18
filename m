Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033693;
	b=BPHr9YOpfskuJ5jzZ/Wa63IK4hEV35oLi/uux9PpFrMak5+AaTfPyPHZoAG4dJEhBKxt
	 HM0tc8LXx3tqbWliqTN3bQZ4VD7aAHWBuE/ZoAl7bmnz882D7l5AtrS2P4BD/ux42oHOf
	 mu6D975x1i1t0tla0zRVwM1l9dnlPMl2/Ab6YrWDvdTcwAIhKWboGRIw9teNZjy4hw1eh
	 +C3sRVsPa2OjfF/km/4LaurvXv8dsoF+Rri+19myxXlmTbfxsCSpvtoSa8FyFp6o5gSK8
	 Dsaw5rz9kqNraG+3RV8zq3TFmqXVoyUDFsawDluM7ZHaC5HuXuLFNuwxwcMh48Gl+MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9otq+X4vPLPr9+UoG0TRQjlKi0WwaaN/jaCsW5c8GFg=;
	b=Mz93lnFbTn6qTPhJQyTmtqikDpuTpdY0+1C9LuC4B/dGuwHP4mJQn9S30WVIrNb6tNuJ
	 B755N4ODwal0aGan+mXmMD0rTqb7Q+xTmmjUQ8slT3yeYSUqzGYDnJ66U4zDHtV5sw1ai
	 9PbA/G2jkOzTfRtHsF5hARnOB0YDhfFwQPcYExWUkf+BW/PzSnDxnHHZs0S9hb3891dNI
	 RwNXiWBggCofM6IRSohu+MYScPbojt6gD0Vv/mtdZO9+1Hp/gsreETMajJJeXZZcd7X7/
	 6iPB5EuIsw/T9GSGsmv6YyDcO+Lzxl+/6rysogwgBLcFrke9j1GpLz0h97g+d2mSAmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn+QAJZo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773B606A33F;
	Wed, 18 Nov 2026 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gn+QAJZo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAAC1F000C8;
	Wed, 18 Nov 2026 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033693;
	bh=9otq+X4vPLPr9+UoG0TRQjlKi0WwaaN/jaCsW5c8GFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gn+QAJZobzOaT+vQ1s+D51stcGtIg6kEuz+u/yMQr1IzwchRZsou8j8D8/JFArZgF
	 dxdVsXrUadLEScn4kgM5N/gpu+7nGFfCQR5Pevo+4fCdFnHTyJr4IPCFxxQ7SX0tOB
	 kPZBqcDTYgXpwJC5Oomb/oVFndDpGxHhRMiLgCUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0104/3318] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Wed, 18 Nov 2026 15:12:06 +0100
Message-ID: <20261118150317.362039992@linuxfoundation.org>
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
index f2213c6158d3e..1ef3358669a3c 100644
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



