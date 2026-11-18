Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039568;
	b=w8PwzjVY+zr3eJ6ztS7Qjnhl7OOS5bGzEW8m5Y/n1PnivLHpW1qMLB6NWrYC1WzXR4f9
	 gJmK/iUS4W2UJscgoznJdihUrbdG4hSExuloTboSeawROMsa9NyfFbfeu0sPPXK8joZqg
	 K5j+oG0CnaxnlFASFmseLhB4XNNOy1iOluRaxUM6jOLYJ8NIFOyoyXM//saG6xGPeaCvB
	 EQ8lapKbgXvrWIXC0IXOsAW8dWxX2iWuGntGKWYc4owUoqWB1jVrHo8gsiCtSTcbZ12Mv
	 P3qpGGOKMW6Xj0zpe/Qh7Nz1JDN/XGy3LMVUaIBgEb1CSso/EjChdrw4gQb4Lns3Pnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l5DBtCT9pFS66jcsKsKtFVDCeETSMm5NCNR3xibho50=;
	b=BYyAlHMDqqhcHouQFzXvrAzUGZwLDUc643KpW0dYScLA7PZfLGZV03Lrdkjwu3kI72IA
	 FDWNkNFVpOdQV8PNi+KY35drb5XG2qNaOc+kYVgzHlzVK/9JDxaer608pi8BOof5jEV7A
	 TKWiTVHFb2suFb5PKIKBjoXOHdCa++y19nELyX1M/JMTTF+kNn9z1F0i1icDlgAWgxK0v
	 RSrIkbyjvyOaOuUnwH1gsPux1OdNaGP8ZgpruGPJpmtTtj/xnE0K4DX37aZRctxbbNq8r
	 LY1FyPuKVW0Fo6BTsHe8EfB5hYdH7qzZRSZw2FXjH7EoH/+uHtNPUMLtc7A94g/vZZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Fjeh7Lg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB4D606A31C;
	Wed, 18 Nov 2026 22:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Fjeh7Lg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2C51F000C4;
	Wed, 18 Nov 2026 22:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039568;
	bh=l5DBtCT9pFS66jcsKsKtFVDCeETSMm5NCNR3xibho50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Fjeh7LgSThgFf0DOcLbnf6CecUTPDmIOaeQW/D2+ZKeeFTXjC5gmF6FZ16YYCuSt
	 ZpM2L1+/c6vvDpXGDQ4zPyr9Yejay/9EK4u9fjydAc6kKi3DTgj8wffh+gOJ+MhVLz
	 zZjAFLNd/Eo/HwxX0lDCSosi3Y29srECtKXRiF5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2148/3318] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:46:10 +0100
Message-ID: <20261118150426.482100701@linuxfoundation.org>
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

[ Upstream commit 4b30c89fb36924983be652bb24fc49e20390bf27 ]

da8xx_probe() creates CPPI platform devices with of_platform_populate(),
but da8xx_remove() unregisters only the separately created MUSB device and
the generic PHY. The OF children therefore remain registered after the
glue driver is unbound.

Pair the successful population with of_platform_depopulate() during remove.
Unregister the MUSB device first because it reuses the parent DT node but
was not created by of_platform_populate().

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260813153353.42817-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/da8xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index a8d7224838cf6..78945b86c4082 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -585,6 +585,7 @@ static void da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 }
 
-- 
2.53.0



