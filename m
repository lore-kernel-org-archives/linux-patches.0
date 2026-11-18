Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055249;
	b=P0G+8hTX/tM+tZHIVqaB+dYRTFgRylT4GKGPdXpVh4Gkue976n/XXXz3oCB5QcBOrDth
	 rWOY9iOT/2Yw/q3n+9a6RLyDjHdOyyPAEti4Yb+rh1LejWmOphYHH4Glo0rfhsu1HQP3u
	 +a6Exw9DRO6HHLz2Ks2AT08YQ0AIp8Y7baQnjuJYKvXB0p6tWCLxfZtXp2/00SKNwdOrn
	 EWTt3JO+EIKeHzZp+IWkgylhYSqQ0WNeqj6OWP3T7CIxLoRd9y7+5T2tJeekNcAKAuRlu
	 AE7CCiM/bUKivhWnMQmsteTZAyg0MTsNcX1V4p22Oc1CDnqjUCGbNF32O7YSu97e6SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HkHRVKJHFYj0X5PIlYLyEq9WjCRJrY3ykZgajXMh2sY=;
	b=37XSGfD0m5cnTliq5cRM2EToPp7qk6m03S62toRvb8ouzwD4sgBqMIVfT1pTJt7sUyRS
	 qdIAaARF1OfFBcEGE/i7lqPaalTrO4gM4ZyRG0EVOVvC1A5QB0KNv1EiX75seS3XsukCq
	 hL2pf1X0/JZfmszChj7wUDntIxOidMdust+TpF3KnbIE0f6vXWydVnKOy3pWdB+a/O6uE
	 oUXRcXW/muUzINv6Q8mU0CtcOIjmxguxaE++l0EsGgv1J8+CmOiF+dKFtCiUo6MRH7GAX
	 4OV0FzkWydeQlg0FZGGHuXAkdyGC9vUtWbJGEUiNGFfI41SUqQEUxVdyGiU99V3OsOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pArv6aVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B72B606A31C;
	Thu, 19 Nov 2026 02:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pArv6aVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53651F000C4;
	Thu, 19 Nov 2026 02:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055249;
	bh=HkHRVKJHFYj0X5PIlYLyEq9WjCRJrY3ykZgajXMh2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pArv6aVonJnnr04Y+tHiNYljvhIEmMjAiGrJtRSzWnS6h5dCu8hrH59u3oYE9iEMc
	 8ZZGCR1A8BC7iiD4uzjqxIm0Q6kqhBpyCjz/pxBFLRtULS5YDKHaRqWbJTyzyzJKsC
	 OpEoLKEES4+kT87YotOh+zJwxmezxrmR7pDEsSlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1565/2214] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:54:01 +0100
Message-ID: <20261118150114.667068768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f956a2e40f70b..cb0bdf5c8ac30 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -472,8 +472,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -489,8 +487,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



