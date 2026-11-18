Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035896;
	b=cmdQPsouIftvx/FKl1j1WQ5BAVYm0QystoHEt5NaANb2ooThYeGWN+q7Aq0FHghJZHwI
	 bnRHBoO87RmbX4ZV1vYCv5JnBFN57cmXIrQOEkb5/tRZrsMY6DVWPoE3YkwKN+2tqPzz8
	 UyMlNRuu8Dd2ljfVzuipGA4KQMj+VzYwSQHoHqLALKQZoaDWefh53NUFP9PUaEoisS3eL
	 NZ+fq1tX90U6pXEnpAGlTrHha4/XPzz+uI8J2RN1GkZASkMbyvK0ab8NBAecIsaEKUcwq
	 DPbKJcHg2s3AWYCKFKF9z+F8jGX2Jk5nBT8DG+hYBjXGCGDcAZCbq0+mBoBwHWjpVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hs7IYxSiQPg4x//ijfNqrGDqSJcr2wM/rgUVZBQ5WoY=;
	b=0v8njWYsbxxW+5Yue7I9AhZqgch6CWuRq7+eBLmy7f/2ingAy/dbL3pbLD/2QnolOCWw
	 fhSfkVyZW6q78o29WHeF2uCAlCXnhhnF/z+Srg+oIUkVSjaN4N3L7M0DQL5GReASbbTuN
	 7SJaYvPNkrXlAd564xpgDu4FU+BRwwDMa2wlCuBNOQOmPm1kkCWUEwmF33ZyselrB3WFw
	 1JGZSV9HmOm0W4t2MgWNOxEUBT+paZyAsqgPhbV5cdgHnmznhWI180hPI8d38s4YWvdmz
	 sQGg14viH8I+sHVRFjMH1jPGfboXAwePTYP7HeL/uwXC8zEoOwHiHISfIOmwWONw97Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cIYyc4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DE3606A33A;
	Wed, 18 Nov 2026 21:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cIYyc4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAB91F000C7;
	Wed, 18 Nov 2026 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035896;
	bh=Hs7IYxSiQPg4x//ijfNqrGDqSJcr2wM/rgUVZBQ5WoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cIYyc4s3lGapgqvtK7WhCsNQP6K33Ip0C8p7FRU1L0iOgV9ILgu/uVLaFmGl08Al
	 /xSLMS1LrYkcX/WDy0vnisI/3JDGBs1uRlCDjrbQrH/tNi5pONwREKFa4aSvuORUeb
	 SB6ukw/GF6H2fz0kWVdcJArn29N6NpKAtSO8LI18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0865/3318] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Wed, 18 Nov 2026 15:24:47 +0100
Message-ID: <20261118150345.253172573@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 27953c044974baf7e24dee3e9342fe0103dea80c ]

The stateful decoder leaks uninitialized kernel heap memory to userspace.
A process that can open the decoder video node gets it back in the CAPTURE
buffers it dequeues.

The reference frame and the compressed frame buffer are allocated with
kvmalloc() in vicodec_start_streaming(), and the decoder can read them
before they have been written. The first frame is allowed to be a P-frame,
in which case it is decoded against a reference frame that was never
produced, and the padding rows below the visible area are never written
for any frame.

Use kvzalloc() for both allocations.

Fixes: 256bf813ba39 ("media: vicodec: add the virtual codec driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index baf024052e780..66d7b626b04de 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1599,9 +1599,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	}
 	state->ref_stride = q_data->coded_width * info->luma_alpha_step;
 
-	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvzalloc(total_planes_size, GFP_KERNEL);
 	state->ref_frame.luma = state->ref_frame.buf;
-	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
+	new_comp_frame = kvzalloc(ctx->comp_max_size, GFP_KERNEL);
 
 	if (!state->ref_frame.luma || !new_comp_frame) {
 		kvfree(state->ref_frame.luma);
-- 
2.53.0



