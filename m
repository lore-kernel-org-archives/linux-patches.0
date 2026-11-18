Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060424;
	b=d2WJe/wIxBmntKKt8/6GgINImANuHpv5wK3H1nGqm//1OGT0pz4NU1XyNMuBrJDb3+OX
	 A4+ZTom7MS4B8CIhtjKPQoJQicdjuztw2rhiemQvjrBeS2Bcxk7U6tVCqU74T06drIBl9
	 nYjOpSyOEUE8pTdXZ0LIfT04urh5xYL2ZIBoo5hXjTKoXablWqND3/BECKrwNTU816m9j
	 x5YSdIMac3oR+7FHVjjoj4PuuW+pQw0KGzi1VxAiA1eDU6pM+BEyJ7DGZRcOebNXLwtZT
	 zd2FAqkiioAv5kCYUXv0eqYO1D2EEAcpugcFzLCEuymO038cWSW9xcMJoxcrDH/0MCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TgQQInF4rdYHh9hWnwtiuQIrNs1u350+1RdbIHfmR70=;
	b=E/j8YhHzVtpTx/kMTeRLvgLscfWQ3zgtMceT3foWtqi/pU04ZG7Fzrl01Kr1LGfL+1ra
	 S5NOR4ydgGVXP8nKA2Lusb7OXafas+gWVlioX+7RJiX5Wn1NYwGWFFzy/nLTYfggD2u31
	 4k/Z0b6N7B1j6urcWgyTtAobW4RicNq/psjeAruhq7BwyUEx+cIAYGGnls/TXpf+VkRHi
	 jAWOoRk1p4iFpT7yqTX4BZJrGxMxVj/3YztopUWnrO6Mpeq7hbQGXr/5MuAk6WPmaZnWM
	 EBSEZHAZsyzLH+WpxJTjmDbDSyQAIWCzR1ZnsfU09bdt/HyZ+pO+IivNdNxBbSA5reA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QjC7/Kh9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A840606A32A;
	Thu, 19 Nov 2026 03:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjC7/Kh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DEA1F000C4;
	Thu, 19 Nov 2026 03:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060424;
	bh=TgQQInF4rdYHh9hWnwtiuQIrNs1u350+1RdbIHfmR70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjC7/Kh9+LJIG0UDcv0fek1CdzVOcMErK7bB2giOzp093uCYJOPgWDHEioH75nreN
	 xPqaw9mVnQueLvdFZV/vbUM37BmivaduPauKIp0NqToqD2QPWuoznnv0144Tiu3/C1
	 BS/unrerLCw3817Muqi3/maoOxWzoZb6kyLNwzyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1192/1848] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:53:50 +0100
Message-ID: <20261118150009.389196537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc1f497732bc4..9e31608d64c40 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1135,7 +1135,6 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 free_chan_resources:
 	zynqmp_dma_chan_remove(zdev->chan);
-err_disable_pm:
 	if (!pm_runtime_enabled(zdev->dev))
 		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
-- 
2.53.0



