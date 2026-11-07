Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061869;
	b=01U0nQwmuLez/SOffmX2sMHBvCS3uqptHSNlVKf2kehY4HI3Zn4OHz0jNjSyxljnid7I
	 fM7Fm+HIYZqzqlKYd9qVoK1L7eGhk1zXuwuoE1wclVMUFohempUf88Ziesw4X7Kz7uZji
	 oxktjNCFYrCYC07Cl5kzmUkPGSSPBBOnti8TzVBicPssICLK+zhtH5wFdT2iZv6uUtd1V
	 9epSw6vZhvZlg91lnAdfoakBzW0iqPZC91qmy9bcBz2hxqm/On22/VhkOR6+lODdJe+yt
	 pg+Gp0CYTkbiKsxNQSAQkQTm7uwkWQDOYLWs9fLM6QVRAHWN3rDUfHwIOlplhcOtgNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXCqEoJBzmE812vnjyLqUPM1jF8HXQNv74uBBchbauE=;
	b=uCSd17H/zmzTT3g8SlJ0powsT7BSfXPkWnG67qj2OXZ8+yJuRbrLx8vEpj6CWgRVE4DL
	 eDQCrCFTdJvK0xM2slZSAeNdQFQ6XBEWfrMqnwoXRYlWEGR8frWKBzYPA67+/6ucRkS5q
	 3GDngT1ljnxKcplzzejm3YtyVaQM8t6/0gUiQ8Ir8tpIyZSCAeERiyYJa9XpYeGTbD+AJ
	 8MCk63x51YDcUxkrfHZprdZNQKzN/XSepDir/3NrXUqnNI3yIngc1VrcgOzJFHs7GNMwI
	 LrGjllwd6tglqM4W2KAk/q55x9i8mO3t/EsO04HgyAP+86up1wboIXjx7ykDrFYMfJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0ZERGeF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B99606A32D;
	Sat,  7 Nov 2026 14:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0ZERGeF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27F31F0089F;
	Sat,  7 Nov 2026 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061869;
	bh=iXCqEoJBzmE812vnjyLqUPM1jF8HXQNv74uBBchbauE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0ZERGeFDnvpLNCGGSPmmwRvjhc8FaQKrGrMreVxfhei29RTlZFjrPILnCPHNKXEh
	 CpAHEkNuSa/Pw3KaqhOeGyGNTY9aNvEP2acgC55CtqOLn7QvQR3l/d+Zrc2AkpEAlb
	 iibbaSra1g6fX8l+gmxqWmw+Olz7p7WBhL9GOgeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0884/1536] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Sat,  7 Nov 2026 08:48:20 -0500
Message-ID: <20261107135022.455213731@linuxfoundation.org>
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
[ sashal: Adjusted patch context to remove del_timer() calls where upstream removes timer_delete() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d108a86e196ef..f4be99c8eb472 100644
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



