Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036257;
	b=VabJ+IAcKHk5HdxW4cOi2aAe3rlKrvOD9Ljr62Gy58bK8JQSu6j30OQy4Jn/yjpmutwM
	 t5Al8V7KVsFqFYuPkGr0Aha7rYO6CF8+i5p4hJ62ztd0UoMI7IuUMZOeRfNQIwaxic4VI
	 Tb3ysFQszVXdniA7ylXUgDYVhe0uYz3shX2NMU5pT8xAran39+44CKpNe1Vrpi8EneHvf
	 mbXFiuoufd2QyRp4sBiZfTSOavn787DOYif/3vfNulmOmXGHPLIBi+hqMkfE9rOf4xxLV
	 cEglOQ+pfhIceJph1ZKSh5mahDRP7yeTJhGWuS6BvJ0924W2QUI3loy9O5ii6Wr+Otg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3fbe6ulCf0RI4IKjfNJP9rg6ADOA3XrubGeszGRGpsU=;
	b=R4MpkYPOX8jF7hZAi9trU3+X6Fl/setbKnckqZJpxb8s0d4XKSJxBkwlQc/GtbGzzKXY
	 LEZjXgYF7xQ+VpCmXucuorfoDDZPfsq3iL1ZQ0GWeAM0OxuYR9pjKUQpJ4DBRI2DVcrVV
	 pCjlffJJOfcoZFldInB6QTEN2WDaZO5Z731b0JIuFAJzmMA9MtrcirKfAR0vZVofuAAIP
	 9DVIC3SPRUhdS7g7NiWCo2RmQ1MaVbdJ53W+7g/JaKcErZTwZ60YnF+UNFIBX7Ysoc0hV
	 dZ78kaXkqovmfSg4oltEZPcGcC6RniDhnmFV42G0Fih2pcEdwpPk4wSxlFRFFnZLjZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngRDlYFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6420C606A31C;
	Wed, 18 Nov 2026 21:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngRDlYFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B4E1F000C4;
	Wed, 18 Nov 2026 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036256;
	bh=3fbe6ulCf0RI4IKjfNJP9rg6ADOA3XrubGeszGRGpsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngRDlYFS2Bn0/J8IvRVKbV5d/8CSUJhnWF4lizXerFILzgovHEZzNZoxJq+JUhdhA
	 dgsNTR8uSlOyzzJ57xTD6XDaDSSMV0uTgKPu/NF0VHmbM2hnhHpSBb8iOQKnDLMVCc
	 /3dvyoNBqy1Xi2JS0/AjLYfxs6qIEQb1igG6P5i0=
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
Subject: [PATCH 6.6 0995/3318] media: amphion: drain message work before releasing core state
Date: Wed, 18 Nov 2026 15:26:57 +0100
Message-ID: <20261118150349.681779201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



