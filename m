Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1450F44AB9A;
	Tue, 21 Jul 2026 21:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669718; cv=none; b=e39L80FMB4+LhYqZOzCTTue5QZSCGCpGcyUHj+tlMGZyYX/RaPQTRPpARCQM/GFI/H+LvsqWJg+rjNmomZgFkMCH4RMwC0DuBnls7nlJ9wCSX3K5440xwDDKISLcp5yG5pTpjnlDDt53jUH1pBJQ/6unHFtRi9VcYgOIPyi6Bss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669718; c=relaxed/simple;
	bh=cfNeOm/YdESbd7ZT5MyjQnH3hKHB37S2LnI2+IyRs/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gvpc18UpvDTi4O4jo8ufXc2YWQWTD40/G8AMSEanp8T+RWhxecnfoXSa36GtZ63XDRVdQ8Xrrsien/GasSQvJlxwitdv+IKXtOMsEsYFoXvEyd2hEhJijy9/tsVAhT5dVCgZcA3QZ4vYvOQxfDJacGgO0ryaHMJbQObTLxqFTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPI3vnBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPI3vnBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350681F000E9;
	Tue, 21 Jul 2026 21:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669716;
	bh=iMgFElGUllkk0jXl54fG/TtCRzc8xIKeBUcoP4eFSWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPI3vnBnpaSgGq+DOcVG8xyovcflbuVYskKNwSfKhS6ORE+LwdKMRifEH/OsdRBI4
	 b+LkUVqT5r/hIcVdUVp48h/jAg/V1SDAdbiq6VWpzhVvuj7c8jC+ozBehQF7PaYpf5
	 MZIvLMuSbl8mBnI7JkxYGs0YE1Wsb+Ocp7GBpj9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0607/1067] octeontx2-pf: Clear stats of all resources when freeing resources
Date: Tue, 21 Jul 2026 17:20:08 +0200
Message-ID: <20260721152438.178020607@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit fd4460721fb4062ef470ecdfdaedadfe7e415c09 ]

When all MCS resources mapped to a PF are being freed then clear
stats of all those resources too.

Fixes: 815debbbf7b5 ("octeontx2-pf: mcs: Clear stats before freeing resource")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-2-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 60425e6ce07674..a415af6dce275b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -163,6 +163,7 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 	clear_req->id = hw_rsrc_id;
 	clear_req->type = type;
 	clear_req->dir = dir;
+	clear_req->all = all;
 
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
-- 
2.53.0



