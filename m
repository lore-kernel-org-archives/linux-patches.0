Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F159417C;
	Sun,  1 Sep 2024 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210117; cv=none; b=igNXFLK0lTqhuVuG6uM0i83lbid3/P2TLe8aZepl0d9O8sNNqzHXhWPTPc0CyXeM4ucfPn6dSX4DFKn4JEQuk7vX64q0hwVK2wO3JD0V5xrdeLqu83ZAV9Xe20vvlj4rOC5yGfXBzHSjMhzm0rqwff4U9RKhsDUTX1tiVczMjfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210117; c=relaxed/simple;
	bh=fJy34YqySsukoo4w8e8jtQNU9AC0owLXLCGYIerrNfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yb644sSCG37axCqLIF3Z9U6gM2qKCEUYBUDn1v3boU8g97TbewmUhihOE4tHuvJXC/8faQhPkBWBUXXbLcS1osB4f5jVQAumbBRuk/ekOSYSLJpMTcEbnCi77gnm3d6ZGFBiZrljKzahSrX3p35S0+eQmkL10q2M8SSUhisA+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUuI1/Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUuI1/Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628B6C4CEC3;
	Sun,  1 Sep 2024 17:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210116;
	bh=fJy34YqySsukoo4w8e8jtQNU9AC0owLXLCGYIerrNfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUuI1/Ni1VUd2Bz162hAa+iaTcSIJ5u4z2Osx4HBq0GyUeF2cln5+2ePFD3g9Wolp
	 hZUS8Q+gJci1Y9FvjEFmlE/jlmp+AoD+KIiMS6vsLYESeA4WPc4Vo6OGZg1mXBABDC
	 DqycPv2bIpOm/gi8j2RvWP0YI3/UDa0jZ47M0CkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/215] usb: gadget: fsl: Increase size of name buffer for endpoints
Date: Sun,  1 Sep 2024 18:16:45 +0200
Message-ID: <20240901160826.867835830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 29fcb9b461d71..abe7c9a6ce234 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2485,7 +2485,7 @@ static int fsl_udc_probe(struct platform_device *pdev)
 	/* setup the udc->eps[] for non-control endpoints and link
 	 * to gadget.ep_list */
 	for (i = 1; i < (int)(udc_controller->max_ep / 2); i++) {
-		char name[14];
+		char name[16];
 
 		sprintf(name, "ep%dout", i);
 		struct_ep_setup(udc_controller, i * 2, name, 1);
-- 
2.43.0



