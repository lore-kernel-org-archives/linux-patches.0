Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062810;
	b=GAIwCoJyGiIcb4amADf5qkC6RlOG2vE5ATxeUrlMHS/ggiuhCRDN6dCdd2SZ+jjmCZav
	 l60W9mRQKg+IEvSGeHajE0XOyIMQ+FsmEpweypsgeOmQRIJP7lTEmhcW9xEsKs4EHLbH1
	 nFVsJtvQ3a1rDcsclR/y+NTUG491Ki2wKmLOwuCHA37bdry2WUK196wv+4QOwxGe93hl2
	 Otv5Foho3GfWPqi3xSrP2Qu1SORjmPHnZgz/QHN3BRwinbQHxBhNCeQUY21BTPq7tqv3F
	 FTAeRXHQc2XOlJrS5xhDXc8Bb8bx4yualpK1Su4WFxp2PqBtrz3vUlAsmUGlYkeb09w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uSCnuG3oe7frNLtVQayuPUSRRVg1QOUG52tbyAhuy9U=;
	b=zuvJ9SUb5TCIT9OYi3TdQ/2C+LyS4pjdFEaiMKhoiPm1r/UDhva749MmBoPkiJEdxM+D
	 nn/qnmixnnLL0x+GDttHH3C/ON5XmerGKnu9QLACW3b3fqhiSPUD730rZ3vHpo2kTy3gm
	 BA8sSkVjXV+GiFhas2ifmxI367QE5uKw2dTCNv/VxQdC8L44Db9IfvNZKWP1qnTT4xbIa
	 Wtv/jeGP252VIod0kk0tCtCnlkGiNTnkpv9pp3SF4lE85Dg+pb+hHTvkTy7qkI8yWv7kY
	 wHM1cW1+2OcUckM42JbMPZz8bPVEFpAGWPc0toTAifdwpJdFKTc70yGe6tHg4EL2h4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7bYnI7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9BF606A332;
	Sat,  7 Nov 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J7bYnI7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9E41F008A1;
	Sat,  7 Nov 2026 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062810;
	bh=uSCnuG3oe7frNLtVQayuPUSRRVg1QOUG52tbyAhuy9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7bYnI7+kVC7UT1gtTDtuL+cBbmk5WKEVl7Kf2YVKw15AkxbzojgPaQ4alzFuJh8b
	 IfqYK2IScRYwzvAvG/xij/6gguhN3dTgGDM49SnjjU8jeY4JnFjS9x98O7tHTQrsDI
	 Bnbh7hlDlQo+1FRTnFcT2UwK+oc4RqqJ6xz50JjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/869] dmaengine: altera-msgdma: initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:46:32 -0500
Message-ID: <20261107134856.321115015@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit a5f8e3471fc20567df888267885dec3eb340eb37 ]

msgdma_probe() registers the IRQ before initializing the tasklet, lock,
and descriptor lists used by the interrupt handler. A pending interrupt
can access incomplete state during probe.

Initialize the handler state before requesting the IRQ so the interrupt
path observes ready software state.

Fixes: a85c6f1b2921 ("dmaengine: Add driver for Altera / Intel mSGDMA IP core")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260830053308.2190597-1-runyu.xiao@seu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index e1811a9be0bbe..2d4bca495b3d5 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -849,11 +849,6 @@ static int msgdma_probe(struct platform_device *pdev)
 	if (mdev->irq < 0)
 		return -ENXIO;
 
-	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
-			       0, dev_name(&pdev->dev), mdev);
-	if (ret)
-		return ret;
-
 	tasklet_setup(&mdev->irq_tasklet, msgdma_tasklet);
 
 	dma_cookie_init(&mdev->dmachan);
@@ -865,6 +860,11 @@ static int msgdma_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&mdev->done_list);
 	INIT_LIST_HEAD(&mdev->free_list);
 
+	ret = devm_request_irq(&pdev->dev, mdev->irq, msgdma_irq_handler,
+			       0, dev_name(&pdev->dev), mdev);
+	if (ret)
+		return ret;
+
 	dma_dev = &mdev->dmadev;
 
 	/* Set DMA capabilities */
-- 
2.53.0



