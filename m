Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059375;
	b=tm9WTct1YpqK/gpuYNB1d1tGUxnafex45fdvMM2QeWAgxtzuCjaMU23NMM5deOWa3Chz
	 yGvMLOxs4r7arEdyUu4lQprXr/njapd/FDAUuaiQSML2rvU++1jE4NTM+3PdK2cpJN6qu
	 pA3f+cemeeb5GobD79TCDn0pIoV/PF4+eSoYLGM8HdyMqpT+MnW/Lili3Ir5pdmO17/wW
	 K37/KaGwC/ionPvueORdSiVQOqZqqBnOybAOMIPYOyTI2XmHEl9n3gT9ignmrD/eR37WO
	 ssNJr7ycEJKP2n5Jd/Pb3ETUggss6Ll2+/+wKNtyo2qAi7S9i0FozxrB51yRKHL4vsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfNY4wKVyPiul59v0BhUszMojMG+U/lVt+jyK87drTk=;
	b=BYOKs8zSKchdnuF6qpuhnoEGrDblBw0rd2GJ9aj6HDoRXMJHyS0Way1Eqj52EZuH9D42
	 ZRXl0enlrVLoRI8QxGYKaU4M0waNhgSjoAvegXH/3zjaxrdwQl1F7/SgO1t+iU6cgGeO1
	 2Gi/dC9zrcx0u1K0yqnOTrQ6bOEdPZd9SneCO3N4+78ip2XhAEfsPm+OF8aoFiuJw4l5C
	 XsbctB8RsqTLi7WzEXyTcbvGzce77qxDWZefSZLIm2LqsGJMjWP2Fv1Ps6FH3XO/10bGs
	 XYo1q8COqbU9wZKiK+ZVDj+HijEZgaonxPk4x7cSdTF74s9yev3SLcvu38eXvwPhzPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c9Gn/LxV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D24606A32C;
	Thu, 19 Nov 2026 03:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c9Gn/LxV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70D51F000C5;
	Thu, 19 Nov 2026 03:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059375;
	bh=NfNY4wKVyPiul59v0BhUszMojMG+U/lVt+jyK87drTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9Gn/LxVzvLTKn/cg5+zKQDaD6NySGCrw+97OHRvLhHN2xEm51NG6OBD6z8RAHdME
	 8I/+KPsz1GGhveWKgyhyQymsyTEHhjp1CCyEAu6+jSLWpABBQBG2i2KHR1dCbQ3L3A
	 1pzfyztN77IR5oUdSZK+k+3w91rWr7IheFTphk50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0819/1848] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Wed, 18 Nov 2026 15:47:37 +0100
Message-ID: <20261118145950.785714124@linuxfoundation.org>
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
 drivers/media/platform/mtk-vpu/mtk_vpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index 98f043f1c8749..bb207a4ebbed9 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -938,6 +938,7 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove(vpu_debugfs);
 #endif
+	devm_free_irq(&pdev->dev, vpu->reg.irq, vpu);
 	if (vpu->wdt.wq)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
-- 
2.53.0



