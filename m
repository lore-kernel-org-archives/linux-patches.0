Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054941;
	b=a+4Y0iMe9Y/DtGKHWtdgCfof5NZxitidBoycZxz7QPFhh1v8LrYw0uuf2g/t9nKVFctS
	 DzLHqRW2W/z3WughnK7X625GrF/cbxu+og0mJjm/MzZdsd/P/m8+zXJ29NNfJxQDK0JbM
	 pojAaf5vWW6MC21HVXjkW2IJCE1u4V8jioi4pU6jq+KwL2nwNndJvkLJVsoJydSQ+5WL/
	 kZxI6wAAPA085eOtJvVkRKyMvpZerwFGBcP4Ok03+FG+W9P4xZICuKfA+wCQrLJHeqydi
	 SFtNJvDGTN4BRd/0QB77MRQMkRZQ6ZCoOhRWcndviYh1TIUEaP7M7YYyDlG4Mv+9g+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nx5RchxmSbKuPuRAyKEEjLqVcUHj8L7kIp1FHIYR2Kg=;
	b=JckaZDhY6HmcZu+EVmK+nX24vI+Rggxm4SQ1wMWcPOTryDVjSMm0HmtfW9ftUO8V+1qM
	 kFidxP/6FavYzyIkiGmZ2iLzg4oX/ErLdYJjUZ66LPDSGoGZhg85+uxCY+WUJS3TeBLBU
	 1PGfuq1/U/0JTWOgncfcg7DqOiXTc2kqI0bw/0/uXGJXKHV4w0cdDjQY/YGPEIDqa1yIG
	 Y0/Ro1+hETWaqe7DEOrLSxpqwD600c0eU/tFO9lpZlbj+piJt/44EB8KmUZQZFdP7fTcx
	 e3lOf0hf+gaMXTfsr9t/T02Py2v94/+yUKDSG5wOcVbZhykaxsC5fSWftTAsKSE+pig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLuFJmxb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E0B606A320;
	Thu, 19 Nov 2026 02:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BLuFJmxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D31F000C4;
	Thu, 19 Nov 2026 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054940;
	bh=Nx5RchxmSbKuPuRAyKEEjLqVcUHj8L7kIp1FHIYR2Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLuFJmxbj2ou26YEr+Bx2daUe3FdAxdhT3I2hFw/f9eUK18bVv3he8eRvaSdtfkLy
	 07I+Tg+/UR2qyQwoOEgO9ZoCrKMblwj/fLlVkqzIoMuA1AHFRgsxijWA1enCzirD4u
	 FHYHma5yAvsG/FxS1zRxwrSkY7y11Nxe/4KGoBRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1453/2214] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150109.204162321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 46920c3576503..a9e0717627abe 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -556,7 +556,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		goto err_unregister_phy;
+		goto err_depopulate;
 
 	memset(musb_resources, 0x00, sizeof(*musb_resources) *
 			ARRAY_SIZE(musb_resources));
@@ -582,12 +582,13 @@ static int da8xx_probe(struct platform_device *pdev)
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



