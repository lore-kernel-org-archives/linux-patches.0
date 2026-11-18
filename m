Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045289;
	b=3sYHbjLJ0b4BIzBDiBKLUIgdLfxI6QjpKn2Qk8F0ZWZjef2bWNQjXZxYBfv1NF93mfui
	 Xgb6gCsNdfHT6AhVJBToiTa8DSfc7bl3dN2X07tugiot2YUWnCBR3PyLCv9/9GH8S+3rI
	 L3Pnbva97wD87G8JVyAV3LiuCL+kNFkGUDfsWLj/lnrldqY8Ln5aGG/j0UrnmPIjJULPs
	 d+nAe/bfzWExYgo6VVSpyHxwZZJaj/M/rjqA9ep5qCpq/ghnEL3vUAs+Fo6akzn9DbV9d
	 kowyt8C6a8Oe79iA8c7x9MkDGwccLhGt5yl3sa63DS673ZKwOATsqW6IEjEIryTS8Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MuYGgKwUuAC2lvdIZYDhe6q2mJBGwA+gZJu2bIhye7w=;
	b=cPGKuDPc9Pcxqb977hUWTaHG3frV98rcpl2MBhKNAt1YcjVj8bNKH2I25Orr84OHkeGZ
	 AJIjRms2WXkPiEhpPa6tbVMJEgtMPznZRFFMKdvsGu/YMij3QBLGSf8EPHZ8HR2LU0Lnh
	 kmJx3JGE8d/pyD36XTGVaiKTa/695GjFkLr97E6pORXtinR8wt6oSlY80sVFeGmtgCuyG
	 6XjepgLXnoWm+GK+5xN2yMfnPZCxTjhVHFI2fJijmyuHd4/G2er73xqHQ4KzrS/4rk8k7
	 ASkJSk2BNN8+INPMS+OmcVCqGrFf3jQ9GtJA0yFDlGNTye8id8tDfSbeKaTEE4fDC9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLkLERgP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E57606A325;
	Wed, 18 Nov 2026 23:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLkLERgP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981DC1F000C4;
	Wed, 18 Nov 2026 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045289;
	bh=MuYGgKwUuAC2lvdIZYDhe6q2mJBGwA+gZJu2bIhye7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLkLERgPFr8Ig2tTGXOO2ImL7ONIKIBF7/4K4qnjTQ4tls0haAhY/i4zwVVAclMGE
	 l4/AZ8QNHr2b5qVF+zw1f0r8sZgWcaFJfQ0Z1NvK6aLOyfNujtrUSmgtb6qARkABOh
	 dMxTn9JFDS7hAaVJbGSAc2Db5a9vLiQjfC2+vIcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0869/2857] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Wed, 18 Nov 2026 15:31:43 +0100
Message-ID: <20261118150232.851490858@linuxfoundation.org>
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
index 44adf5cfc9bb2..37c0a4abfe8df 100644
--- a/drivers/media/platform/mediatek/vpu/mtk_vpu.c
+++ b/drivers/media/platform/mediatek/vpu/mtk_vpu.c
@@ -962,6 +962,7 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove(vpu_debugfs);
 #endif
+	devm_free_irq(&pdev->dev, vpu->reg.irq, vpu);
 	if (vpu->wdt.wq)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
-- 
2.53.0



