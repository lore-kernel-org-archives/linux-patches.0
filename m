Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060480;
	b=dqGXekxINPWEbjwnM+ncXAhdDnl5DGVHzgTnsijLLfbdCr0tymEZXVkMLNyVtvLnc0V6
	 x2sPYiq8z3Ol5IejzFlvA9JQZV8gB+qKUR6Z+N1AgnvhplJLaXW2i7vuNAeAy6sYFb3v+
	 V7dGheMtNiCazEROu7nSH3+MCXmAHe7ds48jq5H+OLICv/Katown36MOdzAyIKI9J/K9D
	 PYpUaKylvyPFgyJmDCzna0Dx9UYXjbQpJc7RavR/wu7RGMRskDeV6e7tU5/I4CER18c42
	 jc9Xb+PRLQ0ElJsE769qogwNXOmzCD5HeR2NR3EtoE4U1EdEm6wlCe4CxQIrhm1n4vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rEXMxFFdnH7hj8LZpti/IaLJfk7z0mGUOeW+9U4PUnE=;
	b=FVEJK+ICDKJovpuwpNQPRuxAkzGHQzz4K7923qY8Jaox81pdFzoLn+tWzV0bOJDppx1y
	 uJCi8BTSelvxBsvymJy2NnZgRHhzRWfoe41LxicI0BlZQpEQcQilOe8Y7OraYIaSqGSw9
	 SHOVV3835zTAUqycFWzR8ogFMEWPYZXjWrPlX4jTtIzBQfXe4c1W2PH+OY8PqikHm7UCw
	 zhiuxe08i7Hal3xStB0+43a8UZwAvjYEjdHw9c8Gkv/rHMTLOS8t4SS+bLsQhL6LwmID+
	 O0Unf/LklrdSUXgX+nbXekBezHVhdksNdCDEETue6XEGjQxUVy+4RMK3vahuTkluotg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdpoXmFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F0B606A334;
	Thu, 19 Nov 2026 03:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdpoXmFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C721F000C8;
	Thu, 19 Nov 2026 03:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060480;
	bh=rEXMxFFdnH7hj8LZpti/IaLJfk7z0mGUOeW+9U4PUnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdpoXmFEmWhddDG0bm4vsk3wIZhYYwD4LgERkTYm5vNcehkUC3wey4uOxS+VDB+2D
	 l6lp4UKECQBEtzpI22C6MaYpWW2HO2dWc19Z3qjH9xyX5XAi1UflJxnggrzJZrOIB5
	 rSWTTelzTJpoGk94VkfUTbdiKNGQbOZauA0TR/Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1214/1848] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:54:12 +0100
Message-ID: <20261118150010.807252433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



