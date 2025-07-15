Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2982561AE;
	Tue, 15 Jul 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586751; cv=none; b=mDCLo62YVOByCLrmEHUxHbvk11LfcOw0biDgbDsI4WkqjYXE7XDQHJ4bnQA7rapwA53XcYaeqS8YiGf4u4WldljSWPHfjznIv2mnn5VgPw2hCQdQfPouwNNjN8k7eJBf+nGa+O0xhCIgpkSDNHZ4NlqbkK9tXVqGGI40lDl6Lws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586751; c=relaxed/simple;
	bh=96Q1mbem1I6fFpMOedE3Cq9Fq6o2BrgkCzaLgxs8nxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJs6IxiTAq5tSfmxoCZYbTjKGaE2nkV8+XgH6C5ge0GJY2RcMwsKa4WNcDSWezdWvyakANKDTkyP4AGCy4EGiby4TlKNfOmccgrDeeeWrh4jvb6xXmzvNH8P9DUiKSMsi4LhJwVVayfFQh1cdiodeX9yntg/Zsa3+ewKFNSoTiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTtQnF4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTtQnF4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B563C4CEE3;
	Tue, 15 Jul 2025 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586751;
	bh=96Q1mbem1I6fFpMOedE3Cq9Fq6o2BrgkCzaLgxs8nxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTtQnF4fA2Pm4AMdew/Laxr3lu1WTlhPBc11+sXXr77dY/8GDKqUajnVVBDjcyDcp
	 hT9Ug2N4oBk3w9CkC6zTTsDnPvAeEt5e8JdW2RXaneov7Yqp9UDMjXptBHJxWO713r
	 VvJCfBGAAHEuwzcnLl5CNbJrZxDLCTQmKVx3gHJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 035/192] net: airoha: Fix an error handling path in airoha_probe()
Date: Tue, 15 Jul 2025 15:12:10 +0200
Message-ID: <20250715130816.268104176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3ef07434c7dbfba302df477bb6c70e082965f232 ]

If an error occurs after a successful airoha_hw_init() call,
airoha_ppe_deinit() needs to be called as already done in the remove
function.

Fixes: 00a7678310fe ("net: airoha: Introduce flowtable offload support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/1c940851b4fa3c3ed2a142910c821493a136f121.1746715755.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index af28a9300a15c..9e70cf14c8c70 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2628,6 +2628,7 @@ static int airoha_probe(struct platform_device *pdev)
 error_napi_stop:
 	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
 		airoha_qdma_stop_napi(&eth->qdma[i]);
+	airoha_ppe_deinit(eth);
 error_hw_cleanup:
 	for (i = 0; i < ARRAY_SIZE(eth->qdma); i++)
 		airoha_hw_cleanup(&eth->qdma[i]);
-- 
2.39.5



