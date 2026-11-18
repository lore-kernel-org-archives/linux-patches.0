Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048104;
	b=S6v0jnVM0sw1ek9RbWnesMG+G85wll3dqdrhQk7dhA8Kzl5RwFBs68jAbjvp+XntaZcj
	 XKCGYldNqPkg6envA2WRIv1PVz8KR6vVcu+CMUnWbNKiw25spLZt63EmVZYfmAzrfQcp/
	 RjpvR2cFUtV6RUZb9cINMjQMqz0pQHuTH+gh8epZUckyYk5xSGVF2NZnNadNtlCK5iOKs
	 YhNaJqGO1Bx2/RdoM5B1c9fZlQsTJdESFL5w9+DOvCl/Mn3yG7aHvH2+yQUSNCQGWYjgV
	 sT1wRrkDpKEtTklzodGWDtRQXY72ezrPc1hURVHT22aiPEOJ9wuwELsvzFFGzJRo5+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LLZlp20+qFSwhYynSFnVhouE+ZZ1Gl2KMOxbYC5pUjk=;
	b=VTIkMtyL50HrutYQzWPbqgHLvt4dDEFtRpaQCSxFqKJgeZV9ufRFA09CI5ypfz8SNI1u
	 Sd8V7JKU0CCIOo3cU9+3AWq2bQ8haHuoyIERUJHWFjUx+h66fCreiT/gyDj4Yd7VsHcDd
	 Oz3/puIzV3HDyRkRCUbBXYOb8ZWRRfhOa+YA1ylBz8RyuvYBPHWh8jrHmxGNMrZoO7oJj
	 6VM8Y62zAawPEVIVyTcvbr2IS/JQsKWEgxYm+yQHyR5agXZ7OAdCkEjwvbKww4lNPyMBa
	 +40q/SiO1PzXe1GdutgtZ4YB+16uXT7Fo4K4VSAvYbELsTHN8iKntfc3BeTkZJAd/7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4xR3bFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01EB606A320;
	Thu, 19 Nov 2026 00:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C4xR3bFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A31F000C5;
	Thu, 19 Nov 2026 00:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048104;
	bh=LLZlp20+qFSwhYynSFnVhouE+ZZ1Gl2KMOxbYC5pUjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4xR3bFlYwSdBJ+ifLAe74rTP5dSlnoWt1STuA2CRbkATf9GBAZuEHj5yd+l0BW4e
	 q+tZ75AG5siTCYESdyeNx+tdTcYMo9qZpc6Xwjf3DlfYPGQpwfY1usDMyW5+HMvg+s
	 8sYMDWBrxLiSfCwxSTi/34RFwK8ONuYMQ8thWa+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1876/2857] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150308.778781003@linuxfoundation.org>
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
index 2628e056d319e..f01a43fd16522 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -553,7 +553,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		goto err_unregister_phy;
+		goto err_depopulate;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -568,12 +568,13 @@ static int da8xx_probe(struct platform_device *pdev)
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



