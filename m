Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064929;
	b=1dFv3F/pASd3VOvaPzB1Y5aIqc18HlaH1Mo/ScRQogS6iKyF+tn8K31XKLz4N8QbGQbY
	 bLedwHhWVGwb2Ij6wLVtN0EHswZ981k5T7JvHwdV8r6nPjKDYOBYz6Q9bEeSz8bo7sx9R
	 FK0lzOs/b3CCjjdzH9Qt662PZkGdq0dc3+79iHGshGI80YDvFtWe854MBjruNEPvWdtDP
	 Ai3FEFtrHjN7GVxeo99db9jNcKPyl0BDHsptteP+NmVQyKvyFFNjaoipK24H0I9GyGjcJ
	 eCbI2/BLToeYDpun2yMnnm4sTJAYWQAR86Lyy/oqUrqRKy99Z+A2hthfe+czXJC62hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UH8COnv0lUTglUWy9Fjyx61PdgFiznQP0muvKWUZ4gI=;
	b=GgwGeOe1AfTGYpmaigXQWlNhMb9JHaJxe7CxOdj1SiuUvVli1kxvysm0Z6LOKZnZ4VMb
	 61FH2q/NYgJSGx/6FeezNJ59FxSMbGIkGLhYDmUPsVX5XgLVxQigIvIwVIaR7kygqxFev
	 k/v4eeTQnwa5r95BukJNSpqZjSxPqkKNOc8sT7tx46/SPXABYyCuNnyM8bvyLE7LGb8+o
	 3F6Tm+071rn44ubSWAMTPsK9t2bRLVhSbdEJfPv2ackQzentqcw2YGXokPtFu5flHdd5X
	 HH6kwCrT/2BwqLMgaPFXwzsSAUnMYaMQwvX3POnbSbgzw1HJm+Rs64KWa9kqYgqJ/Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwi9XShH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA37E606A33E;
	Sat,  7 Nov 2026 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwi9XShH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9620B1F008A1;
	Sat,  7 Nov 2026 15:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064928;
	bh=UH8COnv0lUTglUWy9Fjyx61PdgFiznQP0muvKWUZ4gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwi9XShHCBAGWiw4xTYGQky6vXj2UyCZPXu8QdYWB7IpUeCGWFTbLn0pNNmqPAfIS
	 c/tSG61SHEzX7tIfLFQa52x52L8JraRSfQDLs13PZhNZbO68RdNa2t3evGduNc5CuG
	 NvgptkNudVZDJ8mLGoOe1ZfUB5401wDhdAsgG5lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0823/1257] ublk: reset the FETCH round in release also without a disk
Date: Sat,  7 Nov 2026 08:51:59 -0500
Message-ID: <20261107135002.069940068@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit f06ca594eafcdf58a399a0f92480631192e06032 ]

The release of /dev/ublkcN resets the queues only when the device has a
disk. Without one it skips ublk_reset_ch_dev():

  server fetches, never starts;         old server exits
  or STOP_DEV removed the disk           release: no disk → skip reset
                                         ios stay ACTIVE / CANCELED,
                                         nr_io_ready stays full
  new server opens /dev/ublkcN           FETCH: -EBUSY (still ready), or
                                         -EINVAL after a partial round
                                         → the device can only be deleted

All uring_cmds are done when the release work runs, with or without a
disk, so the reset is safe either way. Do it in both cases. Then a new
server can fetch and start the device again, as the STOP_DEV entry in
Documentation/block/ublk.rst says ("ublk device is ready for the new
process").

Fixes: 82a8a30c581b ("ublk: improve detection and handling of ublk server exit")
Cc: stable@vger.kernel.org
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-5-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 5e37b8e9d9acb..8bf0739539c04 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2551,12 +2551,13 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 	}
 
 	/*
-	 * disk isn't attached yet, either device isn't live, or it has
-	 * been removed already, so we needn't to do anything
+	 * No disk: the device isn't live, or it has been removed already.
+	 * There are no requests to abort, but the round still has to be
+	 * reset, so that a new server can fetch and start the device.
 	 */
 	disk = ublk_get_disk(ub);
 	if (!disk)
-		goto out;
+		goto reset;
 
 	/*
 	 * All uring_cmd are done now, so abort any request outstanding to
@@ -2617,10 +2618,9 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 unlock:
 	mutex_unlock(&ub->mutex);
 	ublk_put_disk(disk);
-
+reset:
 	/* all uring_cmd has been done now, reset device & ubq */
 	ublk_reset_ch_dev(ub);
-out:
 	clear_bit(UB_STATE_OPEN, &ub->state);
 
 	/* put the reference grabbed in ublk_ch_release() */
-- 
2.53.0



