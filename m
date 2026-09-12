Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10663F7877;
	Sat, 12 Sep 2026 11:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213733; cv=none; b=TsNWnz5CXknxVkg/5mfMgTPAHdo6h3Gy1eluozCtVXYpS0ILCaqc7EIZT1mB6m1xmiwGiJvHfccT6hyd4CA5sOhjTfskUAvhB+nP/a1RA++2wDLHkqlfqcZiO7Q0om/QMagrPGRkBltd/kiGBAqV5BDX31vk+4qp7qrAnBOHZ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213733; c=relaxed/simple;
	bh=j5fImg6OFCAkjZRc7rrS47FP7nH8JWoOiT0TSWDZ690=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCd7QAZzlpZ7mK9c4jcb0ytIV5YAhZjPp3oZ1vK5rfYc1HtK9FEqHQlP7BkPVlpMhKJPxphchlblCeWO4m/H42+3ac+E5ZPfCEo+SBfnFev4EcACLBT+9Ds5QLEATbGBM6oyM0W3z4+hTRxsC5BSaZbu1Zi+rHKw4kI8BNhFTL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc9rcV7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc9rcV7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1191F000FF;
	Sat, 12 Sep 2026 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213732;
	bh=/pvemxiQz9ZBPjLvZPaRhimsYdNVsz3bIdxzdxzuutg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zc9rcV7jpJyYOWvFfXc3vRyhyjgo9KIqP47M5FpmkL6rDJg+MYihfikGHJhQwz3G1
	 i9CohiksRZKGA8r81KtxvrkgghTyYfZV3FAJrWk1PVYefiA58vpEEEgxHqXmBsniR4
	 owV2ekoYL2QGCJD2SolTJFLVOZ8qBKiCaIlIVeFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0180/1376] media: amphion: Remove obsolete frame_count check in venc_start_session
Date: Sat, 12 Sep 2026 08:43:26 +0200
Message-ID: <20260912065611.563341842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 2be6ee86385badab95b1bace984735bde6e0fec0 upstream.

The dev_err() log warning about no input when starting was originally
meaningful when min_queued_buffers was set, as it indicated an abnormal
condition. However, since commit 5633ec763a2a ("media: amphion: Drop
min_queued_buffers assignment") removed the min_queued_buffers
assignment, having frame_count == 0 at start is a normal condition.

Remove this misleading log that no longer serves any purpose.

Fixes: 5633ec763a2a ("media: amphion: Drop min_queued_buffers assignment")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/venc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -967,8 +967,6 @@ static int venc_start_session(struct vpu
 	venc->ready_count = 0;
 	venc->stopped = false;
 	vpu_process_output_buffer(inst);
-	if (venc->frame_count == 0)
-		dev_err(inst->dev, "[%d] there is no input when starting\n", inst->id);
 
 	return 0;
 error:


