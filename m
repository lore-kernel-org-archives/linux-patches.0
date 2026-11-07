Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064377;
	b=P/pJAb0r3MCuD/fWe8nT3IxbhthF5LnS535kzcV2dSnLrSYHkgTn5ZP8emUGQOcs9HSf
	 zwZzTVmQIFpHbFtiJVRWtHCc+cB3PjUB5HYgMNoLnv2MYz/6Uj2iisryFurghaV3QS4Hh
	 fJ/4Me9RCMqdBc5XMun8kqz6ixtMpu4+sk5NBNeThaa/TzfgvSd3Pr1kxigD2w2Mx24Y5
	 ohaBIM6zEmrjU/0YeuwvM61m8qXRYadoZE6qoTmKw8AZostD4SSCzzXAW5LpCAeZRZd2E
	 gr1uFMDbtkCUEyJwIUG3RbUzY5p1XvzfwiWjHs2ApvTQFVnUS7Y+QpqQCS6ei2ZdyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sM8vrdKNxS0JKv19K0mM/gUBMX67Y8U2Vo6X9CD7ySM=;
	b=jdl22VXCDjQStuJMzWb1V6JKk8U3k4NytmE4f3whZ2T+/hePUrG0Qo/lj2ebbs71ZBFm
	 wmppJX06v19fWVOREg6GulDsh0kh5uPTel1soRBg1SPFMfLznnppElexS5WZ8SFGGMoLO
	 T03Jfe4ts90i9tw96ntl5huJZqO4WK5rPCSq772nCOUQ8i55MXt7wBUgqIXMjy5NcNv0+
	 kQqv1iF1hB13EMG2m6R2y0jfEIsNRML9y+lRx5siXyMcWlrZyTuer6UDpqnHJ14QmmBYK
	 4iJ4mHqNKU92pd8ffztLvlObxRp+H3Gk3RQHDtSs8lrh0FM0jZO+PQsI347EtMDFGYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjAr03iY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42996083616;
	Sat,  7 Nov 2026 15:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjAr03iY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9A31F008A1;
	Sat,  7 Nov 2026 15:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064377;
	bh=sM8vrdKNxS0JKv19K0mM/gUBMX67Y8U2Vo6X9CD7ySM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjAr03iYemw0onaO3wjeEwZpA9cE4RCczsa38n5QaA1fo9IQH4G8VEs/KHlCzYXgL
	 cAu7jyE4lLEIR6b9js+xFcRY3sGz3aoq6hoTOQDMn1FYBs0MASFlrCa80Xj9AaqQ6M
	 qdZodx9EtzZtKjcyD5q9AJaUzKNM6B6K8ceNSYHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0455/1257] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Sat,  7 Nov 2026 08:45:51 -0500
Message-ID: <20261107134952.040644849@linuxfoundation.org>
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
index 8d8319f0cd221..b6bd80b684459 100644
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



