Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052067;
	b=EhkbB3R47UIxt6IERl6h51a7tkYVq4i1bguPMZ7abZcA4vhJ2O+MWxip8oTfwr/YZUYI
	 aVg6pJtvJXENTVAbH6tm5V1/EfRcLOJBwyGB1BYm9ysZCLnY3mL0N1FdLbDmI5tYoy0Mr
	 BC1tf4IhIoFbdEdxzXF4UPB4+0zVtDsV+9cyxQN20IVAd8T0zDFXskg/w7ZJwXGBBLgHo
	 bxg8HfK+Y4GOgod4dg3dZutJnMIaQfnZ5lU0eSMTnnik1ejPxqBWW0Z63ljTLaMGuOKnu
	 sNZrYmbqDUacgDYlb6BFKG2eX/qvWyw0xIfydjpP2v279GeUYMH0VfINpa1cjLkQDxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ojPZ6EB37vNDHP1i/nQMHVpFb52rVIdIij5tUfYP73w=;
	b=is2kP8Yx5PAg62m9STg9A0/0eu+nRTMGnOvl2v556Gn9+5OL53WGDY663XPZjs3FuPuI
	 zggldBrW6Oi34P2NbKspMHc2jjKSl+81v/q0RA1QTzbnC1WuXPUWJ1HFAerwjWszMSeHx
	 3W8UsIKn42YRJymHScPJMirm/wm4wjXmDIRopR4z+wkwXIaTYkKAwAUg2vAy55E0bBhXk
	 Jnpkcq0+Vo+KPzlXXTVqPWQ8TlKZxjbNMijIbl2uUwb3/PdISz4vzN1omGZzp+C/JhbPB
	 h8uzlcHE4Bd3jXO26Izc3ZkPSiwCT74rLUBsIS/K1EpRNz/XfwH9cWKIXKQp9I2gc4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEC6hpnF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213C2606A320;
	Thu, 19 Nov 2026 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEC6hpnF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735D21F000C5;
	Thu, 19 Nov 2026 01:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052067;
	bh=ojPZ6EB37vNDHP1i/nQMHVpFb52rVIdIij5tUfYP73w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEC6hpnFmXWK9hCQYPErfFX3A1TE687NFZd+wEC9BnFRyUJYwTUsDQBudcberlBz/
	 rqqhu/a3KnfF9BXS9xsDrvNaqeNTgJKrsiNg0jiFj2nrhA2IGJr732ZEY6rb7HvDEB
	 ls2QwjHTHzOJ6ucnUX3zcJEwPU2n7yQGw+o+Wh54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0433/2214] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed, 18 Nov 2026 15:35:09 +0100
Message-ID: <20261118150028.302319872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for del_timer() instead of timer_delete() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d5623253826f1..7b15b86e85879 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4416,13 +4416,11 @@ static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
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



