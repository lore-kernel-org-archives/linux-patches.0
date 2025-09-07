Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A90315D54;
	Sun,  7 Sep 2025 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277394; cv=none; b=dzxd+PuYVrOUs4ecJnPF4LCnazdxgzmBCgyv9X9A1MiPlU0MT/9Klahc08noYvmyiVsvfucvyU/2paLLytYtuVVkt25C1fB+1MGsPmeItk8/CMaxZPcu+tg/LAnys9sEpXtU0qjX+GARJb9vJsb4s7sju3oFppmZo6McMXvrE8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277394; c=relaxed/simple;
	bh=6Ca2ikZGmjB7b3FNdSZ/BtmTnDAdefB3pgo6IBMqUqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luJ1lTDpIZjkdr3o9DSJuks62XxpBYB/bnDKR3EcNHgtTwIMaI2UIFR9HnIbno3MHI+lweZtdF7m91LAiliaaxXX1rs8qGrt0cpSOYMmyNpeX0UBbtkG0Is9PS7W357biOT2rPncElVQvSUT2/m+fY+L9YAAOdcJKWl6a8iipeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AaU6H0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AaU6H0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46506C4CEF0;
	Sun,  7 Sep 2025 20:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277394;
	bh=6Ca2ikZGmjB7b3FNdSZ/BtmTnDAdefB3pgo6IBMqUqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AaU6H0jFzA1Ub7eAItwKmR6x+76Ac8qHyKfZC7MR3DIlHdhDVBV8OMnjW6iJzUPK
	 +T3xan3JvtH3IgkuP8MGsVQVaT9PUEH63waQnijzxZYvb8LrmwS0n/1XlxiFSbsqD1
	 JMr4GY5mdp8QfeVdC3VRj8GvNspUr+4/AQT4Y4Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Eugen Hristev <eugen.hristev@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/175] dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()
Date: Sun,  7 Sep 2025 21:59:30 +0200
Message-ID: <20250907195619.001041536@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

[ Upstream commit 8eba2187391e5ab49940cd02d6bd45a5617f4daf ]

Fixed a flag reuse bug in the mtk_cqdma_tx_status() function.

Fixes: 157ae5ffd76a ("dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505270641.MStzJUfU-lkp@intel.com/
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Reviewed-by: Eugen Hristev <eugen.hristev@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250606090017.5436-1-chenqiuji666@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-cqdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-cqdma.c b/drivers/dma/mediatek/mtk-cqdma.c
index e3c887148987b..1bf4fc461a8cc 100644
--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -449,9 +449,9 @@ static enum dma_status mtk_cqdma_tx_status(struct dma_chan *c,
 		return ret;
 
 	spin_lock_irqsave(&cvc->pc->lock, flags);
-	spin_lock_irqsave(&cvc->vc.lock, flags);
+	spin_lock(&cvc->vc.lock);
 	vd = mtk_cqdma_find_active_desc(c, cookie);
-	spin_unlock_irqrestore(&cvc->vc.lock, flags);
+	spin_unlock(&cvc->vc.lock);
 	spin_unlock_irqrestore(&cvc->pc->lock, flags);
 
 	if (vd) {
-- 
2.51.0



