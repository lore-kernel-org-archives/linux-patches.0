Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036126;
	b=FUkCR058EQlaYhLNeX3kw1XJsbDA78Jjq67gEc+sCgFwazsyw1+BBxc/KTAC2sW0o8eQ
	 abtM0TiMIJaxMGssMN94yuNgmTFNRk8WeZV6HnM0uE0kmuNUIWADyL1+DlXcwFh15sb8u
	 6zZBdO1i8HCbWIn2wpE1VTqnUEnWu+2qMcTKodSiDd+xdBtqD125Iev3fzRFhrxeujHmK
	 DgXzcCXfYNyxB0zbTTdOl627sCpp9ZOB8e2LEI3+vUVLg2D8kuzivYhG7pMzQjwI9lOeD
	 Y3fRL3xi8v0eESr1ol47MQ0rWMp7dOyfcwsc/GLrmXcTjOsl8LW/F8m9bMrAcwo8t9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eKndIIW5jwR/mtCYcFkfNcQ3hUwa4sQjX0gdfGoc3a4=;
	b=W/o48hwrNCkushEq+uQBBh5Ep/Eh469St7ANPwcxa5es4u4MviOjzW8oSdj9LEqDbDSs
	 LSJRKmVAhOC8FGwL5Mx3CckyYkCck9b3e6rkzBk0X/pZmYHPiRbKOtnay0MPmzi8zUb90
	 ITonun+vqNvusTitZYNY05jtYFjN3j60Uh8RGBA3dz1tD0yPahAvgxZWe/36o/IdAhHu0
	 C7e+3kmhrxGOzO7n81YIwsLy5lJeDSgmYnTbIi3d7AOdTs8LZrPw/WrRz8Fq+MUpXBiq2
	 MbWXIEFlp6K7JYlcajEkXj+QZ6rwX011PAJoqeWEoeUCS17tGLvHzTFLrnZRHQ76c9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zl9mC+g+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000EC606A320;
	Wed, 18 Nov 2026 21:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zl9mC+g+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A73C1F000C4;
	Wed, 18 Nov 2026 21:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036125;
	bh=eKndIIW5jwR/mtCYcFkfNcQ3hUwa4sQjX0gdfGoc3a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zl9mC+g+n9q2GC1/4Y0Mfm9eHlJZ52Tiv/5Il6G5B7cNEq4bBFQ19Nf4KYuD2fXnE
	 NqQYGE0G+Rhe0ScOvd3UpV5t2Qlrsh8C7kfVn54lCpwtK2QDNv19ZRea0+ek/BJRlh
	 Qve1rrHYplYk2LQhnk0kCYiM5V75AldmhcvUC9Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0948/3318] peci: aspeed: Initialize state before requesting IRQ
Date: Wed, 18 Nov 2026 15:26:10 +0100
Message-ID: <20261118150348.045945024@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7fdc25afcf2f4..26a94fa2a5e7d 100644
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



