Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062185;
	b=NfhbcZF40Bs4Be1mGfVFECYjJR2K0Wv1AQ2cWhQ5R5XGcPGAIEFC39vTv/p9UovBB3Cs
	 ucdA7RIZj5Wml53aDyLPq85bb9dj1BhvdjIrPUNm72tOOfyz39Gf35FP8Yc6e08fwmfhl
	 WplFmoCImDABILRgktwSNhf+5hE9deO/s68CSJ/CKoY2lzA8wdDgqOqJu7Wh1Tbm9AtZc
	 BW/g/FWUweJZuVt4Jyt64UbIkvWp9FTRpixXOITCM+WiNFjmuEpDpNyg/qd0s8W+E6T/D
	 GKv6aDXxOpIPg0KwGZXEvylGxaUjU5i/RYl2Dg8sQKnA0ewM9xXkC5RSBOpiscCcQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPNRspbsboGzpTuCp01g4Y3SwVIo4qCDgpGeKEzKPKQ=;
	b=bKNeBkmDkUrftEqh85/o7hVSd+or03+gUo2sxkQjyDoYJ8HQmw+U2HLFd9c3EqUUwk2z
	 pbXgrHAWfSGqD94QfjRqtxIw1r/ljrRmMTlLthah78aduz39k2laa5hELJTn91Emm+u9c
	 fEONYN0yEcahL4LnFLZNUUlro2HXW4zdzfnT6WQUB2swI7Chgo8qZQ/KboJF4Pa3MLkMf
	 MXgFHhyiQnhZPlELAFU290ySCeay0Ylg1m85TYi1pU56fzTay9uN9tYMJn9HXIGIk+aul
	 5eXOk/baerj1FBkX15N9BRglg7/s9t0Ef/Emye5gSONMq8sD5kZQetBWVWyuY/WFeAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4NSvmuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5CD606A326;
	Sat,  7 Nov 2026 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4NSvmuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616A91F008A1;
	Sat,  7 Nov 2026 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062184;
	bh=HPNRspbsboGzpTuCp01g4Y3SwVIo4qCDgpGeKEzKPKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4NSvmuG8wMRjbeo6CbkygKr3zHGsgKHh/6XXXZ8ZN5but6WMrggS7LWNd5T+Qx52
	 xQGJxXKTao4pXIFEw/QvwvwpvhS0N5bGgX/oREwd1eLDzuC7PXacMg1tYsUiq6BM2z
	 STFbWE1Bw1WTuFNcc4VGXXnCRvueK4OAtJ4ou3fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1142/1536] media: amphion: drain message work before releasing core state
Date: Sat,  7 Nov 2026 08:52:38 -0500
Message-ID: <20261107135029.790834214@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ec95ae226f240ed657834fe4114abb7067e1af2d ]

vpu_core_unregister() frees core->msg_buffer before cancelling the message
workers, although core->msg_fifo still uses the buffer as its backing
storage. A queued worker can read it after it has been freed.

Drain the core and instance message work first, then release core->vpu
and the FIFO buffer. This follows the ordering in vpu_core_suspend().

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 3a2030d02e45e..b2531a0e6c0b0 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -301,22 +301,23 @@ static void vpu_core_put_vpu(struct vpu_core *core)
 	core->vpu->put_vpu(core->vpu);
 }
 
+static void vpu_core_cancel_work(struct vpu_core *core);
+
 static int vpu_core_unregister(struct device *dev, struct vpu_core *core)
 {
 	list_del_init(&core->list);
 
-	vpu_core_put_vpu(core);
-	core->vpu = NULL;
-	vfree(core->msg_buffer);
-	core->msg_buffer = NULL;
-
 	if (core->workqueue) {
-		cancel_work_sync(&core->msg_work);
-		cancel_delayed_work_sync(&core->msg_delayed_work);
+		vpu_core_cancel_work(core);
 		destroy_workqueue(core->workqueue);
 		core->workqueue = NULL;
 	}
 
+	vpu_core_put_vpu(core);
+	core->vpu = NULL;
+	vfree(core->msg_buffer);
+	core->msg_buffer = NULL;
+
 	return 0;
 }
 
-- 
2.53.0



