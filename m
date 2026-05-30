Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0225823392B;
	Sat, 30 May 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164256; cv=none; b=aJrFMM4fDlnqiFMl23Ec9GUDs4y9fm9M7RR3E4f2w5+EMOyHz88FHRCvjacxyKS8U2NgL32Aqod7yO3H76wbCspBthEhL+nx1lEl4zULQf3b2EXXFTbggpZJDwzAx2JelhuJC5Aqro0Chb2oLjYFkh5FWoNuL9vM+HksK8BahWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164256; c=relaxed/simple;
	bh=KApk8uxzXOjGAD+bVZI2Us1W08OLuh3Xy6gOKEOGAxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kb1/Z2qJmzjV4Jaq2FH5FvFuO6k3OaOm8Guz+Rd3Yf/paiEhucpS+qW2URuADUbfiKsWjNbZttKKUvZuE4mvt1Wpc2yNUrwzatGA3l6ZzFZcoM+ul2Fn2JbVbn3gwbG9+ds49Tu7y1OY0exuzinkmKFftI20G2kZaovwqBnRSUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9po43wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9po43wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BBA1F00893;
	Sat, 30 May 2026 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164255;
	bh=EILfFk3gAelawK+R3Qn0eb5ycg65AFS2Ir82MPEd6KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9po43wvGghAQdYtzxhVIj5wAWR1zD7c+vbH6/2Qzc/qt3K2gMdwhEzPJQEeYYCrD
	 1ZXNBU2qJkCK0G+onqf2/wucm41ssSIoGJq1g3yKf4SZyhYmmU7nCGJf9BcnGCGj1A
	 QO1K7yrCDXHn/W5dUDkqK5nIpTf3fL+zdRvh5nXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/776] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Sat, 30 May 2026 18:03:35 +0200
Message-ID: <20260530160253.237938216@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit ab2bf6d4c0a0152907b18d25c1b118ea5ea779df ]

Propagate the return value of of_dma_controller_register() in probe()
instead of ignoring it.

Fixes: a580b8c5429a6 ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260225-mxsdma-module-v3-2-8f798b13baa6@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mxs-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index dc147cc2436e9..5d34440b9e127 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -827,6 +827,7 @@ static int mxs_dma_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(mxs_dma->dma_device.dev,
 			"failed to register controller\n");
+		return ret;
 	}
 
 	dev_info(mxs_dma->dma_device.dev, "initialized\n");
-- 
2.53.0



