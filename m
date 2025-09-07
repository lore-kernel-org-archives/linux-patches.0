Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C9D2836A0;
	Sun,  7 Sep 2025 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275748; cv=none; b=Ua58ZIsRgwUop62/W/N9vlBQzTfA3AgsmEU5T0y4aZS1YXsECgrqnjYdkoG5MHFm+nk153XHYtRF7a9XCKfdrrpX+J3T+HmBguMnTzBkq+f2YZBBN7Ve2LuTDhpTMzQo9mQOmBxSQFpf5+ykrhOYJmRKl2fyfVUrC7pYhFNdDHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275748; c=relaxed/simple;
	bh=bSLR/zRQSITA+IR7O5VfEsmni4KqN9RS5DCkN0XN+4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vlb5WdE0rzT4PlN6LgkHIOTb77saMePmqiDOPuit1kUvafXreDBVTqy639+FE76/sKhsGMBxxUXgH5TxDw6BJo0EfXpGqY51tFM9oNIPoCaTUoaMx4AWHS/03DeEIslpGS/t3kubE+YfJ5KseeJP9CRhGi6Lw+r5Bh3KBShwgHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRJgI2u2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRJgI2u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581B4C4CEF0;
	Sun,  7 Sep 2025 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275747;
	bh=bSLR/zRQSITA+IR7O5VfEsmni4KqN9RS5DCkN0XN+4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRJgI2u2z0JfCf2ifyKVMYRr8e+voSEKu43rRMlhLcgnEobkdyC1rFIznbGSvzmEt
	 exx4FnEy/Cr8RKBp7+ubFSO2XNoM2akb9Fqp9vcd1l4kzAvwEukJS/3526yHZEDBlS
	 4crdn/bdEQDl22NHjVdgu/ImDnNlJOauZbZo8gEc=
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
Subject: [PATCH 5.10 52/52] dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()
Date: Sun,  7 Sep 2025 21:58:12 +0200
Message-ID: <20250907195603.463317167@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39e902b279e64..60d1d56b98317 100644
--- a/drivers/dma/mediatek/mtk-cqdma.c
+++ b/drivers/dma/mediatek/mtk-cqdma.c
@@ -450,9 +450,9 @@ static enum dma_status mtk_cqdma_tx_status(struct dma_chan *c,
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



