Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064320;
	b=IZDR47myvJUvU0sO9sgvsWbE1TNVfuoEDQDx6OGpz3U+t5A/Fbeu+DSDjzPflNXuhGi5
	 +adxzJ8xXwK1/+g+ZMdp0K04FJsdCds4S5FQ6OPzrK1qPagZl6MTfnZbH4ajI+Xrd6jIV
	 T1ewpaJFqlT6nUKFnDwLZNb7iLR8LO+nbC8Qa1BnXXhdao4Z99ZljJICh550/OPofucdm
	 CD75PwRl+oxuSk+9H9BMkt5lURE2dFlEx8/YtwP3vQa3G5DCk+cHTvg6tsjYIDVCR86cU
	 4lYxycO8m+hufdSIUa86JjxfT5g4Zr8vlcYv3tfQlGz/weRTlK6aEawtN5rblMljztA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+ZFAl9nOV83FPylUjDuxarH+QWyQ2gEl+MiNlsJ3eo=;
	b=XLyHmM104E/ICMVv4Jc1jtW5JQQjfedRlkwn7Qi7tuV+SaXTXxc2vL7uIomuTuRaSy9x
	 YZGqp7FWOWK81s178EcGrGje5HL73DrTwCb8ZsJzFpjgeZTlPqdMOjG1pz5zYz2QAL2lB
	 SzSvqtl9TyGbkwKtgkUpAyAI9ftF61GJ4GCuMC5FaZ0imICYg/cxvOQdtqn/6AMx5UqYM
	 IlKVO/t+6I95fniYUhr1PnrsyIZueZBtXUaJV2f7SWNRhwMfNnFGNgNihVZ0d+hOX2xJC
	 /iB9iPyrnGKABtyEE1coN4NV9OJtYRi9/VI5/sAyvC5XbS8Sg7sb2VRmVtHVflGtJSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dE6I2ATU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A54606CE46;
	Sat,  7 Nov 2026 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dE6I2ATU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CE81F008A2;
	Sat,  7 Nov 2026 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064320;
	bh=L+ZFAl9nOV83FPylUjDuxarH+QWyQ2gEl+MiNlsJ3eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dE6I2ATU2iduXpu708lpjW0qeOl8bFUihqQSHsvaXr/7zAFtE6a4swQau+t6X0uyx
	 VT3uE3k+TNg1RYSmgV0LQGFZOng46gu8VPPGYunmFaueHyGXULkUo8Ii2hhbINZ75G
	 O/+Pmy7LlWFG7YWtgb8je8c0yXm/aTGPYEF6KZyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0408/1257] media: mali-c55: Check the statistics buffer address before filling
Date: Sat,  7 Nov 2026 08:45:04 -0500
Message-ID: <20261107134950.790510619@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 907273d00dabc60494a691907cfb9bb9bb50ab2f ]

mali_c55_stats_cpu_read() copies the metering registers into the buffer
returned by vb2_plane_vaddr() without checking it. As for the parameters
queue, a DMABUF whose exporter cannot be vmapped yields NULL, and the
memcpy_fromio() then dereferences it from the threaded interrupt
handler.

Report the failure to mali_c55_stats_fill_buffer() and complete the
buffer with VB2_BUF_STATE_ERROR.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/arm/mali-c55/mali-c55-stats.c     | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-stats.c b/drivers/media/platform/arm/mali-c55/mali-c55-stats.c
index 655e52a5f288b..a9c28b090b2a1 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-stats.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-stats.c
@@ -200,9 +200,9 @@ static const struct vb2_ops mali_c55_stats_vb2_ops = {
 	.stop_streaming = mali_c55_stats_stop_streaming,
 };
 
-static void mali_c55_stats_cpu_read(struct mali_c55_stats *stats,
-				    struct mali_c55_stats_buf *buf,
-				    enum mali_c55_config_spaces cfg_space)
+static int mali_c55_stats_cpu_read(struct mali_c55_stats *stats,
+				   struct mali_c55_stats_buf *buf,
+				   enum mali_c55_config_spaces cfg_space)
 {
 	struct mali_c55 *mali_c55 = stats->mali_c55;
 	const void __iomem *src;
@@ -211,12 +211,18 @@ static void mali_c55_stats_cpu_read(struct mali_c55_stats *stats,
 
 	src = mali_c55->base + MALI_C55_REG_1024BIN_HIST;
 	dst = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
+
+	if (!dst)
+		return -EFAULT;
+
 	memcpy_fromio(dst, src, MALI_C55_1024BIN_HIST_SIZE);
 
 	src = mali_c55->base + metering_space_addrs[cfg_space];
 	dst += MALI_C55_1024BIN_HIST_SIZE;
 	length = sizeof(struct mali_c55_stats_buffer) - MALI_C55_1024BIN_HIST_SIZE;
 	memcpy_fromio(dst, src, length);
+
+	return 0;
 }
 
 void mali_c55_stats_fill_buffer(struct mali_c55 *mali_c55,
@@ -224,6 +230,7 @@ void mali_c55_stats_fill_buffer(struct mali_c55 *mali_c55,
 {
 	struct mali_c55_stats *stats = &mali_c55->stats;
 	struct mali_c55_stats_buf *buf = NULL;
+	int ret;
 
 	spin_lock(&stats->buffers.lock);
 	if (!list_empty(&stats->buffers.queue)) {
@@ -239,8 +246,9 @@ void mali_c55_stats_fill_buffer(struct mali_c55 *mali_c55,
 	buf->vb.sequence = mali_c55->isp.frame_sequence;
 	buf->vb.vb2_buf.timestamp = ktime_get_boottime_ns();
 
-	mali_c55_stats_cpu_read(stats, buf, cfg_space);
-	vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_DONE);
+	ret = mali_c55_stats_cpu_read(stats, buf, cfg_space);
+	vb2_buffer_done(&buf->vb.vb2_buf,
+			ret ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 }
 
 void mali_c55_unregister_stats(struct mali_c55 *mali_c55)
-- 
2.53.0



