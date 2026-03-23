Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CADA3ACEFE;
	Mon, 23 Mar 2026 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274780; cv=none; b=I6XYBjfZuVpWdwN9EB1/Z2BfEaq1UooMGCEHyHMucvLJ9QnxRYZ9vRtzSejS1TQvQ9z7U3mtf24Ig20mTu4lLx917gbkE2POj02ttltR3CqlorXrOrKeOPh0rvMHTtbB1ohP5UAjKDBxsBg37i4F88jMrCec6aS+lDLb0GrGzc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274780; c=relaxed/simple;
	bh=DbFnt+cqXJUfKaOup4Za2s2rrJ7budjCM+N6dqubImM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpO0JwLbFg1xZ8uj1qy4yZOjGIhl/oRALJFmz7O3UKVUQ5357ALul+5+fjLUEFEN9z5383QKToumA2t/+UTwH1twTAhdUI9IX1KpI1P2V2WldQbZjvB2oKX3PIa0P/zRm4RnEVQOKduAZNmsK5CoebJYl3mIKQlQ+Ae5mOAOtuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyUMc5PX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyUMc5PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659B6C4CEF7;
	Mon, 23 Mar 2026 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274779;
	bh=DbFnt+cqXJUfKaOup4Za2s2rrJ7budjCM+N6dqubImM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyUMc5PXuS3aVJh7MaLIVzX41pNYd3rwKEOzm4XzdSmkYvykfWgxw0HdbhYfY9FJ1
	 w7npkqlwj//IH9aAwqluIdeF9BNQV1EURWowN5oHGYmRqNYyzMf5l9IENnw+jjyVXt
	 ZYh2NJhd4ryAX3vHoRD545Ju4qwdetsiB8munzt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/212] soc: fsl: cpm1: qmc: Fix error check for devm_ioremap_resource() in qmc_qe_init_resources()
Date: Mon, 23 Mar 2026 14:45:27 +0100
Message-ID: <20260323134507.132866507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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
index da5ea6d356184..6db5ab05c2c1c 100644
--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -1799,8 +1799,8 @@ static int qmc_qe_init_resources(struct qmc *qmc, struct platform_device *pdev)
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



