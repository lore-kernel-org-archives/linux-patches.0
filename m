Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053743;
	b=NvrjE9ssyo5fXflvBcr+Xz6AK2rcKcLRu3vDkxSTpkVh+bdxY3sOb1TmwJpOpHoMIbf0
	 y5DblO2LG5H7T3EANeLtRqxaUZzvNhjGdD8J139HhLPUCvQwBURe7W5sa7/lcXJ3SwKAI
	 VlNzDWZ/SlnZKSTJIpDBIPEXOh4RY81dQeIurRD19G4TAP0l4hyteefvFAJ/2xMzJsKcr
	 J9wPRFzN1i3nROb2d8cu+Zgca30RY+1xaF48x0GD50PtcDSTTxOLq3o25gAkJT03BnBjp
	 aBT1U02EL8zvmoLUHyZwcUG7dt9A6/A7qz4nt+Ztlfz++9ZP5dTl+47h2OVP1eyArIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SuRYx1ka+GrGxRJoCyu5S0f9YEU85lcgMDeeuv13xLo=;
	b=4TbY4nP9xUqku/2b1Ky0YARgWjsEl0vB9rsOP7JSrIxSAXxhqqEK0DkaXO16E5iUIpZN
	 OIM7Uwd5RM+Hzkyd0BHXnUGFAYjuNtNz8jt8XgXr57T1yw1gt9IqHQsrgtWz9RMhxyy0I
	 8VmksowCh6iju+NoTU/uywg2mRgDnrZ9LwJ69wUN/37cynsah34mBfY8oc94aAbS9lYsT
	 u2vzDQtil6kAWRJNw5UVCt3GcgfE2mtsnZ+i3HRJraeH1ahZCBnNGMmnX/dqtYZQaraHk
	 eruDQ54QgYrkXtNk7pbJTS6B8ml+d7TeuWFs+UpFDY5pNm67sEYkmMubnsUbowQSjxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J87HXWBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A795606A320;
	Thu, 19 Nov 2026 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J87HXWBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA391F000C4;
	Thu, 19 Nov 2026 02:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053742;
	bh=SuRYx1ka+GrGxRJoCyu5S0f9YEU85lcgMDeeuv13xLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J87HXWBSVaa4ZuR7fUoydk7+5gYEGv7PYsErwKFPTIDVcNHYRPPDYeiC1F71VrM69
	 7wpqYypfmR71K1lJatSJFik3Uc1T3mfqbBSKKFyCaIbPGoGfLXBS+Y3OipiR2RSakY
	 xB0KDYEx84gMH2YiBiTeYRRvUOj850McSilCqP+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0986/2214] media: mtk-vpu: Remove redundant flush_workqueue() calls
Date: Wed, 18 Nov 2026 15:44:22 +0100
Message-ID: <20261118150051.677213865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 360c887a39cb56e75be4f558b16f1b6409ecb93f ]

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 2c50b58d4105 ("media: mediatek: vpu: free IRQ before destroying watchdog workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index 87da09148b266..1657575346735 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -966,10 +966,8 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove(vpu_debugfs);
 #endif
-	if (vpu->wdt.wq) {
-		flush_workqueue(vpu->wdt.wq);
+	if (vpu->wdt.wq)
 		destroy_workqueue(vpu->wdt.wq);
-	}
 	vpu_free_ext_mem(vpu, P_FW);
 	vpu_free_ext_mem(vpu, D_FW);
 	of_reserved_mem_device_release(&pdev->dev);
-- 
2.53.0



