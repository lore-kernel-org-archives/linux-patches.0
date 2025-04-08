Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A361D265633;
	Tue,  8 Apr 2025 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113540; cv=none; b=hcky6MU+rS0MSLzsbZ3X0YHxnYYRdSF1C8UL/hxvTYPgn8r05blVMH1J5DljztMkqucFaveSghXVn2JzPny8JHFWBkM5FTeutLzs3avSiKDpEqw09dIu9aIo+0oEcNtrRpDTkKFMDKAbjQcr6Th5KRTeQbI4Kl8hoUV6ACPuWko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113540; c=relaxed/simple;
	bh=v5//8+hjeXm0iQfyzx4Nb1z+yE4rrq8vksZBghSPuSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnbpl7VPDUpKVKo+49q+k//xjPZ7mJ72bgU37c4/9P3ou3Cgdw29d9Rvu1ioliL9/2F+RM6x6FjzPS1XFs4nEVApSzpPuKIXMD7VBQnQASPIcXuVVbjvbeJrxucYM1RsVh8vyVdstIVgjdjypP+xC7hb/hFMP+iLTxuvDwbpgAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BScMoJja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BScMoJja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB82C4CEE5;
	Tue,  8 Apr 2025 11:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113540;
	bh=v5//8+hjeXm0iQfyzx4Nb1z+yE4rrq8vksZBghSPuSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BScMoJjaudPKL1y7pzPdA4vKSIWHMaH/MKeJfrLFvyiUqiayZWavLyhVbgWReobN7
	 FiEEK0tQjwkqgm4AXtypIwWnWbGLHKyrVErhv3U9uxDYBsktgNqfeOPf5s9YVQbtuy
	 LJKTLWgVGPpslOhdZsjZ1h2bjQfhlRQVaVYiRzkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/268] octeontx2-af: Free NIX_AF_INT_VEC_GEN irq
Date: Tue,  8 Apr 2025 12:49:28 +0200
Message-ID: <20250408104832.775623889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bffe04e6d0254..774d8b034725d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -217,7 +217,7 @@ static void rvu_nix_unregister_interrupts(struct rvu *rvu)
 		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
 	}
 
-	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+	for (i = NIX_AF_INT_VEC_GEN; i < NIX_AF_INT_VEC_CNT; i++)
 		if (rvu->irq_allocated[offs + i]) {
 			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
 			rvu->irq_allocated[offs + i] = false;
-- 
2.39.5



