Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064322;
	b=pxux/8o4u9VY4E1rrRXqsYNev6kTP1f/pBK3JPd+p6GnZCjMRyaeaGlF5QT7nrYW2D8P
	 +CgNIB4hAVMUNhkPn0BWfpAS9vJyU3cIPePwnpsJ/z6ZfEMy3TaiVxTyo6Sc+v/H5QEZy
	 mDQTUefSCqpoVVV/LKDzufKrl+ONkjRMc6F4Cjizb2JEU0HHyLhBe8+QbkxNC81muXEwh
	 fKoEuwWLcjYKJLWCIqFVAfhd47FtExAEFZVR68jsiEqEJzm3wt8JglMRd3t9WxMqkoR98
	 upLt4kzzY4Rw4XEP23ENZXA0CbJ+iWwX/d7G3DiR8Esj60priuBHP5wB+0pXjSU1KAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWfG/JaJOwcIwSWGlFk+SAosOHlChZ3ldDeorWG+YmI=;
	b=eFMZgvA5b03YUpBRt4CqO/ictsl+BTNnWUuPdP8/dYV8HHmQ6B8m1H8K/fmWeOUkeAkV
	 FYY4GMJemCtdVH2hj3rgPlEtrVor/xoTraFfErSkyQw51KXwso5qIX46yyPmAXK+afrCC
	 CD2qQxB8dUmXhtEoNZlJn5ryjt9qS0S9lQktNbvTowQ/2Eaw5dtB5rdi7hKN5S72Opggv
	 e4bnk0FHHOB+wNIOoH2L9kfglcQdYLRqfMOPoidLCOSQiVMcV+zsrgDYZINV7wDF/JyHJ
	 Kcahv7rE4cgUeg57hrTPtWH8nOmY9W4/r1lMxIiIAAik2Ph7g+QfaGE08v5WMd0CBBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgGT6V1A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1E6606B880;
	Sat,  7 Nov 2026 15:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgGT6V1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6683D1F008A1;
	Sat,  7 Nov 2026 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064321;
	bh=XWfG/JaJOwcIwSWGlFk+SAosOHlChZ3ldDeorWG+YmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgGT6V1AACKIDbyZc5mwu/tTAQm0JTE+UOZUwUuRFBmTTH3O0O6IRqdiqAM+QKBsT
	 W6N3y5RaAYcX1KKFpqyirNT5h9wiPaVk0HsLQCFh12xIhTBCjERFcWA8SlxPdJxIpr
	 q/U6huVfcShzrZaSkuKayOFRYIPjKNehrNnpSEtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0409/1257] media: mali-c55: Ignore disconnected queues when checking readiness
Date: Sat,  7 Nov 2026 08:45:05 -0500
Message-ID: <20261107134950.816914393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 9cfc1aca0781ce08e307b6c9dd617d37021544a8 ]

mali_c55_pipeline_ready() waits for every video queue to enter its
start_streaming callback, regardless of whether its media link is enabled.

When libcamera uses the TPG, it disables the statistics and parameters
links and queues only image buffers. Although STREAMON succeeds on the
metadata nodes, videobuf2 never invokes their callbacks without queued
buffers. The ISP and TPG are therefore never enabled and capture hangs.

An unused full-resolution or downscaled output can similarly prevent the
pipeline from starting.

Only require queues connected through enabled media links to have started.

Use media_pad_remote_pad_first() to check the video node pads, retaining
the capability check before accessing the optional downscale device.

The shared readiness check also keeps stream-off consistent: the first
active queue to stop disables the ISP.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-core.c b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
index 288fba4831808..a14c6042345bf 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-core.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-core.c
@@ -510,11 +510,16 @@ bool mali_c55_pipeline_ready(struct mali_c55 *mali_c55)
 	struct mali_c55_params *params = &mali_c55->params;
 	struct mali_c55_stats *stats = &mali_c55->stats;
 
-	return vb2_start_streaming_called(&fr->queue) &&
+	/* Only wait for queues connected through enabled media links. */
+	return (!media_pad_remote_pad_first(&fr->pad) ||
+		vb2_start_streaming_called(&fr->queue)) &&
 	       (!(mali_c55->capabilities & MALI_C55_GPS_DS_PIPE_FITTED) ||
+		!media_pad_remote_pad_first(&ds->pad) ||
 		vb2_start_streaming_called(&ds->queue)) &&
-	       vb2_start_streaming_called(&params->queue) &&
-	       vb2_start_streaming_called(&stats->queue);
+	       (!media_pad_remote_pad_first(&params->pad) ||
+		vb2_start_streaming_called(&params->queue)) &&
+	       (!media_pad_remote_pad_first(&stats->pad) ||
+		vb2_start_streaming_called(&stats->queue));
 }
 
 static int mali_c55_check_hwcfg(struct mali_c55 *mali_c55)
-- 
2.53.0



