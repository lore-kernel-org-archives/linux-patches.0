Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058041;
	b=E5JurxdtwbnRkO37KBqJAQP67mHfU0oSCiKbBiTqz4fXpQP0geWd9emLtkVIT5nUrFNL
	 0qzYpCACb58XQOKCRjxceQhCAqPwJBYfQCOH0r8sLkg/mQoYcvoOGMsbV7fHLJ8KvWbVw
	 d7ByHHLtLIYHY2n+SkXsNTKli/ONCiRPUOfRHJFePOP0bSzj+fWBGH2zH0zOPbddK9Ebl
	 rbB3zrlSsgGjkFDguQ+z0IBpqHm0BF2KUqekuNrDbX54J5fVsov5wn/Mv1VoIcUkIXpEl
	 K5UXlu4Ngrl10W5NQpejT9UmEkN1jtq6n5oWeyDOowvTntB0fkYNMc8ffx7O7deENCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqECQ6tOddDt4zToX+NIWQ1WBbgJtSpL5XY8rWENEZw=;
	b=SZ0kOyBpWAettF6TU5XbQSIlMQFuu1x8LnpUwkuhbNuFqjI91nEpn/R9D+lsJ+7Q+5UA
	 ncqeu0J+zz4k5PVF6Vyi0OBlqPQS48Nf8u6yR7i3nOUKNmWrYyUly32OrxasxY0GXNDm6
	 KHc6uHClu5f0pz72ERsG6TAure5MWloNLBqpbxhoxZb5zJh6h5tmasuZGZ4jdrGDnMAq6
	 pOYE4RYsmtptlgdyFCa13nwBtTbOm7l4mMaWG2fDMXO6SSAVmLOr+BkImC6EGV90k0+u1
	 As4bv4ibjBe12TfBnjatPrl494UWg+oKWol9e1En8s/S+0TP51IU6zH0lPLNy+ArsGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JkhWQ2qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A46606A320;
	Thu, 19 Nov 2026 03:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JkhWQ2qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8891F000C4;
	Thu, 19 Nov 2026 03:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058041;
	bh=jqECQ6tOddDt4zToX+NIWQ1WBbgJtSpL5XY8rWENEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkhWQ2qitXb6jVHrcdp41eBcM5o9olPNbyg9pct+XSsWNrICh1nuO53cDK1Y3Bg05
	 P0ZkzVC7BQcBySqwhexP4PDCts01sH2z3mQnCs1VQJwEPT8RGaiFRute4TuxpMJnKl
	 AwC8rYLYBFnt2DYtmesU6JP3ycAiH6jhSe4s+aa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0343/1848] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118145926.925141554@linuxfoundation.org>
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
[ sashal: Replaced unavailable timer_shutdown_sync() with timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d8967bf72ef26..5442713433f9b 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4456,13 +4456,11 @@ static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
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
+	timer_delete_sync(&acb->waiting_timer);
+
+	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);
-- 
2.53.0



