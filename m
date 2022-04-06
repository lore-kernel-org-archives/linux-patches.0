Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F63533D7
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 13:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64757C385A1
	for <patches@lists.linux.dev>; Wed,  6 Apr 2022 13:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649252995;
	bh=8Tfbq//FlhZWD3Cw0VcZ0rfbLlylOVhmSLZROKwe0ws=;
	h=Resent-From:Resent-Date:Resent-To:From:To:Cc:Date:Subject:From;
	b=eUJ0+mKtAFs8Bb3cENsFApdb2Yzhk0uch1JEFq9r30cORP6FNRWAteXxo1btz4oXq
	 uljVm0p67Xe72Vj/9mwXgG7yDwIjiPKU5t0YCHVNvFoh5E324zBT/B92JiOvkyjYyW
	 h5/AyvpajbBRslvn1v96jF3sBZWns8jaMOPrDMQB1OM3vCzMhXHVYVRTmDotsLoL8f
	 Ng/uW5mFmbY5r3ZpMclOnxc/aVybqnt4wpCPOJigZQvk3qvgJoWZyTaZjxBTKAtVg+
	 EeTkOmXxg+GUv5RN2LhtEC/wm44yKqezVfF+WhIscvlUjSa7rYP4E0ZkbRVqrntNiP
	 mZ7Yrb47KMBwQ==
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 6 Apr 2022 14:49:52 +0100
Resent-Message-ID: <Yk2agCQ8o89peSU+@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 06 Apr 2022 14:22:47 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <vkoul@kernel.org>)
	id 1nc5cT-007fut-Jq
	for broonie@sirena.co.uk; Wed, 06 Apr 2022 14:22:47 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 556A5614BD
	for <broonie@sirena.co.uk>; Wed,  6 Apr 2022 13:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id CEA87C385A3; Wed,  6 Apr 2022 13:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B691CC385A1;
	Wed,  6 Apr 2022 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1649251363;
	bh=8Tfbq//FlhZWD3Cw0VcZ0rfbLlylOVhmSLZROKwe0ws=;
	h=From:To:Cc:Subject:Date:From;
	b=lmBKWZHZuPJb7WAFtjmHzE/A7eR9iNmRM6gDhTJrTFKzuVwpEjo8veG1B++eysUT0
	 FxzMEUHBRHcS/LHAjbeskVhKzc2ELWFr+dJJ9KHx0QET1OYTSjIdvOjEqRMa5mAoz3
	 F1VfdYvybYCJxj+isHL5g1nvQsMKoHkXzAEFCX8twgWd768A4QXygNsqvc0F+8wns2
	 3jXDy5GjyFowV87vx4kSqXnO8fyubYhagNDSgPjA6zTpq2NrWUZWProh/eFMEEgkVy
	 zMyu+JiEtBbBj2zbmizF6G9JexLL7zqB9sXHk6OuYTOM5DkYPbdLFbFz1V8EYR0CNJ
	 CyJw3AOOEPJLA==
From: Vinod Koul <vkoul@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-msm@vger.kernel.org,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Wed,  6 Apr 2022 18:52:38 +0530
Message-Id: <20220406132238.1029249-1-vkoul@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: vkoul@kernel.org
Subject: [PATCH] spi: core: add dma_map_dev for __spi_unmap_msg()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: VrDdvMiJY1vI

Commit b470e10eb43f ("spi: core: add dma_map_dev for dma device") added
dma_map_dev for _spi_map_msg() but missed to add for unmap routine,
__spi_unmap_msg(), so add it now.

Fixes: b470e10eb43f ("spi: core: add dma_map_dev for dma device")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Vinod Koul <vkoul@kernel.org>
---
 drivers/spi/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index c4dd1200fe99..32443ae175fd 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1130,11 +1130,15 @@ static int __spi_unmap_msg(struct spi_controller *ctlr, struct spi_message *msg)
 
 	if (ctlr->dma_tx)
 		tx_dev = ctlr->dma_tx->device->dev;
+	else if (ctlr->dma_map_dev)
+		tx_dev = ctlr->dma_map_dev;
 	else
 		tx_dev = ctlr->dev.parent;
 
 	if (ctlr->dma_rx)
 		rx_dev = ctlr->dma_rx->device->dev;
+	else if (ctlr->dma_map_dev)
+		rx_dev = ctlr->dma_map_dev;
 	else
 		rx_dev = ctlr->dev.parent;
 
-- 
2.34.1

