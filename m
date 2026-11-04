Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830866;
	b=1ZeiCRjNQ+IxRLZv3yQHSGBNvVowpAWYmkJ0gWD3+dKKQmcuTpUYtrWiMsKZQxAV/8S/
	 t5wY+sWvvCmIaxGqizJIav1p1BS6FDvLC54hXkKP66PILQgH8liDcl5rRZzzuT39TV6jB
	 P8NRsClabYmIwgIgB0Dc/YnXpMgMdBpgRms49InSOPXUalvY0dhj05hN6ChZSI5ktz5xN
	 kwS4kyi+8FTVqsGd6T/eGSxk7hCBaqDhgLyQMGlWQB2xGI7wJkQnLobSu61O37PleCF92
	 0r4fhaPzM7R60+/IS4dDXj4BT1IumYS48Od0b2wYvAaFN28e5kAf0dan2Ds+TVhBR6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hfqnRtQXS4mfQmDgsBkgjsSUCw8s/tITyTgXNNGPASA=;
	b=4siwA/e3ji/DXkCtTvykH3HE8K52SIuARvy/tOr60wvF2Emeq+6pOT8wOjJ2RE92TwCB
	 XkYZCbPmG2A8Ja3xfqQLHSAQvZO/8VvshiVomN6QODPpyGRoe2DKlEe+UC5e4B/Oypwwi
	 GjX2qYmfCBFzGtmGLguQH4vREYWwx5+W83EGcy/t2N73KeV5RVevLLpUChaPONll5Xs1T
	 Ry7JZ3ICMuDCMhF586H522FHkb8NB2i/AMO4MzYE5JvkrYEb0MFdMye2FWD0tIyD38FD1
	 wAf5oGJEi+NEJeRO/vZACpmq1xOt7VKxMA1leQM1eBPoRSo2/k83GBKdB0TtcfRYuVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSha3Mkv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFFF606D838;
	Wed,  4 Nov 2026 22:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSha3Mkv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575001F00A02;
	Wed,  4 Nov 2026 22:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830865;
	bh=hfqnRtQXS4mfQmDgsBkgjsSUCw8s/tITyTgXNNGPASA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSha3MkvcgaRUPeRe4939JJqr+NEGl3+ZuB8izNSr5ff6zZQOA9XctJF9mbV6UOQJ
	 ydVTRDcoTCutMigiZh5nbBtLLSQwUN1ibYpDHVAjs6qZiynduzG0l/EwEwVubmHfWB
	 WAA0AnmLs/6b6q7gwBTKbeRj8VzXD6D9MuSsc9mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0368/1005] fbdev: omap2: dsi: do not copy isr table
Date: Wed,  4 Nov 2026 16:01:41 -0500
Message-ID: <20261104211054.397063638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 370e8623754ec..b1df2c014b00c 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -326,8 +326,6 @@ struct dsi_data {
 
 	spinlock_t irq_lock;
 	struct dsi_isr_tables isr_tables;
-	/* space for a copy used by the interrupt handler */
-	struct dsi_isr_tables isr_tables_copy;
 
 	int update_channel;
 #ifdef DSI_PERF_MEASURE
@@ -838,15 +836,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		timer_delete(&dsi->te_timer);
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



