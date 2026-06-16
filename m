Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82423A5E91;
	Tue, 16 Jun 2026 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630281; cv=none; b=J3MRleNruUtTDH5Fqr+0qNqiFrOTElN2ytv142uHNs4n3X247i3lPXW4qlEtnWpTgIE+ldi+aaA6V1YNHb/m0t0UyCKEiia7Q1EXi4xiO2fsuanrOZGgW4lbk2p8Zsj797G65ASYvNK6aLypBf2BTwP0J2H0u5oHcu8OdRca1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630281; c=relaxed/simple;
	bh=W6N3lHffJu3R/UekuC5k9mCDQduYsfO+eHFkYA46KL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMHg6wMBly5Gw6tdHaVQmHuKMLaCMnPztE73WFAwB6A/qr9m+J/czCvD7UVuSzBjRnjlKUsoZZLZ6zio8dGcc6+0F0FOH3hB5B+doeXfrqZ9Yx5eMcuRLCVb4g8c3kwlunf//g+ksuCGygYlh6t7PfTCxp5gWvD79Q42T6LydUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeZgpgzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeZgpgzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25031F000E9;
	Tue, 16 Jun 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630280;
	bh=48MwtnqeuGY7A7rK062wh0FCNEjCA8evbCMyBSXndFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeZgpgzi5FSvE08bAW7X4kzgZ78dK6+B3hVp1xZO6LJ6aFGT4WpLTeLjGLTIbFgQG
	 h2HNZUZW2Iwn01Ow4PekVDieq7ncEVsLlGa+3tO29iOiEbgleI6cVZo+edL34ByRG6
	 i+rN7loJYxOCd0u0H/3bE7jhtsiKbWvbpM1clG10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 412/452] usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure
Date: Tue, 16 Jun 2026 20:30:39 +0530
Message-ID: <20260616145138.429566590@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@cixtech.com>

[ Upstream commit e6970cda63fd4b4546aeed9d0e2f53a7c95cd09c ]

Move usb2_phy initialization after usb3_phy acquisition.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-2-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -121,14 +121,14 @@ static int cdns3_plat_probe(struct platf
 	if (IS_ERR(cdns->usb2_phy))
 		return PTR_ERR(cdns->usb2_phy);
 
-	ret = phy_init(cdns->usb2_phy);
-	if (ret)
-		return ret;
-
 	cdns->usb3_phy = devm_phy_optional_get(dev, "cdns3,usb3-phy");
 	if (IS_ERR(cdns->usb3_phy))
 		return PTR_ERR(cdns->usb3_phy);
 
+	ret = phy_init(cdns->usb2_phy);
+	if (ret)
+		return ret;
+
 	ret = phy_init(cdns->usb3_phy);
 	if (ret)
 		goto err_phy3_init;


