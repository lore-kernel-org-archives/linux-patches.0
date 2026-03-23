Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92523AB9D;
	Mon, 23 Mar 2026 14:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277262; cv=none; b=CE8kHbUMUW6zE7enoGdZ1tGuR1JVYbgQKtVpKV45cXMO8Px2x/Ge8IQNyRWRZNGaXp1b3iVt8sKtsD7DtO7hHe6WjzWVwfOv4t3Cnf+HXkeXPFtyixq69MfPEyoMULyj/x5mX49bXYOSDippCmBMiOM35/de/+oaEN2O/4Z1Dnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277262; c=relaxed/simple;
	bh=rW7vOtqFUThLHIfRkha0XiouyuenVPo/Am6GJcxAEww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7UFp5JSEvT9zuNiX1KjT6SPEiOyfcNyivGDyvOoDNWsUqs6gscvHU/d/WgAfJQ9KF6gli/IYuBLauZ9Olyd7ag2AJQlMebSknROi6NZvjJH3KkHYpY7y+E3LOmQLzI06JndeEY87ro5v/scAPBOV0/W9485eVL3iawLi6YbdlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5T61hDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5T61hDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A55C2BC9E;
	Mon, 23 Mar 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277262;
	bh=rW7vOtqFUThLHIfRkha0XiouyuenVPo/Am6GJcxAEww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5T61hDm0ViVJutSS2iYPsANxQsCoDfcRftRCcKzxoClquO1OxWabAMpJ3d+upg18
	 rU/I07BwAzRtmpBYORrLpflZj1TUIGl7JdGPV1iV/oJ9bhTydATs+aCh6RHNCF8i3B
	 SAcBsfkvBANtvLpv2ntUt80nBX7KRo863S0suT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/460] soc: fsl: cpm1: qmc: Fix error check for devm_ioremap_resource() in qmc_qe_init_resources()
Date: Mon, 23 Mar 2026 14:46:09 +0100
Message-ID: <20260323134535.732516455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 3f4e403304186d79fddace860360540fc3af97f9 ]

Fix wrong variable used for error checking after devm_ioremap_resource()
call. The function checks qmc->scc_pram instead of qmc->dpram, which
could lead to incorrect error handling.

Fixes: eb680d563089 ("soc: fsl: cpm1: qmc: Add support for QUICC Engine (QE) implementation")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20260209015904.871269-1-nichen@iscas.ac.cn
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/qe/qmc.c b/drivers/soc/fsl/qe/qmc.c
index 36c0ccc06151f..cc7032a0ad8c3 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1777,8 +1777,8 @@ static int qmc_qe_init_resources(struct qmc *qmc, struct platform_device *pdev)
 		return -EINVAL;
 	qmc->dpram_offset = res->start - qe_muram_dma(qe_muram_addr(0));
 	qmc->dpram = devm_ioremap_resource(qmc->dev, res);
-	if (IS_ERR(qmc->scc_pram))
-		return PTR_ERR(qmc->scc_pram);
+	if (IS_ERR(qmc->dpram))
+		return PTR_ERR(qmc->dpram);
 
 	return 0;
 }
-- 
2.51.0



