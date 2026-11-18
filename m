Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043466;
	b=uPSYLhYU4pFdAgq7kHhn21xMR2g06u2yh12ZwnIkk+rtROm81H3uU7zBmmhgxLBfLjAE
	 6bMVJUfOTJWMqaQekBTbPM1hMr/TYEsLQ4I+ePoxQqaT13/GOz3RGmH4E4X33JbgY9Oc2
	 qqlY2sYdh1X5e778FmHCVt9vyDv+8HkEuoW3BUnRG1I+rfRiIt9YX02kWp5GlkQSD6IbV
	 0+O15U2v70Jcm3z95YzPj1IlT156ihmeXFKHc7WlHFYD5sAX7ApLcj9rvBp7qqvFptsCx
	 XDDUGux+O/4t2OZWKnS/77HXTuOcuBb3yE/NpPlFNa0gxsQv78QUtkXD+X2mvOeiOhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9UiJN4lR62i9ll6jhEsSEkKAgoZS+/pSTbTwCg0SNs=;
	b=tkagNsZ1+KuIK7qZUyekGrXNzKZeoXkbm7x+BlyAxY4hTODZoFPMKYwE18sLFIZBIoJL
	 pJ57rldHgHcBr1icCNiVYI0xUnaVtwh5zcvjlXhB1jQiRGRwtTw4vToPF6PRPXgzMRA6v
	 AeVwQhxny43A5kNFJ32KkoRR2Gp4aIO2gJ8g9HallkueXwLO/93jjo9X9wkRt9hdmH/2L
	 UEwopLbZyOJcGvsusYcTTBZQD4h7t5ClU00zRvLGWE/L/cdavdxPgk/4KKIx0z7EYq5df
	 sOsY2x83/rE+CjDwY6HY/sE5Rz8hgR8aaFLWEUGo7b3l3D0coPrNwG6z1DVGuyPTp2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pdpbj4/2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01134606A320;
	Wed, 18 Nov 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pdpbj4/2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E68B1F000C4;
	Wed, 18 Nov 2026 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043465;
	bh=Y9UiJN4lR62i9ll6jhEsSEkKAgoZS+/pSTbTwCg0SNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pdpbj4/281qSWGgQfMW+jDTkhdt6rmnaItrWrD12I3BmrLjVw3+6x7XVVt8wDb7gS
	 TkF8HorSXGEQMgVAvXDCrHMqwyGUL4Xn1bRqU8v+4JZT7qfhKCtk8s1uB4psM4351P
	 pRljymX154SBBJa8hXI6FbqfhtgEhyNvdjyCD4WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0220/2857] fbdev: omap2: dsi: do not copy isr table
Date: Wed, 18 Nov 2026 15:20:54 +0100
Message-ID: <20261118150209.384217192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7cddb7b8ae344..53b621081311b 100644
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



