Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063017;
	b=YlxRGZEQvW7K2MKfVytBWK0nt1XG82A+5eQSGRcBSylo/wGo5iyWUON+HyylNVRJ6AMs
	 Vj85Qg9j1xsv691GyLQVnOfj8DKxR7ZXUAnjuHIs0gflrAfs/G/x9Gyt8d3b9rGtCvy50
	 aOvhz3WXeuOaRvDCItf3SryagWsRjyrC5yly08DSTuKbZQLYaPt1rKMbQ0T8tH8EpU0Mz
	 mBwNPxjfxVKt9PzlmQ/Q/Ok39CMSgGGJqOTwpttbhsmfFxNlgLsy5RRC0acfN77Gw6LE7
	 dr1fYZFy87Y3L++8vXKaeGhNZUScUOXxxYoEnSP/gxkTRqOTinA+Xt+l5eV03sCmJxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZTpE4nCJAhNhl2GrmKFCxsPXSoR7cAYLGikuBcroj6w=;
	b=LYSHaZuJQMLsBpHjjFUPDSTf7P4wTZBV++jf66PFDibrhmu1PXIEHzGkgWcJ9HbDx+EI
	 /pRMZ1C9eZkUdvkr2CsmUsO71ps4YrjmwatQXb7B2gNYwbeaJneT5h/8LbxacKWQ4tSzj
	 J18clbHK8m5YtbeOvL1VBXDZPNYFroYYvboFZhJBlkUa+fFi8eUlSkUVrMrjyE2P1Lk3q
	 0wPJeqvLjazFelunWaZo5lFJPfnLn4pfNRArZCUCBD9QWtcB1UhYuHnX2APm4Mt6sR8mF
	 D37O0oZ6ZBTyYkQLzPVEX+nBilzOjJhjL4Q+1Oy+C0mEhVEvlEtDiyLlL6fc/C2yQ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kequsqkc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5387606D801;
	Sat,  7 Nov 2026 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kequsqkc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D011F0089F;
	Sat,  7 Nov 2026 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063016;
	bh=ZTpE4nCJAhNhl2GrmKFCxsPXSoR7cAYLGikuBcroj6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KequsqkcmzFfXDFjWLzEkj2qdV63lJxV7nZxQH7e2S+1Q7qUC5CYFKPl0Lal98hB6
	 Y5+0NKjeLk4CrFy3nFLmOQFp4xzs4zr12JIwWJmSiZvBQodrp9IsxvvprDOLrURXtP
	 rZR/X1Uj+xK4eYu02QiJhiHs8Q8VtsEKL3oMkJMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/869] mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral
Date: Sat,  7 Nov 2026 08:48:33 -0500
Message-ID: <20261107134859.671558589@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit dcf0e640b553d33512fbcaedb909c32ba9636a64 ]

ddata->dev is only assigned at the end of wcd934x_slim_probe(), but the
of_irq_get() error path has passed it to the error print since the
driver was added, while it is still NULL.

This used to be harmless with dev_err(), which copes with a NULL device
and was skipped on -EPROBE_DEFER. Since the switch to dev_err_probe(), a
deferred IRQ reaches device_set_deferred_probe_reason() ->
dev_driver_string(), which dereferences the NULL pointer and crashes
during probe. Use dev, which is already valid at this point.

Cc: stable@vger.kernel.org
Fixes: 0f1b1b899521 ("mfd: wcd934x: Simplify with dev_err_probe()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/mfd/20260903145651.AC1311F00ACA@smtp.kernel.org/
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260903-wcd-dma-v3-1-d3920c6563c4@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wcd934x.c b/drivers/mfd/wcd934x.c
index 7bea64fc09562..d57796933d873 100644
--- a/drivers/mfd/wcd934x.c
+++ b/drivers/mfd/wcd934x.c
@@ -229,7 +229,7 @@ static int wcd934x_slim_probe(struct slim_device *sdev)
 
 	ddata->irq = of_irq_get(np, 0);
 	if (ddata->irq < 0)
-		return dev_err_probe(ddata->dev, ddata->irq,
+		return dev_err_probe(dev, ddata->irq,
 				     "Failed to get IRQ\n");
 
 	ddata->extclk = devm_clk_get(dev, "extclk");
-- 
2.53.0



