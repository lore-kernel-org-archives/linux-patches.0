Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DBE359A6F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302386; cv=none; b=Etaed58nY6z6v4cMWBN6VwLoo6vohXiQXtQuQl2ayFghHVuyqxcae+hDEgc1Y01i3xDLaVEg9l/+74xti7P2Oj4uYZhHeLxwmnZ+RPsePIDNZGwqy2FZIzDoODoMKxnLNmEUrMiVTpqUXp0IXlrsZpjEvJGSlngyXY11lf3BZy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302386; c=relaxed/simple;
	bh=PGxXTo/az+9J17yqFkhEV31Uh9rpR2hcL3Jc4F4XXA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z91LpGmZBZqrN2s0E5Qi71ccL8UsJfbCemM1TswjzP8dvU5zYvFKhRA0ikgzKOKREWugsmiVLPd4JPtOkF4FUtWBqKuitTMgzierxHyVcaORNXO2GhO5VM3MqYqPtKqvKWBg5/8s8CRK3N3j2DjO5h10K4QgjIz4dNgmXvwWOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oq7E6k1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oq7E6k1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41417C19424;
	Sat, 28 Feb 2026 18:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302385;
	bh=PGxXTo/az+9J17yqFkhEV31Uh9rpR2hcL3Jc4F4XXA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oq7E6k1XpB6wkIcXiBeQi2Gb04opj8zoInfAS9ZPIqrJ0wRuSQCpSTzELONGT8kN6
	 Q5j0hDKB9CskeMoFalFyupMdOO0ul4BJO371pnv/7mgDx3xAMniUsKInLs/Gsnid2v
	 KbBe+57NarCPM6A2RtRzfbwtRInznI9pcalzb9vORkfTFxN5GfQRNRac2ZcTCUxpHZ
	 F/Y5Y1YItHcegJTP+g79xZL9T0mYSLk6xRobVtwOxMFB1Bz1CpReVOx7MHZ9EEQfwr
	 Sg5u7Urzebwfb3u5OvPi8Ev/T4Whtzle03PCJM+0q3C2pWxZR7ExwPPDSfin6H0nC3
	 CzpxDHileczhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: ye xingchen <ye.xingchen@zte.com.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/232] timers: Replace in_irq() with in_hardirq()
Date: Sat, 28 Feb 2026 13:09:27 -0500
Message-ID: <20260228181127.1592657-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: ye xingchen <ye.xingchen@zte.com.cn>

[ Upstream commit 8be3f96ceddb911539a53d87a66da84a04502366 ]

Replace the obsolete and ambiguous macro in_irq() with new
macro in_hardirq().

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/r/20221012012629.334966-1-ye.xingchen@zte.com.cn
Stable-dep-of: c9efde1e537b ("nfc: hci: shdlc: Stop timers and work before freeing context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index d7462b19b2f7e..4a2aeaa85af31 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1561,7 +1561,7 @@ static int __timer_delete_sync(struct timer_list *timer, bool shutdown)
 	 * don't use it in hardirq context, because it
 	 * could lead to deadlock.
 	 */
-	WARN_ON(in_irq() && !(timer->flags & TIMER_IRQSAFE));
+	WARN_ON(in_hardirq() && !(timer->flags & TIMER_IRQSAFE));
 
 	/*
 	 * Must be able to sleep on PREEMPT_RT because of the slowpath in
-- 
2.51.0

