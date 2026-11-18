Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023409;
	b=2lPZZMT1ksozmjEATRuL/1/eo4E9plaAOk/2cu7NhC04KEKgUaXfufsQ4gliR9xrgvW5
	 lkC8Qnqqa5JMCnYyDBoMTf+WtcWUX00alpWe5TsDDDuOYIisO6tQRGfcb5P2HPsSbo7pW
	 bSEmAq3zfbxQNTmA0lRpUpQCE41gs/XqZOrkRZLgvA6V9I4XJIygOaQea6S6Heq5hLXxq
	 FCxQRw6r2z7emB8JLoRXCPaPd4VvEyy0PCMRRkGi9Ny9xLHSopRO4ZwjqIzO8HeILPHRz
	 BFN6BILpalB4NNiwjqaO3mNlNfPBzI6aF7K3t0jZhhZ5XF9z8uiR6qaczHzO7pK3Qbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMnYS8L27XwpzD/HBqj1bO67sG56Jj+4c4tugff5bcs=;
	b=irUC3m9H4N0eltm8T6+4Z9twIISv1ezlVWhKi8rx+5K0Uq1W6XM9Apc45H0p8TYjHKvS
	 azjFVrDbMjpNJPmnF7TFnnZUKdEZSE6Pbgyj/ggpWMZZUmCL5z1dpy+xp8/7lRxUYyW+6
	 Oir0VlmHAg5X6Qg1peEt5oSbEi7vqmu80rWBvd11H806cirqdWBIRWDPd2yxEE/NUltb1
	 VXi8EYu9wSwT5Kv4XQ6N/OGOcEW5stmPqlCEZZxBv+4IEyvjDIKg9XVK178tEdRqaFCr3
	 LZjfxA/Ne581poK7+YIMjvWxaN9Tsky6QrSGPYpyJXVcpItrfoZZ/04Fv0KXEOzSe3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8bGqBsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59F8606CA44;
	Wed, 18 Nov 2026 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8bGqBsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BC81F000C4;
	Wed, 18 Nov 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023409;
	bh=UMnYS8L27XwpzD/HBqj1bO67sG56Jj+4c4tugff5bcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8bGqBsJJKfsih/IP3c92ZWIWmeH6nonWk8+Z7pHCY8c3PN8h5Qx258qGIXDHlN50
	 JR48iX97XyJP/MrBnE/64m43IFVSdbJ9kKLeZ0FBWcy/nxsly5kIXVKx/WBcrJBKFU
	 li9nxUn/yRTGdHZCS70OmRvlk5dt8ctrz7RHgny8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0359/2151] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:34:54 +0100
Message-ID: <20261118150135.183567695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



