Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591026;
	b=X6FJfDueDW5BqZ7lwWk0U4hE3mbvqo9L3+XK9ysGZbxv+Fv+E5Kbpho/VwCYGkEIOF8r
	 0RjuHRRINav80KI3IeO6uG2aPjmJqMHk8KD7FK2vLz/qgGLezZxmJNZRfi2nU2P6ePl4e
	 CioryWzjtPXZs+pwKHdCqGR+Ut3i+Sw6BQyNREu5+ai32jnQzrq0WTfVgqAatHrQFye5z
	 raxPwKhYh0RBTXSfUMZ5E0YoMTu7RTqoBpcQj+KIcOLK12ePYvbS83TACx2kVhNvXW9bL
	 pVCID+bf0XSClEQ6sq8Bm2iFZH6fVmF/GR7vt8MHbjEO0qAhQ+p5gf2EZ0rGJy5brFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VvMONmzaxO8KmqT85cwLRN3izDVzI2RQN2cqD2ExxTw=;
	b=iX/Pud60bCxDkAAL2320l85DdWyfZ93UNbgZHSrhQpUS94PKhYoHu2HfXNEX0jPC4LJj
	 RrJXCOMDwRxarFEr96+elsHo750EZcZbH93SFYzfxv/YMBjyJc6sF74aL4fkX7z6f/nTA
	 moxOLCnY3ua4RD5ye+D0u4/wZTN8EarHeOL1Df+xax4zjuzp0yIi0VzgeMMYs3xDH3M3u
	 L8vf3Ze+dd/MBU+EnUmC5XH6u3+JxW4V1RL8NZlh4ruZ10eR5ZFFIhePNnmDf6uUmtZXh
	 YwJezBSM4djQ6oJYprnKjEf0eK/tQcvpXacL0sUZAI55LjM4pzUDJZGFfFFnnLqjAOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hq2gyRH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7DA6071422;
	Fri, 13 Nov 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hq2gyRH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFAC1F000C4;
	Fri, 13 Nov 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591026;
	bh=VvMONmzaxO8KmqT85cwLRN3izDVzI2RQN2cqD2ExxTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Hq2gyRHaPieYx9zsS56SLpsVeI1bm2e6RtCvr0P91AjH86zhhby8JgSlQfdx1zZl
	 h0omPiOgg9p35a3L7tu76FozobwYX95PJ2PZ98J5AZOoXwAFJq/5vuVvZSbfz4zlG8
	 kUCRGR0PjalQa/ANTGUxu12q4y9xVvObf3zC7Nw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/670] media: mediatek: jpeg: Avoid context access after job finish
Date: Fri, 13 Nov 2026 10:45:12 -0500
Message-ID: <20261113153816.939257194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit 7c7f31405b76acd95a628c834ee8a2d6da439782 ]

v4l2_m2m_job_finish() publishes job completion and wakes waiters
before it returns. A concurrent file release can therefore finish
v4l2_m2m_ctx_release() and free the context while the single-core IRQ
handler continues with its tail.

Both handlers only need the device for the matching runtime PM put.
Use the IRQ-owned jpeg pointer instead of dereferencing ctx after
completion has been published. This preserves the get/put pairing and
removes the post-completion context access.

Fixes: 45f13a57d813 ("media: platform: Add jpeg enc feature")
Fixes: 5827e4b14ee7 ("media: platform: Improve power on and power off flow")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index 3a7027459731c..a69ca8fc5701f 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1584,7 +1584,7 @@ static irqreturn_t mtk_jpeg_enc_done(struct mtk_jpeg_dev *jpeg)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
@@ -1871,7 +1871,7 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	v4l2_m2m_buf_done(src_buf, buf_state);
 	v4l2_m2m_buf_done(dst_buf, buf_state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
-	pm_runtime_put(ctx->jpeg->dev);
+	pm_runtime_put(jpeg->dev);
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



