Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063117;
	b=mdGkx4T0HoeBIqU2rgvq+UJQco3ITQ19YrGjRDtPw5pEAoFRTcNujG+lL0KcMhigLFp9
	 HkfKZG9nczAyfFbK8m7LOBegC1F4kEzlcfGa94ynilBXO86EtRUULkOyavLVEfBr9dzSg
	 Le0al+0AUNXWuBUiJIB6Ds7224OLxk5QHxC22WDU5fYXGOcvX2/XLbrSFc7MO2CGY1Vor
	 L3eiG/9fN5yERUKTqcCiDbshukUwmh+9uWDzW9rJgXroafoAlT9NLChtESIry+U+mYTDa
	 qb2qs/tlDjVsY1lET0PiVYi9T3mgqRdueHpiXXykSKJ8piXUjx7nghxnXutNY+pPAFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P9iYgqpjnxaQW/ShoBVNX2ac5K6HURpJ4BFNnyTSMwg=;
	b=5LTs90le1zWVNUgo0uHpVJecrQmJTOP277IYSz4Qhrhzof7F6Agnx78bngBxUJ5ZoD6U
	 lPjogkLRviKN1qDHWn/KqfT70PkqY+Wu54K5HqetAXX6X3LGUoCDd3zjBy4y9JMqRSwpU
	 A+bZUR13No8HBJt+aiSmvsMUmaowZBiAEU183JHzohsyf+asCW8epvAPHNWk9XUwWeFJG
	 t6qtkApr4Xx/klSjJHSDOAbSYhGGkFnW3Lxk8kG9PbZaoCzGK7rVzfAlaezbuNNPC/BMW
	 CZp6EL26PJfRgry8MHpGd/VgM3PM+KAoSARMlboMsoSN7QJGbx3Kn8aOGwNg0BhyT9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwmrNoUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FF0606A33B;
	Sat,  7 Nov 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwmrNoUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8E61F0089F;
	Sat,  7 Nov 2026 14:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063116;
	bh=P9iYgqpjnxaQW/ShoBVNX2ac5K6HURpJ4BFNnyTSMwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwmrNoUnmgkeINGQLnV8IDeZ4/xcsnPXqdZWjhQB5DID8wqV5BqMBM559+g8fhX70
	 OYM3bUfCjYbSrQPLIVnL9CpTPV/JNkeAtwun2wWqaMwmDg4qsy3aT9fhiLeHt/jdj0
	 /AsB/+zOGoJpwLTVhRoXxx2kepCQTxRkOjbxKGAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 347/869] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Sat,  7 Nov 2026 08:50:29 -0500
Message-ID: <20261107134904.161032894@linuxfoundation.org>
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



