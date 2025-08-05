Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81691272E7E;
	Tue,  5 Aug 2025 13:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399421; cv=none; b=iU8PwfeaSZYC3+iDHQmvhLu2xhEvjs1pU+BwHJ25RAGh6ofjt07GHJiU/J7rU3Je7thSxHieeMyDIKCem6zVOm544MprtIOOwSuerbujgkLxU/CAc1AnAAxTU84olYudy7/4DAUjjInHZXTTuYdu8dCoqZgS3HIFJnw6/U0Cr/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399421; c=relaxed/simple;
	bh=OtL0BvKJrFQvW7Ox0KkmTvFHyapror2XBcqcthYyGek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YRqhWi1Yc5B2i4WAZKmK9+sq0ULzPiuNi0fEg5H96Honohg7L3sur+1qFvuS11STRuipHUVwX7NmpfTIM9pOvwhDR+nf186KOlkw/jq8XxATZB5iDbHJvTTGvSLQr9uT0dg4gP7MmxWGLCF0cpQ31hIYYyhPFLZHsaOTd6SU740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QU+N3ybq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QU+N3ybq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6CAC4CEF0;
	Tue,  5 Aug 2025 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399421;
	bh=OtL0BvKJrFQvW7Ox0KkmTvFHyapror2XBcqcthYyGek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QU+N3ybq0GG/icLAmX/HjG7d0buXSJuti1IZGRHl7rqbNmum7g45J6EkcEeBlJcB8
	 MQsoWv3Yhf9PAROxZ6FC+WC72TVR4T5KSjoZbSkoWslyfwPFfSlBQTYsixl7Oa4Fg3
	 cuehlDcmxwRRmF/TnPDIJFj02DGQN+7c0eB0g3Pi2IydxmzQVZcNI3LhWCLC07KC5r
	 kEG7BLiHa30ARhVLXunUInei+CnOOa+yLrxsm7qwpKJBOAXLCHPqs7UMX/Ez0yDeNJ
	 cyGUj91dw7ayObMPJ6dB/R0zGoG0/fx59ricFILwHbx7nZ2dbdSCbI+ftc+NeW9a1G
	 8gCZ1ZQiMMSjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	kernel-list@raspberrypi.com,
	florian.fainelli@broadcom.com,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16-6.15] media: raspberrypi: cfe: Fix min_reqbufs_allocation
Date: Tue,  5 Aug 2025 09:08:51 -0400
Message-Id: <20250805130945.471732-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 57b5a302b5d529db96ddc52fbccec005092ebb3d ]

The driver checks if "vq->max_num_buffers + *nbuffers < 3", but
vq->max_num_buffers is (by default) 32, so the check is never true. Nor
does the check make sense.

The original code in the BSP kernel was "vq->num_buffers + *nbuffers <
3", but got mangled along the way to upstream. The intention was to make
sure that at least 3 buffers are allocated.

Fix this by removing the bad lines and setting q->min_reqbufs_allocation
to three.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Bug Fix**: This fixes a logic bug where the condition
   `vq->max_num_buffers + *nbuffers < 3` could never be true since
   `vq->max_num_buffers` defaults to 32. The original BSP kernel code
   was `vq->num_buffers + *nbuffers < 3`, which got incorrectly
   translated during upstreaming.

2. **Functional Impact**: The bug prevents the driver from ensuring a
   minimum of 3 buffers are allocated, which could lead to buffer
   underruns or improper operation of the Raspberry Pi Camera Front End
   (CFE) driver. This directly affects users of Raspberry Pi cameras.

3. **Simple and Contained Fix**: The fix is minimal - it removes 2
   problematic lines and adds 1 line setting `q->min_reqbufs_allocation
   = 3`. This is the proper V4L2 videobuf2 API way to ensure minimum
   buffer allocation rather than manually adjusting buffer counts.

4. **Low Risk**: The change is confined to a single driver file
   (`drivers/media/platform/raspberrypi/rp1-cfe/cfe.c`) and uses the
   standard V4L2 framework mechanism (`min_reqbufs_allocation`)
   properly. There's minimal risk of regression since it's replacing
   broken code with the correct API usage.

5. **Recent Driver**: The rp1-cfe driver was added relatively recently
   (commit 6edb685abb2a), and this bug was introduced during the
   upstreaming process. Users running stable kernels with this driver
   would benefit from having the correct behavior.

6. **Meets Stable Criteria**: This satisfies the stable kernel rules as
   it:
   - Fixes a real bug that affects users
   - Is obviously correct (uses proper V4L2 API)
   - Has been reviewed and signed-off by subsystem maintainers
   - Is small and self-contained

The commit properly uses the videobuf2 framework's
`min_reqbufs_allocation` field which is designed specifically for this
purpose - ensuring a minimum number of buffers are allocated when
VIDIOC_REQBUFS is called.

 drivers/media/platform/raspberrypi/rp1-cfe/cfe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c b/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
index fcadb2143c88..62dca76b468d 100644
--- a/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
+++ b/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
@@ -1024,9 +1024,6 @@ static int cfe_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	cfe_dbg(cfe, "%s: [%s] type:%u\n", __func__, node_desc[node->id].name,
 		node->buffer_queue.type);
 
-	if (vq->max_num_buffers + *nbuffers < 3)
-		*nbuffers = 3 - vq->max_num_buffers;
-
 	if (*nplanes) {
 		if (sizes[0] < size) {
 			cfe_err(cfe, "sizes[0] %i < size %u\n", sizes[0], size);
@@ -1998,6 +1995,7 @@ static int cfe_register_node(struct cfe_device *cfe, int id)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &node->lock;
 	q->min_queued_buffers = 1;
+	q->min_reqbufs_allocation = 3;
 	q->dev = &cfe->pdev->dev;
 
 	ret = vb2_queue_init(q);
-- 
2.39.5

