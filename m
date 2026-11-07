Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064382;
	b=wng2ax5nt1z4TTOlPbK3uMRQa1KGg7nVHQzcndEpx430cCiqV27Awe1Nr+DQ20LHZKcv
	 4rcY/LgxB2YX+4e8WaapNd46wAm1wjgBBLVTgQd44OE6WfCOkpBNv1I6wYTiUz4pSdNzA
	 d6bRxSYgxeLdGfyhp1VmVP89AjXCD5XtnajhGVHj/WxJMyorU8zUKayiw3LqU9hJxpJVa
	 2beFEaw8quyZz+5Ow9F7EaKGAfc6BGKVSLlwVXB8PT7tGM8iwMkfpcz7pDbv5jZcAQi7e
	 jRVjt0rXOaC4+mVXjwpBaegTNwlExLcoMybolO4JxkJDaXzEvsNTQ4n/JwZA2eU37kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZzFRStltm3JDXeUQQNhzP2vmQb52+t3hbH6Zy2O8cBc=;
	b=fPoe/28Sdiwvq7AdgcE//wKo64fwyy5UPjM2o2k+v6zDUVDWTkWqM2zVaA+Q7FLG1spa
	 Xm0P/EL77Id59ic0ZjPWFaHr+lD8lH8okIidwMovk167UOoC7DDpAkYi1JzQCIecjv3Nj
	 NJ66FpLOpg3oET7U2y7+lNkRL7a0SnV1LWQmJHGkPb7gHRhTwX6YiYDZIZOoRBXGRKWb6
	 eSL8UM/gzpK+I+ERZmq7HZ59nT313iaPVJ9TEH3u1+C/ABd0qfdgSLtdI0TqdOaG/Yzks
	 cMcbv+BzNFbACTghP0GbONn9dfLFgkN2Z8tupeWX4/9S55jK1D47BElXrZwU5PcYQUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHH5yqEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6D606D811;
	Sat,  7 Nov 2026 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHH5yqEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA8A1F008A2;
	Sat,  7 Nov 2026 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064382;
	bh=ZzFRStltm3JDXeUQQNhzP2vmQb52+t3hbH6Zy2O8cBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHH5yqEZTDYwFQOaA9ayb/6MPAvyxqayh5V0AwqShIun2wwkjQ8KIOL8nu16tNvxr
	 mleWQjdugbCt6hNUaw6099WNcTPBUOueon99aPxoJhiSMmEIcDfabKkY2kvGQoCxVQ
	 OCmX5bB+wL8U2RU/FYTYCXtR5eYKdRn/Ajq+TIk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0458/1257] media: mtk-jpeg: Fix runtime PM leak in mtk_jpegenc_worker()
Date: Sat,  7 Nov 2026 08:45:54 -0500
Message-ID: <20261107134952.121679526@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 7ec8fd17f3a8059dcf94101065a35d0136031794 ]

pm_runtime_get_sync() leaves the device's runtime PM usage count
incremented even when it fails, and a failed clk_prepare_enable()
drops the reference as well.  mtk_jpegenc_worker() jumps to enc_end
in both cases, which does not call pm_runtime_put(), so the
reference taken by the successful resume is leaked.

Use pm_runtime_resume_and_get() for the resume failure and release
the reference explicitly when the clock cannot be enabled, as
mtk_jpegdec_worker() already does.

Fixes: 5fb1c2361e56 ("mtk-jpegenc: add jpeg encode worker interface")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
index af44d581e4980..906174302476c 100644
--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1623,7 +1623,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf);
 
 	mtk_jpegenc_set_hw_param(ctx, hw_id, src_buf, dst_buf);
-	ret = pm_runtime_get_sync(comp_jpeg[hw_id]->dev);
+	ret = pm_runtime_resume_and_get(comp_jpeg[hw_id]->dev);
 	if (ret < 0) {
 		dev_err(jpeg->dev, "%s : %d, pm_runtime_get_sync fail !!!\n",
 			__func__, __LINE__);
@@ -1634,6 +1634,7 @@ static void mtk_jpegenc_worker(struct work_struct *work)
 	if (ret) {
 		dev_err(jpeg->dev, "%s : %d, jpegenc clk_prepare_enable fail\n",
 			__func__, __LINE__);
+		pm_runtime_put(comp_jpeg[hw_id]->dev);
 		goto enc_end;
 	}
 
-- 
2.53.0



