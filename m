Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41C2D8DB9;
	Mon, 27 Oct 2025 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590507; cv=none; b=X4D/aY33WwXCeoDDsyW7ouTieKebN7DvQpFWaTMk+dKJCY7En2JlxV+J+f3mEEjNaoqhSsgPvaDDOJ9sotQ3joEExwQUkC80Bdsqkhu/eK7YJcKoayx+cGeFy1Vhunn/RedFMMHJnRKxbwt/Zkm0B6uQNyPY4xcKVGFFhJpICpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590507; c=relaxed/simple;
	bh=4tpq+echlyINaU+1HdAfpnZOVrkEZenpcVT0smzH4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K92m8ZvKwfhOMln2LMzlMCxWBbfxYmlpqVU6NWGajXQSWHydGBY0l8XwFUsMSZu38Kf/5AuT/6QUM5L4AdQkag7O5/+nMwiTx56p4EVK7PRUc0pRwLel+yYmLJUZkSJFUeXH0HbcsPC0OWW7rXffj9HzcGEbwmOhMqZUyMIX5ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gN1LBYYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gN1LBYYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085A1C4CEF1;
	Mon, 27 Oct 2025 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590506;
	bh=4tpq+echlyINaU+1HdAfpnZOVrkEZenpcVT0smzH4Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN1LBYYuhLdq1zzd0l0AKiIxMsfqWxSzY0pdHuy10XbZrG2G8pNbrgVvAOGf7vV+d
	 FXEYnT9DK3A9z3Wg8a4GqA/sx0ELgVgYHArA8KC7U5fNMloum1uzD4FPLYjvQ3E/Ea
	 h1rCUS35VnvayOxUBbHVq1ZrMT74/NsBP/32gQes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/224] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:33:07 +0100
Message-ID: <20251027183510.105662464@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9337c30f0743b..607c3f18356a4 100644
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



