Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062187;
	b=44f0fT0RiL3peRyIjjqr4pONpVIlHeq4HChU6+6TOwFY03B3zVfZViPs8TlJuXBN4Z3z
	 wvqsbVbnIHvrn1Cc6kpNEXypRMwB7ui+9AIuUPYakSChtepnYh+dHSStTg5MVOmXPplT9
	 wy5UoGnxuep1oqK0XXhRfp5N0Adk0wjH7vJF7B+gA1s4QO4GESUHnSypmt5YRva3S637y
	 f0MdTDwjZd7qORhEZmOQe2P9IeotexVkWam3QzZYsoSsSsi4Pk1TOAGziTi8x4XYhxoog
	 t6gImpgq0g/dynfFx3Pche8bLPRpGU7Gt3+aN7v45KPbvLVjCCoHHronk53T1TxGlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4pmMgnbijlcdbihgGKJQn9Y0hVox7O1/BC0VJ0mIi8=;
	b=LFuF68JKT9U9YSABpHEwWsZX922OCVQqptVJE7rS10Lrc4JJ3P/4h8D+PARQJCDzUUrI
	 2PdiyohQLuZ8nwNfcjAhMvTwtgF1zYRF3pCMCb+VCctU3k3WvWX4HKTBtcVNG2cJMtkmL
	 /4QxD0ltyZmmIH7EUNymYr2MbOuzI6YPb+eoewOLIkaqZ+yYqOXqG73V1goQ8D4LI7clU
	 cLnV2ofJtk6DjoQ86WoY/nVxCqaJSPD8yf2I+8prAX1EtGokaAFvW9CcSS7upnIbKvF5L
	 grM1dIhJ2NWRo29vWAVYQ8wjutAaojuUtneGkqZixEGLMPmzClKbunS67+TzerbbaDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uiYN7l+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0FC606D821;
	Sat,  7 Nov 2026 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uiYN7l+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9781F008A2;
	Sat,  7 Nov 2026 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062187;
	bh=Q4pmMgnbijlcdbihgGKJQn9Y0hVox7O1/BC0VJ0mIi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiYN7l+oPUj8iNb6hknOgigBgXwKtha1egVvYSqf1knph43wcIt3MO1QcF9dux87I
	 hczQBvxBVI3SBbuUGzlQFsOAHK3KS+LhsAYCT1EXxRcvJkENJQ6RsJSleLFX+5SU9x
	 laajg95wpjBm93hSTTP2bxTuDwOKEeLRBj0MdnI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1144/1536] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Sat,  7 Nov 2026 08:52:40 -0500
Message-ID: <20261107135029.852386916@linuxfoundation.org>
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



