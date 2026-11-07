Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060940;
	b=QvX0opZ3bdRYZHDuHDaiwXe4yGyeg6JEAkw+raEIeDUHgi/LptCM0kfayfb6tQW9b4iz
	 QTmHb9MOYpzVtT155MKNWgqLUd+ITBezDd6M9XXvNnfWgrMa6pOPYrCrn+7gW2B8/uv0P
	 1PrHRWnIpYZ/ECaRtZfcDvYWJDYySmxiDj53zwyi9DV/d2MJfMVp3VCOyTfWhWQYNuADi
	 g6JdX2F5uKzMT3XBkHX7NaCJAEAQslsuxyBKABa9gAi61TJvCvwAb5OHsMA+oZhkma4VJ
	 NK/oau6J3LAiBfd59BbW4IcxEQ72sLZ6IqfSdkV7TlUqvGoILUhi3NTGK+3qSoGoLkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9DLpz+wggGflkHtEkbD9L1UIKL+BXjVMYaKBohaoCA=;
	b=ivAqp3/tO+Fz2f4AY18PhRC47jPQOXM7BzMGVjYa0JhdUzsJp8XKBDnTozRBNs0FKLdm
	 FSuO6DB9IwadZQ/LJXq5bH6l3khzJwNc12tjYND2pkR3Ca8M5vIpoNWoO+ML9wwbCcvTu
	 d4LVyBDM2cgRct/b+pfd/+NuhWcPxFOInS6nx//Uop61SiwA1oEvO3KEamoN9u5+ZJoap
	 EJogxFbWlBNmpbiZ08EDcp4OwJvhi3e7bwsn7s7LPh1RE55xFN8DGWeuoKwtipfzxI0Kq
	 aubemCoweD0Uv5J0R9BCHGKd6Wlr5GMAZP3/l/Jc+UrLEEfI6YX9boVap7LbKl6v9nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Haz6cUWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21F4606A33D;
	Sat,  7 Nov 2026 14:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Haz6cUWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8000F1F0089F;
	Sat,  7 Nov 2026 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060939;
	bh=n9DLpz+wggGflkHtEkbD9L1UIKL+BXjVMYaKBohaoCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Haz6cUWyfdsjAw0D2HUoj7UC08UNdoFfWKDdYvFuwGEfPrnymB7r6NX1c/F38XD/x
	 KxvQjX3zX4ySDGKY0qnNqrEDxQAJYmSzvE2n0muPAMcbpkFApnq0e/IaRkOslzG4Q6
	 l9GqEjH+ZGLnq4KUFfcmnSqdjsJG/IexC6gyb2+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0303/1536] fbdev: omap2: dsi: do not copy isr table
Date: Sat,  7 Nov 2026 08:38:39 -0500
Message-ID: <20261107135006.236160680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1f3434c040c14..bb1bb545952a4 100644
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



