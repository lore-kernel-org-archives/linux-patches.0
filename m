Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045182;
	b=0Fz6F0HbVa7cGX0DMhna6lEDDJH1EOfk4mEfFjZ+tO7TIi8SNxunnCi6o3Lx5AKMRjVy
	 AqheHZM/F+Lm+LJtSQJ1+YSMxCrUtCNi+5wFLymdVL5SS/MqQmcgRLHTa0xwfJOiJK8Js
	 3kfr4Dlfqdht2ploMCJC/420TY29NL6wjmmbJQzI0LXdXbXCOz6opn1l4FCcfNO8PE07+
	 7qfLlZyvd3scJWc57NFE1ar7cNTEWtwkZAaJMMi+Zyk4Xy7DyG/JcqG8cuBPngUs8sGRO
	 aGZ2EQ+8gheclUIvb0M7/831oaBPXFJ29pIB9TVbwJX2tRbckoHaQl2g6LRdYPauMWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OgT33IzfCtpBg+UrslHG8NFJUrXYbI599pfaY7Bo7+Y=;
	b=pJV90eqs3FSM3i1+ePAc+fG8prnhqnP1qEqZipQdoLNNhw6EI6VNuw5hi3R6T9aDr0Xq
	 yNMA7mwrlp7qtoai9xa0HBaCZNazmJZUlw49TqkzVEqtba1E3E69Ior57w2vbQWdY2X6M
	 JvZdRlivMp97zuVZiLM7mGsZSDI2SGlFZLAi5nD+PU+HxVPkVT1Wbz4iBuEvQY4R5gMgq
	 GNHrhEQhW3b5jES25Vp3PEZvYbNPPyDhJjOWKiDM5NWrV7HUVa61MRxKODic+jkSs81hG
	 aiJrx3mSIRp4TwXmr2VKkrAfvsQ6ibXItvKGDvLRVhA6dfAU/H+f1EvmHNgkk3Rbk8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEDK6r6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC6606A320;
	Wed, 18 Nov 2026 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rEDK6r6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6351F000C4;
	Wed, 18 Nov 2026 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045182;
	bh=OgT33IzfCtpBg+UrslHG8NFJUrXYbI599pfaY7Bo7+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rEDK6r6zn0JOXlmDOEoSXiyt5IP2mrefzPaD9OpuWJVQc9WuYsL1WlpcbeBAEdse9
	 7FBVDfUSfq+xxitHJeHRs9fyIMfmimIeNF73wD5S6uCYos2eZBaunsAdNYUa1ul6hO
	 fC7dYNijELyE/wxXPdiaYEjMncCbY3HABIn/zo1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0830/2857] peci: aspeed: Initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:31:04 +0100
Message-ID: <20261118150231.456027625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 731c5d8f75c66..f589dbff18380 100644
--- a/drivers/peci/controller/peci-aspeed.c
+++ b/drivers/peci/controller/peci-aspeed.c
@@ -526,14 +526,14 @@ static int aspeed_peci_probe(struct platform_device *pdev)
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



