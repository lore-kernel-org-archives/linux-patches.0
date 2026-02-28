Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2933539B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302582; cv=none; b=qkIIu6yK3QSoBYs6MhUI/rGbYOS4dly6HI87w2cj17ErGz/dcuLwo/euuAxZTrE4YcNWo75L0dW0qaEbL+yjIdUsikKte+9d/xaKUZiDx2jaR6xcHrs94dSyBcJ3nmf6QFv/2cdvrUPX4SXB7O2iqUHC/LbME5SSZZJRbEtE4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302582; c=relaxed/simple;
	bh=iNbWj8GWaD4gLGfyRat7BdcQOZRDL+ExdFB5IIuNP3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz1Z2D0Pv8BJfa1nTezT2dosZyp139wg1lFY/f8D3oI3QMWeo2EY2lJH+mRqKWb/7KFc6HuIx1lrCFJgbGqXsuoMwNy74aZdvKl2jFl+ggCnZ97bzk/xm8qEGu4lzpJVr4lzOm2YeTWP0vxv+ckB7m+WNUc2HjijFzlrXo7UiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jue49Qic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jue49Qic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E9C19423;
	Sat, 28 Feb 2026 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302582;
	bh=iNbWj8GWaD4gLGfyRat7BdcQOZRDL+ExdFB5IIuNP3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jue49QicTArgro6xzI7Hz9f5bCpd5SQbVJ1oMC/u5sAEW+FusF7blzqdpw1LWwVTL
	 qv9se3Uw1WTUzIsKST6bvgpO1ij9+eRBi9vK0tERI/ItsRb8FOKGa/miEqWmYOehEt
	 cTYLpdZQit5O02zjQPOXdUlVJYJEAJbNCnd6N6M+1nZZ1W/1nBwzvKQ7aVZprwhiG3
	 hSNOGo00WEenw4BsTxxLwf4Zs2nLF7Z2fNJm4WLF3ANecPRsGLosMaGUPfmYb3keff
	 IS27b0AFqEiw655ShyuWdizb1X7Vhv0DSQx4le5x/r6BbRxNn76AyiFY8+wWNBRXH+
	 PzbyCnpM+2oDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/164] octeontx2-pf: Unregister devlink on probe failure
Date: Sat, 28 Feb 2026 13:13:49 -0500
Message-ID: <20260228181505.1600663-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 5f093b34db698..803f40a2bdc19 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2777,6 +2777,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0

