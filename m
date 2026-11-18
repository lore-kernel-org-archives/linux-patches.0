Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036267;
	b=dGD/M409CKJdFY2j1GAKkqX1tikmUj4XcFGHpuTh2vKm4DdTj3azQXgNjS3Zx/BJ1Tis
	 BQ8V/38vBygBX4Iiu4G2HNy6P7367fIW56UIQlIW7M5rvGW0Pxct9CaH+bcjPM2jegd9g
	 IcDuIuW5WVsZTnybFpecMUF9ueL7+vk+yC/ivBEMJUXgHpaSBZAKqlsGPHZHAJLatiwaz
	 6k7ANScymHg5MoGqypiDrIKlr2fctZlyop8ILaoy6EfeQBcNEKvjEib4S9fJZ7wVc4c3B
	 iYQ1CYo+E11Pk6O8lIa3ump+FTfiGqjn24NFKWk/zOiFkC/qgygNK2iXj4dOk0U4qpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jTDKoMmxaOPpNYd3z3O+NWcT402VSnIF2BBln1/g4gg=;
	b=x99KB069gLJGyg4JSGecYLc8xRvOb7s8BHbrFoiyXCtv8NrwgIOx/XEydxPMaoEbsJAp
	 00BnRrms+k4wiLylC23Xo6FdzSUd7pT1qEj7vPgqf3rfyyqRWRUozhQ04qtYFnn4zA63s
	 F+mTqJtF6rOM1nteeF65FW388mPuYqQckMBOZg/IODdSIb42jQpecnIhsVDBeGgKojtB3
	 HC4pySfeSmCwrpBalZ0OYp6XtfQ5P126xc1B4DgV/EktL39gNpzmujP10jtlpnEvx5cEC
	 V0IWc6Lzf9qGbA8Te9UXaFGjYWYGbIXQq5mgmWMJQSLvOBUZm+rWeg2SKZsFTepc43w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqA89TSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CBF606A31C;
	Wed, 18 Nov 2026 21:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqA89TSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D911F000C6;
	Wed, 18 Nov 2026 21:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036266;
	bh=jTDKoMmxaOPpNYd3z3O+NWcT402VSnIF2BBln1/g4gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqA89TSATL5N70unmQPwu5cmy9k/OWSv8UwkBvF5GPus5gEQMeb114jZlqs3gNwoi
	 y92wseen7BbNtK+ItExz5HhlyoGOmNTyETLLebaLAmAV5tScsbYXvkyJC+QQJu6fbc
	 DV01J/9ktE4pMBvrzd+NPaZk75lK8hqxeQ/PH2kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0997/3318] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Wed, 18 Nov 2026 15:26:59 +0100
Message-ID: <20261118150349.748875392@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 2c50b58d4105f6dbaa36d6306087954b9100e9ae ]

mtk_vpu_remove() destroys the watchdog workqueue while the interrupt
handler requested with devm_request_irq() is still registered: the
devres core frees the interrupt only after remove() has returned. If
the VPU watchdog fires in that window, vpu_irq_handler() queues
vpu->wdt.ws on the already destroyed vpu->wdt.wq.

Fix this by calling devm_free_irq() before destroy_workqueue(), which
releases the interrupt and waits for a running handler, so no new work
can be queued while the workqueue is drained and freed.

This issue was found by an in-house static analysis tool.

Fixes: 3003a180ef6b ("[media] VPU: mediatek: support Mediatek VPU")
Cc: stable@vger.kernel.org
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vpu/mtk_vpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mediatek/vpu/mtk_vpu.c b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
index 724ae7c2ab3ba..3d437898e1f47 100644
--- a/drivers/media/platform/mediatek/vpu/mtk_vpu.c
+++ b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
@@ -962,6 +962,7 @@ static void mtk_vpu_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove(vpu_debugfs);
 #endif
+	devm_free_irq(&pdev->dev, vpu->reg.irq, vpu);
 	if (vpu->wdt.wq)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
-- 
2.53.0



