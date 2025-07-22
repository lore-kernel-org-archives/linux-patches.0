Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991B62EA174;
	Tue, 22 Jul 2025 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193341; cv=none; b=cLHHN03U8E5ECRVzwlhPR0pYs3yqY34kQMzPsp1sSAysZe+zKmyzIso30KbDgvDPkiao7qshTCjY6eAEAlyxCJ+LwxHhsLeLzYoUwcgOVO79ilTP38u/uu/s7FkM0TSGek4HbAnBOMu/B9dHLPjnqRuBsle9x+bCzy8glNDimQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193341; c=relaxed/simple;
	bh=YbX4kurl3Wd5UCLyK+ISKQsTW4QEq6ryo9yXE9eyTZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKSTff5j/l4t1AgTGA4Wq/Lz23YoFKIF48+z/W2MiRmyEoGinaE0NfZiVTmwuss/ZYHHN9VgjrOtzI2dYT/WqvKYsCXFC3sDELZQyDmQvsgo6xlol+EaNpQWWZICVZysofVgkFunVeyKMLZu2pki2Dw6J1c7BrP/f/mxtW+m6U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD+QSID8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD+QSID8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24074C4CEEB;
	Tue, 22 Jul 2025 14:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193341;
	bh=YbX4kurl3Wd5UCLyK+ISKQsTW4QEq6ryo9yXE9eyTZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RD+QSID8XpUeEAim9NYpHJPVUB5Iu/FAxBKl4JTYo+hLwuecV6wWYlbLFMuFRA5Qv
	 Z9CCh1C+ej03NXp5dGxTeOdelpJjaPtjrR4dWM3QxFgZWH29n15POY+ln0MKLXnDJQ
	 RVTHvGd1qz7MAjR8hAEbxmYXt4g0Fkyn5oClzPH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Eugen Hristev <eugen.hristev@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.15 061/187] dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()
Date: Tue, 22 Jul 2025 15:43:51 +0200
Message-ID: <20250722134348.026919367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 8eba2187391e5ab49940cd02d6bd45a5617f4daf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mediatek/mtk-cqdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-cqdma.c b/drivers/dma/mediatek/mtk-cqdma.c
index 47c8adfdc155..9f0c41ca7770 100644
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
2.50.1



