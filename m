Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034112;
	b=bjdc0Z9uije5enib8GnNbJV4BNnaIg00iPo92ldydFrdNYLv9Ub9oHbJjp/NURgxEgBY
	 U3aXH5ATgMpN4K4DRvPXL0LZhk6LLZxWNA0p7p2nNLDNHOf31vDRQNPMznCowFG6su4pu
	 FqA9YImWWjeAx1bCeDw5+vDBRZICouNfV99CW/0Vh64x1M03XJ16AhiBn2RTFLYQ+nae2
	 fZYlqPenbG9Cn9qbOmhuU7ILD7AtWzcGhGvlu2kKIayHzixbeMjTrkeOyTfjSLiyN7CUX
	 lmzhId+2hbKRd6bZu5q3Ex1hHGVFTW7iF9fXQS8dhquy4AutBPHYboUwJ8R3iOyQaLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a+oN9KJUR1UNVdJZiUP75A87IXVkCF6u8z+R+X/FriU=;
	b=gk7FalFRyCxJ0vUc2YSyq+onl/y+Y0DFVY67c/kF7Fd3eiMDT5b782FIYz/gLPde/6bf
	 PomWsgXCzZVmxM6aS8x6Lf5hJ1vtwAvTwnmy4J0S2kwto6jJr9y6pL1F2+gDhVBFTqbjy
	 6nssd1mHx+oU6mINxKebfzkFtBdGFoXOipSG3DsuQVYGBR/DmkKTgYdYtR4b2SmUjIGDC
	 apjk6hNEB0SiEJQQCAGAuZoc/vtL6Cv5kHuYa3HMp4qdn1Vdwouq+YrsiSinYre8/PWLB
	 vrjWAx6yEk3vlfpugYLYlE95a3p8YZ9p65U8q8ml/bgpeCC4r2Cr2u3N2UWXKZJ6NqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T49yaMhQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C2606A320;
	Wed, 18 Nov 2026 20:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T49yaMhQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2834E1F000C5;
	Wed, 18 Nov 2026 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034112;
	bh=a+oN9KJUR1UNVdJZiUP75A87IXVkCF6u8z+R+X/FriU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T49yaMhQ58yJwOxh3vQIrGohyQ8Q3wlgpAqCUnb84fpTzEJ+ROSjg+msXZi95aYD9
	 62D6feMgB706nUyQyhZmO8tu7b05Hu+m4GNGwZ1I+2PIY8M0nCn4GqvKiTQ16hToPu
	 q7hQzVDE9RbqRclyUbRyUzDj+eAwDlSL5agseWEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0255/3318] fbdev: omap2: dsi: do not copy isr table
Date: Wed, 18 Nov 2026 15:14:37 +0100
Message-ID: <20261118150322.985625972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 31875c51c31edec57b3620f278680c23a823763b ]

To te able to unregister stuff from isrs, the corresponding table was
copied.  Nobody seems to unregister stuff that way, so it does not help.
But there are stack-allocated objects passed to these isrs giving chances
of UAF of these objects if irqs are unregistered while they are handled,
so better do not copy that table.

Suggested-by: sashiko-bot@kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index b7eb17a16ec42..0dc771f0c2ba4 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -325,8 +325,6 @@ struct dsi_data {
 
 	spinlock_t irq_lock;
 	struct dsi_isr_tables isr_tables;
-	/* space for a copy used by the interrupt handler */
-	struct dsi_isr_tables isr_tables_copy;
 
 	int update_channel;
 #ifdef DSI_PERF_MEASURE
@@ -837,15 +835,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		del_timer(&dsi->te_timer);
 #endif
 
-	/* make a copy and unlock, so that isrs can unregister
-	 * themselves */
-	memcpy(&dsi->isr_tables_copy, &dsi->isr_tables,
-		sizeof(dsi->isr_tables));
 
+	dsi_handle_isrs(&dsi->isr_tables, irqstatus, vcstatus, ciostatus);
 	spin_unlock(&dsi->irq_lock);
 
-	dsi_handle_isrs(&dsi->isr_tables_copy, irqstatus, vcstatus, ciostatus);
-
 	dsi_handle_irq_errors(dsidev, irqstatus, vcstatus, ciostatus);
 
 	dsi_collect_irq_stats(dsidev, irqstatus, vcstatus, ciostatus);
-- 
2.53.0



