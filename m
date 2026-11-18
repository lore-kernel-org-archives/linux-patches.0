Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044821;
	b=JD1GnZZKcrdcSVO2zgDL+4TqXWwVgsZtYf7HJGK0KJKlaJeLhwTENSWeBFUJwRMOu+rp
	 eK93WMhbqbFJDpc97WYGbK1wrpq8WdhU8GNwW1wwNEevGYQkxWAWLBzIldwAMrrYXBsCq
	 nTgmHzfeFSXaQVxwnu5LfnDZiaPxwXtZVvchvB6ugv40xCVs3XdMDIJDMyV+NTxZQNX0H
	 EHBvBk/eGofbGUHcG7Sp75QMylKui86bQwgfYedHpo09rFZtfc5yDE93UOghBqe2kxmxp
	 7a2jgCjz7sVQ/ySW+KXDAPp1/qDLMMSpA5H8NhA2tM3Y2r2B/8W/fyx4DfeXvgQ2U2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BiHS1PWFj7SOVgLcbnEEjRs0PYEkjpDsZl1g8oggawY=;
	b=uKed1mZQSiN0XoYv4qXpqvMMpKhWCZQYWIyIJGGILXyrzCQM/YYWZHwam9lZdWkAavJE
	 638NEUJSBnybeiuPykvQ+ZAsUW9Qtt/annotxV6AKyF1UPm7X01zJGFQRHEQhYbaFogNA
	 ZNt2fC7hsC+jWY14Jz27uexMR0XLGZuvl4yRHFh3/XaOg6e3WX6lUNssoOQJhbw4S9idK
	 3fnoF4C6KK94g3e2ZMT3noNSl1RmqbbfH32kUdevRH0zIBQL4RHpOEIaX7B+/JfFeot5/
	 UtJMO9RNH0VLDYI/bPv1RWU6rKdg6HLHyDuDDLPlLhsLvgMCJZrGylYADCpEs5mNSfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQJ5ZVQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBED560A263E;
	Wed, 18 Nov 2026 23:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQJ5ZVQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3451F000C5;
	Wed, 18 Nov 2026 23:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044821;
	bh=BiHS1PWFj7SOVgLcbnEEjRs0PYEkjpDsZl1g8oggawY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQJ5ZVQWaOYgKE0EuVvjzg/nWhjwj86ejUZqOI7eyw0ClLp8mKu+jsOPiUrMN3Ghk
	 zfHFaVKuiFVfvVWQVDOlBiyDS9Mv3xmhBlfdcYxNl838WoCc8LmxZ6HqhYKM9z9mLB
	 k+hPZ7jB8DeMg1zTRH4s99A2rMz+hiTdHU7rmVm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0704/2857] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed, 18 Nov 2026 15:28:58 +0100
Message-ID: <20261118150226.902787819@linuxfoundation.org>
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
[ sashal: Adjusted timer-removal context for existing del_timer() calls instead of timer_delete(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 670a836a6ba19..f18cd86ee7b4c 100644
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



