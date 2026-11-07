Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064170;
	b=WGxHhpxsXQ/3pkY1N8XYoQhCgVEMBes4f20sDf+Bu73N+QrL9AhnVXT4jo7cNIZqND/X
	 0ejsRZY5cZg/JDbElUBjXXgx2GDCzDYGcCb7cCHm/ARN76cFy91vR9tJUfiMEa/39vb6O
	 h7E9PZkMjd9woF8Dqz23xcIS+JMhUvR53mwGNmV3OvsvpjjWb2SJlMkq7InldPyF2S1Ik
	 gv+w5CP0Ug6ymiGxTRGd6aB9TGSsEM+hU+evLQEeVVZbO6qSh42mB0foCfNLTLa52C5cj
	 2wvPkSsODk8i/Kg1qR1cK+GMuizPTxLeWrGL8eetl3dCxbeKtUSOsOmKFmPXclb7qFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Lj8pGhKqbtrBn4FNultazCePcE1YsxV/Y3yOfH3zxQ=;
	b=JRTIQ6mZWf5SVjupHBg8gA4iRJo6zDYEO2drWJ/nI24j8EAi1m/BbTJ+k8xPZ/+Z3reb
	 NFcl2gp231fOuT/9roekfOEoUMThX5+94sE8JC+a5YKVMZRb5QRvmtVGvUVQ2jU/GZg7E
	 8i22LfydGgoZYi2NKiSt1ROxcZ9fvfYDTRij39JOovTVNM649xtWLuT5yyBwzAEQXEN61
	 cBELu8QM57San7hIpnSR9LZYz/XaoDviMSWKVVuiwCfIWyPj4OcbnJGfmCFrb94uqeMYg
	 s7Z5FPGnInRhhvFqFl10SENuGHY8f/cKMxCx6nuTnyKv0M/JcjzFJtu+vmHm6q0HBiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCMUxi+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A538A606A32E;
	Sat,  7 Nov 2026 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GCMUxi+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D81F0089F;
	Sat,  7 Nov 2026 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064170;
	bh=1Lj8pGhKqbtrBn4FNultazCePcE1YsxV/Y3yOfH3zxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCMUxi+ajWbKH4o9t1l66NhHW85UEP4cE+Uj2FKByR8RIFDCtizHTsTcxq88GyWAe
	 N+EgL/DruOAuGo9Htmi3NfzcBopYaUDqme1/sCBmJVoMfkbKUPfOrpukj38PKpV8NJ
	 byBKS2OGMbzOOoTCga7LVgw1XF7b07ZpFmTt7X2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0316/1257] peci: npcm: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:43:32 -0500
Message-ID: <20261107134948.161021543@linuxfoundation.org>
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

[ Upstream commit 425125e6d408b5969afb99c3e95a391f1f1ad81d ]

The PECI interrupt handler uses the lock and completion object as soon as
the interrupt is delivered. Initialize both before registering the
handler so an early interrupt cannot access uninitialized state.

Fixes: 3e16184a1bd8 ("peci: Add peci-npcm controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20260902152256.3591658-1-runyu.xiao@seu.edu.cn
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-npcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/peci/controller/peci-npcm.c b/drivers/peci/controller/peci-npcm.c
index 9318689912412..3cc4e959aff36 100644
--- a/drivers/peci/controller/peci-npcm.c
+++ b/drivers/peci/controller/peci-npcm.c
@@ -253,14 +253,14 @@ static int npcm_peci_probe(struct platform_device *pdev)
 	if (priv->irq < 0)
 		return priv->irq;
 
+	init_completion(&priv->xfer_complete);
+	spin_lock_init(&priv->lock);
+
 	ret = devm_request_irq(&pdev->dev, priv->irq, npcm_peci_irq_handler,
 			       0, "peci-npcm-irq", priv);
 	if (ret)
 		return ret;
 
-	init_completion(&priv->xfer_complete);
-	spin_lock_init(&priv->lock);
-
 	ret = npcm_peci_init_ctrl(priv);
 	if (ret)
 		return ret;
-- 
2.53.0



