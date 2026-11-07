Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064459;
	b=2VKk+DsTvLLV19DBI/fbHMqDXn3c7ll0+NF5Dg6silq4vuNBzbiL1GmmI96b9lZohoTr
	 NB/lY9LFoRo51GRjQQjj0qV4t6gTydJrwvTzRmutiyUN7a2lXwwCLaP0Bd40tpTyrvgGT
	 9N8+J6cQqUmRpUy3sIkIKPGWVF/wAfGR00yJHqW/XvUVbiW4uDVx6PwuXLwWu3uUobgeO
	 d1GVXhz4b0xmiguhuR7cXRDuOfr0WZwpS8P4Zc6BaQxUxO6NqqwpcLQhmhuo+pGYJFfz+
	 LW7Q8R6FU5vfuCRnDnjP/a0ax4gUSVt9A9c7jSMvfHsC6nqClrfWAlZKRQd7Ok9p1Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8jy9HLr2zXkfTET8YOm2hP9q1cZI8VupGbFz47FGE0M=;
	b=0RCf7lcjhDHxyaRc7Wp0TiFYkWhetElsNAuxh6RtJ6EZx1EZG99BHQRHmFxrLttn/vUj
	 xkoegItUr656aASUn7/cbiPA7l++onGQxXqbNgsxnr91b/XKZrk40KV+pHxrz1D5bYXdO
	 b2NCEReKGuDHziNPIfU+a9zR3g9P2D4o17QFNlXwtq7sfhbl1woVP4q+Hcc3TT001nxv0
	 w9icbiGb2MI5qjmUdWaJ94L/eHktqQxQkJqQmoiEi40PhLvCwt7tDx8VEDwH5xSLlxJ0y
	 vbR4FDzxKo5pBt10vaAs7q/nxDCVkaROdydv5d90bsX0FBTgspGnp8w2kAcEiEc/rlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KEL/jdiy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9636082BFF;
	Sat,  7 Nov 2026 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEL/jdiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEDC1F008A1;
	Sat,  7 Nov 2026 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064458;
	bh=8jy9HLr2zXkfTET8YOm2hP9q1cZI8VupGbFz47FGE0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEL/jdiyf4chYdzCfndMrgQD4ESBcg/zu9eruGCp+T32RQoQa3J8xWDr3+IciyEPc
	 3kgVfQdZfIMSUtARMParxXXeQRaOJw/UnwqZl3AfCurvWKXMlVRoGkzMLTP61nyJdr
	 J6aX2liJba7B523t0ghiy153h0VsHhkQ7cbkH6yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0464/1257] media: mediatek: jpeg: retry HW selection after successful wait
Date: Sat,  7 Nov 2026 08:46:00 -0500
Message-ID: <20261107134952.275333822@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit eb0bbd0ad679bf363387e3b8be8892cfbedabb72 ]

wait_event_interruptible_timeout() returns a positive value when its
condition becomes true before the timeout. mtk_jpegdec_worker() treats
every nonzero result as a failure, so a normal decoder wakeup finishes
the mem2mem job as though no hardware became available.

Handle interrupted waits and exhausted timeout retries separately, and
retry hardware selection after a successful wakeup. Increment the retry
count only for actual timeouts. The encoder uses
wait_event_interruptible(), whose successful return is zero, so its
existing check is correct; leave that separate no-timeout policy
unchanged.

Fixes: dedc21500334 ("media: mtk-jpegdec: add jpeg decode worker interface")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index bddd0a070d665..cc375309e4f34 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1698,9 +1698,15 @@ static void mtk_jpegdec_worker(struct work_struct *work)
 		ret = wait_event_interruptible_timeout(jpeg->hw_wq,
 						       atomic_read(&jpeg->hw_rdy) > 0,
 						       MTK_JPEG_HW_TIMEOUT_MSEC);
-		if (ret != 0 || (i++ > MTK_JPEG_MAX_RETRY_TIME)) {
-			dev_err(jpeg->dev, "%s : %d, all HW are busy\n",
-				__func__, __LINE__);
+		if (ret < 0) {
+			dev_err(jpeg->dev, "decoder HW wait interrupted: %d\n",
+				ret);
+			v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+			return;
+		}
+
+		if (!ret && i++ > MTK_JPEG_MAX_RETRY_TIME) {
+			dev_err(jpeg->dev, "all decoder HW are busy\n");
 			v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 			return;
 		}
-- 
2.53.0



