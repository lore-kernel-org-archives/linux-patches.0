Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B843DA53;
	Tue, 16 Jun 2026 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622927; cv=none; b=Rq97fI4JrooXFrVc+02dY07B9VPBlq1CyrSxCTYKf9yeVOl4+xKo1S+JPR3JwIFmDcrBL8aUGr4tEZacY2Nx9rU3xO/cMIWRgOak+qw16vZLfkmh5d/JJ/5QZUesQ4XcvnjmU24zDAqxOJiVy9VobWKyXj0gz6M+QhXcqofOosI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622927; c=relaxed/simple;
	bh=sPPO+VRo+ZbiUWO4PUhsNpSziFO8K/MGeiliHDvOLvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9TkHJye8nmfcyco6x2aIDEB+QnUFum/oow+qzzUecKdwh0QO43Pc0geh5BxgQfjYxUFDiTwedaUPnZi7VPq0Jkbcak+sfZud+5bO6zdwqylT4caMG8HIxznw1s0QwaB0zF87nLRCOUF7vEaZvNDAN7T+bSsBcaBlHu1Ra5yJUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tN9Mhnl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tN9Mhnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4AD1F000E9;
	Tue, 16 Jun 2026 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622926;
	bh=luaoHQmhkCeXMmh2T+P6N0Y6na3XvQHslSbYTTliiK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tN9MhnltKygAWVgSvvpGC9j8mR3iXEhm8oEngaThzxhoLWu6NNhC9Mb2eRJBgc8B
	 Ofz4D+Z5Pk95cCnBijPkHp458Fr54Y9lKZHs8qa+YM+8YyxLg3dc3wK27DQ8Dxe1Xc
	 nFv28DRIQexE3gSyfCJ3lUG3i5Xsp4w3wpVS+OCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 055/378] octeontx2-pf: Fix NDC sync operation errors
Date: Tue, 16 Jun 2026 20:24:46 +0530
Message-ID: <20260616145112.859370939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit a910fb8f7b9e4c566db363e6c2ec378dc7153995 ]

On system reboot "rvu_nicpf 0002:03:00.0: NDC sync operation failed"
error messages are shown, even if the operations is successful.
This is due to wrong if error check in ndc_syc() function.

Fixes: 42c45ac1419c ("octeontx2-af: Sync NIX and NPA contexts from NDC to LLC/DRAM")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1780054677-17249-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ee623476e5ff1a..f9fbf0c1764825 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3473,7 +3473,7 @@ static void otx2_ndc_sync(struct otx2_nic *pf)
 	req->nix_lf_rx_sync = 1;
 	req->npa_lf_sync = 1;
 
-	if (!otx2_sync_mbox_msg(mbox))
+	if (otx2_sync_mbox_msg(mbox))
 		dev_err(pf->dev, "NDC sync operation failed\n");
 
 	mutex_unlock(&mbox->lock);
-- 
2.53.0



