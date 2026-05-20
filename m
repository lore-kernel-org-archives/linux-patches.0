Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED16400E09;
	Wed, 20 May 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302420; cv=none; b=Nq5VFgutdTl32guu1lyQDXVd+aOwmlkMmi6Lmlph/Qb+AgAKXxv+kBQgUxDvcknyFINvV1GUporZMbk1Xh1+OSvM9y2ELsBhb4PUOa3PbG1VYQAl/XI6PotpPvyygVYAS0bmfrj3/pkh/6Hza1KnM2PdjvErfcKQfdKjiOJsQHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302420; c=relaxed/simple;
	bh=jSIS5qcXle4Jx/n7EA+7ya9hv+r89aaGe3UEl8bH17U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsSyeLHw8EBCkcItcW+0j13IgNOFx0Iyl1f59SR0AhVbyjRiOEglW8OHgFkRuCQKYEECFI7RuBRAcCQRBhrlo1iYe0LA6TZibN976RJCtWPZvtqbwf3gRvO/2MDlUUOK6UMh9FlJauQdsQCcWfNTcGm2utap88rMSjOAUN4Npgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2StQVn+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2StQVn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3142F1F00894;
	Wed, 20 May 2026 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302419;
	bh=H3O+zaa7xUOiJkTdAinhCnHFCo1+aBG9mZMMut7HZt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2StQVn+jlJThylq8Rjp1rjXh5xf7wc28ffHj6StWnmlM6pGZ7xgf1WX/tKa7FtVh
	 OWNx/vBC475nvIC/Qpp379EICn6Y3K+sGlD69wBRRtrJ0Pe5iBsk0KIKQZkNgQmr3G
	 w3Rq2THKUvJTC4+yB7F1tJXA3h9MC/EmeVAUR2Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/508] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Wed, 20 May 2026 18:20:41 +0200
Message-ID: <20260520162103.364649849@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



