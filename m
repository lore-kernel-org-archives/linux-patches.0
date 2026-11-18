Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039571;
	b=3fkQIZCreWejZX2kdUDRQvQ8O4aOy35YtYzv/apatBeG2kYJyiiXJ0B1QXRyLtff8DQR
	 a9mbfHL+2cD2whJxEYLfb14ZhIqyUkfqVl1KXA4nJOSR18wMhfSwUoDk3ZvjKs/aZsScw
	 OBPoBttZPe4pWXay4nX5eDAP714FIxTR5cPYi8omnZnvt2zi96dKOGOKxWj8GhUNojjBU
	 OJM3VbequVXUf3VHqgCcQlNtjpJgn4uJYel8ohICQaVwmvgBNESgazSK9kEg8eNi7WU5t
	 wpSJx8xfmLS8dl8lr1qiIS/SaP6sRNwcNPJU4jOdc+TmOtlhCcz7EH7EMJUitaYxyAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9HLAtE2PH3NVMvFMZ4pvxAw4IyUiw2syi8WfM3qg9U=;
	b=caKL7KFqTwgel3DK7s8jl1sC7h4oY2Cui1LbHsUUMokO/Hvir6W/vPwsT578ECDYDwI/
	 qJKGsNdNFrviGiaebFtbX6bYlmLxBqssvL911si9xx7F71Nf3QIBDqZOSpF9mZK+6JLF2
	 dut5t4GKhqoda3E372h1ps2pNn9XgUgiH7V5ERTVGXTkPmB7dPnDaqUjgmIeQwQ/62rPI
	 xJpxtUb1jCGkP1PNYt4snbV0UMZxPYHXB3cB2xPcgNvoeSi9mAC9i87rHY1iyjUWmkUlE
	 R1cIjiQVDWGmpDQGihr4UWCDIKTLz24M/0LEZY4a7LFd8fb6johzKpgrEq2MQ4U8+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAiegc30;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA44606A320;
	Wed, 18 Nov 2026 22:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DAiegc30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21CA1F000C4;
	Wed, 18 Nov 2026 22:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039571;
	bh=s9HLAtE2PH3NVMvFMZ4pvxAw4IyUiw2syi8WfM3qg9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAiegc308FyivZwQs9rM2YkqvcpXdAQ0B6RrQfXrES2u55Qg9TMQ3HXiTUpjC9xTL
	 pCuCfZIsCOYZQ60+t4nYsVBpK68JmDle0/g0Vb76u4P/nBuxIudk/43W1cEwxpS42f
	 fRzd7Nh+d0OrpOv3njKwHbNCVqa/iv3BUhU66dBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2149/3318] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118150426.509597552@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8d70a378e702141424e27e0b8341e421f058635d ]

da8xx_probe() creates the CPPI child devices before registering the MUSB
platform device. If population partially succeeds or the later MUSB
registration fails, the probe path unregisters the generic PHY but leaves
the OF children registered under a parent whose probe failed.

Depopulate the OF children before unregistering the PHY on both failure
paths. Use one cleanup label so each resource is unwound in reverse
publication order without introducing an unused label.

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260813153230.40421-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/da8xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 78945b86c4082..3f5746f89405d 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -555,7 +555,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		goto err_unregister_phy;
+		goto err_depopulate;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -570,12 +570,13 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = PTR_ERR_OR_ZERO(glue->musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		goto err_unregister_phy;
+		goto err_depopulate;
 	}
 
 	return 0;
 
-err_unregister_phy:
+err_depopulate:
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 	return ret;
 }
-- 
2.53.0



