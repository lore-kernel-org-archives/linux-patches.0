Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8E29B8D0;
	Wed, 20 May 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299683; cv=none; b=qh/unPQioc4nn9RLENwGk24ZMHtao2MuOBTOSh8bYx3YGLH15TVWao+g3oEbq5oZ3XtIcMtHEsCYMAEFAnU4VUGF/u9mG7bpNNMGqd+vCtXoUt9xo/bmqKJxMGfz0xrv9lm4hijDDSXLNz6EYxxvf6HEeeoKC5LhRu2B0aNXsFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299683; c=relaxed/simple;
	bh=i6P86fPEQSEutgaIzzFu+3kwkjAktrSbnnCj50fVyUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjrPUYUgFWoQWrIGhu5iQHzJR2nBR7g1OF4BixR6SEdb8PwCsWLFANLwIsmueAMorlG5PxJ1QkOlp/wYZ9KnEp5BqN7+t73WJ/htgwNYi59wEfE+vYdgTrW9VlGDOFJ/Chdqr4ckoB6sSO/vjFwJhBqe648niECWh6tcS63r5uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMdJp4dV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMdJp4dV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38541F000E9;
	Wed, 20 May 2026 17:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299682;
	bh=negxEwu36E3rzB9Zdsn6hXB+vQLHxSDEDC4kXnM3d9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMdJp4dVeUGeatE32qLREJ6H6vxScgj6K4NJJjgtd/w8EH8acp3Xz6FWchk6I/crJ
	 fHOiKtfBrO2lEwHW5lfTTArOy1LhN4SETDLoTO6mCaSv6N9EnBUP2mZZAKLDhTNbIJ
	 ykX5KdxuEKYcM00oU1PsPbtd2S7LhVfhxUTRmHfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 865/957] net: airoha: Fix a copy and paste bug in probe()
Date: Wed, 20 May 2026 18:22:28 +0200
Message-ID: <20260520162153.325250107@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 05e090620bacf317020f9591cfff8926093380bd ]

This code has a copy and paste bug where it accidentally checks "if (err)"
instead of checking if "xsi_rsts" is NULL.  Also, as a free bonus, I
changed the allocation from kzalloc() to  kcalloc() which is a kernel
hardening measure to protect against integer overflows.

Fixes: 5863b4e065e2 ("net: airoha: Add airoha_eth_soc_data struct")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/aPtht6y5DRokn9zv@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 81ecfc1a1094c..4364f4320428a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -3097,11 +3097,11 @@ static int airoha_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	xsi_rsts = devm_kzalloc(eth->dev,
-				eth->soc->num_xsi_rsts * sizeof(*xsi_rsts),
+	xsi_rsts = devm_kcalloc(eth->dev,
+				eth->soc->num_xsi_rsts, sizeof(*xsi_rsts),
 				GFP_KERNEL);
-	if (err)
-		return err;
+	if (!xsi_rsts)
+		return -ENOMEM;
 
 	eth->xsi_rsts = xsi_rsts;
 	for (i = 0; i < eth->soc->num_xsi_rsts; i++)
-- 
2.53.0



