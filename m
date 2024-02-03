Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7919E171D4;
	Sat,  3 Feb 2024 04:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933939; cv=none; b=Qpc/vgcUqzxxA0or+GPKfIBGOERgodWbJj1gCqGICYa2EF2JvcMzyrsDL5nMJ4F803Q9IKiTmgMUdEgSgpEuDqV/r/Z+FcwcabCL6sx/iT6xPzBbkLHrjRLs01mmuN/fqEkPySncxFD80SdHbJfKakoTtrBNUY6OAMiaGgWYO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933939; c=relaxed/simple;
	bh=3I/DZVFQQ7AQbQwyhYf9tIj0k7shBttptve6+PDhRNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxdCu/Yb4+gN8SZ8YvICPNDOYMzSMgYSiCwsqmpmt3gqK1cuvO/K8rhQy4/KCjiJxK6Kv0S1mg3bDgLJw1npn2wPzrfBn4W4I5BRzeIV4XHzOR+a1OIOlfW28Jzs5wbhP/Hc6sxi4ptp3Xvak/wWHuqbpXqerZKobk0HK4u5Whg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1m3ehOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1m3ehOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421A5C433C7;
	Sat,  3 Feb 2024 04:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933939;
	bh=3I/DZVFQQ7AQbQwyhYf9tIj0k7shBttptve6+PDhRNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1m3ehORQHC315zs0s79Df3R0ndyWXI8lMsEPw00krZZbHJFsDKvex9xIHIXkVft7
	 cyyWWjgk0l4U2OsLdUQL3nc2c/b3q1fIa3QfYQS49aXhzLnfpHT3CIDEaeo9RFbylh
	 2ffr0+YG45pLs+NR/MLd6aAoef9SiXPfkomdQYrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elad Yifee <eladwf@users.github.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 301/353] net: ethernet: mtk_eth_soc: set DMA coherent mask to get PPE working
Date: Fri,  2 Feb 2024 20:06:59 -0800
Message-ID: <20240203035413.363704481@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit cae1f1c36661f28c92a1db9113961a9ebd61dbaa ]

Set DMA coherent mask to 32-bit which makes PPE offloading engine start
working on BPi-R4 which got 4 GiB of RAM.

Fixes: 2d75891ebc09 ("net: ethernet: mtk_eth_soc: support 36-bit DMA addressing on MT7988")
Suggested-by: Elad Yifee <eladwf@users.github.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/97e90925368b405f0974b9b15f1b7377c4a329ad.1706113251.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3cf6589cfdac..d2c039f83019 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4758,7 +4758,10 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_36BIT_DMA)) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(36));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(36));
+		if (!err)
+			err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+
 		if (err) {
 			dev_err(&pdev->dev, "Wrong DMA config\n");
 			return -EINVAL;
-- 
2.43.0



