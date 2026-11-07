Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064314;
	b=PZnRQ5QCedpDmQ1xutSo1twWcM8N8C6b8J9AyaffhU8/nF5lMPhtegUWkb61UfqnIWEs
	 EjbyaRDokT/2QqaROeVxflX0PzTm5x5mTsvo01/oJONf4WX7l5f4JZl4yUtD6nKFVGmBF
	 xy+9B5kyzqFtkjI3tifda1dHJnoe7eWcbjF9mnFS/kOEzxwLTcbZzyOFIKEtwKzMFw5k6
	 DK6gagns3PbF7lfYxemuyGkg2vBzDkEp6v2tNrlhqS1wDiaLwACPA4zHxdae/UiYIQm1Y
	 9ondiy+CvQ+PsL7YAOtI5SYS07YaNX5rhuw1evLAJixLHHZb6XKCmzzbPU6/sa+cH7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mnFk18tjRgb5xzkbMV9GFGFmBtQafb8AQdu8+3RellY=;
	b=sumDXmzHUp0LMjkUQJwMJT3xKTR2X32Ue0/WooFpN14HLGWykkSq3Kp0o9qPIMf0zm/x
	 yi8Nifa25wVixe+bO9KbAGU6hGXYncICvXln6CvWRGeulyh+steLFwha25VFk75C8ssMC
	 abe+Ny0R6sXYiGOW5Rqa7qg+2qjgihFViHhgPdwboc5b3s1dHG3Y8WY+OrKgW/dd5iXii
	 rumDXV6Ap2TBJut+ofFO8yzlH6REYHCjOYgDnbrcr2NxIu55NapQsERoeBRpIVohlYrn5
	 Qrx8bocM2ajFl9+Lq+KecbIsUeebmFBGZLYRTsmcJiJOLjOSz3Visym4/PndWr4CNxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vQK07g/K";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C39606A9FF;
	Sat,  7 Nov 2026 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQK07g/K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37B91F008A1;
	Sat,  7 Nov 2026 15:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064314;
	bh=mnFk18tjRgb5xzkbMV9GFGFmBtQafb8AQdu8+3RellY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQK07g/KLA9fwXCshKzvvRgZrXb/1atncwK5DOKGJbvPMNXpeu+5rbaex9T4et1Gs
	 X4cPn6F4srFFmWDLHut2ThJ5y47gtm7dXDCkeavpK+D+vMLU8kKpp5McxRfuy5l5tx
	 XYooyD8rc55puMUxfE0gUd1Tef5mar5an3+1wRBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	David Carlier <devnexen@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0404/1257] media: v4l2-isp: reject zero-sized parameter blocks
Date: Sat,  7 Nov 2026 08:45:00 -0500
Message-ID: <20261107134950.686624820@linuxfoundation.org>
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

[ Upstream commit 43ba38e1e02bbfbe99d3c4145df3c24797586c97 ]

v4l2_isp_params_validate_buffer() walks the blocks of a parameters
buffer by adding block->size to the current offset. A block whose
type_info[] entry is an uninitialised hole passes every check on the
way there: a size of 0 is not caught by the block->size > buffer_size
test, and the match against the type info size compares 0 with the
hole's own 0 and passes as well. The walk then makes no forward
progress and loops forever.

Drivers build their type_info[] arrays with designated initialisers
indexed by their block type enumeration, so an enumerator left without
an entry leaves a zeroed hole rather than failing the build. Drivers
call the validator from vb2 .buf_prepare, so such a hole turns a
VIDIOC_QBUF on the parameters video device into an unkillable task
spinning with the queue mutex held.

Reject a block whose type info entry is empty. The driver does not
implement the type, so it cannot tell whether the block content is
meaningful, and accepting it silently would leave that content
unconstrained until a later kernel implements the type and starts
validating it. The size match then always runs against a non-zero
size, and no block can advance the walk by zero.

Fixes: 3cb6de6fafb8 ("media: v4l2-core: Introduce v4l2-isp.c")
Cc: stable@vger.kernel.org
Suggested-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-isp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-isp.c b/drivers/media/v4l2-core/v4l2-isp.c
index 1eb46e080afa1..8e6c2ef326aaa 100644
--- a/drivers/media/v4l2-core/v4l2-isp.c
+++ b/drivers/media/v4l2-core/v4l2-isp.c
@@ -99,12 +99,25 @@ int v4l2_isp_params_validate_buffer(struct device *dev, struct vb2_buffer *vb,
 			return -EINVAL;
 		}
 
+		/*
+		 * An empty type info entry denotes a block type the driver
+		 * does not support. Reject the buffer instead of ignoring the
+		 * block: accepting it silently would let userspace fill it
+		 * with data that a later kernel, once it implements the type,
+		 * would validate and possibly reject.
+		 */
+		info = &type_info[block->type];
+		if (!info->size) {
+			dev_dbg(dev, "Unsupported block type %u at offset %zu\n",
+				block->type, block_offset);
+			return -EINVAL;
+		}
+
 		/*
 		 * Match the block reported size against the type info provided
 		 * one, but allow the block to only contain the header in
 		 * case it is going to be disabled.
 		 */
-		info = &type_info[block->type];
 		if (block->size != info->size &&
 		    (!(block->flags & V4L2_ISP_PARAMS_FL_BLOCK_DISABLE) ||
 		    block->size != sizeof(*block))) {
-- 
2.53.0



