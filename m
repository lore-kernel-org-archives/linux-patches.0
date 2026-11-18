Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039552;
	b=LJ43/CSw5Vt3P8rKF/bU8VxCs9nJzt4IwkvAe67WrGGoeLda003k80uRF/wwUTuAQHCa
	 aniii7pBhnDcErkgABjt2IHNEMCnNrINA3c9W6dFhGmqbpoECaS86u7EaItMFDmxZh4cG
	 KqqFeZU7y2NWy2GkZjaI4BDQ0L/g7lYvixjPXsQVCbtLg3yc/W7e7hq9EvyOHQ2UyIFBp
	 g/hjw4SfU/EJ6OehmSD3fpDOMvAkVkvD3CKKBps7GOsvRzDYkf7yUUjGZvJcEF+vdf63A
	 DWUZG2G/9j5HXe+B4oWiD7B0zbfg8/qMRaXeV6m3be8DXII751kSI6wKxsuvZDmuY0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tWowUUu1Qv4ju12unLEoXf9na0hS5oiI8H1lbafhN3o=;
	b=AS7Dh0Jovh99Gewv6+uot6Zf5xvVHiTEYWV45r2aMnskKNwg4rjl5F3jsxtOLGkunxTK
	 Iqt8/JkaVO3jYlMyiMoBVgYJeANeKI6k39ifW3bRAaCUpkl7uiXY5uKE9sQiT0+0bDsx+
	 ygKhAq3qw1imAPIXNSVhXyhuTJUw0e7TSi7R6Arrto3KGRRiuaql8C1Kck9pNUhxJbaoW
	 755nO9tv4a6IgFiuZm9eqhTp/KFa4YHUfCPQFgVsDwMxRaaytOI4iwA4xL//d+hyxBuI3
	 483Ai9orkD8cZVBQ7a9zRDhj/wMz/wUXHNIJEL2Ty6zps4NsP3JR1EzbGP93Pj1Dhtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyakUujV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3DA606A325;
	Wed, 18 Nov 2026 22:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CyakUujV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49FD1F000C4;
	Wed, 18 Nov 2026 22:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039552;
	bh=tWowUUu1Qv4ju12unLEoXf9na0hS5oiI8H1lbafhN3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyakUujVT9tnowMk21o1TSigAQxyEnNEMxsQHne+7VCfka1nUZFoOBID7nw4jmfLG
	 nYakp+PcU1i8ZXRtrpTGCBICr1mH0ZsqztQUbpXDXbbwABYHMb9EyOnCc0vT8nUyP2
	 4nF4aFdyzk5/KkORkG1qhabj9Y8Olb2HyEKEPms8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2099/3318] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150425.058128125@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7d4aa37bc38bb..400b086f7295a 100644
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



