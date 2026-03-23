Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DBA3ACA62;
	Mon, 23 Mar 2026 13:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274078; cv=none; b=S+SxkusuRyaKwm7GRCY3T1fQjXkhwtvBBkUiElh/OIfa55vx0UlCtuxSLvwTOqaJ67jYhWNU8geyfZ4Q6Dr2kUbACjywIL3x3VgZU5TmOJFHW4NTmh8+HNBFGakjCjYpANaAwwkntG2R1M57ixGeMeXR8SOwZhmBZ9eYGtZAKd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274078; c=relaxed/simple;
	bh=m3YVXj3x7sbV1a93NHzxgV46VUtsjy8k4pScNr9BMZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LM71P3iKrdGRIsfpK/LVhOLKOW/tE8KCUwYN1KzMYuuQvfx6crKgIvzTZFmFgmQhGCURo2pN6V479W3ahpAfGwuOSDyzgIoSwSemFJo43EB853veiUT35DFMxg+lHqDLEAJEgzZZgjVZnu9lub5FG+QT+hoCKVfq/CJY8CQ3EGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFo5P/HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFo5P/HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A22C4CEF7;
	Mon, 23 Mar 2026 13:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274078;
	bh=m3YVXj3x7sbV1a93NHzxgV46VUtsjy8k4pScNr9BMZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFo5P/HWmEu1yi21CA58j8QA/FzXwYLiMTLqR4GMhqiNItdFGal2v0kATa8pTbmgB
	 eR7YSQk5gu7oPqVI1605GFgFR/hBIvnnxmaG0hLD6/U+9DxVtT3AZZZcB5324YRh3M
	 nrbnaBHJI+5HIQigX/QI+agPAcDp06xOeoULN+wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 102/220] soc: fsl: cpm1: qmc: Fix error check for devm_ioremap_resource() in qmc_qe_init_resources()
Date: Mon, 23 Mar 2026 14:44:39 +0100
Message-ID: <20260323134507.825806740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



