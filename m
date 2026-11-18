Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029934;
	b=4bEun+Kj1qGcVqjmCLQA4BRRyAuZwNLHkKFw1ru5/mVlchK5Mf3hTH3qErD5AqMz+oof
	 QKnbkxSvh5JAXPfsL3eQWy0soUdpeVzyy0/HoeBdTbwFtWX5gHL3GiNF85KmmApMJcq/B
	 9RsKSwgDPlS3ejdzQoYl9+BUF4o+enB1hrFhmAqy3dlIJhDbJOCL7ilL8du503KOlxVzO
	 fAVFI/yMlypn5/Zm0taFRIwUojHUDTz782t9hDY/HbXDvuXmBUJxY4tcm1CGNACA/h5TZ
	 WwjpMC78m0npNCJhdbtEl4bkrhNpZkqu7RmemROn1gYQbR9EDpJiPXTg4myIzGoU0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gg8kubN03nJv76GrdZxn2ItPrTHl5HpivwOLGtmVzG0=;
	b=C8zm8lWpZjf36LY92C7OVKpBLQa7PK7VnjSp8b75yTL0tpclz7GqmfHsRhAIT+kS9G9g
	 nfVt7xZD73msifgLBuAtVKJyGJDzSQWCg5qSAIML1TpiLkIOaJ3utHdL5YfF8+Xa2xHV5
	 pV98lUI6yh89wGwmlVfGyJ6+ZiH8KB0MaoYPoq7qqpys2oCPbuTZk9KvSmZH5OroIfh7I
	 S7dkQMQ7+hd1AMpxpaJ1jsb7CL7V3/n8dSIzj1kQQIR1o1BGUbD/trHPX2xa3Vt3o4oTw
	 ed/YmLC0lj7CuqRhC+KRSd5DhdN/z9IdAUsU7UNw68g9ABSAOE9hhXn1FD0vwMEgXAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPBejHTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AC960A2606;
	Wed, 18 Nov 2026 19:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SPBejHTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56571F000C4;
	Wed, 18 Nov 2026 19:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029934;
	bh=gg8kubN03nJv76GrdZxn2ItPrTHl5HpivwOLGtmVzG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPBejHTN8CEb0Zkckhpf0nyx7xpFnWi8TuiQoweiyQO+dMY+KOUGMpxqLNnE6Qjvs
	 UiHhs4WVPI7PYLAWeMauRMl+VUX+m1TqnPOXEonXl8mcKm2ys3jZF0JtXb0lnv+4+p
	 r2TN6mNYdVxnNEshvRw0UOwXLj0DY2Jg9risqy58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0527/1756] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150030.110706478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit b9c1095048537cc9563f12d0a24f2f0df129e4d5 ]

The UPD72070 spec indicates that the track zero sensor can take 3 ms
to stabilize following a STEP command so add a call to msleep().
Remove the duplicate swim_readbit() call as there's no need for that
once the sensor signal has stabilized.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/6d17ca20a7286c1d74833b29510c506a66d96e6f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 851aaa11e80ca..57f37bb3ece8c 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -402,16 +402,15 @@ static inline int swim_track00(struct swim __iomem *base)
 	for (try = 0; try < 100; try++) {
 
 		swim_select(base, RELAX);
+		msleep(3);
+
 		if (swim_readbit(base, TRACK_ZERO))
-			break;
+			return 0;
 
 		if (swim_step(base))
-			return -1;
+			break;
 	}
 
-	if (swim_readbit(base, TRACK_ZERO))
-		return 0;
-
 	pr_err("swim: track zero recalibration failed\n");
 	return -1;
 }
-- 
2.53.0



