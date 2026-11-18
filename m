Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029386;
	b=nfVL28HXBCtTf1LSRXNCOJcguDZl1/iRl+E7L0vbTLlfh1zeIY1z3IKqnSIpBkek6JYU
	 1qv1NZLc9luMAKJlUcYOU6m0qo6i3NtE8GP9UnFeNxJrPquIRY8u0vD0MYhS3okG8EdtH
	 B5u/Xb0572UeiqaAOVFT3WygqI3NUht9lYwZGUin4na18MJXffrPnJRQZe58VaR6fQ3x5
	 mJHN0Qd7Hhp26GYbpHCtoXU2k9iyf7wmvnwcHDjelOnsYE5GbL9j50LsJ2slAXaw/Paoi
	 lUYMO0NZCNRNUA3XDCKz3Ee31izWlN3AUkqnANk7lA14I8oNHT7WK/YwxkOb5jvjkqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZBX3HGC7bUCoAk3+n2VIgXnzGGsPXDasxc88oMI140=;
	b=Ql0EoZK6fzhQNVNHU80iL2NR6xEvys1ZuPrw21SjAFmbqdLLah7SLE1CsL+JYBK1pfXF
	 0QGn/Pf7VVAJ5omMPg6dNE/DR1BgbE5IHEohyQjcT7Ur/alaWOXnD/URjzJh9KCFRfIUe
	 +e4LcfEkXFdRyrHSvjt5clO/pJNSp63ZP66hlFQRO4ZMRRQ9RJm4QK/eigQF+mcCF9vSg
	 6Eba/LSvnsgdF/CBL/8FaNxhnIKQZ6zSQWp2tnv57NdxAmwtjpbDKonvZ2coRxWA25xMf
	 VBsb3j9iIpr3h0FyzfwkfIh41DKqybrR+Gey+pz/WQYrzRaKidBtehrJuuLano3MhqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfmqIGL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9A606A320;
	Wed, 18 Nov 2026 19:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfmqIGL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D091F000C4;
	Wed, 18 Nov 2026 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029386;
	bh=LZBX3HGC7bUCoAk3+n2VIgXnzGGsPXDasxc88oMI140=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfmqIGL91gnV0qho6U8tuPA6zlRqTi/MWnCkLyin7IY5182ii+04VG1dUqIhQJKtY
	 nDqKQ5bTohdVyr5SmHKObYGMP1dGP0HF4tLmiNsL3LLNh8J5kDBxCCR+RXVYlA0RHI
	 WBfXWz9PnN94NGjgwPpcRQNu+sZfUf1t1bMYxk5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0332/1756] usb: musb: da8xx: depopulate OF children on probe failure
Date: Wed, 18 Nov 2026 15:40:59 +0100
Message-ID: <20261118150021.473435760@linuxfoundation.org>
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
index 7bc1f935be296..f410015567999 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -560,7 +560,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		goto err_unregister_phy;
+		goto err_depopulate;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -575,12 +575,13 @@ static int da8xx_probe(struct platform_device *pdev)
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



