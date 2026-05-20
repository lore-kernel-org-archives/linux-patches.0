Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BA63F787E;
	Wed, 20 May 2026 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300823; cv=none; b=EJHzjd/2qE9AiGf9MV6pYGQNgrIMJtvOaUjm8J3b6rgr/A5Q+EimmRxhtqTDV56ozjAx9HuKrcPHGFu5M1lP6frmWfEgbpYGhNGLmgiPsnLDLM7VvDvWMFRqnEnttKIlVzVMdeMBsFA/OEO59SvqE6lvOaT4PbOOzwyqiMP4xsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300823; c=relaxed/simple;
	bh=AGshqD3X4hfFE4IoQUZ/Zgnhp1MuEPlLMihBdX5uzK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t92b51FQ4hPyq/GjmnF6YmGr/ZhTwbXfjLvFIYq5BvCYEJllweGCprPNWR256UGvimQhEaiZ2eqRoiyYxpJQWlmsGATG5/x28vv4K1hMYxnzyuNN23RiYqVZHbPB+kJAcaOfSxTUWyZaaN5OTdhT993LB6e7BFopA6C472uiqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaAcx7ZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaAcx7ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593B61F000E9;
	Wed, 20 May 2026 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300821;
	bh=3R66wQvXy4+fFKH3bAuM2lFgT8A3OgMoL9hQPlnoU2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaAcx7ZZX0ZATvsGry6hUWVkK0kD41RzYQiLHHqLlQn7nnP4bKq8q9PzSZl8IUnQD
	 vO1NLn+hgw8idX/wxl9x4245YfKR60dt2iV+MrihMFbt01T9xcduibr3Lwo5AM7g1L
	 pU2tLJTc7k3BYQSFz9lT99n/gjVw9Dit0JbZ9gRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/666] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Wed, 20 May 2026 18:18:52 +0200
Message-ID: <20260520162118.179904323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index cfb9962417ef6..53f572b6b6fc6 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -824,6 +824,7 @@ static int mxs_dma_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(mxs_dma->dma_device.dev,
 			"failed to register controller\n");
+		return ret;
 	}
 
 	dev_info(mxs_dma->dma_device.dev, "initialized\n");
-- 
2.53.0



