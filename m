Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015972;
	b=Mik59AhVCQL2k1Pb1t9Bu/VqgkMqAMMze52/6eWyAgacf5lvSNf0DojaZqibU1dvSiWx
	 otYlde7IF/iR2sdyBFafhBYz/G97RY1MXt/EQp+e+OKp51g4WpeTqHCo773UUZ15sj96a
	 PDsP5FbYcCS1i7VamLj4UbyaZxUJJBoJHzLe8MWbr0MclG+z7rPx168lTANMRRRiivVKZ
	 ai2y1pGaUGRPR00vEWMNV+Rk4YtRPOhEEEjwCMP0URjamI9BaPON3dvpUmppglZ9pPu2L
	 fCV/jQ9gXehmNAxui3uibqQmiX7YaEv8HJOzXloaxvgIUXESjVgcPtrUjzl8pvd6Fjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yX4p6FZsA2JQWyks84TNOpcRC6BDj1lt7ynqbtl7rRE=;
	b=nMnXG+8WqmogYWzj/VWyHAC2i4EXa5ZiPgOLOjjccOoij8iMdMovPbIPYkYBHdE2sv/O
	 O4AMYoWLj94O5Zn7Q1/D1IreC4Hp3EWIF+nUt//ucDlJ5T4S7BHHHQ2csk4ie/WNsBoOB
	 sC6Yu5F0jeuGgiurxhR9wmvN1fC44AUREPnHyOkt3J+f6psUBv8zPmzRtjnbDQF3JxRqg
	 OLihMWX2BVA9SBGDm+gHwgAStlQQJQSLFOoWTe2YDESjl3eWhqKbFc0ak0pwcCOAlT+pM
	 E3AYcHCGTlQewPEzqxxMjEQWHyylzPSSTkGSCH/ptf1hjGXB/JHT9rpLeNReetq6/Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOhwEZHW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5C9606A337;
	Wed, 18 Nov 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KOhwEZHW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938161F000C4;
	Wed, 18 Nov 2026 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015972;
	bh=yX4p6FZsA2JQWyks84TNOpcRC6BDj1lt7ynqbtl7rRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOhwEZHWl9VJwOck0w1/NVFZMoGXE9gH2ZK/3lSyatr2UvI/kH9CZ+SeCrPhBSZSg
	 VUPpt/ercVVWzPj8hR6Q06e2YwjUAlxCZmACaiCs3eFR9SAVsIWFg1c1f0OGfEOZVK
	 ox9Y+IbTFXTfnMNIXWyHDNIgUruTIqr9NID1unEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0363/2651] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:26:43 +0100
Message-ID: <20261118150300.907548643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 7cefac2e5ef8a..6c859a1a11d04 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -562,7 +562,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		goto err_unregister_phy;
+		goto err_depopulate;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -577,12 +577,13 @@ static int da8xx_probe(struct platform_device *pdev)
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



