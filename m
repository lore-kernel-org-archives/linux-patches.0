Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036511;
	b=rYGA4Pl8s0R0kar36YjdIRPuFiizPfeDUSv9G3bpSOThTVE6N0agYonYVJSIxsElP+Tm
	 qpqs/WNWxzPFh11lLCuzOFAYgH6Lb50XHmfDvYuN9PDo9W/58kV795RqRex508TdTTnHG
	 etlaPpMOUafkg9UoIji7XtkmwKMPHpmahFseHrWiY/nnW+1SdEoPvgDGZR19X14WqlIDg
	 HtNBuw+vAZaqnKDvVOEBehTGkjuKm8pSVA6f1apddoP81z5BIyePNukT2D4HbrnfJyVYf
	 zRw0ONaZERA+EXP5v/zNbOOk6GC4OET4ND3nFpARwoj4pboE0rdD0vzc35/s8Uqz/yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K/pKEEbbFnQVeJ3cJdIdML07ImgUM6paPHX3K4InobY=;
	b=v7RZ5TLphb/HuUoJMIkXDETacN7LOYaKFz0X1j1zoGZt796QrNTBfquRptAohduF6kJb
	 yBi337UKIrNN82GG+dXr1OBU6xIqMVVKWrBhojVxw0+EBb3jMSgxIVg//Q9T0MPcjya03
	 XNMDLGBglLEsHm5yDAwG/dzKeqgBKfU8j+TsL8pzKsKdvZZ+o5YsM7mj4PXYcrvqyGLcv
	 n7YTNFmEVNsUfsTTmYgGf2POXpLaC3ItOz06wcmIzU9mRItWXB/TmzXk2DepEJdg9/tx9
	 cv3qdv9EYBPg/LBli8YWjFcsiRTi/q5xz3urKMyqeOv48XbfF0z0Zrp7m5ZcdaJXFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lv/wfGj9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25E606A334;
	Wed, 18 Nov 2026 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lv/wfGj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44FE1F000C4;
	Wed, 18 Nov 2026 21:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036511;
	bh=K/pKEEbbFnQVeJ3cJdIdML07ImgUM6paPHX3K4InobY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv/wfGj94k4HlxJnIeM1pVfgAIBQ5orEUDZOk9fv5QfqiH+hdjhWsCUYf9gYRjXyv
	 nGchpFAJA6/dsXRefwcxJJcavaJw5SaZbvrngzPpJbO0iE3bmt1g4a1i5Z76WzqblM
	 5RDqC1Arp3WML/VfgK+b3sj5OhhRQSrL9ygO009I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1086/3318] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:28:28 +0100
Message-ID: <20261118150352.554324129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5a0706765047..4e6419e5f9545 100644
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



