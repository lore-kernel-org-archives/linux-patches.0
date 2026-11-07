Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064930;
	b=Q1Bjd4a111OyPNpzOryI4H/C2oLvVbHF/dQbvnCb55o2Tgyc4ZoZ4vgDrnAH2nm/T0ly
	 uc5rHE8ikuSDJYjMNcpObNz+EIJhlKtmlJpBt7YWkG2oeOU3A30zN7ENsXhqdVMw8lDwr
	 v9/c2WGChWydO391QW5pSYd3V6+nUeyN8SfXyseJhh9XruXkzcsSTIaJ4ziBzm0xSitUc
	 fpK61CFSejlbJ7KXPKLiArWbcNY6w4SB/TTugMGPf89ibxYwwsx1ozKBl6LR8cNpDny1+
	 6t5KBQJuZuyKGfpOtxumJHszTyIIUwpK3oaNubLgyGu8nh9vW0hBa78mE4sDQEOzP9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKjZ2A+7+yO1NMOWcXa39i28UVFYkHD4GIOcOPPU7CU=;
	b=s6dHivtZcqyDMFxtB6tZPNykS8GXj/if+J5+DDkhpsZR/71HDNuwvDfdKj0O7uGegHpO
	 AX1hmR70NDuc3EeJDtpLe3VWgw0kzBwUDTuLBjlOkOkX8CTsH2t929+a3fV8MDT+u6wPt
	 Edp+GBj00QKQJ25sIcHKkTVhTJ7bC1mSiktLy2klfqrxZ7d/Imwrq+cUk+EWPltcd76Nl
	 8HO6dW7oV6ZcFab4nxqetQWBXJK5whIt0hH0/A0089MIqJiG/xD5ZoN/mNYR3Ek3TpUSV
	 dohDFu6VAhKgjs+7oj5vuPlDDLAisBDJj63bJ0BcTf52U4rXFKiIRxPpgGQgA41nBag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dh+F/8q5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E92606A33B;
	Sat,  7 Nov 2026 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh+F/8q5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A391F008A1;
	Sat,  7 Nov 2026 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064930;
	bh=SKjZ2A+7+yO1NMOWcXa39i28UVFYkHD4GIOcOPPU7CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh+F/8q5Hww9lM/PQ8y3h7yUMUDkQTWWKLg7m7oxMbtcel+6yAsXhoKwb8XK3CoSj
	 HKrdQCuvEUaWX5CZ4BAUVaCg+K6pZQ5hPIyG+9u7wj4UvvQU6Cwvb+EuEv3MPf/HNw
	 ieumzt9Kc2hGQ8J9Qv0t83XVKiw9WYd72w6GhXXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0824/1257] ublk: reset the FETCH round under ub->mutex
Date: Sat,  7 Nov 2026 08:52:00 -0500
Message-ID: <20261107135002.097507456@linuxfoundation.org>
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

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 84824afdb5a4dc127fbd7036142d7611c5e53651 ]

The release work resets the FETCH round without ub->mutex, while
START_DEV checks it under ub->mutex:

  START_DEV (ub->mutex)               release work
  all queues ready? yes
  ublksrv_tgid matches? yes
                                      ublk_reset_ch_dev():
                                        io->cmd = NULL, nr_queue_ready = 0
  go live: a request then reaches ublk_queue_cmd() with a NULL io->cmd

Do the reset under ub->mutex. Then START_DEV sees the round either ready
or reset. The work already takes ub->mutex when there is a disk, after
it has aborted the requests; nothing holding ub->mutex waits for it.

Fixes: 728cbac5fe21 ("ublk: move device reset into ublk_ch_release()")
Cc: stable@vger.kernel.org
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-6-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8bf0739539c04..162a4d1a2e2a3 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2556,8 +2556,10 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 	 * reset, so that a new server can fetch and start the device.
 	 */
 	disk = ublk_get_disk(ub);
-	if (!disk)
+	if (!disk) {
+		mutex_lock(&ub->mutex);
 		goto reset;
+	}
 
 	/*
 	 * All uring_cmd are done now, so abort any request outstanding to
@@ -2589,7 +2591,7 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 
 	/* double check after grabbing lock */
 	if (!ub->ub_disk)
-		goto unlock;
+		goto reset;
 
 	/*
 	 * Transition the device to the nosrv state. What exactly this
@@ -2615,12 +2617,14 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 				WRITE_ONCE(ublk_get_queue(ub, i)->fail_io, true);
 		}
 	}
-unlock:
-	mutex_unlock(&ub->mutex);
-	ublk_put_disk(disk);
 reset:
-	/* all uring_cmd has been done now, reset device & ubq */
+	/*
+	 * All uring_cmd has been done now, reset device & ubq. Under
+	 * ub->mutex, so START_DEV sees the round either ready or reset.
+	 */
 	ublk_reset_ch_dev(ub);
+	mutex_unlock(&ub->mutex);
+	ublk_put_disk(disk);
 	clear_bit(UB_STATE_OPEN, &ub->state);
 
 	/* put the reference grabbed in ublk_ch_release() */
-- 
2.53.0



