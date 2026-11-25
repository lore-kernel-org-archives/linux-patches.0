Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626005;
	b=Qse/jWr3TsK9OtTfzRbN9iVcB2cOhiNT/b6hWMNRGMapghtNKMsOgDJ/xVZy9TA8xrN5
	 3PzPvAWc74zyxx1r+1VZZMV37xpWL5ah4MAlMwVnZwONFmWt4v5HFgxCf6k3v0fY+8A4F
	 V1JuaHfmaAz/TBHyKDiwAni8GuMUBmTK8KUiah7CCySAMLn9RL5b2T1VQECfxyVs5hRaB
	 sMq1QebTwYSnWCJWoNK0rvnkVk4uY7gb1Y/9lfLsj6iQoKzLQ/KCo9P149bL3lUuvw5le
	 OOZK9/ARsAL/ST3Ia4KFc9xf1Qz+nWkKaSebMNTGynQh+1l/nuapeUJkFC9XDH0eAQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cxeXMKEkwriYJh0DPuNJsAhV51gLozIYY9cTJhnFOQ=;
	b=xTQK2BSC36YocGI6ilxM0uuBd5ybw9anvRpMcronE/UF710nY66HL3rLxdmARJSAHwcY
	 Jp80AmIcqq2kVurTWw3TRlD2COcDFbxMMP/ZqIo8Tn3qalqzvi0cYBxyeWmM+4lTp6hb0
	 HZdbwTYpF9aw+t0RvKENXHRx/iZRwWDCcLZqmgQg2+sc8hl8880L1JXp+djHnrZkR5/9d
	 ULjq1+hkhregJHBa60z69VVSmiwMHKiT+/3+n1EFbBBwGXMFg54n9iAhPcGiefK78xRls
	 f8tiyoHvLJWTtcECTXE1jyfIcMRgDQVDRd9ZDpTYiMTmnmXROnWft0hR8BlZ10cxD9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVNgyNtz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516D606A32A;
	Wed, 25 Nov 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hVNgyNtz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DF61F000C0;
	Wed, 25 Nov 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626005;
	bh=1cxeXMKEkwriYJh0DPuNJsAhV51gLozIYY9cTJhnFOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVNgyNtz+cfr1s/lE88BguPq8kfUXKadvqCME+x5zrXAq+2XclA0Zs9IR8hbiiDRt
	 4Zkt9AkTZeKdTVW03r/jPuYOplE5RaEDVgVm+6WEBqv6WTHi+tmcgF5Su3l1kQu8C9
	 2aEYk4XEBoLCbE/sRkTXuEvSgJnEyv79Kh8EFSgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 698/816] dm thin: avoid wrapping no_space_timeout
Date: Wed, 25 Nov 2026 15:37:26 +0100
Message-ID: <20261125143905.339537541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

commit bcb78d49620f666b4a9d62997691e8d031fd4ebc upstream.

set_pool_mode() converts the no_space_timeout module parameter with
READ_ONCE(no_space_timeout_secs) * HZ. The usual arithmetic conversions
evaluate the product as unsigned int, so it can wrap before being stored
in the unsigned long delay. With HZ=1000, 4294968 seconds becomes 704
jiffies: a pool that runs out of data space switches to
error_if_no_space and fails queued writes with -ENOSPC after about 0.7
seconds.

Widen the value before the multiplication and cap it at
MAX_JIFFY_OFFSET / HZ, so large timeouts no longer wrap into short
delays. On 32-bit kernels, values beyond the supported jiffies range
saturate at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET. The timer wheel's existing handling of very long
delays is unchanged.

Fixes: 80c578930ce7 ("dm thin: add 'no_space_timeout' dm-thin-pool module param")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2544,7 +2544,9 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
-	unsigned long no_space_timeout = READ_ONCE(no_space_timeout_secs) * HZ;
+	unsigned long no_space_timeout =
+		min_t(unsigned long, READ_ONCE(no_space_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user


