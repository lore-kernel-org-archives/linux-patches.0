Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063114;
	b=r1EMwoeVsvJOV5KL24GQuElrWOhpBRl4S3iIAeOgYvrW8K9M2WNOqNFTdJCboWNysM3K
	 3l0Nj135JgWDRROipsrUDqa2Iw+H/fYYS3d05Lmwp/jj+WPdPxFf+6UFN1dsSGPbrVHVq
	 ZGcVZnANgmyeEnRVesIRJeJkoCHRuKFghZ/M1cuhHoabNDBSsNH/pYrMgg3OjUI43zoFS
	 1bGmfkIu5z5vcZvkcMk6qftL4g3MCX4Oa2zo969LdxfbBwwYb3kWRkXqQvQ12PAxipkFR
	 58lNcZY1MEbB0k3eMaZxTGp9lAhGoNU/hVEuiGbFVAGT2xteAdAToaODa8VN3BGNdeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jz47uPD3oK58d8N9jRLmruKuUOJ4rAuEqDdFKN7iHOk=;
	b=dGvUUoOsBW3Y4OHuJHDdcNm1VCLmrZNKEJNwx9aGZmhhqtUTCwGiH7Z+6Xmf/r/t/Z7Z
	 FLmi1lowfWgIP6WE0d6sdVnqTa4kaglme/r3nFFSoIVDyXB3GJOpKbztkV3bWyk0lF7v2
	 55bk3TR/VhkrAjGLURrAX2xEg2HY3jwfZuxbBRGowCAlKyFVdTImZJtsc4UMo/44WPVSO
	 IlSmmC2KmUSa1PisCh5P0zMHS/Ga66imHh4aJzhzSCUZW92asKc263rgxlMaCC2qbFpG/
	 lyIJfVex27l6lDc3iGaI4s5tLlqLJ/WWYNNs8OjTg8h3aYKxAgWHkQyJM669jbYO+4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFiaW5tS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2795C606A33B;
	Sat,  7 Nov 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFiaW5tS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9801F0089F;
	Sat,  7 Nov 2026 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063114;
	bh=Jz47uPD3oK58d8N9jRLmruKuUOJ4rAuEqDdFKN7iHOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFiaW5tSa17GeGj7tN73lfowxxq3JQCKdiB6bboq2Y7DadyQirMUuB9sf7Ctz47FA
	 kZ/kRTscG2n7YvgTZXvDg204Hsevtl8axPeXf4iXEiiC803oWh7q2UdZLpdshB0vdV
	 CKzbSJ3hzR60lOqNCzwB+JEq1SlfscINb2ybaiBw=
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
Subject: [PATCH 6.18 345/869] media: amphion: drain message work before releasing core state
Date: Sat,  7 Nov 2026 08:50:27 -0500
Message-ID: <20261107134904.083376380@linuxfoundation.org>
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
index da00f5fc0e5da..0501c2383ccf7 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -302,22 +302,23 @@ static void vpu_core_put_vpu(struct vpu_core *core)
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



