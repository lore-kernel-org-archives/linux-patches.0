Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063905;
	b=kw7MDTKomIQtWiN6iQW8jPonB5KzMfd8JGLM+D7paouDw7zcOStRwtMHX9RtnsKRLmvx
	 gXXlqsF+D25QoWJi+ikBOFR59ThWtWgNIIR7+XKkAbPvjBeCDfxaF5EWBtZmfC+Reo71a
	 8ib4MA7WkRhueqekt5hJiH6xgmg19Pc4iRXcJUwBZ7qXoS0YIjvlAmQ5pqFedxpfPFEJz
	 J0q23qevOWoEWF2tDy1oa6pnqvso8Uccj1dUvtLyr4pVwuB8ADnSCsetJ5I4+hHYiZ4Hf
	 /lYW6iCaYNgoKfg1nFURZNToB/GXKgJRFGylBdFw3hRA/yIYzraZ4Z6ZHVqM5alm9uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fu+EBv7/+OsP9fStfvBMKt72EXSmNV0yWnG26D9s6rM=;
	b=n8SJHP9T46rgFadUnimFcKLL1pNCefKL6koyyNs7/5XjAW8jB9C0iLklf4GH59SeJ/co
	 gyo/zb/Qx5LhusZuJaWQWCiINU1vWLof6qmetZMCDnQET6cOZwAUvH18xJc7EpRxWmEnp
	 E7YPhgIymRGnFaHntLANy2lvnp+fL12f71mdsX+m8tiXmei5AXyWr33nFCF1TGMBHbqfH
	 kyxAKYZB4BGd42aZPzHAhYLpByexahM2v/x/i7xCS/P8TmArVRCMqxA+2AdU12EoT6148
	 2IfoPccAndebfhNhhKAfzpBug0KudgB4LxlwQOPyL5/wjBZ00oK5l8lsGpksQbeJ0sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQKa5Hmr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA21A606D81A;
	Sat,  7 Nov 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQKa5Hmr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670A71F008A1;
	Sat,  7 Nov 2026 15:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063904;
	bh=fu+EBv7/+OsP9fStfvBMKt72EXSmNV0yWnG26D9s6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQKa5HmrX4QvC9Om0dGuGk/ujIg2VVsGxPi+9vuD0H3/fq5fSnjw1xSQKuJN+nOvS
	 WQbT8yTeKWCEOp+7f0c4oCFdUgOe8i43rVtEn20qMA+oMXtIu09E9WQzjoXn5RzWxp
	 6IjFHgs16q0/kJ4cN63Jy1bxjkfamFpsIz7etfxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0104/1257] media: m2m-deinterlace: fix default capture field
Date: Sat,  7 Nov 2026 08:40:00 -0500
Message-ID: <20261107134942.229366419@linuxfoundation.org>
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
index 1d0e70eaea3d0..9dcc4bd6cbdd5 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -822,7 +822,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



