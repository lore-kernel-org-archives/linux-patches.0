Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063576;
	b=NXaJ8hwMKycak9Fi4srcnlFw9ETlUgmVL22qSEoERjafXFBB3HGkstDq//BsL1KZmW8Z
	 3nPqASlj8Q6/FCE9h13GUM80XIQaaLmhKILR5v9/VR8TYaRyMicpswzMCfgxGwCXvufB8
	 +j9KBJ4yTCn+KaQhLmYyt0qthWl3cOe+i4HcXak0ELpIYLEGc3bPYG5ShtVyzEnvgoH6W
	 /C6wqlBmwWCJZt6h1QIZyLPMC2oTjl4CIJlFD4zdkgqsSSdFN9ndId0wFVS3h9AXClxmJ
	 JWDep6KmR+RBBGq9XCymFu+15zbKvIOuHJyMqVCSYh5t9nRX347zYTUQ23Bqo8VBFig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DG51pQpKV2FMaz5AgiJ76cbWhXJ9tj9CTq6Bps1Znms=;
	b=UpYYqHFZ/hIJ9LPWJnVrSIuWwc1xdafn+jao4rIzMEQfDLsaBmFB/uggN4lMRZI9euWA
	 /sBppAOO4ufzuZdtmgv7bFd5o/sZCZ+Z/kkS7IeC8Lly7tJLEnHxT+vJEVgCTrdkJ19H+
	 Sp9cqkBBypZwjCkwUHEPsod3YCnGbzBtDdDS3gJUkEXsp8FVchpTRFJcM15aNj4rgFMCd
	 hMrOOM0wdfNpqS1MByqq09madHto6VeOTzP2HpfjuyNFflsml4qs2rOy9Uotq6VAhIiEE
	 cvoVMbpPcPiUGLXisDlTIpN0Y/MWRLdLhTcnAvYVr2J2zvpyS5xC5TgyRquhm+HQ25Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwoXlZZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937B060A2621;
	Sat,  7 Nov 2026 14:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwoXlZZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4392F1F008A3;
	Sat,  7 Nov 2026 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063576;
	bh=DG51pQpKV2FMaz5AgiJ76cbWhXJ9tj9CTq6Bps1Znms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwoXlZZRLk4dTuIBstOzAGsF6OO6ypRfMD58pCmOKX09Ph8zSdRPNmEwkx3YKw+Uf
	 SZKM4ml5dr/CqPWLL9YPE8YjM+9ifNZ0s3DTLqadGlbhvYETCvQq64mD//EDzh+7BE
	 /yDg5wnQisKF+wSfdNhT55+6Z1XUst/wHOfbusyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Florian Fuchs <fuchsfl@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 706/869] sh: maple: Use the matching IRQ cookie when invoking free_irq()
Date: Sat,  7 Nov 2026 08:56:28 -0500
Message-ID: <20261107134916.851334952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e3ef44e77b40e3cecfb34757ff3c15ecceea0309 ]

The Maple DMA and VBLANK handlers are registered with
&maple_unsupported_device as their dev_id. Passing NULL to free_irq()
cannot find either action, so the handlers remain registered and the
IRQ core warns.

Use the same cookie when freeing both handlers on the error paths.

Fixes: b3c69e248176 ("maple: more robust device detection.")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-By: Florian Fuchs <fuchsfl@gmail.com>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/sh/maple/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 6dc0549f79005..3d3302c900caf 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -863,10 +863,10 @@ static int __init maple_bus_init(void)
 	kmem_cache_destroy(maple_queue_cache);
 
 cleanup_bothirqs:
-	free_irq(HW_EVENT_VSYNC, 0);
+	free_irq(HW_EVENT_VSYNC, &maple_unsupported_device);
 
 cleanup_irq:
-	free_irq(HW_EVENT_MAPLE_DMA, 0);
+	free_irq(HW_EVENT_MAPLE_DMA, &maple_unsupported_device);
 
 cleanup_dma:
 	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
-- 
2.53.0



