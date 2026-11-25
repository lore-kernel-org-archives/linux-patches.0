Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619392;
	b=HjEE8gcEt9MO6Zav9mD4SJgjEOfe7AfhNuFVCumZoZ2f7EiKJYffl9VfjnYJULFdMuG+
	 ux46/qd8dw/i63TLndI9Q9+g7HMYU1YrJWK7gSoRT7vb/FC/5PVtBrMxHsUNJ2/B4pk5V
	 r5LYY10F10lsobYQIJlghX8wevFEf2B50LV5YxZ93JLdjTrMMBnLXibWze2YiYMg8X0Ty
	 PaZOlXr3brR3AnjywOMTqj4Vz4H5aoRTrmWDWqpfe++jo6w7dHcMuJ0O0wDi8jOQSq4dP
	 WFAsXA0wUl8kFMap+sjmfUX0ZHq6+tYCyXwLYkCKs2cmJQVm+IGt8qK/ZjcKVS6S+OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNz1KOwR6n96aCMZyo3IYB0MzFIl7ThI8kPFtwPsjx0=;
	b=Xb/VjbCgRnJsv8/IuXtCfsrPRUtEYpFb8DiIoHpMjDpmQ4PO4qGZRdg0Ua3G5Dhzg8EJ
	 SO4axmBTDiL8dDu/wUFes6rpZUwODWgoPIrojSAY/ahOwMvBz04t+mRSvU9m8usJJVYVL
	 Bpx1cfplbSYPAoaERuoXIVH1OxS6lYP9Hyadl+9/4sPR92ngiMWB6ivAlBouxEmoHURVV
	 LCWhH4e1dQDkPkoR8zecQd4R1mY8uQ2rfFaOx2UrMOV0ZJ/JPYfCGUZyrHuz9j6gwLYWQ
	 nBXJnjakWYzci+pgLchSRaQ2rVw4oeflGT4I5W9KbLNN9Gdvg5dnB2AFAepXyJKbzig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRZdKFUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F191C606A31E;
	Wed, 25 Nov 2026 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRZdKFUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05AF1F000CF;
	Wed, 25 Nov 2026 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619391;
	bh=MNz1KOwR6n96aCMZyo3IYB0MzFIl7ThI8kPFtwPsjx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRZdKFUb6KQTsYXCTNLEb69XFzLrVABCfoR/9jNOiQMFl3DuDNXjfaEUloxsyGy8H
	 EkkXqn5+Up4XjZLa/sW48JBF2tj4skwDBmLwMzA0gGP3ohUIeDTU10lSZJKPH28FH5
	 ZZ3Fdzr44cHruxJXwqfw3mVK+ivG8rMRIxirexmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0580/1005] mmc: omap: synchronize clock timer before disabling fclk
Date: Wed, 25 Nov 2026 15:31:58 +0100
Message-ID: <20261125143835.335300060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit c931c51681e33b24bc8d65c6df35b70e1827daa2 upstream.

mmc_omap_select_slot() removes clk_timer with timer_delete() before
switching slots and changing the functional clock state.  timer_delete()
only removes a pending timer and does not wait for a callback that is
already running.

If mmc_omap_clk_timer() is already running, it can therefore call
mmc_omap_fclk_enable() while the request or slot-switch path changes the
same clock state.  During host removal, the same window can overlap the
final clock shutdown.

Use timer_delete_sync() so the callback has completed before slot switching
or changing the functional clock state.  Keep the timer restartable for
normal request handling.

Fixes: 0807a9b5739a ("MMC: OMAP: Lazy clock shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/omap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -214,7 +214,7 @@ static void mmc_omap_select_slot(struct
 	host->mmc = slot->mmc;
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 no_claim:
-	timer_delete(&host->clk_timer);
+	timer_delete_sync(&host->clk_timer);
 	if (host->current_slot != slot || !claimed)
 		mmc_omap_fclk_offdelay(host->current_slot);
 
@@ -273,7 +273,7 @@ static void mmc_omap_release_slot(struct
 		/* Keeps clock running for at least 8 cycles on valid freq */
 		mod_timer(&host->clk_timer, jiffies  + HZ/10);
 	else {
-		timer_delete(&host->clk_timer);
+		timer_delete_sync(&host->clk_timer);
 		mmc_omap_fclk_offdelay(slot);
 		mmc_omap_fclk_enable(host, 0);
 	}


