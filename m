Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054938;
	b=vbv6gxwXHPZ8YkkBUwLjmMRGyEvUwEpexawFafoihJyKQMRYiS+gg+oxl7sjSpY0I2ur
	 IQI3Gb5l2hvHTPGnPD6wjU8z4YJB+tpr7ihJJS9bTo/h/PQmDUjpqH4kJOgtmNXR2RhQp
	 8NYN9CUtC0IE6Jr2GqnRr3bknCU62MhV4/4qwk1nhbMuxXwdOnBeCUelI2nWRZDZWkMi7
	 G/bt4ItRK/GT7mFuH3iCIif9xZl9Hequ2043F2ePbRLM633nThLUkP4douny0hK9gpelI
	 kIHKsBCi45G5DSrRk6XUwoaFPFem6fNkx53AZ4FDJ1o7I8YOGc9I5wh85S3B7g3V+7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oecAIejPYjLm1envO+kAMpCwuvgj75uRsxaYss3pFRE=;
	b=O/+OU9dTDBM4KM7xeSBFOfo5NZOmvDV/ZrG1Ny9J3yQlh2c+DOVd+nAzw+erb6qRzTAJ
	 zAeyq5VScFyA8xQFa9pHDTFFsK/MxRyDc841iX7sWSUeryJ/eJC9lUjdHXuqlrvK+aKkK
	 A0qiMuHKrXrglkHMevGhv7ww6RJt2xPpd8C0MbDtQmVx+a5oEcjrX2cePj6DJJsw5Ov+M
	 BP1C7GX3cpvYSE6Dv8PdelcJsbcasGDoEtH/cDD/OS5V54h2D5MRPSBI3fD0qK0Suks2t
	 /w+jjAhXnaeA8VsOx4EIwPy13uU0IHhlbzrqiCyc4NKERZvlmgCjSw0BHvcAgNm2YuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8LWvf4T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCDA606A320;
	Thu, 19 Nov 2026 02:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8LWvf4T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D841F000C4;
	Thu, 19 Nov 2026 02:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054938;
	bh=oecAIejPYjLm1envO+kAMpCwuvgj75uRsxaYss3pFRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8LWvf4TWS8SegGWVy5B3NTxetg/gLNT/Gmub83HuF02ob+IxpJ5emVulNeVm00Ts
	 uTf8XE6K3ozjcdUjUhl135JJwXC7W7jrfYVIUHhHpuN1vJzdz6qzvT2LmlyHB80AG2
	 fs7qUkpx5aMou8WLMkSf8fcju+nDTFRIXAU6rQlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1452/2214] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150109.167529267@linuxfoundation.org>
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
index ad336daa93447..46920c3576503 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -597,6 +597,7 @@ static int da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 
 	return 0;
-- 
2.53.0



