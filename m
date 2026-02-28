Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1113355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301016; cv=none; b=bwjddRMgR1sZVWbppnktXl0TzYBFpxHajoi0N9Q+qsQV1dDFd3wW8ssdze6zFXoPcXu3hgfj54krKcUyWc/EnLUCblDPdLtX1G2Xce0QdYXAckkd+VDthcnexEIAh0XkMPZ91CPWOa+U8vNUlyNG963Jq1UA4GKj2s27HXy2wzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301016; c=relaxed/simple;
	bh=rNCkH+rId8De7AeTKfbJtAdu4dW2wTMqeGDe7DTmVdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0kusGGc60v/g4JDNkteOJ3jgcvSHMJJxOQk5EFllz4X5ZA/Ygv0wC8qUuFve+pUNSOa97mtm/lwb8PLER66jQ02SAdClZpxnfHvkByE5wDwgmvUCJZLvQIhvzDcgaRGC3Q6ke72/m1AAP3B3eqcKvNn1cc9PjC7vb8rRrasd9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7HqSEe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7HqSEe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23846C19424;
	Sat, 28 Feb 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301016;
	bh=rNCkH+rId8De7AeTKfbJtAdu4dW2wTMqeGDe7DTmVdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7HqSEe9HSVwQZDmfzKTfvWTRYYeqBPoBcTM4193C6U3bQw+hTigKsGfnJW0m022p
	 qlC8+z9pRXFXi5SAOWVrbm809Zw9wuXsaWjs7Foa4JgFBF1zdaL9Zv7tIQuZ95n7jd
	 EJnL6Z6HcS8dgQWFUMQTDPgIr5KzNnoiC5WK3roMs+GAt4/R7zLOmbnN/idSDLAhBC
	 lby3j6cyTcNDymKNG1cQrDN40k+P7WBYMAZb3MMyRF7HKCfHQ4ulPtUleMXymDAbLU
	 h+07ybeldRHAmipdHtzeJ6BBt4IBclc8V6j+UpTLeSTnsyMdDjRv3z+1CS7wsW+869
	 EDmxfsRjwjRoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/752] media: amphion: Clear last_buffer_dequeued flag for DEC_CMD_START
Date: Sat, 28 Feb 2026 12:37:43 -0500
Message-ID: <20260228174750.1542406-152-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit d85f3207d75df6d7a08be6526b15ff398668206c ]

The V4L2_DEC_CMD_START command may be used to handle the dynamic source
change, which will triggers an implicit decoder drain.
The last_buffer_dequeued flag is set in the implicit decoder drain,
so driver need to clear it to continue the following decoding flow.

Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 32eef2fd1f2a9..6b63e8ca0cb40 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -726,6 +726,7 @@ static int vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd
 	switch (cmd->cmd) {
 	case V4L2_DEC_CMD_START:
 		vdec_cmd_start(inst);
+		vb2_clear_last_buffer_dequeued(v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx));
 		break;
 	case V4L2_DEC_CMD_STOP:
 		vdec_cmd_stop(inst);
-- 
2.51.0

