Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060474;
	b=nOpobdbbebU1SwE7qE6m2kWWvNni86pqXuR2lWQEBmhtgMR6srz/sKTBiz9naJXD4U99
	 EnmRu9V6b9afb/nRANSLbWRbDpMFi5EBHeEiWFES+rDv8m0udWUso6J0vkcggbuzpqcfo
	 zO2Z3arId6WFtUePvYBYVmGKys9ZrBAXoy8X8tTx2IevRhqmju1HLcHKT1eVTSWtLdRQs
	 FSelpiUgWutrhRGo7LhDX9Vk5uXwMzgNSdM8FiEo15mH+6eUtNa2aCHI1IOrgZaQZ7mt2
	 8PHXHuUI23AxCP8rnN1PRkKtkfZEwU814IrmGx6Lv/4lF78z8ZJbpBUR3TTJ5Uuliug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OL/pgwt8x4hnUeyAkWJ/sx6kwWNEuyEb23A6RW6SFzY=;
	b=i3cpsvgbAt8jm3++r0pD3U3gvd1oFTE4pep/rXCd26Is+xtr5bbeu0u2q76X0YK8TnOK
	 o9HG1OepcKuzxds1ZXeMGGuKvdN0CNBCqWxIUfPhl5PCo/cWl3bH7XGq/gasADZ20kQWY
	 lQe/rOqvzpveEDd8cQ+lgfohb4sZ5rt0bYH61LfFz+U1MP7vu0W0lqj9r4wL/Eg2FS3PB
	 qxvQKRPg4sb0AnaUNW6JTJ7iS9RBeYSWno0LT6F+AK0ZzC6xYoG485/MuzAP36viLuANN
	 KrP1Khac/CdDWdfj2Zb+rrp6pDxwSMqXb8ULGqqOlGdvR6TaCdkn+RnQ2+nvHuQCJCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A5QHIQF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76B606A325;
	Thu, 19 Nov 2026 03:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5QHIQF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B31F000C4;
	Thu, 19 Nov 2026 03:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060474;
	bh=OL/pgwt8x4hnUeyAkWJ/sx6kwWNEuyEb23A6RW6SFzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5QHIQF/kIHc9h0RgcYmUfqdHRywrGrq4dhcX93vRZM36MFZpCAy8FWv/PH/fxQSp
	 H9gYU0sooATDEehGtF4SV9ord/0J1RCcOG9hRTR2aoqscGEOxXS55xJ3kVB7x5Q7Sr
	 0i8RZNDtW49g5E5DfwEiazUDs/xJ8oUwJkbR0RrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1213/1848] usb: musb: da8xx: depopulate OF children on remove
Date: Wed, 18 Nov 2026 15:54:11 +0100
Message-ID: <20261118150010.770101544@linuxfoundation.org>
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



