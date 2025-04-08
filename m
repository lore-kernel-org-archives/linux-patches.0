Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B295C26A1AA;
	Tue,  8 Apr 2025 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115083; cv=none; b=tikB+oILCxPKqsv8RL1pSU9qjXVB4R7MNlShqdyAnXZEFtnl8XLDQzVQz9GYYR2jdaDy37ogDx2u5VVYS4PfitPjbYdNYAK1fkim79ruYn2tU1U7jamRjxCssaHdTJ1FFEOYtwIdMInEnwQt7n9UalvCxG83V4dGCy9d8W7Fhak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115083; c=relaxed/simple;
	bh=GP9gNI426Eb1XTjwJP2D65ujzGD3X1Drym1W6DbtqzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiFOUWXRGR+sWlpSfpDMLQ0WP35MWOfFrrt2eg98v4UaF/VeCUvKbGP/JajYklXhmG+ghq6xDE37cTFpDEeL+5gZICxczvc3i6ipFQ8+qOKmCESiGJQ08Hke1bc0rIBQZSjm49Gcg2xqiKiAYq7/TaM3v971DsfJ8K/hoUreTDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiKXakOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiKXakOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429D6C4CEE5;
	Tue,  8 Apr 2025 12:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115083;
	bh=GP9gNI426Eb1XTjwJP2D65ujzGD3X1Drym1W6DbtqzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiKXakOa0/QHi30LIF9+PASwTTYxYmeGPpNsJZlCR1x2Ppqgx1YTe6FxwWEdNp6l9
	 fmSwfSdRnZ1wctSfilTrHeOXoWNo5pj+ayw6lRxsGLoSUHv2lshSkZXJgokS5zwCmj
	 pCBQWscbMpUIHjIcnueICpELMgo7JxDqm/H+vPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 293/499] octeontx2-af: Free NIX_AF_INT_VEC_GEN irq
Date: Tue,  8 Apr 2025 12:48:25 +0200
Message-ID: <20250408104858.521882024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 323d6db6dc7decb06f2545efb9496259ddacd4f4 ]

Due to the incorrect initial vector number in
rvu_nix_unregister_interrupts(), NIX_AF_INT_VEC_GEN is not
geeting free. Fix the vector number to include NIX_AF_INT_VEC_GEN
irq.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250327094054.2312-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index dab4deca893f5..27c3a2daaaa95 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -207,7 +207,7 @@ static void rvu_nix_unregister_interrupts(struct rvu *rvu)
 		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
 	}
 
-	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+	for (i = NIX_AF_INT_VEC_GEN; i < NIX_AF_INT_VEC_CNT; i++)
 		if (rvu->irq_allocated[offs + i]) {
 			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
 			rvu->irq_allocated[offs + i] = false;
-- 
2.39.5



