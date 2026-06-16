Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E339150B;
	Tue, 16 Jun 2026 16:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626674; cv=none; b=lYMrvxWO7vXWlRrIw3aByAQD8WJje3HDSSXRDxxNdp+an2Zp6tootCnybUZToYZPQIXYZOmZgsdvo406EnfEKrpeA8109oKNRjML7Ok8sRnGIrYv7A0VoOUyqnb0mVAVfbbzHxxc+QCE7LdXKFRhmguGmP2DZa7sdUiQWuv3ZMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626674; c=relaxed/simple;
	bh=eAF3u6Oi2beY6WpNB9G+uvHKISpy83zpC+WIjmYvicM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBhgVK8JcHr5l6c7hUUcLuiRhcCebdCX4HA1HBoS/Dn5lk8IMHxljv2re9j1+1r+sgPtzpuL2yFVDAofQiJBhHxoC7v04zbVcLh6tk14x0cGpdnUjiGdZo/B7yRkT84XgcKjkuPzakXFmiMGpf7U+3WcHFx4LQrKMPkXQltLZCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXOQU3lV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXOQU3lV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1788E1F000E9;
	Tue, 16 Jun 2026 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626673;
	bh=2JRCcdcr0MyL8B4UJTKlERivFaWN7ANh5r6jXK6npdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXOQU3lVoX6hCXw6eY2yUB/pmLhmZEz3Ub3gCKf7CrKe8qgABFMXOed9G/rEkYvE0
	 lH4NaSYORgxr9c61vUKwG3ryd47OvfFBh6SfN1rSEzW3rSO8R7nWB0PIZEP6YFosTo
	 bMISiYItCojCIg03e5lE39YCEH5+rb9FddHBJd74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/261] octeontx2-pf: Fix NDC sync operation errors
Date: Tue, 16 Jun 2026 20:28:05 +0530
Message-ID: <20260616145047.349435601@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index 2de9c44ef57c77..ce01fab28624f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3263,7 +3263,7 @@ static void otx2_ndc_sync(struct otx2_nic *pf)
 	req->nix_lf_rx_sync = 1;
 	req->npa_lf_sync = 1;
 
-	if (!otx2_sync_mbox_msg(mbox))
+	if (otx2_sync_mbox_msg(mbox))
 		dev_err(pf->dev, "NDC sync operation failed\n");
 
 	mutex_unlock(&mbox->lock);
-- 
2.53.0



