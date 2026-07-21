Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74A1367B92;
	Tue, 21 Jul 2026 21:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669599; cv=none; b=jAPr0CNJnCx5G2PTlHJcak+2ePx49k/5wrDp4ZEzlGx0LYZXtrP7c7tzuimUS8uXVUsXDqfFEsNqDXSnpG3gSaRl3FGTv4ei6RZLDM5bNIa6GjHxOHupbtmPjUoEuzMLeGxC9kajangwVc6/g3nRYNlpSO85HwMv0ZNvnTl+zOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669599; c=relaxed/simple;
	bh=GbzkB6D1yKrC+xNo+cWJQeRZ1pr4ScjDim295XrJAEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9aVFkwF7CLkit1TxIEzSW4aRXIrBjCbOeI4asP03oyZ4Dto7WQn6LEUQ2Bwn5dhKxiD+wzPVOYBRejWvrYuaR47naODUhuw3i8erMEK0FXrY9NOkkZiDvzW7odJWrjOt03gtPjUmJL67bk0mtXcioKcQdywX0ekKpWvAuawADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfDIefUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfDIefUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4396A1F000E9;
	Tue, 21 Jul 2026 21:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669597;
	bh=cSJHrk2ktoVO4LgxXfNZkvjGxbJhNFyeNy0Z6/Jm09g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfDIefUxSZ5us9X3vOKRHNx+af5NM8p9N9/2EJ15qSz00ePROB8LRf4t79uFFlpzR
	 Cpx1+WSX/f/+vJx57ISsPdqcyopuWeFuUk6GS02yiw5eoprsA/8L6ReFPjEkhdhDfH
	 DvqSmd9X6JV9T5u6Tt5CLCsg0b1dAwMLp9YE9MZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0608/1067] octeontx2-pf: mcs: Fix mcs resources free on PF shutdown
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152438.199201769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 450d0e90b10393bd9f50c127875a9fdd4cc81c30 ]

On PF shutdown, the current driver free mcs hardware
resources though mcs resources are not allocated to it.
This patch checks the mcs resources status and if resources
are allocated then only sends mailbox message to free them.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-3-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c    | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index a415af6dce275b..e20fe888824a2a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1685,11 +1685,16 @@ int cn10k_mcs_init(struct otx2_nic *pfvf)
 
 void cn10k_mcs_free(struct otx2_nic *pfvf)
 {
+	struct cn10k_mcs_cfg *cfg = pfvf->macsec_cfg;
+
 	if (!test_bit(CN10K_HW_MACSEC, &pfvf->hw.cap_flag))
 		return;
 
-	cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
-	cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	if (!list_empty(&cfg->txsc_list)) {
+		cn10k_mcs_free_rsrc(pfvf, MCS_TX, MCS_RSRC_TYPE_SECY, 0, true);
+		cn10k_mcs_free_rsrc(pfvf, MCS_RX, MCS_RSRC_TYPE_SECY, 0, true);
+	}
+
 	kfree(pfvf->macsec_cfg);
 	pfvf->macsec_cfg = NULL;
 }
-- 
2.53.0



