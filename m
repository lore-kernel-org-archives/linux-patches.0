Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063462;
	b=B4M529n+4hEgvKQvrOGHSRZ8ZD/gh9CrjMU2UPLv/ALxI8aK1df18x7Aq6PpRSDTfck/
	 kwj3XkvK2ExJtEq0wrs33BnOUHXD1up8Cpm8hBXsSTy74HbgGuW5AKwSpvsBo3uQ3tP8G
	 1a9seBsWtaNbubRVr86TscTHmk+rfmVnALW2VPB3uj/VNn5v4jezizeY3roJ06sREa8u4
	 cO4AFaZrQkWCQwvXM8aYjyU5kPdFYJSSpIpH7HWLM03CiX51RT5Qse/GzZy9AcMgdownV
	 JJrGrCHlnR1iJ7cfEQUCScTP79pn+HdJR5ZosY8al1UqdxsOCdlfYJqM3FpPrfU9GCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oXlZ1/aUbtQpyd0iBRV00AJpU7v6tKwaWUfc8tdDv04=;
	b=5stMqHFtfPgk4Gv3OLb0vvpRQeI5nJ8cnq1OowNglhITs1kMlc/TRbimJTBzgQoTiwwC
	 JDWB29opFNU9BFWC9TUKK8OH4HshFgByDkoaY/YEk6fT5DfiFgsmKljFj5ODhKIN2tJ2Q
	 HimoPIeBHPYOVSIUvfPut+ggAqBrshxA3HHor8gFcbq8nRPAN1uHKGktIICLSMu1eHSlZ
	 X0tLoO+S8s0gqNz96tGGr/PymP3fmOuXGq6Wb+TYBpEH6keipECGSZefnKt+nttpi0GJy
	 Qm9b5MkQ+cY8HRX7HLulkhRU0kxhfhmk3EK/o0SXEqYS2DyB6ePIaeHkOeCO0F7QgCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzKKugiS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C8606D82B;
	Sat,  7 Nov 2026 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzKKugiS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196651F008A5;
	Sat,  7 Nov 2026 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063462;
	bh=oXlZ1/aUbtQpyd0iBRV00AJpU7v6tKwaWUfc8tdDv04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzKKugiSO2326KeD8usqb1cbvlVq6WncsE0Aurr+LgKjLfebDDzKZlE8cTlQ1frpb
	 0CsKeZOnL+bTBLNETOLC7e5+6JPyupwto8oGWKTOPtmCxkzBkPF96xsUnpHDFiVwoB
	 bLVu2K2Jk5AhGoRrmNa8mfED5zAcBIM9kfWvspU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 600/869] ublk: reset the FETCH round in release also without a disk
Date: Sat,  7 Nov 2026 08:54:42 -0500
Message-ID: <20261107134913.405098396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f44512ed12176..f85d66cee9c3a 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1761,12 +1761,13 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
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
@@ -1827,10 +1828,9 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
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



