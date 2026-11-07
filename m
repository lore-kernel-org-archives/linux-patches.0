Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064170;
	b=nOyYsff6Yvk5pP0nZl5iZ09gH8FQOB6n33svuyXlHDSHxW4McngyrsTeNuwoR55ULlgV
	 s02gzJ436kSsy41+Dz2MOITH/iWW5DgFW1COnkJ25mR6ZEQg8hvDT5oWMCM83J/zLueTf
	 1BiLDuu+oUXjM9cPs4pl9dB5pQYZT4sY2HUAvhBgbp4eLx8n1ha15U+w96bUcHjSTX5mv
	 qQjQN7C8qM1JrXfPd2Z2iyvsN9zx78BYWmlZxGnxQy80AB00GEwdHQ7EPmd3ZA6PNjNL0
	 F34kKOGB3TLPuVE0JhAxpH896CfINyXnOHcfZfEqqP6KlbkkDdEUo8vaZ6r38Zrl1BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0+Zq1Wn3AFlpagzx34OeE7++hTwdC9xrVeAeyrGLuYQ=;
	b=i8+H8d5DkaFzYfdWFAokXpnRFAw3KM0zINU+yAlcfKi+DMB2tG8borfBKn/4ApNJyPD/
	 siT5akPu9/Q1GbQ9R7tVCP8BFvUgzgOdoYekOFLnAXQ2htlD3Y0cL57MY78IFBh/nQ43P
	 ycTD/pVPHukpMhjLnZ1kitltaYPuktVlokM1S876kvKPFgvvEzyP4otor/OfM4mIf2LVB
	 kF8Ejj5ttyMbO8rN1xBFa94bWbe8WWOqC+cMnBI3Ep8OCx4wQEiy1USzRun02S9DmKfSs
	 lsHzP0npEo6jgC8jz9I6rFWkSMNplDnX1JNBgoaN3fK5qHmd6yX1+mT9b6MpYFS+dQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNQkoJTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD86606E8DF;
	Sat,  7 Nov 2026 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNQkoJTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A621F008A2;
	Sat,  7 Nov 2026 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064169;
	bh=0+Zq1Wn3AFlpagzx34OeE7++hTwdC9xrVeAeyrGLuYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNQkoJTFQeAaQme6b7sMTMhLjNSQuGrG+joRfK3dPmOsRl5dOuMjE+7ph5x4m6Si6
	 XTLBYx4Qxicmu1UmnlPBV/d4irt04M3FxwYDoOpfz7vLT5sAWnrGDM8oRT7yCvXMBi
	 /elmJRactOg1ls/XF8ImClkcD0J6UYiBII/9Cgyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0315/1257] peci: aspeed: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:43:31 -0500
Message-ID: <20261107134948.135473476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a0c99ecf7f380..5d7f4f8fda731 100644
--- a/drivers/peci/controller/peci-aspeed.c
+++ b/drivers/peci/controller/peci-aspeed.c
@@ -529,14 +529,14 @@ static int aspeed_peci_probe(struct platform_device *pdev)
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



