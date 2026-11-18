Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035829;
	b=qV6XbxmnV0R/9lbX/fbYdzuzIDkDI7kmwt9Wjh4p68ajtCb5sJkIBhKjgQAYr8x30gug
	 edOIObAtd6eNH8wtRKwPFJxZ0A8EdNGa6Kym3wP2LbKA+Kg5iaXdNtGkGo4ce323wLoA4
	 STk5R7L8zbcirXwx5QXjBxbj4ee1tm5BYr4V/pAyJ0ARfu17J+zMf84Rr+1uA4rycoCKD
	 raYbbdSkB5SrLLTBHL/cODzgW0e/8uzRMhsvRs2I/pjH+NxIQRmhAszcvv/0VhAgrCvQ3
	 JeuKSdAeJRionWnaHAd8saxu1HQHXDXyl92QnL5sp2YOM6JUsDqhmLFYaRVX/Nyj1Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0AB0vUAIjzHeGX6WRWIaLdNEUevlaqL4NOuuj1QelkA=;
	b=YP2qZJLcXbQ72URBoOztZncaex3kjKmqlocWf4TLzwfKeNff04avaIk/CT9UtYo6qRWI
	 4X0zufKG3eyPbtSuEkL5FJnhQLE4etEH4NqNGsnBVKaVtx022NkokcrMY1t8prPaUKgUz
	 LbQ+ZmC3NDj43UE+E/5JFnLp6MNk6YIggaVCcn1GrrnwcE4xPzZKoROWl1P3BxMs0Br8D
	 KU/bhkdKzjkYVTKSDxb1w006T4Giho3voT6MdPkByp6muilIKoY8SibehIdlN2JmOhYCL
	 A/v031lNyrKz3W8nVOKeHE7QjifNWo1kaNCwdrKvQcE5jzcCAH/EiCC93gfTrez5cSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifXFikSr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F9060A262D;
	Wed, 18 Nov 2026 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ifXFikSr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA821F000C8;
	Wed, 18 Nov 2026 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035829;
	bh=0AB0vUAIjzHeGX6WRWIaLdNEUevlaqL4NOuuj1QelkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifXFikSrBtzexMdwc/BDdHr1wGwTBSjvLkgCoDeEE31U8WkTFwXeb1HxQhN+B0Hp3
	 72SV/u8jSd+xpXMrHx4CuRkTNCn5jV6rKfX8VNPfTakaq9Rf5lY14u/I1ACSLlIUi+
	 s+TRwlGIIRjqBEMFKqNOU5Wuqn6pJmLRPP6Jje54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0843/3318] media: m2m-deinterlace: fix default capture field
Date: Wed, 18 Nov 2026 15:24:25 +0100
Message-ID: <20261118150344.473026196@linuxfoundation.org>
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
index 96b35a5d61740..ce8664083fef8 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -830,7 +830,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



