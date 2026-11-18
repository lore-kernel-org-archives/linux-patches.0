Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023252;
	b=dMPwnEgIr3dIFtso1ukmMCEETtXoNOKQ0O24pPClbmHXSklPy0MBUQXsqECAYSs6mB9A
	 2B7IuTVRZlJMZeLu/8/+jb/0Ldultd0fw/WMbYkIrMu7Juo/3f6kXq1BQMZfOr6Apa+JS
	 DopGWjT4VD84xS/71uT5shdXMyOEpQ5WPplz29PsOstMD88bTq867/qZWHItZKIjwr+dS
	 gOUkuFwVPnBYL8s5wBYlt0MQVneDyPEOVaakgklZ5iStcTc0Leu2TZA3RzgEOEATISx0P
	 Qr3Vae2JEhaQvlo6PmK5ICljVItp/uH/uK7tXPZ7JTXUcWWQyIjM3tX2sqXiMNmNwTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QEfwZDekaSRIbgDROHDzKYmfWmK2Df/6D7qf6jcDxOI=;
	b=23gZJCXof05v9oS1IulzvczZzNNURgiZqtz3WjufX85eDZt3CHFW3+LR6OBXwuQn2jCC
	 W+yQ3Ou/UYb0vM3uc8fBPqK5R5M8lNtjegj++wfD2HzrQS1DeD17dzTMlpr1Wdv/liUnl
	 bcfL4uq5XfnrKTAZLa9PZyjYkG8QGNtwK/TUNn6OJd05WorwNvwK7XhWI8hvhIaYtm7+A
	 zdL2nA8FRAkiQCzquiOjCvlFgYRxrG0VboSxWJmLjmQ/BU4pMVCvabcHG7RrQftCKY2D6
	 evASY7SY8dIw/rYKFTrDK3ihNjjUnDOFF3RN7+cdtRiFl52Iucva6kg5qHxnCXI1pjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z/bSSQ/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CC1606A320;
	Wed, 18 Nov 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z/bSSQ/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0C71F000C4;
	Wed, 18 Nov 2026 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023252;
	bh=QEfwZDekaSRIbgDROHDzKYmfWmK2Df/6D7qf6jcDxOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/bSSQ/opcsqv2sZP0BjTcWVkUYlDTOJivxwFL5Nvc0vWUaoolljqsVqtxw8yo6JV
	 BwaPgQGMd0V3n30Hc5baADnP1jNhHXN8kPtZHbhPHvuphzIo1rXG7XnDbeHVmPGNd+
	 9iR08SPD03BQrSQvZtw8fpEQVz4TCYFv8GIZ47+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0304/2151] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118150132.987720785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 08f04d5ab868bc28d3115f7406499e8e5d1d1765 ]

Commit 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error
handling") dropped the use of err_disable_pm label causing warning:

drivers/dma/xilinx/zynqmp_dma.c: In function ‘zynqmp_dma_probe’:
drivers/dma/xilinx/zynqmp_dma.c:1171:1: error: label ‘err_disable_pm’ defined but not used [-Werror=unused-label]
 1171 | err_disable_pm:

Drop it

Fixes: 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error handling")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260903170357.1711462-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 59b5199a58a48..1f6bb492be6af 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1158,7 +1158,6 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 free_chan_resources:
 	zynqmp_dma_chan_remove(zdev->chan);
-err_disable_pm:
 	if (!pm_runtime_enabled(zdev->dev))
 		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
-- 
2.53.0



