Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045478;
	b=m0rAeTzyZy7o9GiFFbEW8HJ9Uj/2QCnGfru23Od6heQXsnk6tLl3lExsve9Ok8S34peu
	 CZ1MJlz6xEiseco68Q9U7ZBY9lT32UU4sZ7uVLzt7wHHAGSxbfwj5WuTG6MwSlJ3StTTS
	 L/tZnWH+f+IvHY3oXFT4K5d8R3DzkLHvttGaXvAC2Aqo0GiA/EjFxKD4K2WxU24p7FObN
	 vRs9gLLfDZKIy4A1geSEpVllZX/afvjZJBRNqKDsFy2xIWC0x4D6YXYSgww6canDi3eEq
	 P1mFQn2si4BDz/9+mGRsgefRR1jHhcimIy2zz+QVDPLvjcuoV+yIfj4lsk6nZTpBD4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TCCVpp6rjn7sr3fsTBwF9hIGf8i9SgRh2FZ27RUGPWA=;
	b=AUsFLfG5MmSi7GXg10sj2++COf0bXqx1WvEWnQU4xPQfnf8qKt3ktMB5oNuQi2K5wDXx
	 1Bv6FHQBcErzbARf5aAlFTQfs3XZ44cvnS7FnDoYuYNNbqCmRw0CQ7LkFEHDQHXfg765u
	 U6/Jn4HbAZ+RPN1iuZcTsZMG4Wt5K7Tkum4IrkX7eBnIsVDDpY4KlWPvCAiBbuPi/uybf
	 gxa55tPobVD2Vl6A9YPRU9D6N3+F4a2U+OzwqaAIv68FUwl1ALykCuZ90YheAogVb/mBT
	 EISbv7swlZ+4/KwtADyX/qX4dyoC7UR1K7VndKq6UqJmHMWj2Kl/RHvoFAz3wcG9f5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hDcKfhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00163606A320;
	Wed, 18 Nov 2026 23:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hDcKfhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED11F000C5;
	Wed, 18 Nov 2026 23:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045477;
	bh=TCCVpp6rjn7sr3fsTBwF9hIGf8i9SgRh2FZ27RUGPWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hDcKfhh6BUVPLHadv78AbyJ3Kpaf0CzfO4HgKOVu8pFyERHz5sP7AG4ffeaM24d3
	 Gxtn59Rn5PtiBJWSWHOewPmtw1V7pOchtT9iJ1uPoQY7d4PrhP2LXpYWd51R9LBkIR
	 9mGPQIlmo7QOYXVcxW0M4ie+BXhYvSbCjJo8YtM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0935/2857] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:32:49 +0100
Message-ID: <20261118150235.265684146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6ce0fc3e706fc..03bc97741ec1e 100644
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



