Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062197;
	b=bryeJ5tu8aqrO0HgUJgLhmwBhNAMfb4mfbA6P11bkEzmKGgky51MiZxzOz5mNpYFYhTW
	 AqPcuAO7rrjlfVMZIy0cjU7l1YHTspLK5a092GYY1vybRnzITrLMfF6LP7mF3UumouApO
	 u1NzbcJOb5QMVp5xk2RvrZRCdN1fSgtZfsp2WEatQ4f89lnqIbjGXPdtXxYou1lJnglHt
	 hbrMLNTZEO+QAvJFIdMgF5iA0maaJpGlh9Ck2TQHuxMdUUsx7wkeqJyHAKsbEav1zldH7
	 qmA/423+u8RMjKCjBnmaJvfaA1HZT67AbMglAiAGVDq0RBLHPJi8i490G4/m4SOUS+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEfNZSEjeH3AnZLIIITcz/Ye4HzsZd63EnutnQ+6PZU=;
	b=1qEPn3bTzd5sy+53SQMm5AgzLKr/wCdFcd3HEBKxgxBLANXyiNhJp/XH84hXBkxm/sjU
	 BsIq5Nx9h8rbOAf3+x5cFoDLWhyPTSscDdRUlWy5ExRS//5wwdtLsI5EP3LWkM1YMnVBO
	 XFYOCaV0ZL7rUFhWxExD5kyJ42wsHdnU0Vp7XE62fyIGKNbdjPX28PWIW/Zuzl7D8nD1Q
	 RyZuR6mf7+M4LF+zA8z3cZNSu/hY4HHkLB15k8szTYBUuLEEsrr327ZbpfRdaAxwO7V27
	 TPD4q4H7EHi8JXVxQyO9g3SN2hs6ZqxgwhcINWRA4HOfhID692h4Z3s71R93otEiPJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/ft53O0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AE8606A326;
	Sat,  7 Nov 2026 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/ft53O0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2F21F0089F;
	Sat,  7 Nov 2026 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062196;
	bh=fEfNZSEjeH3AnZLIIITcz/Ye4HzsZd63EnutnQ+6PZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/ft53O04MzE8VjKtjRpEyuU4oX9tgUmfkTo7fUHCVMrE3qEwvREmvU4xs4dwwh/B
	 FUMq73JMbeBj3lMuQybrZrd3v2LeTUmdq8LSO+vRzBinZpnkyj6+vIGTOZdyJcieUw
	 KAcewT3SAFxuLipEn8d9bC15PSHH69fenGwOOw/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1151/1536] media: mediatek: jpeg: retry HW selection after successful wait
Date: Sat,  7 Nov 2026 08:52:47 -0500
Message-ID: <20261107135030.053715508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 2bb86ce85109b..3a7027459731c 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1708,9 +1708,15 @@ static void mtk_jpegdec_worker(struct work_struct *work)
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



