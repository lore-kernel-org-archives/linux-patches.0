Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029382;
	b=p0SdQCRV2IwhAAmLnq12qNasGo9gAv7GlrxjkkKW6saBrrOBh02KbiSSySd6B776Gdtu
	 chB5AJfdDSU1kyQh7/hTBi4/jDGjlg1Ydz7KX+Zzcldex9C8fSewe5GGnwiuwl3++KkZS
	 JwJGvzcQAY4nLHGQ0NoHCoTeAw0wvVsCVjbl+EyxQczvo9QDpsskV+PBhV8GlxpGSLYrR
	 4b+gMB9L2mWYomwHIh9de7fUNDQpqPqSdTBXg9t2bpobPj4jnJJ3+meVefxITZ3nbylk/
	 XQslcjF7Z4OnxOoioYo411t8B5UXCvhnc/bF28VSRSRsmh7XgKY1qg8ExNO97kYjD0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1rkjsu3ydyw87biDChHOleJ4aCxmHLuBgFpnCFDcb4=;
	b=WD3YxIZp/LQlQFW4TP8T3+NDDD9rEf+ZxmrICGYIdwLl8p0jCrt9OKcYvqESJfxR02lm
	 mxgv/HpC7N2F+1e+E272CBeMYjGxXfFtR+ABBSaatQS5VraeMDxsZuev5PsxbopQ/PVRU
	 zw3TpMsxDCapOngRdO/nRppTf0N0brHHhW6iB3YZnxC2G+0XW8NamzLQm7dhFSbXS9jvc
	 DxewtrsPWJqRIpTFn7uOdQM1aNVLm/BXqzlSSLIRxdwTTNBjJ5BBK7BXyzcw3ztK988Vn
	 0H6HDUzUzX21bGFELeC70ks0Rz8BDETssUjQstQlrz0zxJWHfV65a/GU2lcNSm/CNug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr2J7yBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D817606A31C;
	Wed, 18 Nov 2026 19:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vr2J7yBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF551F000C6;
	Wed, 18 Nov 2026 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029382;
	bh=+1rkjsu3ydyw87biDChHOleJ4aCxmHLuBgFpnCFDcb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vr2J7yBO7KF9jcLcxiCJHrxJ8hnbKmI0/OMX9mVmBPcVd68oIkKDKHMQBcdnapLUZ
	 xp8oFrS39iSz4qD1wmGTxCH83geDVAFUgmB4pb93LGzLPIh9HUMd0Eh0mlLFCKuzDN
	 D8GR4A/46skFmgE4uLch4ahFKtNJKbVqjJiEphYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0331/1756] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:40:58 +0100
Message-ID: <20261118150021.433144596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 953094c1930c8..7bc1f935be296 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -590,6 +590,7 @@ static void da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 }
 
-- 
2.53.0



