Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024179;
	b=P24ymbP/XV1GHkKhkl+izPPEwiktKO7REw8P6iMCe5tx1/6J41wIk42IoGEl3lK/eenq
	 cd7+3mv/UT10ZUQc5hS6tfCL5oqLV+O4ggrryOEdCr7i2HzQ9+UsFNbLPuZwiRmkLe/L5
	 v+pztiNROYV+2I8daB5ZwpOdKj/SjcE60KiuA04gaLVK9leRWC2u1UBgKi7dWtqaTIkTK
	 zJiTxJw/1RKqKAwy3RczJ3k247w1jupmkiQePTQxbkj/MkdbN6Fuh9VKPFsNIuMvSLGyn
	 Ypo91WVEIrl/OqjiJN3w9cMCr6NSQwdvN+GALoV+R/OEQV4PXXzWh+96BjzIQgp1vOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zr+osdVk5EN1/Zf30ipM867BimZzvonmVxpXXguuqwE=;
	b=gIDrjDXHVkNL9nb8E0h8n8jw7yJ1lp6LrnslVdD1daQD3V3MXBH0ND5ylnuanWw0jyjf
	 zASwXEv9zDcJirnRvygqjgi+ShCIyYydcJ1CrT8NYJv6C8vOgbgtTs5GLTkZFh2oxGEX2
	 leUgtCqFwECfriXyHOSWgmblIenrCdGXHkih12dr3H3qyA5L80jfnMVGsxScYr4+MsD4W
	 qUfxM6Z7GWNcyPy53Ddg0pk1/GLAoYBVHfnOOvtVo4dhE/S5pQEccG1SjAhubch/jjIkD
	 ArGyOpO5FKFTrdGqGRSKjMoQjCsIxDCnq6S3ZsEcV4nw+8DSj29pYsjxk9cRcXVKDvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIgDohR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5169606A325;
	Wed, 18 Nov 2026 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIgDohR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6C01F000C4;
	Wed, 18 Nov 2026 17:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024179;
	bh=Zr+osdVk5EN1/Zf30ipM867BimZzvonmVxpXXguuqwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIgDohR0+WuZJsIHtTK3tC7HOxy2keXaJsk0nemOKVl86eyFWufT9wKNHeqUGEg56
	 Ifuii+vdbeJz8kZbVAlCfRJcsiq9bqdjkw6giSu5YtkslK+gHl9kMfVRo1OtSkWGFU
	 BX56RLT9mGW0hNgip2gqL13sh3cXppHArxx4IR2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0632/2151] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:39:27 +0100
Message-ID: <20261118150144.910592733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 1a67b458d2512..4fe5a1d775a6c 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -473,8 +473,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -490,8 +488,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



