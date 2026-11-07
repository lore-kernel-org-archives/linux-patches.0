Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062785;
	b=RSn85Ma4QNsrsrbCRW9a8+4uAI5tuN3fs55fT93U39PjBBeNRt2gBXc4gPMNAVFthAAV
	 y9Nu4MhHb/QBY5sFYedJRyZCWFgNubtOPT4SpwIjGErU1IRUZQ++LMxVmmT/HVe+XMYGe
	 l7MPabynxbohiWuIQNZDKuQjh22dpCZGC6BG8c9V+HI1j7/gx9EW/4mJ1I1FixylXsBro
	 niqlcDfe8C7GVSmdq8GEKetgDnJxAEXzreEZ5FSlI24YRafjo+8MU/3Qb4HDEwOzlSM94
	 jHxdPDT34dpTM9MKVlGSfQF8NN7ISpeeEE/ILBCKhGh2JxzrfABnteKCtVR1ydx/W8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OmAPLmRmyIW448tSDZwr9jBLwDaS9wDSASpVQUbiJe8=;
	b=J/thaegQqQGnrlod0ujql8oLZ/68+K/+anmSLgToL846IpwzRcUcMPrZrONKFxjrUxw5
	 ee1DEu9nmZj+wF6Y2cIU9wBPGe/0Ai+MT9ziYhHAyEKXFSvYYlWwUWpBfVKA6fywyh1st
	 czr/UL8MZQhZo66Cg+PomVrueRPNiR8Mc9nfdSp0RJDEJLP7yaBNQ1q8wOkv5ERSg4CTO
	 capjpI7B//J4ErgXcRRS1FYDn9PaBEfR8ySChZYxw533ZdL/WegDQX8SdNyFL7DJ3iaeT
	 z7XT4bXqycB0CZ5JGCACyjhKb881vlfE0FPEacmuctuVLyrEUfpP2c/6V77gCivMrag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj6WlEgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A304606A326;
	Sat,  7 Nov 2026 14:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bj6WlEgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD761F0089F;
	Sat,  7 Nov 2026 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062784;
	bh=OmAPLmRmyIW448tSDZwr9jBLwDaS9wDSASpVQUbiJe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bj6WlEgoOmAnahJKL5dDb7zgaCBm8/TLick+RFu1dF4Kn6jRJrXlF+irdIkUVxdNt
	 uyMDn2p4Gsg3TjXy7l0qGNBb3+Eh55MyAIXkHjRG1F6wds60E7Zemz9ipr4N86ShCB
	 yNz3/k+CFIy0UyfTvztLluSumYFfrLFVoCHmBZiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/869] media: m2m-deinterlace: fix default capture field
Date: Sat,  7 Nov 2026 08:46:14 -0500
Message-ID: <20261107134855.825204031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 4ee3ebede5d01efdcdd88c94f9df271d2eb237de ]

queue_init() initializes default formats for both the source and capture
queues.  It first sets the source field to V4L2_FIELD_SEQ_TB, but then
stores the capture default, V4L2_FIELD_INTERLACED_TB, in the source queue
again while initializing the capture queue.

This overwrites the valid source default and leaves the capture field at
its zero-initialized value, V4L2_FIELD_ANY.  vidioc_streamon() accepts
only V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT on the source queue, and
requires the capture queue to use a compatible interlaced or NONE field.
Userspace that relies on the default formats can therefore get -EINVAL
when starting streaming.

Initialize the capture field instead.  The bug is usually hidden because
mem2mem applications commonly call S_FMT on both queues before streaming;
the TRY_FMT paths normalize the fields and S_FMT overwrites q_data[].field.

Fixes: 8f0755c06b90 ("[media] media: Add mem2mem deinterlacing driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index e07e57d4206ba..83d6c54f015db 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -829,7 +829,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



