Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064697;
	b=irWAM2bCLzU1QfaLiowWfDSA28iBhB03WZUzfAFfbUgbN6hT0f3D4ZDBtkj1BrU1p63G
	 7rRtn+NqY7sY0s9cNENQgmn9G5M4/Q6qiFMsQad6PbBSXa4/KDtpNhMnUHQaF9z5gJm9f
	 Emhn6W5FMGHuUKDKdlkhZl4lER5y++0WaQARipylaqrIIyxG43kHTiVEG3wUCmhQxK9Lh
	 v8Hscou+qyPgfWR8/ZfSnMYkAjd5rlYo7jJH6uJ9LHfA7nJsbqmJ8W1Ru4TyThp7fGcCA
	 amtOoimYzvXUO+OPvSKiS1lDO5XvKIpVMWBUjwrqorIT4D+VLM7Cl3pl49A9/tjqjGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iszg5LnTzkXiCaby1yl+oBKxXIXcw9vhhWgvluIPYbs=;
	b=XAy1CCKcbp3jYOTWgTZhGCqPgds/C0LbF+VBWTiFbcBU2VdvG7foUy8/YwId2jLl8RoY
	 MY3iWqT8rCbs2iOiONV0rpWzOi7yXVVwsEBUc5QkCQ01K0R0taZEFdtasADMtrhnFHo6S
	 N9rjo2sF4o98U1SaNL7aQD5rzTAs4HQYFTbw0qyM2eRTnn/OKEdwsm+LlmW7qYZcI0b8h
	 Ooky6XqpznhIzXw5CwIdALHNCEhpV2+83QLqQ1+KFx4rF+w9bHymJ4+uoS4kcknPQj9Nc
	 FCzmjrG4ia5gZ1RDy9Z8TfkIQhJItnAB0Bm1n78jq0NTwqJoFuzbwV1blthUPGqw3ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBqPrmVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCBB606B8B9;
	Sat,  7 Nov 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DBqPrmVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DCC1F0089F;
	Sat,  7 Nov 2026 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064696;
	bh=iszg5LnTzkXiCaby1yl+oBKxXIXcw9vhhWgvluIPYbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBqPrmVElFOjfZzHCvXRirOsfwaKlvtTN1qPURPBHZgW8T9kgMLxUAUCWo0U4ZNsU
	 IewylQYj6rpzCdD1bC5/bZzZcz4mUSKl/V8gNONxkFV19VW8KtYuwAl0o6k1TNOTpB
	 2I+fF0hYwrpuqS29dmLdCDyV/tXaXzwtXVYzfXVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0687/1257] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:49:43 -0500
Message-ID: <20261107134958.241836740@linuxfoundation.org>
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
index 5743c96d54814..a8ef7c5993919 100644
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



