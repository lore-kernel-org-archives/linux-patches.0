Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062153;
	b=MwWGl+O9OlaAmf4GvLBQFrGcvnFkVORbKZUZnsoCLPBCYxtNUK6LQSLYFDIYE0gR+Sp5
	 lMrRqoMqJ70K1617J2msxu51mGezQtskvfATdJcMtWpRgVJ554s1KCdRKrJ6JO3i2FbaJ
	 pETP/tceQlIvEB8plE/VAvseVsnLFRhV10VNLJtPvnOKK77EMLYjIxDSQ0NFdrjo6RcAd
	 LS9G55+o9yp7kfFjCIxrFdcmgYXRV3txq2NmZHp3BvPIU79KXlmsdFypF2pHwpN7e/0D8
	 3ZWp2bjSTPTkabjF2NbBwYFzzwccFTI0zvSTs/IoSKc7PgDAHhgQWxzYy8h0QSxus3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rwkw4LoZaSx9FiY1KzaQTMySLZI7n1PE4mEDnjl0ipA=;
	b=KdtgLY/M9AqrSO8eiNUF6EiiEtiMtvBQuCvOHWe55xvKOIqC6iRjuot2LlKSjFguhKbi
	 MUSyOlwdPLPCbwHFB+0sYhCPQs16hEovJV2TnwEFoEjBWT15oNFzQ/J9peZhAfntm9gAV
	 IhW2PSdgsFTyO9sv/jVgKzuuAh+y48PJ4Wehp0ZmfUu5N6SDRKleRC9tyBwJy3rLNLQ/3
	 M5rbLbw0gcwNQhh9rlD4j7mINkw5298fUcs6eppp8ur57dMTbezlYfOMe8abM4zsLcOFf
	 f8m++Jgcx0KI1dkg7UVq+dFUGnHghJQJgQVE8sJnU/NOTOFVQO1KSgaD5EKhWksB6Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEPfXbNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350AA606A66A;
	Sat,  7 Nov 2026 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEPfXbNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58321F008A2;
	Sat,  7 Nov 2026 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062153;
	bh=Rwkw4LoZaSx9FiY1KzaQTMySLZI7n1PE4mEDnjl0ipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEPfXbNi2Zvj7fnAGrpGN/8ZGRPF965EBVw26N7TsbGeO4P9rr9JJKoHHIvpyX8/w
	 W0FXjCAAs+dykAs5yJ5PLjOP84UxtlsYvS+S4a6T2tlW1TacEcMRkK0R/Vz9PUcAOf
	 vQe5dFLwinFyrbxhM9EJFJly4SiNJWcWpY/VTjNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1079/1536] peci: npcm: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:51:35 -0500
Message-ID: <20261107135027.998455839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ec613d35c7962..d0442c9306a86 100644
--- a/drivers/peci/controller/peci-npcm.c
+++ b/drivers/peci/controller/peci-npcm.c
@@ -254,14 +254,14 @@ static int npcm_peci_probe(struct platform_device *pdev)
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



