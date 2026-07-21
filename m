Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2635D46D56A;
	Tue, 21 Jul 2026 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662876; cv=none; b=mOiNSdXOJ2kAJyhIX5h6cghiyQGarPjFS/fOzxk6VxoyXgL9kqBRobgAqCx5b4beORxxgkH+spL+XGq1yMzkEDpvuC5glMCiTdPtfjRHVgz1Kz3zI0MkQiukRKli4nioJKIhvbKNJf9kDQP+L8iNgnxWh4EX+vSQZdQEn9LXXDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662876; c=relaxed/simple;
	bh=yTIqaYpt/0oGIPFAunbQGTxEjGOfzSptnkXKr4OcybA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQIuBEeyQTAU1W/9Uujzah9UgRLzmPVetZCz0eqReMVNFXcLEBmbYYPOGaOUIRspbx3/rIrePuWEPIJHVzfBSN1p4Pq9O0bc7Cx9YsZC+dLbLg2QXrVnN711vi55+uRHym8BIVaq79kLua2iMTkQLJ6pUMyyfeJpRfVIyzM2uHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcAk+nIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcAk+nIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CEB31F000E9;
	Tue, 21 Jul 2026 19:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662875;
	bh=4EWVx9lIU53wgbL4XxbDr1TTZFY39uH+9vcqeeGGTEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcAk+nIiDvk1AD0ln1mTHuIn3ujBj23afNcscvAGTWi6+lm+Wa93D1TThXcAq9B3r
	 zuSw30uUFZIWuj/b9yn9ZgJHVczS/lJO40JXtsRJCaGR5elDKvCLhrhy6sONnCSgEL
	 djq+gzDOR3jEUidmkjZCKfDjwXudkKJ1Lpo5tBPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0611/1276] octeontx2-pf: Clear stats of all resources when freeing resources
Date: Tue, 21 Jul 2026 17:17:34 +0200
Message-ID: <20260721152459.782082228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 3af58bc9f533cc..b288edd9e22db0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -213,6 +213,7 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 	clear_req->id = hw_rsrc_id;
 	clear_req->type = type;
 	clear_req->dir = dir;
+	clear_req->all = all;
 
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
-- 
2.53.0



