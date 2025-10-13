Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE7E30C62C;
	Mon, 13 Oct 2025 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368341; cv=none; b=rj7Iu/6uDh80+zU/W+d+OSdWy75s53zRIaCmAYs1p46k6uztr6OVxS9GHb0H3Mvr7r9cwpWKl0VxkGOLqWrkmArNaQON9/iXC3eOv/zv9shd3T8mhoCdiQOnmn275gZsp7TpNTo2FqWUY9DqC+mhb9KT0NS+zbD9z+ZtRQF1ow4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368341; c=relaxed/simple;
	bh=NoFp7kdMzPa9oB7luD3baWnO7A+BYZ1vq5fDBrju7js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M71mJvoyS+UGMkqrGvRzs4D9Hm4i55hXGr+fpBA0xG0y+0syOgYtW64icfXpqXZFS6e4LB1NEFuit3Kq9iLmjJD9StidDIB30udsmJm0l2sm/W4VE6mND3n/FR8eN6Qaul835Zc3LGT51RsCus1GuMGnWTbqevMzMUccJx4nk+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2EX68eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2EX68eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA8AC4CEFE;
	Mon, 13 Oct 2025 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368340;
	bh=NoFp7kdMzPa9oB7luD3baWnO7A+BYZ1vq5fDBrju7js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2EX68eR6FQ7Cr3qUTkgUN9JKJ4vnduYi7GyPjMG8od221qXbt8HPltw9bzN5NiCd
	 xPDpVTE0gdfn7tPxMMLdNUzR0rd8pOOBmlF2tLeoZzMzwzDcPjSvyRJYb3gTCu7Q4F
	 0N8/fOaljmByZH10gH3ab3m69kuvhav1ZsBKKnXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/262] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:29 +0200
Message-ID: <20251013144330.698005390@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit b570b346ddd727c4b41743a6a2f49e7217c5317f ]

In the twl6030_usb_probe(), the variable ret is declared as
a u32 type. However, since ret may receive -ENODEV when accepting
the return value of omap_usb2_set_comparator().Therefore, its type
should be changed to int.

Fixes: 0e98de67bacba ("usb: otg: make twl6030_usb as a comparator driver to omap_usb2")
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Link: https://lore.kernel.org/r/20250822092224.30645-1-zhao.xichao@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index da09cff55abce..0e732cd53b629 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -328,9 +328,8 @@ static int twl6030_set_vbus(struct phy_companion *comparator, bool enabled)
 
 static int twl6030_usb_probe(struct platform_device *pdev)
 {
-	u32 ret;
 	struct twl6030_usb	*twl;
-	int			status, err;
+	int			status, err, ret;
 	struct device_node	*np = pdev->dev.of_node;
 	struct device		*dev = &pdev->dev;
 
-- 
2.51.0



