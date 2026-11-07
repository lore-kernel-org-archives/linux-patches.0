Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064300;
	b=YqJtJiUDQMoywtAUNYDJj1CfTFQohg4nQusFXi/1MezgYJuEzWSZjbx99yHTjv8pv1W5
	 XCtwqwU4jsOGYrchlktwSepd50jNHLBAWI1Ww9z3ggrEXtVVJIu/OAvo73se4cvqgQ5Pl
	 inK3sLnHNsD0LS5Mu6NWUCGiMoYnBKruJl4sZ7tY3gNWLd1W/zdr9JcWy25zUPJl52IeV
	 Lu209jx4O9/81zY0ELCRIsKqKklCHEiZTQjyQHvFR5rwmdxkOpb/FF8zU3EZB5IhO9mYc
	 txGs7MrO0v+qWD9xXp7flKnKSLHfyERVqvYcocN2KI0YwojuvLWlBI1w0Ud59l7ikTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsmYsPC6ZdLnPXli+yZ+9RHFunPlQgTIhDjn5M1o1g4=;
	b=KD7mAsAE1btN7JbhtHryx1XOpOm41+gppum4YMSQ0hH4S1KCGAFfam2pXHTS5M297T0e
	 GdijgFiCis7vs1oVjdqDfgiTbKRCCTNEyPElTCAOgJWgsFSryYNQymoXcQAaNloPQZSu7
	 8oX2J5QseY43EZA0xnSVHp/aYod7eCzZ43PyZVlNFg6HNZYN4B58bFV8jjSxIv9p8rHC0
	 U2ebMd95nmxaC5nVMaXvWipt2e6Pvra7fvqcgIFvzXIj9wSs1vsC2MIb9vxfHCsTdtva3
	 vKdnLRWnTmqVtQQZ50I++oeQnTOkqVR8h08sDKMfByRDZy+Xsputnyg3BQiZFEltxwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaRm1Fk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0107606A9CC;
	Sat,  7 Nov 2026 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaRm1Fk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7141F0089F;
	Sat,  7 Nov 2026 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064299;
	bh=dsmYsPC6ZdLnPXli+yZ+9RHFunPlQgTIhDjn5M1o1g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaRm1Fk0TQjfomOh8Bwa9HvdvcTgfIJc+n6FmtaSaOZKnw/aNburlZtOhfIrWeMbL
	 vbd6/i7TAzqfK2xB7gOyEUAe/FWht0zhUlelrUKZFrgruNVsPJHE/4mRJ1ZjEnC01z
	 qwNdXOyApe2MGna9lnPJIjPvwMX7YSdQPhGKGViY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0393/1257] IB/hfi1: Shutdown self-rearming timers before freeing
Date: Sat,  7 Nov 2026 08:44:49 -0500
Message-ID: <20261107134950.401308092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 9d3259e41ccd5016cd2c6d013232b89df6d73011 ]

The HFI1 receive error and synthetic counter timers rearm themselves from
their callbacks. Their cleanup paths use timer_delete_sync(), which only
waits for a running callback and does not prevent a concurrent or
subsequent rearm.

Use timer_shutdown_sync() when releasing these timers. This prevents a
callback from enqueueing either timer after cleanup begins, before the
containing hfi1_devdata is freed.

Preserve the existing work cancellation and workqueue destruction ordering
for synthetic counters.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260930070455.2934286-1-runyu.xiao@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 592e330e74bf1..faa724ca33bd7 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5567,7 +5567,7 @@ static int init_rcverr(struct hfi1_devdata *dd)
 static void free_rcverr(struct hfi1_devdata *dd)
 {
 	if (dd->rcverr_timer.function)
-		timer_delete_sync(&dd->rcverr_timer);
+		timer_shutdown_sync(&dd->rcverr_timer);
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12300,7 +12300,7 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	int i;
 
 	if (dd->synth_stats_timer.function)
-		timer_delete_sync(&dd->synth_stats_timer);
+		timer_shutdown_sync(&dd->synth_stats_timer);
 	cancel_work_sync(&dd->update_cntr_work);
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
-- 
2.53.0



