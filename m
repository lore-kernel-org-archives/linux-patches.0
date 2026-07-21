Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152F7471246;
	Tue, 21 Jul 2026 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660972; cv=none; b=nskIOdmq0lGjhMZw9GxgFBZHeG5c3lbwuVtm4JTyIjZQ12DW+6NzMjdCQWT66moSxbSTvTUreKn8KJPXk2nt8NjJKaENvWmX4waE/5raRJGEWcUwrh6BPnEwH/SVtoXftmR+OeXVx4SC6JqGBg/t6Nf7YxA9kMYeD2g2WrCcXrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660972; c=relaxed/simple;
	bh=fo9tmSZmejDSkBWnilKVMxmBhhK1Gs3jbnmM35eDBMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gsm8qakZHlmpsjmLJXKzzqLVvoAiU81DCBAml6nrkTclrJC3EC0d2F6TvCOX5JhQLhnYTrShbJJ/tL6A9jPkGCharLhePrCn8W6bm8xS0NFYpTIQmmuGIg9ot0Vu+Uq0yPdmsTpxoRCKEBtcJoUJuLLvDnDXF0ZORWw4v7ei4f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsfnJoWW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsfnJoWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3551F000E9;
	Tue, 21 Jul 2026 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660971;
	bh=Sm83a+DhNR7vJqTACFA197U5eXISWyEBwMtRX7YZJQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsfnJoWWXkxA4FjkNdGWgso7NXvvQd1a+1G/ts7vrMRg9Fpf+av1MF+cwrMmYy3d7
	 ZciX1ntBei9QQMe47AbYFXgGDcBSa+0CDaxtUb28gNBsZK7FnyWejK4zGxaoDf3toO
	 d6bfL79pL+7i2kQvAF7zyc4FU7FfpUMAWllQjoQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1181/2077] octeontx2-pf: Clear stats of all resources when freeing resources
Date: Tue, 21 Jul 2026 17:14:14 +0200
Message-ID: <20260721152620.675916365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2cc1bdfd9b2e81..702cf07490e792 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -182,6 +182,7 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 	clear_req->id = hw_rsrc_id;
 	clear_req->type = type;
 	clear_req->dir = dir;
+	clear_req->all = all;
 
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
-- 
2.53.0



