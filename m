Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059372;
	b=nRMhmTY9VGtLCWYOdMDimQxDTB0kZJAOWUTe7pJM0mgQXE23xpt++KMSRe2zUJ8D2kuq
	 ynTkPb0t8epaPAm9Lan+g6aRnitprrlm5CjB4WsVYHlpoNz5Jc8l4LE8pX22F/iILRGr2
	 2zTt8oMIfW86Ir6C9xMORpbIKcGtxNRfJqLKLeBbUjYHLo/1uWcXp0cI1lSiAEIb1zYSu
	 JaEgEPXz7DW0K8mPUmsShmVAkmtdXJrxhasU2gA3b1ItfTK6rYOgABrJZ55E1wKaLznTd
	 iUDP7snOuYsTlxUVupHiyzKx4r9JkvJOBZSdRTwSN+d7Qhh9nvspav2RQLU1v2WQ8JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dbp5AsaVnBkZIkQdufeYTMQ1NoemX4k9tdxaPaSo6uo=;
	b=TGiCeV2Zc4pYD151l1xbxVMJabskcfo7plWLpqtLHhB/cZpbhfvW8YrvtPnWdr/cxYaZ
	 UQ/hrEJSn5osq8/6+U4lx59EaWoze7xuFqNGTHDjdF3EyBUbZodaYQ1Ke5PxmLMKuS3hg
	 f81SK/694fiTc7EMYjpcpM3vwIyOx3vuVEm1Mvy6QWkjIqrHS5mYzP2OVCaEhqpMC5/Ho
	 0KpXl9B6Gvre/uz25TSmHRrCFTB1HdKkz300c0YV5QgpN/NFlZbj6E3hnWa8B7TRMruqn
	 cksLZveSF8SsrO79zvwF2VqlnfRN/0JkjdThKB3+BuFgTSFk6mpbQUHJjtRF16X29vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWhWbIVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1351606A326;
	Thu, 19 Nov 2026 03:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWhWbIVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3545A1F000C4;
	Thu, 19 Nov 2026 03:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059372;
	bh=dbp5AsaVnBkZIkQdufeYTMQ1NoemX4k9tdxaPaSo6uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWhWbIVvHPUlgUj4wFQ8r7n1c8jdq7UwwO1D87kLkQJ5nkSAcNDj0SDtiyGj4O29O
	 H4cpYQSpx4WZMuzd24tTzLnqpF+F7VTOhFQUnR5UOUPsCcFwhMXJYUKZp3wE1aI80x
	 iL+dXT96Wdid3W8/CIbufaZyyFukU9uNqXOkURdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0818/1848] media: mtk-vpu: Remove redundant flush_workqueue() calls
Date: Wed, 18 Nov 2026 15:47:36 +0100
Message-ID: <20261118145950.751929947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 663694dff3ddb..98f043f1c8749 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -938,10 +938,8 @@ static int mtk_vpu_remove(struct platform_device *pdev)
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



