Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB94416842;
	Sat, 12 Sep 2026 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228959; cv=none; b=lIvIzqsqYLIKXk6LN+rsmIL7YmfVaLgOpTIdE91l9+BopkWPYWIsLVha4Ulmu8Ocw85teShLCsPeaS/55d/I1DSfECmklEk6VsLJVUbt8iPILM8JR9ht8HXsa4e5oeYRHse424kBeq6TYol8IRZz6QKDxOaRr1JSV88xNdJzSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228959; c=relaxed/simple;
	bh=K8LDXC5aeMQ2T541QHSSdLHGWvfHoozQUp2VxYiOpAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcZpX2InBQWWD5JrzssimQR30aoh2RkNIdQIhPqcwM74ExrqJxGs5vrkyyJF8dZIv0mIHswWvGeiTxFB4kd3kn56/8Zzg1HwnfnB6vucz3sMYkhPjlIeyI3k1qUpiVM/l5wMvZp4HG3SgN+2/QHmqZb7WFofQ4slbOknS83d13M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3Xry+wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3Xry+wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514601F000FF;
	Sat, 12 Sep 2026 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228958;
	bh=CtYRvz94nPqtJl2OeStZJiKfU6bgib1LF16IPOLWtxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3Xry+wvprVEy6XsJT+RY4Fed0KT57oT6ivdQIEyEOO8FWlzbXqPD+WmHd+H8qYJt
	 22rEtLnO5nOixLx1oUZHN7eE+C2vEwR1XkbB1ji5Q3DhELC/OscRqFEUBl6Y4Wf7ZJ
	 d2PuKWrOi/VRe0lXmtMyUlaEs3hZJmE1wc5Wn9BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0465/1191] drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format
Date: Sat, 12 Sep 2026 08:53:13 +0200
Message-ID: <20260912065558.678744615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit c1bfe8dac0a79d47eed313b9bcaa2658898684ec ]

The Rockchip VOP2 video output driver has a "is_yuv_output" function,
which returns true when a given bus format is a YUV format, and false
otherwise.

This switch statement is lacking the bus format used for YUV422 10-bit.

Add the two component orderings of the YUV422 10-bit bus formats to the
switch statement.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Daniel Stone <daniel@fooishbar.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260609-color-format-v17-13-35739b5782cc@collabora.com
Signed-off-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index e14557d80efc2..1a17e9c1e8335 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -424,6 +424,8 @@ static bool is_yuv_output(u32 bus_format)
 	switch (bus_format) {
 	case MEDIA_BUS_FMT_YUV8_1X24:
 	case MEDIA_BUS_FMT_YUV10_1X30:
+	case MEDIA_BUS_FMT_YUYV10_1X20:
+	case MEDIA_BUS_FMT_UYVY10_1X20:
 	case MEDIA_BUS_FMT_UYYVYY8_0_5X24:
 	case MEDIA_BUS_FMT_UYYVYY10_0_5X30:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
-- 
2.53.0



