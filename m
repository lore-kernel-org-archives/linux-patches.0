Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831482;
	b=KRUfPaBpHG7ioZ7Hw1oFxjPY/KDt0+oFWChyOa/Yj0J1IgGmqI287MAqLx4VwDiNiAfe
	 KW8SVb9pwKkANINvImwtD4Oj/UwVa3Cwgw6hJEXT2nszlKnNakRixNiKbZb8JdCgWcs/C
	 1xHovJZPjwmRvfcOLnj0QsdJp+T2lDLlL9CnvOUJM2CY+nnEWdgZ7ebfSM862Hpg5qq4h
	 7bWLSTW2FXjn9/0rshN5/clvXB6cRzjgOSdQQn6Qg4C5rRJib/4Y85d+dq76/kto1MuFX
	 fhh3+LibeiOO/HTIDVYy8uberGe6KeTitOY4o+3As5lc/JXWbHQpMSrv7ZIk9IO1FdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjKVAo4ibu1snwGfvLsLHJOKVeP4qV5E8yIT1+1WV98=;
	b=IjGKjsbxY7QX6P6HDP80zj4fzas9EBHHKh917XPUJFA8CP03w2S2gckE15TVRHWILYwf
	 TaiY50fRS3Vezx2NuusB1lWFE1JKQ4eaUBFnwUDZfexGT5vyGXScal1/DHommIW6Cbpq3
	 PF9fW09upDGcLs/pFthBIPf7VJ7Lwl3gTiEYqU+oZRm7uzFU4hltYjx37fQx/YnsWBv3p
	 gzqvBfhZXuBsSQio9tSCekyaPUNaAvlBDPFvFhWJbkpxzPhWlCZff7eyc8F8b8ZaYzLLf
	 VSstw65rL/DC7/WPaSfVBEPYwMhwTYi32isrtfzbP7hLClqU+lMsurotyLVlX0++0XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HR8hWCxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DC1606AC2A;
	Wed,  4 Nov 2026 22:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HR8hWCxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1BA1F00919;
	Wed,  4 Nov 2026 22:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831481;
	bh=HjKVAo4ibu1snwGfvLsLHJOKVeP4qV5E8yIT1+1WV98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HR8hWCxsp6CDI7MBlxSBPUfB6VF2JxSRhiYaJjypHTb/jI2qjA+/firdt1sVvPLxA
	 xxog4wXGwL1HOXawPV4p5STrsjpZKcz5Gw2WBxWOmiGXEwHLw1L6vqRU4Xwl83g+lf
	 QdF1NeeVjz7LoTce9KHpaktpnWl1tUXAFL8K6AWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 0731/1005] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed,  4 Nov 2026 16:07:44 -0500
Message-ID: <20261104211103.970264992@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 0b1a79f2791a06f139dce5450e487307cf0e241f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/dc395x.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3814,13 +3814,11 @@ static void adapter_uninit_chip(struct A
 static void adapter_uninit(struct AdapterCtlBlk *acb)
 {
 	unsigned long flags;
-	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		timer_delete(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		timer_delete(&acb->selto_timer);
+	/* Drain the self-rearming timer; must not run under host_lock. */
+	timer_shutdown_sync(&acb->waiting_timer);
+
+	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);


