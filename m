Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064375;
	b=DMqHHZ/vnuHhy4sQ53LlKbaor71suPrHmVUBK+p6nv/Cf/MSO9Ovpd3y7ZovPG6P3bJE
	 0Rrsg5CZv9EDG/PQBsYx5R4CYwRuzz4TLy/Iw0gdP+ZUkA4GqYh4SnSHPk7nQF0o3418M
	 Yj7abjmpg17BpJu9ovysMxpOEQ5qSgpONhdfJaNYrT5PFrzi7UaFpxJ07+UdsLIENKJ5a
	 ETEu/a2T/Fv7IVOZCVGM2T8Qf4cJtd6Qn+0JcAWwwi48CVSNBC/Qa6BpTEhuqXjcfT9Nq
	 4/XTrLBa0nlajsdk5N4qF/23KwB6oOVCt83sViWUBcfbm1ZloAb5+bsZG6Di2dVtKqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WyKqdOxMCtfYj6kf51mLNjdM/7tzwtb4fVzhS2YtXww=;
	b=U6tRI/f+pRkuK4/Y7/uDYrDc2wwGHNURZ87MNzk2lOl9MIUWlVNr2Q8EmDjHAMOHKKo6
	 8WkSeLkbd2w4ZSRtYudydUrjFEryYmUwkOy2RGJPrAumGwGZ6k2iudMG7AZTz9er57lKu
	 5DBZiSbWmkpy0zw/PSk9O23gXk0wTbLfcfSGaAg944SaAfgzgh2so3usogXfx2QqqxNvQ
	 T6loF1Et36iM8nKtxI70BZvn7qTziIaDkvUpqheVOgs7PuQ6iDsmHjFTBNSP8xEvzk6i5
	 y4r2hC5a9uhfs9pwG++Y1NqPCq/WEse9ZqmSDbDhddns5w2+xWg8nXLRSUfH+Zxqhug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgOjpFQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD36082BF5;
	Sat,  7 Nov 2026 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgOjpFQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941871F008A1;
	Sat,  7 Nov 2026 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064374;
	bh=WyKqdOxMCtfYj6kf51mLNjdM/7tzwtb4fVzhS2YtXww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgOjpFQF2reRGDFKQcP2vuK0wAKWLnTtjHoSD9D95A9KD1OJnF4Xkqo1Z1jJSbruF
	 uOufquClXCRnEDIhXgq0NeKSrD8esPL6PFFNo9imzUUGLeU9nFw2q9gxKrTvJvcA40
	 9CP3Rb7KszC+rLEiSyzpaYAxAA8ofXuFIx2sUmns=
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
Subject: [PATCH 7.3 0453/1257] media: amphion: drain message work before releasing core state
Date: Sat,  7 Nov 2026 08:45:49 -0500
Message-ID: <20261107134951.986780219@linuxfoundation.org>
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
index 85cc4a14f8ed3..a0c58ec97a424 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -299,22 +299,23 @@ static void vpu_core_put_vpu(struct vpu_core *core)
 	core->vpu->put_vpu(core->vpu);
 }
 
+static void vpu_core_cancel_work(struct vpu_core *core);
+
 static int vpu_core_unregister(struct device *dev, struct vpu_core *core)
 {
 	list_del_init(&core->list);
 
-	vpu_core_put_vpu(core);
-	core->vpu = NULL;
-	kfree(core->msg_buffer);
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
+	kfree(core->msg_buffer);
+	core->msg_buffer = NULL;
+
 	return 0;
 }
 
-- 
2.53.0



