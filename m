Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015905;
	b=FL2bCF1w0x5Zdg7sxsg0TP6cpvwPvWRzZ8hB10+T09Ro+ZC3GdaIEBFN3iYnBN1nX8Fg
	 QDO1j7xVVPTC/Xsi8faDknGFp6saVr7/gvwHVm1C2y0be5jB4BzOxs9dbzZtxKqO5b1fi
	 zLiYinMJ2MSIeg0ZTfLCw/Yi1szl1FwXM7SnSdTWS3kC3kcSECXQGh4CbBTLsj98+e/hn
	 mCRmrR0ac5dOdVeKDIYf6ypY3mkAmXoV7rTIPPPoEpTZurx8/9J72+f3nur09RM01YSU5
	 7ZSsHbDjxnYiMpSKfGvZniXL//l0mEjqKFuZWdS9JK7xqCJf05q6oM958h6LQZGL0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOnviMM9IN1eei7FU+LdV4b2ASQIEH8M9wnU0FKPdUw=;
	b=HkVwjs+sLZNBT3PMhcOLndUMS7aF6/LM7cU9I4FtDBfNke95Ve9FTvSKPlNN3pafFY7q
	 E4TweKjGa/Ppycm34YvknYJsl5ADw2cm0PzMuO5yp0dNQtHLz3hXFaOjltCrJ2eB3KiRP
	 gOkC0lujBuQ7sAqZIuXRdazouwR+uVLM8DHjYvMcCB1J/cGf9OtvgVXl8xZd7N4S5JNR4
	 2nnPS7u8apG5nowZdqxe9jSOz25pfEaytn+TKdDRGHyn6sU09/RRo6MtcC3kuJ2eSiQv5
	 Y0vqBAAkEP4V27SZNqObSMzdBiYRaKot3gNW2pHY5XNtY3Pxnq5T9Zu3V6m2xJ984Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFeciZW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCC360A2606;
	Wed, 18 Nov 2026 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFeciZW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77511F000C8;
	Wed, 18 Nov 2026 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015905;
	bh=UOnviMM9IN1eei7FU+LdV4b2ASQIEH8M9wnU0FKPdUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFeciZW8AsnX8l7IqkhUfseXEY27KBdlNNLMRITOvMHGvsiei4xNHagZ4ngBjeJ82
	 vxfIUP3stq9jko7Cuf/bdygeUqAfeV5FGY/uJW27lAqAqsVTNX7/DS1xJwvoxdnL1b
	 0RMfPb+7O/Va0IDIaIoVSwqMdQWU7ZKLxR7IPB70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0298/2651] dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure
Date: Wed, 18 Nov 2026 15:25:38 +0100
Message-ID: <20261118150258.631131265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit f2f44b952ea6e0c600e92ea21fcaa83cafeedf6e ]

If sw_desc_pool allocation fails after pm_runtime_resume_and_get()
succeeds in zynqmp_dma_alloc_chan_resources(), the error path returns
without dropping the runtime PM reference.

Route that failure path through err_pm so the runtime PM reference is
balanced before returning the error.

Fixes: 8982d48af36d ("dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-2-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 2b03584102acf..3a4deab0593c8 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -483,8 +483,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 		return ret;
 
 	chan->sw_desc_pool = kzalloc_objs(*desc, ZYNQMP_DMA_NUM_DESCS);
-	if (!chan->sw_desc_pool)
-		return -ENOMEM;
+	if (!chan->sw_desc_pool) {
+		ret = -ENOMEM;
+		goto err_pm;
+	}
 
 	chan->idle = true;
 	chan->desc_free_cnt = ZYNQMP_DMA_NUM_DESCS;
@@ -516,6 +518,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	}
 
 	return ZYNQMP_DMA_NUM_DESCS;
+
+err_pm:
+	pm_runtime_put_autosuspend(chan->dev);
+	return ret;
 }
 
 /**
-- 
2.53.0



