Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434B82F2612;
	Tue, 11 Nov 2025 01:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823259; cv=none; b=cMIKiDydvoh1Epsbs7uB6OuOeON9AVTgqwYYx6HGq6Z3jconcX4PmMyBzbzD9z5PCxDmt98jBoC01gaiejdwXqm51bgEGk3o/pq6KHoRCXTtrIl8+g4cKvrP7kQOSAyjZlwXQk3Cy9e8h3CrvXzAOI3anPk1fPZe6zMHbUmLniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823259; c=relaxed/simple;
	bh=DZ3X/0edUqF9chtZzuT6YGAtcRBVbChzBbz8Y3VlK1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0L/j0B6i7Ktwi6xtseW6kih1g+MIM6/yiqR7yZ3hRlsARilw1dcPG2LSIIPUUAA4KRhgF7nWI6P2xlumhTpslumivuWgMVznxxKAa7ZIloOeaIPj/d/ncfXPLeOFDKCTwLE+T79Mfne3KT33RU2xOVhrvg0lLNvlxhYcEUrmRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGu7QUuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGu7QUuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41EBC4CEF5;
	Tue, 11 Nov 2025 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823259;
	bh=DZ3X/0edUqF9chtZzuT6YGAtcRBVbChzBbz8Y3VlK1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGu7QUuUTTeFpbZpEO8Q5h7cgsUX74y4I+fVrWr5mlExS3liMBdI7/dNrMTzo0heB
	 lZOH4Puz0+KZ0KpigrbCIY7cT3D2GtvU+ujHeDXmZxI1EljomPHXxTBNS+kv4VHgui
	 +3io+icyksoIG8YOF9P/La/prdYfkY1r5x9Cy/rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/565] net: stmmac: Check stmmac_hw_setup() in stmmac_resume()
Date: Tue, 11 Nov 2025 09:41:03 +0900
Message-ID: <20251111004531.581978312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6896c2449a1858acb643014894d01b3a1223d4e5 ]

stmmac_hw_setup() may return 0 on success and an appropriate negative
integer as defined in errno.h file on failure, just check it and then
return early if failed in stmmac_resume().

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20250811073506.27513-2-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 40d56ff66b6a8..16f76a89cb0d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -8030,7 +8030,14 @@ int stmmac_resume(struct device *dev)
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv, &priv->dma_conf);
 
-	stmmac_hw_setup(ndev, false);
+	ret = stmmac_hw_setup(ndev, false);
+	if (ret < 0) {
+		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
+		mutex_unlock(&priv->lock);
+		rtnl_unlock();
+		return ret;
+	}
+
 	stmmac_init_coalesce(priv);
 	stmmac_set_rx_mode(ndev);
 
-- 
2.51.0



