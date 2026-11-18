Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045283;
	b=hwlHo89rjFltBf/E8XhNEI387UqHt+gOIYDN6S3pbhR0bcEJuqP8jJYfrcyzBVZgj260
	 jML/IQs69DXirwEkl8FtksudIMgLyvk4+o0zj6hqpIJ0iKQt1WQKgFB0SaYZmSLNoiStV
	 2GLRXla9GDbJiNLfdWZ8F6ehEhVnoGqWunMuPTriTQtW525ZneOINJTFDSHAa79HtMs00
	 JiKIQoPFtwOgUpNvod+oA1FJP+dVY6TIzJLsfwquqAz25wakkruSiOqB7ET6A4url1Knh
	 g8Iz6/EVoIX8IOJh5auf4+VoGButqNzRPiA9PLqrIc4wN9S/6ePx0GhyKX20MkGRjdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T7JFgEQ9w7VvIAHABRJ4wKoLKf8YI5AXcaF2H0Gk0es=;
	b=pAelkHcan3OffNnnEQtawvfpcdd/ZKxJVIeBbo5OkIWh4xmOw6sf6dGna+KgpSk3i3Zk
	 JKeszskvAn0RFpU/lF4kDw4iBe10DgAtG8clDunx/4P01opzqpptQfvg3fNTeex9WhsBV
	 WSEQhXrgVlFaNn3w9t01+mZk3XNgmQKZw6ICcH92ZzxPsvHMAZJotl2G4LfupECokxr6s
	 g8TXIJ0L5/bj4SbYRpIJVqyzFq0bn12UKiFiYcAkTDhXK9ZuWZKTb8ho2Hbmw2vjKVNel
	 YMi7vWmw9AZlpLwi24vCj7g8uCV4g4Qke8EQSBWiCufWS02FcTe94TlqnCRU7MVtOEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llcc2GFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C84606A31C;
	Wed, 18 Nov 2026 23:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Llcc2GFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FB81F000C4;
	Wed, 18 Nov 2026 23:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045283;
	bh=T7JFgEQ9w7VvIAHABRJ4wKoLKf8YI5AXcaF2H0Gk0es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Llcc2GFEz1/GjNRvFbD93WrTfW2j94ioasQa5gqLf/oJmGh7Uf3Px5Ac187Y0q+cq
	 r20XDuMyTl3KY0OjyNG/3BLi/5hEPL/nP7GxUtc5+xzdqm9IBUDVrvm5usSyKVjhpx
	 P1ptvW8VEpoxWL1lR9+1gL2BOh2+zxzQ2Kz+lvbw=
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
Subject: [PATCH 6.1 0867/2857] media: amphion: drain message work before releasing core state
Date: Wed, 18 Nov 2026 15:31:41 +0100
Message-ID: <20261118150232.779290135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fabbf442c66ab..d549c0f4fa36a 100644
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



