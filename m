Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015803;
	b=Qs+PpzEF9E4YWVN68EhIwcfMhJeF/t2yBKIZBXo/15Hl6eXEqvu7HoPSM1D2Kg2DS5kc
	 /czhA4LX9vlDwduCaAl6oIPy2yS6+VkaI+qS5RMq5353VQ1fKsTG1XRioaRqnxyWH2X+B
	 Jgsorla2bU+4U6qaugbHPnDJrfT4mWjyhGmdyLQ0LtLlQkw91FmcrqiCsZQdjSSz+iZbb
	 JrDQcr2Tf/JfN3BKM8PrcKvu3ps0gK/FoxWEMwJtjX54LynwaWUtHlWufV0PTSnkGKcCt
	 mik/OUl4HTMPoHHJbLGE9y9Iu3ihjMEHyuGIpN8PkVel6KmnGxNBoxr3USPewf5Xt8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=h7kqSQU80v0NM1f2LhYF4v4FAPVdPVYyQ2jQdZ42ykI=;
	b=z0WD6kSBzLypSmbQo/sqO4BPSFMJM63ipDSSxbP9sPIPjGHiQMAZNtnOeo4IxC4Cq33N
	 ITzmK3GA6w6ZDicpzKdCxDKojOosro+r0dtTqLI1d9q1ddAPMSNqWkyWxNaULLJg9TYSZ
	 MvntKBXl+03q2PWg0g1h0CWLauG8glLahWDLq79WTnxM9un4/YUmps9ZXzVyI5S1oY8cd
	 CIbjZw2OSoDw9BUb1wvoif/NPZCpbha9t49mWAAmSfL2uds/nbyR2EM6gY2lg9Ihy/H6H
	 hDCaVBGOggm4xSJ0Gv46NFIJjhH4Iv0kmgoS3O7vqF0K69+chn/934nZrJLwAX1lNiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfKHyCGW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A11606A31C;
	Wed, 18 Nov 2026 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfKHyCGW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526D91F000C5;
	Wed, 18 Nov 2026 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015802;
	bh=h7kqSQU80v0NM1f2LhYF4v4FAPVdPVYyQ2jQdZ42ykI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfKHyCGWA0eztSOXNd2xn5Kvg3FQFr4omMykky11+KQ0xyw0RnQIz1TLtvWyiLwsG
	 pki4+vLXovks8E2NnOnj1y0q+BE27Hk4ESoWBo6HI6363UFopVQCMBwKA36XOt8FIL
	 OpwBDyV3fI2n3UVbl6FcKE0CCGiJBHZ7bjxfTCUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0304/2651] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:25:44 +0100
Message-ID: <20261118150258.844861930@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 81a60bb1ced4c..56464b6dc283f 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1166,7 +1166,6 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 free_chan_resources:
 	zynqmp_dma_chan_remove(zdev->chan);
-err_disable_pm:
 	if (!pm_runtime_enabled(zdev->dev))
 		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
-- 
2.53.0



