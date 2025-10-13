Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB690309DC5;
	Mon, 13 Oct 2025 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367684; cv=none; b=fZ2Ccy/XQQjf3idzgxjreraCEhBdsxvrKKFBIbjAZzCazZHoLTX/SXoLj6hskdJqaAYNjg4t3I5uBfvFMH2m/mvj9kgFRp6+Co+wIk6a1yNeDXq/Say5Fx7U5lhwRrztoMyxDYGWo8b7A8zklRelkpybY0I7zOrcxwsIyaizewY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367684; c=relaxed/simple;
	bh=PnW2lzPItGkX+LIyMoN327l7nYnnP6gaLDjxpcAh9fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf3IG78eiUeAZ5PPVeuq70cZhxwg+7epoLxmbJrfxyTJaT37Vk7zMXSwTa9ubc4Z5DGO29ZypVhlee3BahUCWoLR1puif5PlWh8aDT8yp3lOh/bk9MoIGogbXdgfT1VVAYE7Vh0EIC7NTsv0LRtfI0BNxTZpw6AYcCL9xkD4Ao0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9ClVQQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9ClVQQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401B0C4CEE7;
	Mon, 13 Oct 2025 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367684;
	bh=PnW2lzPItGkX+LIyMoN327l7nYnnP6gaLDjxpcAh9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9ClVQQtxTjy3bQStInz2NHx+jrRq3quUIaRGxo6rs1O8tmUsmzJvfdGoU8JXmSEq
	 TbsnlNZHYe9K9YZlusozys+hd0GgkpXzODxghacFyE/G1R6/I8KZb6KeroNmCikqaM
	 1RvX8tcchVmEeGW7GAWuWnKxGKxDK157FfeRrKuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/196] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:47 +0200
Message-ID: <20251013144318.790357360@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index c3ce6b1054f1c..292c32ccae050 100644
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



