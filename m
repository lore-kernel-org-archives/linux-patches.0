Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06D2B9C7;
	Sun,  1 Sep 2024 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208964; cv=none; b=EfkXjvd3gL7j0FuTTVPfNxhv2mcgN6PqDB1/mq1XMnIpjH/sdfqnfZM77RyAv7VHixDblAvpiHYAaDjDKxyVxG/3uGIWwBtquBiu2/1iBgbyJdfhBUEJJep01QkgihvJOk0BLfUu6vT6I1WGYKLMVkYIHqFPK65qS22qPcmeE8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208964; c=relaxed/simple;
	bh=NpmEBINSI/g3Fv9Iy7OcEVu5ADM0wL9YbygWTigFXOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2eq9onVCIFLL3ag91Mdeg67GsgnftzwYTyPGNcYBADr003FUqB16ezxKAlXCjEZKDfJecLjiOKKvlfH5Q9MJ56ZGNJD3KHOMvLdHsmhdtxV8wzD+egUlmeTmZqrGgetaO6xoTLbe7uDqG6BAd2A8ikSufOkrUfmAlFN5y3tgdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNMd2BaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNMd2BaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6474EC4CEC3;
	Sun,  1 Sep 2024 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208963;
	bh=NpmEBINSI/g3Fv9Iy7OcEVu5ADM0wL9YbygWTigFXOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNMd2BaG0i24pBKO6Q6W1l2Tg/Svl84+Pn4fu+70iq8XE3b1w/M0tVddVe6/9RUA3
	 MQWl6xp/6CqvUyPU+KSd9KnW0XOdNfzzf73DO86e5S1zCYLTIEm32PFiZ5CfZBP3Ww
	 I9g1OeknVd0vv3sWtptGUXSz7WasvjbWhXr/PBtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/134] usb: gadget: fsl: Increase size of name buffer for endpoints
Date: Sun,  1 Sep 2024 18:16:47 +0200
Message-ID: <20240901160812.400035390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9a05863b28768..6a4e206b1e2df 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2503,7 +2503,7 @@ static int fsl_udc_probe(struct platform_device *pdev)
 	/* setup the udc->eps[] for non-control endpoints and link
 	 * to gadget.ep_list */
 	for (i = 1; i < (int)(udc_controller->max_ep / 2); i++) {
-		char name[14];
+		char name[16];
 
 		sprintf(name, "ep%dout", i);
 		struct_ep_setup(udc_controller, i * 2, name, 1);
-- 
2.43.0



