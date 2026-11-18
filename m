Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029238;
	b=Lfkrqs1m4bgWm0aCgWwo7Eh6fD8pqtK4+HaINuH+VsspzI3RiF5wTFy2tcNOyT3MnnHh
	 7EBRmB4seBTK94svyJ8nzPMIYxyf4/fQyXFTQjX2EJ0V+yyg+/ogSu1hnvjj2jdLi4ooi
	 BPTcFiQ+N/Qp4q67JFTQ82HPwhDAw3S+3pUq07G3GY9ScSGyAptJnScY2jsO0mVtSkT/d
	 LK+iP/9GOfxkiJh/x/IUO5EOXl5mKHG/2VbcjWGE1RFqkRUjcLjdwxBBfY6vlRXSpYYAg
	 uM6WDvC3ZiSeIJ8TaEK+reolAJ4KU7FUILz2V0N5hka/T/FgmTAR6k74GYVLCHsHUmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OIM8aAZJ9ZMl2oeyk+INkD9zv388HjNrETXubyBUE9Y=;
	b=XReI15nNmzt6YFcVbdmnwXw3cTB1MYFg2C/tx3GR2hT5Ass7gqb/ltDuU+UgU0M21wlf
	 sU4glgztiwlg9RyhrldpsQiqZyafCoOSkV7ZY4N8dEP1wktcKubd2NKjb4ksOcMz723mH
	 +hC0O1jTbMYA0PcD5vC5zszqT12bpor3vJq0rxIaOdksmnpsqDKjtj/Uz3PRWu3XURimv
	 yPcnwXcPdBlzW+keYBfAV4mzOH1l/B+m8cDhtWgtHD3QZsk2oL460yxxuHEuolU5MAtQd
	 1kg074g6u+G1Ooco3PJXZJ2TZCSAAPx67BayZdK1T7jeLp2mz1ekVUFpjEXd/XnltIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQxblP99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4A4606A31C;
	Wed, 18 Nov 2026 19:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQxblP99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5391F000C4;
	Wed, 18 Nov 2026 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029237;
	bh=OIM8aAZJ9ZMl2oeyk+INkD9zv388HjNrETXubyBUE9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQxblP99E/tGPTuw27v0GsabJz3jjkhSRhCk6j2kWwMsa7EA7ZD/c009xstYok4PI
	 ukzbJ3zuyp7Dxrnga8iSuZ2oKKgKOra9tdc4g2EF2Mi1G/JR7VnUpa75ASPIk0pUZw
	 r4XQWR/hU3t7h8/Ie3meuo3BwsSqfFimdyAHqLyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0280/1756] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:40:07 +0100
Message-ID: <20261118150019.568366130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e8661f7b755a4..235c60e1e320e 100644
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



