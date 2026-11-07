Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063157;
	b=uGaxUjaHyKTXHZSfzIONdKo1nBuBSs7DJLiGsLR6IQ/2fum+VYSN4xHeSzCoaCG7SbLN
	 hfHOxzs6UBeUNRUzc7mI9Y6qY5VXDTICUG9Sa0ugXPC8YwtKKLv2pQBgySH5OSPl0Z50Q
	 Lg96O48mz+9bfrlFS0uheWUTFsPHjIsAwhBept4/pkMrNvNoxTfpbC0plDXVLMjf2Lvth
	 hmHcbgSQNcE17lFC1v70qsJbI+drfgzHmpk4wq/8dvGWuRws50y1RdnAkFXhJJwSmw205
	 5SIQMq3FMoRlJq3J8dYyeKbRbmRzlRt+DhwdCCCdFC++qoOnkWixqmzDOUxsVlQwERA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXfPkNQ3KsjJw7LgCnLvImUCsCz93Naoe3PJO5xGj2E=;
	b=PNNHPyvIQ56zcpO6UsVdEEQNu52ZyMNkxeydYC626/d7xEwRc0fJ8/o+z/OafJWqwhRo
	 ty1/a5XLf/FfyMeNvFb1S599YrAGih1X4108dQHu+i7fJCkK6Bf2y1pFQ+C3PPWC2hyu+
	 mmnpzLaBxzbD61qEqLXA4O2KvE3gawHeVeFChFNS99PBJmAF8/32y8mCiU44dMdGorNof
	 lH3EUExUee5Y15Uz8rg+Ls6GBfbh9To8IPmMFIbxzzcV/1PBpQ57ymsLlsDdMcmRY6MoZ
	 cb4z5fF5cR59n2fXtWMJ0n0A+OIIeBsWLRogLQkbkGmWIvOqM52eaGORh9pbGVKONrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrdNf8PK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBBC606A331;
	Sat,  7 Nov 2026 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrdNf8PK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC8B1F0089F;
	Sat,  7 Nov 2026 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063157;
	bh=LXfPkNQ3KsjJw7LgCnLvImUCsCz93Naoe3PJO5xGj2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrdNf8PKhBFSo+Llhef5FjX1vv8RKa70J1dE/dTMyi3baAp3rU/bM5j2/GnqOxGCP
	 WNv/RMuSxBqdfyLIB57N4RUgwnhpCEvOkEBSAgY1s8oZFXEM+yJ3dMf9eH5W5EVThr
	 R4a8D1Pw1b9Zh+fNeeIthFkNpdzA8zCIIdvh3RvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/869] media: mediatek: jpeg: retry HW selection after successful wait
Date: Sat,  7 Nov 2026 08:50:36 -0500
Message-ID: <20261107134904.381331009@linuxfoundation.org>
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
index 0e2bb13f071af..8e52b40e2423b 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1705,9 +1705,15 @@ static void mtk_jpegdec_worker(struct work_struct *work)
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



