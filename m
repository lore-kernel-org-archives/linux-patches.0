Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC3030BF68;
	Wed, 20 May 2026 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298537; cv=none; b=HDALg1IRPzwUwJfsenGUZxlvfWND81MD6zZZbeMEw1Ld8YIUJd1NdTXVwt9eVb4Z7rLOhp9KP2yzFW1TWKv50x7F3+XEFkJM7Y4OxHbM9P/qOHKckR1g84Zti3ZFF/utAf5xzft3rSs4y5fcGODyCh0MQD0AiQKYIHEyZKRIINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298537; c=relaxed/simple;
	bh=dvvrr9TcetFsvlOFFiDeFGmp7NYsQouJ803XW3m0DrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sygYK3ZXHAZSr6GBLGR+hWGGEm/3ksqlugHXGyTlEUAgNIiOzM/N3L55233697yr/xNpWuPpiCNwpg8ZSvdjzWpwOZZ7mYLX4npqLNtu5LH51tdtyT3/+erAHfHeO9teyykFXMmzLzyZGcpbx6UjLzZbomROoO1RDOhV9kc8Wv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvhMQzLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvhMQzLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40781F000E9;
	Wed, 20 May 2026 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298536;
	bh=YAcK0+CY/gASevpDJXT9Jc1Ocb1d5hLsxL5DNDD+Qhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvhMQzLJcVedgIjiDErQs/0p9y+u6U1agsBurXXR+oXFDDE0jXY3MCKT7iPBcWA5P
	 7XGxW6S5fA2xrPZKRWM6IbdMO6P1osw87wkoTSFsIqVzTLyHZ6rTCRBkAD82SWkIa8
	 +KgiFmweQj2ilyfJpaYLbZO9QkQwVn8YH6XkN0dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 449/957] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Wed, 20 May 2026 18:15:32 +0200
Message-ID: <20260520162144.257208991@linuxfoundation.org>
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



