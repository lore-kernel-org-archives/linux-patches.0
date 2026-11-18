Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057532;
	b=r26//J8BwCNv8anRo9lTtJZiQGZOLbn+OiYPCy0HPrChtKfjLofi3KDbPVlIu+Q4XkLT
	 /+tgI0LTRymnmGvndVRT1d2KhjoIileo0LLXKcVBV5/JOcx/SjleJTej5Xrk3la0lOP0S
	 krR17ATnIsT47YVEW9uiTgnJluIloXQSRSEYLOPg9cNMiEf0sUxvrtg3FhF3u3IZ8FBNu
	 DAULF+LxGhV0ktrFqWyPYC3F28L5b5SiZfG5jRdrQcPCzD17ndHhOC/x3TsPXfrvJW4fm
	 J12qMkpIsPu3kpaJj1dbei2ZaqRhh/T8ejDhwBH6U5QOf9Ij4DGQw0JkqaLT6K3V6YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CYOB9o3I5qxP3NLrCt7Pgnbtyy8NohCMv4i/Y/yBglg=;
	b=PbreTxQg3MFW23DN8vJJWnVoV2c4UPTuwf9Ya8AYBRQletOg+5nHgvNt0+dN6l8lAF4i
	 nSpQnbueNAvyZ1NslHEJQ15U3GVOznb/1Gkw11m0bRV+Z0UMX0B6gW7h3qib8yZwp0C9K
	 zSsoE9sUV/7U2R6jA146PxK2syfUOePmcZjM1tSDddUaMFrb0JcMSxyLNeBAmvgz4/REK
	 j5Cf7eO9LZaOC15hI7WW8kMpW2eAFjKoaj23NBS+AavRm/ebI/e55BY16ntMmjg7WN4xA
	 ju/SJ283A7qDR1gMy1qfcOwcmlPlSb4n0OuqQSVDbZ4TnD/2Ma4bUYyv7rTok8Sj6rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za+fqPyW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B160A2607;
	Thu, 19 Nov 2026 03:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Za+fqPyW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F8B1F000C4;
	Thu, 19 Nov 2026 03:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057532;
	bh=CYOB9o3I5qxP3NLrCt7Pgnbtyy8NohCMv4i/Y/yBglg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Za+fqPyWBSkI1KcZGU3vyUtYOv/TNPQGMxLW33L9biJvXmOGvlMU11tVXC0HbnFTz
	 g+J3WaqoiG0C0L3JPFUQLpsZGwQU93wi8HImPgUutKD/3/wFux83PRpjnGBNJSzluT
	 NRd6Etu70ud3HUFgZGshn/bET8okgs0mPjrFG9v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0163/1848] fbdev: omap2: dsi: do not copy isr table
Date: Wed, 18 Nov 2026 15:36:41 +0100
Message-ID: <20261118145918.478848458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f9c25fec9946..30bcfe2a2af73 100644
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



