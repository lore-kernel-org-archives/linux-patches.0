Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053626;
	b=IIvjDu2Mh7BGzxUKN3BwveukUYKqqBEQh9YIwA4SY7Rv42u1QSoFJyNqWsmykwP37pAB
	 twxocP8n67XMecYOpjQou79g+P14u22o/bXHIFPmS+a/65WXBCPq/QT+MP4hITiRt/n9v
	 aVqQI3rK9pY5uDhnbFsIN74EbWB5gbuDTDItYvNC1tliafj7AdTuzyIVURplOXCizezzE
	 iUyk/+QW3imaPvb27hCQNp71x8ZeKhJm+csgA29ToeaiAuNRv3+FeGFSMceZhmnP0z8zw
	 LIg0tulZuvKjX56rlxZcOwWKS6+jaBj2QyUpynM7hCpxLYi+yR45TBS0S078LpHdpYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bxTCGdHi9wBRMb6UWovSs8udduI1iGBFFn7ypZX7brE=;
	b=5OljJB+SKt7A2PnS3zz7htsfZQcQ5zCQqRNM04r4S7CqaoiTp4GjtCg7kTvyEjpKAD4/
	 LARIDHFduJcRaggy+4TXXms+PkrtgzbbFGvDW8YpHeSoXX6NXB+k8/xE6Mf+YifVIv45d
	 3S/jlg7fLMjNGY9/0CB+Uzkeb2QMQ4iLbPs8ftSfkkvIOwic4WQQmx6C5xyJcIzGjXBCB
	 N37gOMuW5ThBO2Ys6/geeO5rRsBoacBTwN6CxnRdk16kDxEskBvV6gV4dLZtNme3P6A7s
	 5OKlKYq7JNtAJqI+vBmpQPPJvxnY/smR/S3sGJe/HJm04bsgrYBUxo3I1Q0DiFtQtjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLEuG7J5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23A0606A32C;
	Thu, 19 Nov 2026 02:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iLEuG7J5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DB31F000C4;
	Thu, 19 Nov 2026 02:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053626;
	bh=bxTCGdHi9wBRMb6UWovSs8udduI1iGBFFn7ypZX7brE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLEuG7J5TirwQh+nIjt3LmzyhVq6BZN9jq/cRlP5eaBSOyh0ixt6Fyi9/sMGcKyMY
	 gNY7EdeHVOf90USqNOoXH/vVq6XX0eR6lJ0ZBBb2mWMQZzH1RWa7wmSzTR2yFsEite
	 wXC12Z68uG6HeRqNgoBAo2y5GeXDl/aKXACCTrvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0987/2214] media: mediatek: vpu: free IRQ before destroying watchdog workqueue
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118150051.717602332@linuxfoundation.org>
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
index 1657575346735..b10102e093f4d 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -966,6 +966,7 @@ static int mtk_vpu_remove(struct platform_device *pdev)
 #ifdef CONFIG_DEBUG_FS
 	debugfs_remove(vpu_debugfs);
 #endif
+	devm_free_irq(&pdev->dev, vpu->reg.irq, vpu);
 	if (vpu->wdt.wq)
 		destroy_workqueue(vpu->wdt.wq);
 	vpu_free_ext_mem(vpu, P_FW);
-- 
2.53.0



