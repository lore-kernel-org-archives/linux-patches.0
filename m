Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1584435DA6C;
	Wed, 20 May 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295851; cv=none; b=GtWx+8LWKaYnrGVkCX//P8aY0SEH3DcsABo/tPfJX9KLBpCai0CMGuH0g1LBoyYQ+RbA7mqqO0MagJ5oP8BDRzuGtlopFlWbd+Sj/wu/Lzi10UKLoEQCt+aHwbCYkDVLuBxDN1i8lLgPt+/Q2m2LrLu67fjCk1SFSMc3FSHAy4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295851; c=relaxed/simple;
	bh=rvCn1rbFRiIboIbFYExaJeiNdAVdMh4O5gyCqzoXCPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTiehgXEK1HIxOEeFz1Jcf+h40RpuElb+3C6vhTHYFh82xUmVRwbqixNxQeF0tHiIGOOdPDL4Lb/goDo/DFmkZrJY6FMXhxIp4jfAGSMpoz9Ygrz05TuI4QF4D6zDhLX3O9W2TERJxeMKGuJlAZra3GQ/vSD8U3LcUk8/vaxfvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcgzpKcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcgzpKcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796271F000E9;
	Wed, 20 May 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295850;
	bh=DrBL0YUQMtZFjYq6yU3L/Q5d4JKycqVR/2NqzQg5dOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcgzpKcX411JwYGK5YlXZAoha5+UyjAOyV4DH0hImHvPijL/gPsN0ntJuDirEY3Nj
	 6Dc3HTFHt9zTueQQdqPa30HWbCv25xzM+HhHZsi5mPwb7yit6NHqZ8S2zYppajlCe/
	 okt7TefZZ1ooUxIA7VNSAN8TW8r7XQQ+g4oCbuiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0577/1146] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Wed, 20 May 2026 18:13:47 +0200
Message-ID: <20260520162201.241754750@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



