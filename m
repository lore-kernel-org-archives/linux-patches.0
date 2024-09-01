Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EAF17E91A;
	Sun,  1 Sep 2024 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207668; cv=none; b=te4COMZKnvFuFbDAe6kc0X9BxLdaBAWvo42RKz31vj7Hw0Fxj/vExM2qG+x5aSF1NLUW8vtn63oLVCD1WnIyumOEzBd78fNVXdIHi6PqDpYmT9n3b8FCl55qjEBu/INzE21EVlCgApQx03CDGB9fvHMdb85Jsb7q+igAhf/Xl4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207668; c=relaxed/simple;
	bh=TjPtU/zDy+d9GQB/ZSI4HrM/DhsPo21+E8V3F7gZ2qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5rsJ7HF/7B4aBWeB7fzvh9rldSQGrQDnAC0nEuhkZW6uMG7X2c95yjfp/nuYCNgMNmZ1cJRp0eZ03u2IfP5eFxrwGZ1g5XdwGMnpqKw4jZoSghprjVwRmNgWV9/gEJvrFrgyk9mcX68KMPxkCYHD8C4uRTgPNYpbm+d+yRnqyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHhD4KgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHhD4KgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC53C4CEC3;
	Sun,  1 Sep 2024 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207668;
	bh=TjPtU/zDy+d9GQB/ZSI4HrM/DhsPo21+E8V3F7gZ2qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHhD4KgRmDCpMXpvOM3Lmtu2lqlWGMdA8+axoUA7kA/TVGqejP4hgyYOiXqfQhd3P
	 2zxNPAp0Klkbi6oWDqNt5DmNbttWCXFYe9S+d5LvhK737ho4MuRT+GJypmdvtPtmyQ
	 7d79CKyC48UN8KNYZ6lrUe1oX0Z4I9LZGwvsP6AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/98] usb: gadget: fsl: Increase size of name buffer for endpoints
Date: Sun,  1 Sep 2024 18:16:11 +0200
Message-ID: <20240901160805.248669016@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 87850f6cc20911e35eafcbc1d56b0d649ae9162d ]

This fixes a W=1 warning about sprintf writing up to 16 bytes into a
buffer of size 14. There is no practical relevance because there are not
more than 32 endpoints.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/6754df25c56aae04f8110594fad2cd2452b1862a.1708709120.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 367697144cda2..b86f86902f55e 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2501,7 +2501,7 @@ static int fsl_udc_probe(struct platform_device *pdev)
 	/* setup the udc->eps[] for non-control endpoints and link
 	 * to gadget.ep_list */
 	for (i = 1; i < (int)(udc_controller->max_ep / 2); i++) {
-		char name[14];
+		char name[16];
 
 		sprintf(name, "ep%dout", i);
 		struct_ep_setup(udc_controller, i * 2, name, 1);
-- 
2.43.0



