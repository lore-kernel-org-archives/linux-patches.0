Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4381A072D;
	Tue, 27 Aug 2024 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772351; cv=none; b=Nr5z5/kfHXFw+RNMNglB8hLyXry/VLAuyHyUTI0KJFAaCld+JsK1AUCQ8oIJC4xIgHzaiP6k4NGYQ0ae44Cp2FKlW1cbP0qGIKPImqlau3o8t70QUSW0g9rxV7+bBnFqdThfsMR8A5MCFmszr2dQ57pi2W+EqrwAfIUv/5fvyxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772351; c=relaxed/simple;
	bh=0c7WoMZpyHUP9ljyz9VJ7kPJmoWHiy80/Zb/ozxkOD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avquOsVdy2uADgOX1+ic44Z1jTbipeZViMrMcEi5rr0rsBBO3OFsJY0q9Ouz6EBtnJJnZvNtvt/gzN7qvggGeUohnFcAlwm+6ZDnArH8aMm2hBtpDL+EPfSg9CQt7Oq33v7aWAuLhVIbhEx0WeFpNkcoNw71TxSE4MV/fJQUAwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDrVVM3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDrVVM3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3614CC6107C;
	Tue, 27 Aug 2024 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772350;
	bh=0c7WoMZpyHUP9ljyz9VJ7kPJmoWHiy80/Zb/ozxkOD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDrVVM3UX6i2wFHwRTzjQROsNBLugPA32sdRNPQbXSmFkNldXF4TW52rnM52f/TwQ
	 hBK3hbZ3z7wzls65AaSkUdjxcGz40Qy/ZduaC/MlkO8UdaAdBAsidLcbIDTLW+Gai9
	 zCoLEzym6Uo80Nl29XuUPcRSUTdDQWPc65Px/gAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/321] usb: gadget: fsl: Increase size of name buffer for endpoints
Date: Tue, 27 Aug 2024 16:38:16 +0200
Message-ID: <20240827143845.387935412@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a67873a074b7b..c1a62ebd78d66 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2487,7 +2487,7 @@ static int fsl_udc_probe(struct platform_device *pdev)
 	/* setup the udc->eps[] for non-control endpoints and link
 	 * to gadget.ep_list */
 	for (i = 1; i < (int)(udc_controller->max_ep / 2); i++) {
-		char name[14];
+		char name[16];
 
 		sprintf(name, "ep%dout", i);
 		struct_ep_setup(udc_controller, i * 2, name, 1);
-- 
2.43.0



