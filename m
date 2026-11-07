Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062326;
	b=hu7mPgQ4UcCGXN4J0JU7/WTo8cKORw4hrptLd1Xy3BdYAssTI95zf1uzIp1Fq1E2KGjc
	 MBuK3zJq8ShVxJGmuflphNqKjzmHff/5uvzGol0MHvFwTU3MxssRRCay4PbkOexo/HUFi
	 bZkB+f6LZPotVAFqfD7h0qVPDsUDgUpYs4ttpfY+HgIc8he/lW5Ui2zHk3znEtzZVVQQU
	 fk0U4FkAabLP41uhKCgv+i4GnxzVeOIC5oPasWGH5M3TpmqKTd9NwxzR4yksQiYXC8Q2I
	 su8ogRZGRucUvmmhYwWnLLSp9f87O3RpDOvbAKxYlqSMIOZoMkdQT2DJQd150Oc11uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=95nNhbys92qY8KTQj+xr7BFCEiwS894MfakBkm29Kog=;
	b=AdZVNWxkoKE9vdUw4EOCom+1dUjy+X6pHBBiqgVDNdn9LD7WYd2MgSC9O1eCJVuLSgnH
	 V5njhR7xQgbKLCptIfy4xkcZBsH1V/JBcjoRcFR+HkBc43d0aXiIRvp6LP2cvakfCtuFd
	 8+s3hsiqKTCj1c1fTDmuQOMnRe562pM7+QYWjHkqsctA55hSIPiExvfC05InNgFRTvS9+
	 /Kvin802LQoi2+/1oPkS4eFfpE9nMqW7uBzRqgqf3tg54Hjtw9Q+gwhBPBUnivOF2AsuQ
	 xJ+a//vhuoyo+3JawVhIAWxSyzt1Mk69vp4y0M3DN+JTvD0A5w74Oa4X5DsqEYSe6FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MaB/B1wx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9FE606A666;
	Sat,  7 Nov 2026 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MaB/B1wx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E54B1F0089F;
	Sat,  7 Nov 2026 14:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062326;
	bh=95nNhbys92qY8KTQj+xr7BFCEiwS894MfakBkm29Kog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaB/B1wxJQ7q3Eopj5pdYz4u5n12jyH4i9O8ReDMpb4Pb6NcSMBfDdU9InO+SRBMb
	 EkPXnFe7eKjqeTmU7TD+ntqinm8y8fuDb72nLi//lOAKba7x5MU12Zpwfw+2wydyIg
	 54k5EP/Z3/K+E8OQjd2cU74Ir9sbIuU/VpIKgDFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1258/1536] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:54:34 -0500
Message-ID: <20261107135033.103235704@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 5192201aaac2a923ff98306e3ccda58718ee395f ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently sh_mobile_lcdc_start() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Also clear info->fbdefio in that case, so that sh_mobile_lcdc_stop() does
not attempt to clean up deferred I/O state that was never initialised.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh_mobile_lcdcfb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index 84aa2086d5ae2..59cf785c35445 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1042,7 +1042,11 @@ static int sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 			ch->defio.deferred_io = sh_mobile_lcdc_deferred_io;
 			ch->defio.delay = msecs_to_jiffies(tmp);
 			ch->info->fbdefio = &ch->defio;
-			fb_deferred_io_init(ch->info);
+			ret = fb_deferred_io_init(ch->info);
+			if (ret) {
+				ch->info->fbdefio = NULL;
+				return ret;
+			}
 		}
 
 		sh_mobile_lcdc_display_on(ch);
-- 
2.53.0



