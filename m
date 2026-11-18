Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035787;
	b=fSUK3lnNLvF6Uomv9zzPuSwK7bX0pjSTGAOg0c2PrC03xCbZaAfKHSg0NJmHAKILT3xy
	 yJ6kgxfEKrvh/n/FgG2qN9lZ10M1ZzpsLj85FZM3hiQNh+L5E93EoZhhYyfmnPd69Fwtn
	 /RKo216s/X/aggMY4Tdjvpg7QqmLj6yLENjLBKIznQUHlnrReL6G7y3C57+z4JaBq7xBO
	 bKkGsVrIFMtO4UNPBwa5VIxRtNL+rFUnBYYnU6Qokvrc7HOst3xYR1Uda3Ny94mQVLOHe
	 tmRzuKGrQKULR1j2l4ycIMlkV7vRiyy5YMC9pl3NOQXx8APovOq7WQ3s3y3wzomwBOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9g4Ug4IvehYq9TmHLUiXpW5in61E/yAk25lR61tGWA=;
	b=TaL9yOXPpDY2wjCMMgzcIWEgNpoYCdA27EMZ2MbZcZLP8/meo9KV7sZSYMkPapdy0wpy
	 uNtN41deHUtT2ybaZtJZbH4oiPiZT9X34cCukk4hnnV9izE0qY86RLehEJ+yBbj8E7nQn
	 Ty2OM2Q3rgZ/joTCu/HTICR6eoUmj2YytV5pd/Lwyr9ZPfSWkgzJCs6pDO2BnUtWjj8ul
	 pvHh6P/h6UnJnTaQeNmCliS/zLSkTRel2wEJaYuNbOvgc5loCmx2k/fCu9jcZdoH+TBxp
	 WjTYptUho+lTYKdBDISv0vQaPt1h8IluL0Q4BCO8HGXcblN53nc/NXA9bPtZI4p3lPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bN4t9Jvm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB074606A31C;
	Wed, 18 Nov 2026 21:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bN4t9Jvm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EDB1F000C4;
	Wed, 18 Nov 2026 21:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035787;
	bh=Q9g4Ug4IvehYq9TmHLUiXpW5in61E/yAk25lR61tGWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bN4t9JvmSX+vC8RSMAxCCIefDZHcL76K6ncsKiP+D1LeGig2Xt1w2puaEYoltHJkh
	 NVCUos4+2o+QfNmgjMnxspbKTUeyz6UEJ2rpDIMd+9de4WW6RLaRPkVTGP/18scNrx
	 SeK2Emdm8MulJDY2sA+d+1ujl4iZ6W3dIyUqwiYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0790/3318] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed, 18 Nov 2026 15:23:32 +0100
Message-ID: <20261118150342.579310043@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 0b1a79f2791a06f139dce5450e487307cf0e241f ]

The waiting_timer callback re-arms itself and takes the host lock.
adapter_uninit() currently stops it with timer_delete(), which does not
wait for a callback already running on another CPU. The final
scsi_host_put() that frees the host (and the host lock the callback
dereferences) runs right after adapter_uninit(), so a concurrent or just
re-armed callback can fire after the free, leaving a potential
use-after-free window.

Replace timer_delete() with timer_shutdown_sync() at the top of
adapter_uninit(), before the host-lock section: the timer is dequeued,
a running callback is waited for and rearming is blocked before the chip
is halted, so it cannot fire at all once the adapter has ceased to
function. Waiting outside the lock avoids the self-deadlock that would
result from syncing a callback blocked on the lock we still hold.

No shutdown is needed for selto_timer because it has no reachable armer
or callback.

This issue was found by an in-house static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260911020544.42966-1-fanwu01@zju.edu.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: adjusted context for del_timer() calls instead of timer_delete() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c8e86f8a631eb..312bc719c56ec 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4411,13 +4411,11 @@ static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
 static void adapter_uninit(struct AdapterCtlBlk *acb)
 {
 	unsigned long flags;
-	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		del_timer(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		del_timer(&acb->selto_timer);
+	/* Drain the self-rearming timer; must not run under host_lock. */
+	timer_shutdown_sync(&acb->waiting_timer);
+
+	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);
-- 
2.53.0



