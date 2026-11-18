Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015969;
	b=a7qRQp2gh0KGZQefG+bS6La8YTeeRRWEHP5ORpbqWXg0pYp8AlQ1L4LdJfGTyAF/i54R
	 3q0ZlxbTStRDEI4cBBoFN0oZ/cRr8qweB1zr7Ybhk2DattvsQPzuAh2HKdFrL3iGWh9i+
	 zkQOztJ4hGZ75uBblxTg4X9JxdKALcYCkenzs2NQlB4WqxjTQ9ecSO8YYAWV/jTO5n1HU
	 OE+OEqVDzY/nWggQe2xW0fFuc7+tk8GJVFLO7Bqb89D5cosFfwWSy4YTx7r0zlfEUoUif
	 rmb9NzlIXICY5FAvMtng0PrsNhI3EBC1IaZ1zoHdvd/AHz0FWzhcV6mYbH4D97NL8zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BgO+6/Hcjs030g9oHF4a6QRV/g3/xtDr9Lp9aWW76LY=;
	b=qt8CvZ0ysB9y2r18ldkSiEUFFirXkZ4anWssN4d+VhMjZuRm1/ySTxvsqA3mBwFnfb0w
	 wIYAiXNjzfmrTd/RixouPStPoCLL0c/gPaO87PH5dPsN8xvz3jqgIBAccJwxCbkE6b1N2
	 wzh2oaC5NdmWkOn+76ndmZZ6nAuWkyyzaPKoL2chJu8IS5/mPZq3c+sTHdqWVL1deUPv4
	 G6VvoWWN3WYwATYPrMowZJE6K6obIY6zsmAr6Q6E+oxD2dJlLtOanS05VuNRACrN+VIQ+
	 oqhJ3bRux5xZX/W06r0YvSGXN1wOpB905J12SjSVL4wD5dDm8T2SH36IaSTm23OVW+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eLnC6R/k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92CB606A334;
	Wed, 18 Nov 2026 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLnC6R/k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC64B1F000C5;
	Wed, 18 Nov 2026 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015969;
	bh=BgO+6/Hcjs030g9oHF4a6QRV/g3/xtDr9Lp9aWW76LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLnC6R/kyMCI4Wcqx3mD1fcAJM3BPU65WZXNXKF/+gQux20+OYzCCXX0bnlY6c5Ah
	 BmDg+aHQipSMPLqv5HrOGTfog3mwcWWxlg8sSm7MKxJVtKPizSufWO/A2CrXqOQEe0
	 j0slexdxcLXO9eTNYKF+pUmYOYX192vDHVonBO20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0362/2651] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:26:42 +0100
Message-ID: <20261118150300.871988679@linuxfoundation.org>
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
index 4209f438ba184..7cefac2e5ef8a 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -592,6 +592,7 @@ static void da8xx_remove(struct platform_device *pdev)
 	struct da8xx_glue		*glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
+	of_platform_depopulate(&pdev->dev);
 	usb_phy_generic_unregister(glue->usb_phy);
 }
 
-- 
2.53.0



