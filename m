Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063002;
	b=krFkVDmeSVsrObVGIMEvZRKf51aaBNLK5BmROql9czUXcD42EqatbqI3WtOn6PEEaWpT
	 ZE7wNuiyHs/8UcY58AHw5JEx0bt9cwez6powXsxGORaBiCG5xkQqBr/nUz5QoXMzf58xn
	 E68xSraatXpsxCU6W9tSZc8oz+qMCOkPJSPZUi43kmZjTVk26QVvQeEsUjfn857yo20RZ
	 H3z5JH4EhG1FnH39xQfvgcc+xHQTQGN7ZvsSWEcDIQCA66t+bUHzptSyDHsQt112v+TOS
	 PO7CoakMj1uq16SrXUmrPgEiJt1Db/PKSWv4R1QNBnL+jRxaGUiqijY+8hIm0bUWGtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8P/mkZHwFts6fIKb3TzX+1fKXT6HeTG5K6vfCUIYBXM=;
	b=wD1CpWD7CBr13jwCM+0DzxIHCeD+vIpf7YlpcHO9EP4AvjzvRFgTSaqj2CLXaF0qLoKM
	 Hiv6hF9MMiMTPVxyIo7QUDzK6foE5vui/sXxOYUL1orf9nOXMtSmwSq3QoM6ZIDh6+TRX
	 pzBqXjAxzxyoINsAI95J1l+amhafblqD4bjckay79gHXmraueDKmC6s3ccVM1NM6NkMbr
	 J+hGyCdvpwl1mYBCWmOZfHz8LfkXVkaoct+R0z6hacMnMnI9tQrgh5hSTzAop0lwHiQWo
	 ZC2nlxlhONeUAyp4H673ppi4DY5G5yeu3jWRJ8H/msTbZYjAk1ayhehKb/oknO5pOeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqBR7NBy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2825606D825;
	Sat,  7 Nov 2026 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqBR7NBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1371F008A1;
	Sat,  7 Nov 2026 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063001;
	bh=8P/mkZHwFts6fIKb3TzX+1fKXT6HeTG5K6vfCUIYBXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqBR7NByCicJgznAu2LS35PHcbcNkMO7tRCVcd/QndPYc1d78TnxjI1TrE4tZwfxK
	 TRvTjLulKhaodmsKsyWx2C1r8yBabNGKQFcxW9ANDTt5EdqqbdfzX2RE5H7PAEv10n
	 VQOH4gz71uLNK9H4mpw7qnwm7kGZVp1bL1CI1XYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/869] peci: aspeed: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:48:58 -0500
Message-ID: <20261107134900.455588223@linuxfoundation.org>
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

[ Upstream commit 61cf765b654b76a62510269521a65e4e4a488f4c ]

The PECI interrupt handler uses the lock and completion object as soon as
the interrupt is delivered. Initialize both before registering the
handler so an early interrupt cannot access uninitialized state.

Fixes: a85e4c52086c ("peci: Add peci-aspeed controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20260902142600.3580382-1-runyu.xiao@seu.edu.cn
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-aspeed.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/peci/controller/peci-aspeed.c b/drivers/peci/controller/peci-aspeed.c
index ad3a7d71ed4c6..57e1a71386074 100644
--- a/drivers/peci/controller/peci-aspeed.c
+++ b/drivers/peci/controller/peci-aspeed.c
@@ -527,14 +527,14 @@ static int aspeed_peci_probe(struct platform_device *pdev)
 	if (priv->irq < 0)
 		return priv->irq;
 
+	init_completion(&priv->xfer_complete);
+	spin_lock_init(&priv->lock);
+
 	ret = devm_request_irq(&pdev->dev, priv->irq, aspeed_peci_irq_handler,
 			       0, "peci-aspeed", priv);
 	if (ret)
 		return ret;
 
-	init_completion(&priv->xfer_complete);
-	spin_lock_init(&priv->lock);
-
 	priv->rst = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->rst))
 		return dev_err_probe(priv->dev, PTR_ERR(priv->rst),
-- 
2.53.0



