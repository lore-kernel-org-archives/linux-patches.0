Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016940;
	b=uMfcyTNa9rzIB7nYWllkdWwAtukB4LL3Qb3KrqzHEu06BLz1ZI96dpnx9uLY9gP01A/j
	 vEnkjwncSsASHwqpW0DKm99oLwFxcqoQMHEMgBSOg7o+vPoPcPTpsMuewgkqAofVAu241
	 Ttg0Jj/wLMHud5etkZMIPL8K1pBQWLDMFldBX/CFdlasKyBvO+K13bmVxQ1XjEJHD1U3N
	 JpcPBalExKBZ6ZwVyZ3enWSoCX3EvKMlXuKBoTZRIP8uPJX0BRM6plLnWQZA5aod2tQL7
	 vMTDa0wIEYraKq6U9Vplh+N4MS1LFwAymkktp3W1FO6SJLym+lnla6gFmAHbMbiCgKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jMQvuykI3puZNoBuzDTexppVFiboTFL2kuuD/xnIrqo=;
	b=kXHfgUXHAqG+dlHPeA/Sb+HTbfRodJLmLwOXjFujd6XjoydxD2u67yfuKyji6RDVDjyU
	 09l9H8WIi70VK/F2XAihU9rPedkkB4Myoq1qYoj37TRGyIP5Z9LYWFBrh1uFwNMPlpXdc
	 WuCI4wAoN67n+EQugMpq7dwhAe7kKg+JcGIRZyO6Em1bsb6wlIA/BFwQgtyCs5t/Y4fC1
	 +GKlahlAB7YY4pRbS19JPCIxIpkKvR6w13IPSkZgoIjJspUUHBMQqyyOAVVRd8cofFLcP
	 KpIgjDYYg4zaDBu2GyIFEEOBogT2zPguLAVmnMFMWZKEYy3j89OTmoOYz/ikDk47Igg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgW2BYwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCD606A31C;
	Wed, 18 Nov 2026 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgW2BYwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333351F000C4;
	Wed, 18 Nov 2026 15:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016940;
	bh=jMQvuykI3puZNoBuzDTexppVFiboTFL2kuuD/xnIrqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgW2BYwd1LYd9itBSngC+mW5yk06OaABRgO8bg+NuvGAFZz+ArTRdCxSo+R3RqxPo
	 r5BCcw3eo2PnsMmDLdCF1auWuDHnhDx6ix/OM2FVxZIzMOsE/sy7bzX28HBcGndvws
	 FrAPp2i2NEJQutYdl92oYpzriLXbJsZGdUtLib/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0708/2651] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:32:28 +0100
Message-ID: <20261118150313.315475172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit dbbaaae83cb277d76e70426c0f0ce289e867ed77 ]

The spindle motor should not be running when a disk is to be inserted.
Don't start the motor while the drive is empty.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/7ea60e0bf6135b9bcd4be0991a257d4c5de22bb3.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 1ade5c497e10b..64073e8f6c365 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -630,8 +630,7 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		fs->ref_count++;
 
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -639,6 +638,9 @@ static int floppy_open(struct gendisk *disk, blk_mode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & BLK_OPEN_NDELAY)
-- 
2.53.0



